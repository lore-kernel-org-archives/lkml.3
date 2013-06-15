Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3FOIs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 04:48:27 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:42172 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3FOIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 04:48:25 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Benjamin Poirier <bpoirier@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH kbuild-next] kconfig/lxdialog: Add definitions for mininimum (re)size values
Date: Sat, 15 Jun 2013 10:48:13 +0200
Message-Id: <1371286093-4003-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c8dc68ad0fbd ("kconfig/lxdialog: support resize") added support
for resizing, but forgot to collect all hardcoded values at one single
place.

Also add a definition for the check for a minimum screen/window size
of 80x19.

[ ChangeLog v2:
  * Rename WIN_{HEIGTH,WIDTH}_MIN -> WINDOW_{HEIGTH,WIDTH}_MIN
  * Mention the check for a minimum screen/window size in the changelog
  * Add a comment above the block of new definitions ]

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 scripts/kconfig/lxdialog/checklist.c |  4 ++--
 scripts/kconfig/lxdialog/dialog.h    | 14 ++++++++++++++
 scripts/kconfig/lxdialog/inputbox.c  |  4 ++--
 scripts/kconfig/lxdialog/menubox.c   |  2 +-
 scripts/kconfig/lxdialog/textbox.c   |  2 +-
 scripts/kconfig/lxdialog/util.c      |  2 +-
 scripts/kconfig/lxdialog/yesno.c     |  4 ++--
 7 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
index a2eb80f..3034057 100644
--- a/scripts/kconfig/lxdialog/checklist.c
+++ b/scripts/kconfig/lxdialog/checklist.c
@@ -132,9 +132,9 @@ int dialog_checklist(const char *title, const char *prompt, int height,
 	}
 
 do_resize:
-	if (getmaxy(stdscr) < (height + 6))
+	if (getmaxy(stdscr) < (height + CHECKLIST_HEIGTH_MIN))
 		return -ERRDISPLAYTOOSMALL;
-	if (getmaxx(stdscr) < (width + 6))
+	if (getmaxx(stdscr) < (width + CHECKLIST_WIDTH_MIN))
 		return -ERRDISPLAYTOOSMALL;
 
 	max_choice = MIN(list_height, item_count());
diff --git a/scripts/kconfig/lxdialog/dialog.h b/scripts/kconfig/lxdialog/dialog.h
index 10993370..f9bfd7d 100644
--- a/scripts/kconfig/lxdialog/dialog.h
+++ b/scripts/kconfig/lxdialog/dialog.h
@@ -200,6 +200,20 @@ int item_is_tag(char tag);
 int on_key_esc(WINDOW *win);
 int on_key_resize(void);
 
+/* minimum (re)size values */
+#define CHECKLIST_HEIGTH_MIN 6	/* For dialog_checklist() */
+#define CHECKLIST_WIDTH_MIN 6
+#define INPUTBOX_HEIGTH_MIN 2	/* For dialog_inputbox() */
+#define INPUTBOX_WIDTH_MIN 2
+#define MENU_HEIGTH_MIN 15	/* For dialog_menu() */
+#define MENU_WIDTH_MIN 65
+#define TEXTBOX_HEIGTH_MIN 8	/* For dialog_textbox() */
+#define TEXTBOX_WIDTH_MIN 8
+#define YESNO_HEIGTH_MIN 4	/* For dialog_yesno() */
+#define YESNO_WIDTH_MIN 4
+#define WINDOW_HEIGTH_MIN 19	/* For init_dialog() */
+#define WINDOW_WIDTH_MIN 80
+
 int init_dialog(const char *backtitle);
 void set_dialog_backtitle(const char *backtitle);
 void set_dialog_subtitles(struct subtitle_list *subtitles);
diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 21404a0..7b01add 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -56,9 +56,9 @@ int dialog_inputbox(const char *title, const char *prompt, int height, int width
 		strcpy(instr, init);
 
 do_resize:
-	if (getmaxy(stdscr) <= (height - 2))
+	if (getmaxy(stdscr) <= (height - INPUTBOX_HEIGTH_MIN))
 		return -ERRDISPLAYTOOSMALL;
-	if (getmaxx(stdscr) <= (width - 2))
+	if (getmaxx(stdscr) <= (width - INPUTBOX_WIDTH_MIN))
 		return -ERRDISPLAYTOOSMALL;
 
 	/* center dialog box on screen */
diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 38cd69c..0ab663d 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -193,7 +193,7 @@ int dialog_menu(const char *title, const char *prompt,
 do_resize:
 	height = getmaxy(stdscr);
 	width = getmaxx(stdscr);
-	if (height < 15 || width < 65)
+	if (height < MENU_HEIGTH_MIN || width < MENU_WIDTH_MIN)
 		return -ERRDISPLAYTOOSMALL;
 
 	height -= 4;
diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index a48bb93..907cdcb 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -80,7 +80,7 @@ int dialog_textbox(const char *title, char *tbuf, int initial_height,
 
 do_resize:
 	getmaxyx(stdscr, height, width);
-	if (height < 8 || width < 8)
+	if (height < TEXTBOX_HEIGTH_MIN || width < TEXTBOX_WIDTH_MIN)
 		return -ERRDISPLAYTOOSMALL;
 	if (initial_height != 0)
 		height = initial_height;
diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index a0e97c2..78fe4e9 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -317,7 +317,7 @@ int init_dialog(const char *backtitle)
 	getyx(stdscr, saved_y, saved_x);
 
 	getmaxyx(stdscr, height, width);
-	if (height < 19 || width < 80) {
+	if (height < WINDOW_HEIGTH_MIN || width < WINDOW_WIDTH_MIN) {
 		endwin();
 		return -ERRDISPLAYTOOSMALL;
 	}
diff --git a/scripts/kconfig/lxdialog/yesno.c b/scripts/kconfig/lxdialog/yesno.c
index 4e6e809..abb0c39 100644
--- a/scripts/kconfig/lxdialog/yesno.c
+++ b/scripts/kconfig/lxdialog/yesno.c
@@ -45,9 +45,9 @@ int dialog_yesno(const char *title, const char *prompt, int height, int width)
 	WINDOW *dialog;
 
 do_resize:
-	if (getmaxy(stdscr) < (height + 4))
+	if (getmaxy(stdscr) < (height + YESNO_HEIGTH_MIN))
 		return -ERRDISPLAYTOOSMALL;
-	if (getmaxx(stdscr) < (width + 4))
+	if (getmaxx(stdscr) < (width + YESNO_WIDTH_MIN))
 		return -ERRDISPLAYTOOSMALL;
 
 	/* center dialog box on screen */
-- 
1.8.3.1

