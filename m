Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3JCR1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:27:21 -0400
Received: from mout.web.de ([212.227.17.12]:59591 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab3JCR0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:26:34 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] kconfig: fix trivial typos and update mconf documentation
Date: Thu, 03 Oct 2013 19:24:29 +0200
Message-ID: <7686213.7MfDICRPAE@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:TGuksNv37nhZHWIrWTl1/8annXTIt2y3Pd3S3MxUeOTtbj0Tqif
 XeZxHtDXqcNbs7IkBylBcEuR2hC0scPEKcEe0D9VQUumabURIhV4CASvnYzHFj95KAxcU0j
 YJ9ZHfSWfbrSOZxgSHFOq0RlnOkFlYrYs3bxPG2HqkSiW2x/iNh1kzNHVUcwHyqCtxN3AXN
 bmpX96WcHgdLRkO250hpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Thu, 3 Oct 2013 17:28:14 +0200
Subject: [PATCH v2 2/5] kconfig: fix trivial typos and update mconf documentation

This fixes lots of typos in comments and strings.

It also updates the documentation strings in mconf to reflect the changes in
the user interface from the two commits

6364fd0cb1e4c7f72b974613e0cf5744ae4d2cb2
  menuconfig: Add Save/Load buttons
1bdbac478a858d2aa73a6784c7c2e09de0f6d06b
  menuconfig: Get rid of the top-level entries for "Load an Alternate/Save an Alternate"

And it updates the layout of the example search result, i. e. moves down the
"Defined at" and "Depends on" lines and adds a symbol state ([=n]) to the
symbol in the "Selected by" line.

Furthermore, the help texts now should fit in 80 columns again when viewed
in mconf.

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/mconf.c  | 60 +++++++++++++++++++++++-------------------------
 scripts/kconfig/menu.c   |  2 +-
 scripts/kconfig/symbol.c |  2 +-
 3 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 2c39631..59184bb 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -25,7 +25,7 @@
 static const char mconf_readme[] = N_(
 "Overview\n"
 "--------\n"
-"This interface let you select features and parameters for the build.\n"
+"This interface lets you select features and parameters for the build.\n"
 "Features can either be built-in, modularized, or ignored. Parameters\n"
 "must be entered in as decimal or hexadecimal numbers or text.\n"
 "\n"
@@ -39,15 +39,15 @@ static const char mconf_readme[] = N_(
 "\n"
 "To change any of these features, highlight it with the cursor\n"
 "keys and press <Y> to build it in, <M> to make it a module or\n"
-"<N> to removed it.  You may also press the <Space Bar> to cycle\n"
-"through the available options (ie. Y->N->M->Y).\n"
+"<N> to remove it.  You may also press the <Space Bar> to cycle\n"
+"through the available options (i.e. Y->N->M->Y).\n"
 "\n"
 "Some additional keyboard hints:\n"
 "\n"
 "Menus\n"
 "----------\n"
-"o  Use the Up/Down arrow keys (cursor keys) to highlight the item\n"
-"   you wish to change or submenu wish to select and press <Enter>.\n"
+"o  Use the Up/Down arrow keys (cursor keys) to highlight the item you\n"
+"   wish to change or the submenu you wish to select and press <Enter>.\n"
 "   Submenus are designated by \"--->\", empty ones by \"----\".\n"
 "\n"
 "   Shortcut: Press the option's highlighted letter (hotkey).\n"
@@ -65,7 +65,7 @@ static const char mconf_readme[] = N_(
 "             there is a delayed response which you may find annoying.\n"
 "\n"
 "   Also, the <TAB> and cursor keys will cycle between <Select>,\n"
-"   <Exit> and <Help>.\n"
+"   <Exit>, <Help>, <Save>, and <Load>.\n"
 "\n"
 "o  To get help with an item, use the cursor keys to highlight <Help>\n"
 "   and press <ENTER>.\n"
@@ -105,7 +105,7 @@ static const char mconf_readme[] = N_(
 "Text Box    (Help Window)\n"
 "--------\n"
 "o  Use the cursor keys to scroll up/down/left/right.  The VI editor\n"
-"   keys h,j,k,l function here as do <u>, <d>, <SPACE BAR> and <B> for \n"
+"   keys h,j,k,l function here as do <u>, <d>, <SPACE BAR> and <B> for\n"
 "   those who are familiar with less and lynx.\n"
 "\n"
 "o  Press <E>, <X>, <q>, <Enter> or <Esc><Esc> to exit.\n"
@@ -117,23 +117,21 @@ static const char mconf_readme[] = N_(
 "those who, for various reasons, find it necessary to switch\n"
 "between different configurations.\n"
 "\n"
-"At the end of the main menu you will find two options.  One is\n"
-"for saving the current configuration to a file of your choosing.\n"
-"The other option is for loading a previously saved alternate\n"
-"configuration.\n"
+"The <Save> button will let you save the current configuration to\n"
+"a file of your choosing.  Use the <Load> button to load a previously\n"
+"saved alternate configuration.\n"
 "\n"
-"Even if you don't use alternate configuration files, but you\n"
-"find during a Menuconfig session that you have completely messed\n"
-"up your settings, you may use the \"Load Alternate...\" option to\n"
-"restore your previously saved settings from \".config\" without\n"
-"restarting Menuconfig.\n"
+"Even if you don't use alternate configuration files, but you find\n"
+"during a Menuconfig session that you have completely messed up your\n"
+"settings, you may use the <Load> button to restore your previously\n"
+"saved settings from \".config\" without restarting Menuconfig.\n"
 "\n"
 "Other information\n"
 "-----------------\n"
-"If you use Menuconfig in an XTERM window make sure you have your\n"
-"$TERM variable set to point to a xterm definition which supports color.\n"
-"Otherwise, Menuconfig will look rather bad.  Menuconfig will not\n"
-"display correctly in a RXVT window because rxvt displays only one\n"
+"If you use Menuconfig in an XTERM window, make sure you have your\n"
+"$TERM variable set to point to an xterm definition which supports\n"
+"color.  Otherwise, Menuconfig will look rather bad.  Menuconfig will\n"
+"not display correctly in an RXVT window because rxvt displays only one\n"
 "intensity of color, bright.\n"
 "\n"
 "Menuconfig will display larger menus on screens or xterms which are\n"
@@ -148,8 +146,8 @@ static const char mconf_readme[] = N_(
 "\n"
 "Optional personality available\n"
 "------------------------------\n"
-"If you prefer to have all of the options listed in a single menu, rather\n"
-"than the default multimenu hierarchy, run the menuconfig with\n"
+"If you prefer to have all of the options listed in a single menu,\n"
+"rather than the default multimenu hierarchy, run the menuconfig with\n"
 "MENUCONFIG_MODE environment variable set to single_menu. Example:\n"
 "\n"
 "make MENUCONFIG_MODE=single_menu menuconfig\n"
@@ -172,7 +170,7 @@ static const char mconf_readme[] = N_(
 " mono       => selects colors suitable for monochrome displays\n"
 " blackbg    => selects a color scheme with black background\n"
 " classic    => theme with blue background. The classic look\n"
-" bluetitle  => a LCD friendly version of classic. (default)\n"
+" bluetitle  => an LCD friendly version of classic. (default)\n"
 "\n"),
 menu_instructions[] = N_(
 	"Arrow keys navigate the menu.  "
@@ -238,24 +236,24 @@ search_help[] = N_(
 	"Symbol: FOO [=m]\n"
 	"Type  : tristate\n"
 	"Prompt: Foo bus is used to drive the bar HW\n"
-	"  Defined at drivers/pci/Kconfig:47\n"
-	"  Depends on: X86_LOCAL_APIC && X86_IO_APIC || IA64\n"
 	"  Location:\n"
 	"    -> Bus options (PCI, PCMCIA, EISA, ISA)\n"
 	"      -> PCI support (PCI [=y])\n"
 	"(1)     -> PCI access mode (<choice> [=y])\n"
+	"  Defined at drivers/pci/Kconfig:47\n"
+	"  Depends on: X86_LOCAL_APIC && X86_IO_APIC || IA64\n"
 	"  Selects: LIBCRC32\n"
-	"  Selected by: BAR\n"
+	"  Selected by: BAR [=n]\n"
 	"-----------------------------------------------------------------\n"
 	"o The line 'Type:' shows the type of the configuration option for\n"
 	"  this symbol (boolean, tristate, string, ...)\n"
 	"o The line 'Prompt:' shows the text used in the menu structure for\n"
 	"  this symbol\n"
-	"o The 'Defined at' line tell at what file / line number the symbol\n"
+	"o The 'Defined at' line tells at what file / line number the symbol\n"
 	"  is defined\n"
-	"o The 'Depends on:' line tell what symbols needs to be defined for\n"
+	"o The 'Depends on:' line tells what symbols need to be defined for\n"
 	"  this symbol to be visible in the menu (selectable)\n"
-	"o The 'Location:' lines tell where in the menu structure this symbol\n"
+	"o The 'Location:' lines tells where in the menu structure this symbol\n"
 	"  is located\n"
 	"    A location followed by a [=y] indicates that this is a\n"
 	"    selectable menu item - and the current value is displayed inside\n"
@@ -263,9 +261,9 @@ search_help[] = N_(
 	"    Press the key in the (#) prefix to jump directly to that\n"
 	"    location. You will be returned to the current search results\n"
 	"    after exiting this new menu.\n"
-	"o The 'Selects:' line tell what symbol will be automatically\n"
+	"o The 'Selects:' line tells what symbols will be automatically\n"
 	"  selected if this symbol is selected (y or m)\n"
-	"o The 'Selected by' line tell what symbol has selected this symbol\n"
+	"o The 'Selected by' line tells what symbol has selected this symbol\n"
 	"\n"
 	"Only relevant lines are shown.\n"
 	"\n\n"
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index c1d5320..b970101 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -597,7 +597,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 }
 
 /*
- * get peoperty of type P_SYMBOL
+ * get property of type P_SYMBOL
  */
 static struct property *get_symbol_prop(struct symbol *sym)
 {
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index c9a6775..7caabdb 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -1047,7 +1047,7 @@ sym_re_search_free:
  * When we check for recursive dependencies we use a stack to save
  * current state so we can print out relevant info to user.
  * The entries are located on the call stack so no need to free memory.
- * Note inser() remove() must always match to properly clear the stack.
+ * Note insert() remove() must always match to properly clear the stack.
  */
 static struct dep_stack {
 	struct dep_stack *prev, *next;
-- 
1.8.1.5


