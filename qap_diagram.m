function qap_objects = qap_diagram(varargin)
%QAP diagram
%
%Description
% Uses alchemyst/ternplot (Sandrock, 2026) to construct a ternary plot
% and then adds the appropriate labels for a QAP diagram. That is, a
% special ternary plot used by mineralogists to map the compositions of
% quartz (Q), alkali feldspar (A), and plagioclase feldspar (P) in igneous
% rock samples. 
%
% Please note that the ternplot function does not take Q-A-P in order;
% rather, to get a proper QAP visualization, the user needs to call
% ternplot with this syntax: ternplot(A,P,Q,varargin).
%
% In addition, please note that the qap_diagram function automatically
% turns plot holding 'on'.
%
%
%Name-Value Arguments
% All name-value arguments are optional.
%
%   NAME          DEFAULT
%   ==============================================================
%   FontColor     [0.65 0.65 0.65]
%
%   GridLines     'off'
%
%   LineStyle     {'-','LineWidth',0.5,'Color',[0.25 0.25 0.25]}
%
%   VertexLabels  'off'
%   --------------------------------------------------------------
%
%Output Arguments
% Specify an output argument to save a struct that contains each
% of the figure handle objects (axes labels, dividing lines, 
% gridlines, tick labels, and rock types).
%
%   >> H = qap_diagram();
%
% You can then modify the objects stored in `H` after the plot is
% already generated. For example, you can change the weight of the 
% quartz axis label by doing this:
% 
%   >> H.AxesLabels.Quartz.FontWeight = 'bold';
%
% If you want to change multiple objects in a single line, you will
% need to bracket the objects like they are an array, and then dist-
% ribute your changes using the deal() function. For example, you can
% change all of the tick labels to red by doing this:
%
% [H.TickLabels.Color] = deal('r');
%
%
%Example: 
% Plot the position of granodiorite with a composition of 
% 30% quartz, 18% alkali feldspar, and 52% plagioclase on 
% a QAP diagram
%
%   quartz = 30;
%   kspar = 18;
%   plag = 52;
%   qap_diagram()
%   ternplot(kspar, plag, quartz, 'kd', 'MarkerFaceColor','r')
%
%
%See aslo
% ternplot

% Copyright 2026 Austin M. Weber

%
% Begin main function
%
  % Input parsing
  P = inputParser();
  addParameter(P,'FontColor',    [0.65 0.65 0.65], @(x) (isnumeric(x) & isequal(size(x),[1 3])) | (ischar(x) & length(x)==7) & strcmp(x(1),'#'));
  addParameter(P,'GridLines',    'off',            @(x) ischar(x) & (strcmpi(x,'on') | strcmpi(x,'off')));
  addParameter(P,'LineStyle',    {'-','LineWidth',0.5,'Color',[0.25 0.25 0.25]}, ...
                                                   @(x) iscell(x) & isvector(x));
  addParameter(P,'VertexLabels', 'off',            @(x) ischar(x) & (strcmpi(x,'on') | strcmpi(x,'off')));
  parse(P,varargin{:});
  FontColor = P.Results.FontColor;
  GridLines = P.Results.GridLines;
  LineStyle = P.Results.LineStyle;
  VertLabel = P.Results.VertexLabels;
  
  % Create axes
  ternplot(1,1,1,'HandleVisibility','off');

  % Update figure size so that labels fall in the correct positions
  f = gcf;
  f.Units='pixels';
  f.Position=[125 125 894 544];

  % Remove gridlines
  if strcmpi(GridLines,'off')
    gridlines = findall(gcf,'Type','Line');
    [gridlines.LineStyle] = deal('none');
  end

  % Add QAP axes labels
  if strcmpi(VertLabel,'off')
    ternlabel({' ','Alkali Feldspar'}, {'Plagioclase',' ',' '}, {'Quartz',' ',' '});
  else
    vertexlabel('Plagioclase','Quartz',{'Alkali','Feldspar'})
  end

  % Add granite QAP divider lines
  hold on
    % Add quartz lines
    for q = [5 20 60 90]
      drawLine(q,0, q,1, LineStyle);
    end
    % Add feldspar lines
    for f = [0.10 0.35 0.65 0.90]
      if f==0.65
        drawLine(0,f, 20,f, LineStyle);
      else
        drawLine(0,f, 60,f, LineStyle);
      end
    end

  % Add rock type labels (SEE LINE 226)
  rock_names = {'Q5',{'quartz-rich','granitoid'},'alkali feldspar granite',...
    'granite','granodiorite','tonalite','Q2','quartz syenite','quartz monzonite',...
    {'quartz','monzodiorite'},'Q4','Q1','syenite','monzonite','monzodiorite','Q3'};
  positions = [0.494407158836688 0.817181818181819 0.0447427293064876 0.0463821892393321;...
               0.469798657718121 0.655771799628942 0.0950782997762863 0.0760667903525046;...
               0.344519015659955 0.277293135435994 0.1661073825503360 0.0463821892393321;...
               0.442375776436328 0.385865862708720 0.0704697986577181 0.0463821892393321;...
               0.580418344519016 0.376623376623377 0.0582841163310962 0.0575139146567717;...
               0.640939597315436 0.449834879406309 0.0732662192393736 0.0463821892393321;...
               0.277404921700224 0.177107606679036 0.0447427293064877 0.0463821892393321;...
               0.323266219239374 0.178962894248609 0.1180089485458610 0.0463821892393321;...
               0.447427293064877 0.180818181818182 0.1392617449664430 0.0463821892393321;...
               0.595637583892617 0.162265306122449 0.1101789709172260 0.0826326530612244;...
               0.708053691275168 0.182673469387755 0.0447427293064877 0.0463821892393321;...
               0.253914988814317 0.102896103896104 0.0447427293064877 0.0463821892393321;...
               0.334451901565996 0.104751391465677 0.0721476510067114 0.0463821892393321;...
               0.469798657718121 0.104751391465677 0.0939597315436242 0.0463821892393321;...
               0.609619686800895 0.104751391465678 0.1101789709172260 0.0463821892393321;...
               0.736017897091722 0.102896103896104 0.0447427293064877 0.0463821892393321];
  rotations = [0 0 64 0 0 -65 0 0 0 0 0 0 0 0 0 0];
  for i = 1:length(rock_names)
    addRockLabels(rock_names{i}, positions(i,:), rotations(i), FontColor)
  end

  % Make the axes labels bold
  txt_objects = findall(gcf,'Type','Text');
  [txt_objects(1:3).FontWeight] = deal('bold');

  if nargout == 1
  %Save axes objects so that they can be modified later
    %Axes labels 
      Q_text = txt_objects(1);
      P_text = txt_objects(2);
      A_text = txt_objects(3);
    %Tick labels
      tick_text = txt_objects(4:end-2);
    %Annotations
      ann_pane = findall(gcf,'Type','Annotation');
      ann_objects = ann_pane.Children;
      Q3_text = ann_objects(1);
      Monzodiorite_text = ann_objects(2);
      Monzonite_text = ann_objects(3);
      Syenite_text = ann_objects(4);
      Q1_text = ann_objects(5);
      Q4_text = ann_objects(6);
      QuartzMonzodiorite_text = ann_objects(7);
      QuartzMonzonite_text = ann_objects(8);
      QuartzSyenite_text = ann_objects(9);
      Q2_text = ann_objects(10);
      Tonalite_text = ann_objects(11);
      Granodiorite_text = ann_objects(12);
      Granite_text = ann_objects(13);
      AlkaliFeldsparGranite_text = ann_objects(14);
      QuartzRichGranitoid_text = ann_objects(15);
      Q5_text = ann_objects(16);
    %Dividing lines
      line_objects = findall(gcf,'Type','Line');
      DividingLines = line_objects(1:8);
    %Store everything in a struct
      qap_objects.AxesLabels.AlkaliFeldspar = A_text;
      qap_objects.AxesLabels.Plagioclase = P_text;
      qap_objects.AxesLabels.Quartz = Q_text;
      qap_objects.DividingLines = DividingLines;
      qap_objects.GridLines = gridlines;
      qap_objects.RockTypes.AlkaliFeldsparGranite = AlkaliFeldsparGranite_text;
      qap_objects.RockTypes.Granite = Granite_text;
      qap_objects.RockTypes.Granodiorite = Granodiorite_text;
      qap_objects.RockTypes.Monzodiorite = Monzodiorite_text;
      qap_objects.RockTypes.Monzonite = Monzonite_text;
      qap_objects.RockTypes.Syenite = Syenite_text;
      qap_objects.RockTypes.Tonalite = Tonalite_text;
      qap_objects.RockTypes.QuartzMonzodiorite = QuartzMonzodiorite_text;
      qap_objects.RockTypes.QuartzMonzonite = QuartzMonzonite_text;
      qap_objects.RockTypes.QuartzRichGranitoid = QuartzRichGranitoid_text;
      qap_objects.RockTypes.QuartzSyenite = QuartzSyenite_text;
      qap_objects.RockTypes.Q1 = Q1_text;
      qap_objects.RockTypes.Q2 = Q2_text;
      qap_objects.RockTypes.Q3 = Q3_text;
      qap_objects.RockTypes.Q4 = Q4_text;
      qap_objects.RockTypes.Q5 = Q5_text;
      qap_objects.TickLabels = tick_text;

  end %End nargout statements 
      
end
%
% End main function
%

%
% Local functions
%
function drawLine(q1,f1,q2,f2,sty)
  % q1 = quartz coordinate start point
  % q2 = quartz coordinate end point
  % f1 = feldspar coordinate start point
  % f2 = feldspar coordinate end point
  % sty = line style, e.g., {'--r','LineWidth',1}
  q_coords = [q1 q2];  
  f_coords = [f1 f2];
  a_coords = f_coords.*(100-q_coords);
  p_coords = (1-f_coords).*(100-q_coords);
  ternplot(a_coords, p_coords, q_coords, sty{:},...
    'HandleVisibility','off');
end
function addRockLabels(rock_name_string, position, rotation, fc)
    annotation(gcf,'Textbox',position,...
      'String',rock_name_string,...
      'HorizontalAlignment','center',...
      'EdgeColor','none',...
      'Color',fc,...
      'Rotation',rotation)
end
%
% End local functions
%
