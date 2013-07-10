Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3GJPTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:19:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37229 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3GJPTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:19:02 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 1/3] menuconfig: factor out reserved letters
Date: Wed, 10 Jul 2013 20:45:16 +0530
Message-Id: <1373469318-13956-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373469318-13956-1-git-send-email-artagnon@gmail.com>
References: <1373469318-13956-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These letters that should not be used in menu selection.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 scripts/kconfig/lxdialog/menubox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 38cd69c..5923f2c 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -57,6 +57,7 @@
  */
 
 #include "dialog.h"
+#define RESERVED_LETTERS "YyNnMmHh"
 
 static int menu_width, item_x;
 
@@ -71,7 +72,7 @@ static void do_print_item(WINDOW * win, const char *item, int line_y,
 
 	strncpy(menu_item, item, menu_width - item_x);
 	menu_item[menu_width - item_x] = '\0';
-	j = first_alpha(menu_item, "YyNnMmHh");
+	j = first_alpha(menu_item, RESERVED_LETTERS);
 
 	/* Clear 'residue' of last item */
 	wattrset(win, dlg.menubox.atr);
@@ -290,14 +291,14 @@ do_resize:
 		else {
 			for (i = choice + 1; i < max_choice; i++) {
 				item_set(scroll + i);
-				j = first_alpha(item_str(), "YyNnMmHh");
+				j = first_alpha(item_str(), RESERVED_LETTERS);
 				if (key == tolower(item_str()[j]))
 					break;
 			}
 			if (i == max_choice)
 				for (i = 0; i < max_choice; i++) {
 					item_set(scroll + i);
-					j = first_alpha(item_str(), "YyNnMmHh");
+					j = first_alpha(item_str(), RESERVED_LETTERS);
 					if (key == tolower(item_str()[j]))
 						break;
 				}
-- 
1.8.3.2.736.g869de25

