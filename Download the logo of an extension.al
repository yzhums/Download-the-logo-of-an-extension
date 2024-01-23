page 50105 "ZY Installed App"
{
    ApplicationArea = All;
    Caption = 'Installed App';
    PageType = List;
    SourceTable = "NAV App Installed App";
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting(Name)
                      order(ascending)
                      where(Name = filter(<> '_Exclude_*'));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("App ID"; Rec."App ID")
                {
                    ToolTip = 'Specifies the ID of the extension.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the extension.';
                }
                field(Publisher; Rec.Publisher)
                {
                    ToolTip = 'Specifies the value of the Publisher field.';
                }
                field(VersionNumber; Format(VersionNumber))
                {
                    Caption = 'Version';
                    ToolTip = 'Specifies the version number of the extension.';
                }
                field("Published As"; Rec."Published As")
                {
                    ToolTip = 'Specifies the value of the Published As field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DownloadExtensionLogo)
            {
                ApplicationArea = All;
                Caption = 'Download Extension Logo';
                Promoted = true;
                PromotedCategory = Process;
                Image = Download;

                trigger OnAction()
                var
                    ExtensionMgt: Codeunit "Extension Management";
                    TempBlob: Codeunit "Temp Blob";
                    InStr: InStream;
                    ImageName: Text;
                begin
                    Clear(TempBlob);
                    ImageName := '';
                    ExtensionMgt.GetExtensionLogo(Rec."App ID", TempBlob);
                    TempBlob.CreateInStream(InStr);
                    if InStr.Length <> 0 then begin
                        ImageName := Rec.Name + '.png';
                        DownloadFromStream(InStr, '', '', '', ImageName);
                    end else
                        Message('No logo found for this extension.');
                end;
            }
        }
    }

    var
        VersionNumber: Version;

    trigger OnAfterGetRecord()
    begin
        VersionNumber := Version.Create(Rec."Version Major", Rec."Version Minor", Rec."Version Build", Rec."Version Revision");
    end;
}
