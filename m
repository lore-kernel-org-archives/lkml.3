Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3FRWsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:48:15 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:49332 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042Ab3FRWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:26 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dirk Gouders <dirk@gouders.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 05/14] mconf: use function calls instead of ncurses' variables LINES and COLS
Date: Wed, 19 Jun 2013 00:45:01 +0200
Message-Id: <4f2de3e19983dafca264b672152b36e4962ca1c3.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Gouders <dirk@gouders.net>

According to the documentation [1], LINES and COLS are initialized by
initscr(); it does not say anything about the behavior when windows are
resized.

Do not rely on the current implementation of ncurses that updates
these variables on resize, but use the propper function calls to get
window dimensions.

init_dialog() could make use of the variables, but for the sake of
consistency we do not change it's current use of the macro getmaxyx().

[1] ncurses(3X)

Signed-off-by: Dirk Gouders <dirk@gouders.net>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
---
 scripts/kconfig/lxdialog/checklist.c |  4 ++--
 scripts/kconfig/lxdialog/inputbox.c  |  4 ++--
 scripts/kconfig/lxdialog/menubox.c   |  4 ++--
 scripts/kconfig/lxdialog/textbox.c   |  4 ++--
 scripts/kconfig/lxdialog/util.c      | 13 +++++++++----
 scripts/kconfig/lxdialog/yesno.c     |  4 ++--
 6 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
index 3034057..3b15c08 100644
--- a/scripts/kconfig/lxdialog/checklist.c
+++ b/scripts/kconfig/lxdialog/checklist.c
@@ -140,8 +140,8 @@ do_resize:
 	max_choice = MIN(list_height, item_count());
 
 	/* center dialog box on screen */
-	x = (COLS - width) / 2;
-	y = (LINES - height) / 2;
+	x = (getmaxx(stdscr) - width) / 2;
+	y = (getmaxy(stdscr) - height) / 2;
 
 	draw_shadow(stdscr, y, x, height, width);
 
diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 7b01add..447a582 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -62,8 +62,8 @@ do_resize:
 		return -ERRDISPLAYTOOSMALL;
 
 	/* center dialog box on screen */
-	x = (COLS - width) / 2;
-	y = (LINES - height) / 2;
+	x = (getmaxx(stdscr) - width) / 2;
+	y = (getmaxy(stdscr) - height) / 2;
 
 	draw_shadow(stdscr, y, x, height, width);
 
diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 00d2841..92b89a6 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -203,8 +203,8 @@ do_resize:
 	max_choice = MIN(menu_height, item_count());
 
 	/* center dialog box on screen */
-	x = (COLS - width) / 2;
-	y = (LINES - height) / 2;
+	x = (getmaxx(stdscr) - width) / 2;
+	y = (getmaxy(stdscr) - height) / 2;
 
 	draw_shadow(stdscr, y, x, height, width);
 
diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index 907cdcb..1773319 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -98,8 +98,8 @@ do_resize:
 			width = 0;
 
 	/* center dialog box on screen */
-	x = (COLS - width) / 2;
-	y = (LINES - height) / 2;
+	x = (getmaxx(stdscr) - width) / 2;
+	y = (getmaxy(stdscr) - height) / 2;
 
 	draw_shadow(stdscr, y, x, height, width);
 
diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index 0fa567e..58a8289 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -254,7 +254,12 @@ void attr_clear(WINDOW * win, int height, int width, chtype attr)
 
 void dialog_clear(void)
 {
-	attr_clear(stdscr, LINES, COLS, dlg.screen.atr);
+	int lines, columns;
+
+	lines = getmaxy(stdscr);
+	columns = getmaxx(stdscr);
+
+	attr_clear(stdscr, lines, columns, dlg.screen.atr);
 	/* Display background title if it exists ... - SLH */
 	if (dlg.backtitle != NULL) {
 		int i, len = 0, skip = 0;
@@ -269,10 +274,10 @@ void dialog_clear(void)
 		}
 
 		wmove(stdscr, 1, 1);
-		if (len > COLS - 2) {
+		if (len > columns - 2) {
 			const char *ellipsis = "[...] ";
 			waddstr(stdscr, ellipsis);
-			skip = len - (COLS - 2 - strlen(ellipsis));
+			skip = len - (columns - 2 - strlen(ellipsis));
 		}
 
 		for (pos = dlg.subtitles; pos != NULL; pos = pos->next) {
@@ -298,7 +303,7 @@ void dialog_clear(void)
 				skip--;
 		}
 
-		for (i = len + 1; i < COLS - 1; i++)
+		for (i = len + 1; i < columns - 1; i++)
 			waddch(stdscr, ACS_HLINE);
 	}
 	wnoutrefresh(stdscr);
diff --git a/scripts/kconfig/lxdialog/yesno.c b/scripts/kconfig/lxdialog/yesno.c
index abb0c39..676fb2f 100644
--- a/scripts/kconfig/lxdialog/yesno.c
+++ b/scripts/kconfig/lxdialog/yesno.c
@@ -51,8 +51,8 @@ do_resize:
 		return -ERRDISPLAYTOOSMALL;
 
 	/* center dialog box on screen */
-	x = (COLS - width) / 2;
-	y = (LINES - height) / 2;
+	x = (getmaxx(stdscr) - width) / 2;
+	y = (getmaxy(stdscr) - height) / 2;
 
 	draw_shadow(stdscr, y, x, height, width);
 
-- 
1.8.1.2

