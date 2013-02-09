Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947571Ab3BIAaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:30:20 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50548 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947344Ab3BIAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:30:14 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH resend v3 1/3] kconfig: nconf:  rewrite help texts
Date: Sat, 9 Feb 2013 01:30:06 +0100
User-Agent: KMail/1.13.5 (Linux/3.7.3-treguer; KDE/4.4.5; x86_64; ; )
Cc: Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net> <20130201182704.GB11098@mobil.systemanalysen.net>
In-Reply-To: <20130201182704.GB11098@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302090130.07194.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, All,

I've taken that in my branch now.
I will push later with a few fixes (see below).

On Friday 01 February 2013 Roland Eggner wrote:
[--SNIP--]
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
[--SNIP--]
> +"o  Global help:  Unless in a data entry window, key <F1> will give you\n"

... pressing <F1> ...

> +"o  A short version of the global help is available by key <F3>.\n"

... by pressing <F3>

> +"o  Local help:  To get help related to the current menu entry, use any\n"
> +"   of <?> <h> keys, or if in a data entry window then use <F1> key.\n"

s/ keys//;  s/use <F1> key/press <F1>/;

> +"<n> to remove it.  You may press the <Space> key to cycle through the\n"

... press <Space> to cycle ...

> +"Unless in a data entry window, key <1> may be used instead of <F1>,\n"

s/key //;

> +"Enter the requested information and press <Enter>.  Hexadecimal values\n"
> +"may be entered without \"0x\" prefix.\n"

... without the \"0x\" prefix ...

> +"Text Box (Help Window)\n"
> +"----------------------\n"
> +"Use movement keys <Down> <Up> <PageDown> <PageUp> <End> <Home> as listed in\n"
> +"table above.\n"

... keys [elided] as listed ...

> +"Alternate configuration files\n"
> +"-----------------------------\n"
> +"nconfig supports switching between different configurations.\n"
> +"Use <F6> to save your current configuration.  Use <F7> and enter a\n"

Press <F6> ...
Press <F7> ...

>  menu_no_f_instructions[] = N_(
[--SNIP--]
> +"Legend:  [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
> +"Submenus are designated by a trailing \"--->\".\n"
> +"\n"
> +"Use the following keys to navigate the menus:\n"
> +"Move up or down by any of <Up> <Down> keys.\n"

... with <Up> or <Down>.

> +"To enter a submenu use any of <Enter> <Right> keys.\n"
> +"To go back to the parent menu use any of <Esc> <Left> keys.\n"

Enter a submenu with <Enter> or <Right>.
Exit a submenu to its parent menu with <Esc> or <Left>.

> +"Pressing <y> includes, <n> excludes, <m> modularizes features.\n"
> +"Pressing <Space> cycles through the available options.\n"
> +"To search for menu entries use key </>.\n"

... press </>.

> +"<Esc> always leaves the current window.\n"
> +"\n"
> +"You do not have function keys support.\n"
> +"Use key <1> instead of <F1>, <2> instead of <F2>, etc.\n"
> +"For verbose global help use key <1>.\n"

... press <1>.

> +"For help related to the current menu entry use any of <?> <h> keys.\n"),

... press <?> or <h>.

And so on in the following...

>  setmod_text[] = N_(
> -"This feature depends on another which\n"
> -"has been configured as a module.\n"
> -"As a result, this feature will be built as a module."),
> +"This feature depends on another feature which has been configured as a\n"
> +"module.  As a result, the current feature will be built as a module too."),
>  load_config_text[] = N_(
>  "Enter the name of the configuration file you wish to load.\n"
> -"Accept the name shown to restore the configuration you\n"
> -"last retrieved.  Leave blank to abort."),
> +"Accept the name shown to restore the configuration you retrieved\n"
> +"last.  Leave empty to abort."),

"the configuration you last retrieved" is prefectly correct English (at
least UK english ;-) ), and the meaning is (very) slightly different.
In this case, I think it's more sensible to keep the original wording.
But English is not my primary language, so feel free to correct me...

>  load_config_help[] = N_(
> -"\n"
>  "For various reasons, one may wish to keep several different\n"
>  "configurations available on a single machine.\n"
>  "\n"
>  "If you have saved a previous configuration in a file other than the\n"
> -"default one, entering its name here will allow you to modify that\n"
> -"configuration.\n"
> +"default one, entering its name here will allow you to load and modify\n"
> +"that configuration.\n"
>  "\n"
> -"If you are uncertain, then you have probably never used alternate\n"
> -"configuration files.  You should therefor leave this blank to abort.\n"),
> +"Leave empty to abort.\n"),
>  save_config_text[] = N_(
>  "Enter a filename to which this configuration should be saved\n"
> -"as an alternate.  Leave blank to abort."),
> +"as an alternate.  Leave empty to abort."),
>  save_config_help[] = N_(
> -"\n"
> -"For various reasons, one may wish to keep different configurations\n"
> -"available on a single machine.\n"
> +"For various reasons, one may wish to keep several different\n"
> +"configurations available on a single machine.\n"
>  "\n"
>  "Entering a file name here will allow you to later retrieve, modify\n"
>  "and use the current configuration as an alternate to whatever\n"
>  "configuration options you have selected at that time.\n"
>  "\n"
> -"If you are uncertain what all this means then you should probably\n"
> -"leave this blank.\n"),
> +"Leave empty to abort.\n"),
>  search_help[] = N_(
> -"\n"
> -"Search for symbols and display their relations. Regular expressions\n"
> -"are allowed.\n"
> -"Example: search for \"^FOO\"\n"
> +"Search for symbols (configuration variable names CONFIG_*) and display\n"
> +"their relations.  Regular expressions are supported.\n"
> +"Example:  Search for \"^FOO\".\n"
>  "Result:\n"
>  "-----------------------------------------------------------------\n"
>  "Symbol: FOO [ = m]\n"
> @@ -229,26 +222,26 @@ search_help[] = N_(
>  "Selects: LIBCRC32\n"
>  "Selected by: BAR\n"
>  "-----------------------------------------------------------------\n"
> -"o The line 'Prompt:' shows the text used in the menu structure for\n"
> -"  this symbol\n"
> -"o The 'Defined at' line tell at what file / line number the symbol\n"
> -"  is defined\n"
> -"o The 'Depends on:' line tell what symbols needs to be defined for\n"
> -"  this symbol to be visible in the menu (selectable)\n"
> -"o The 'Location:' lines tell where in the menu structure this symbol\n"
> -"  is located\n"
> -"    A location followed by a [ = y] indicate that this is a selectable\n"
> -"    menu item - and current value is displayed inside brackets.\n"
> -"o The 'Selects:' line tell what symbol will be automatically\n"
> -"  selected if this symbol is selected (y or m)\n"
> -"o The 'Selected by' line tell what symbol has selected this symbol\n"
> +"o  The line 'Prompt:' shows the menu text displayed for this symbol in\n"

... shows the [elided] text ...

Any reason for the re-indent with one more space?

> +"   the menu hierarchy.\n"
> +"o  The 'Defined at' line tells at what file / line number the symbol is\n"

... file & line ...

> +"o  The 'Depends on:' line tells, what symbols need to be defined for\n"

... line lists symbols that need ...

I will push soon to my branch.

Thank you! :-)
Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

