Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3GJPTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:19:11 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47358 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3GJPTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:19:07 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3/3] menuconfig: allow j/k to move down/up the menu
Date: Wed, 10 Jul 2013 20:45:18 +0530
Message-Id: <1373469318-13956-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373469318-13956-1-git-send-email-artagnon@gmail.com>
References: <1373469318-13956-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like in Vim.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 scripts/kconfig/lxdialog/menubox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 698d7c3..151394a 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -57,7 +57,7 @@
  */
 
 #include "dialog.h"
-#define RESERVED_LETTERS "ynmh"
+#define RESERVED_LETTERS "ynmhjk"
 
 static int menu_width, item_x;
 
@@ -308,11 +308,12 @@ do_resize:
 		    (i < max_choice ||
 		     key == KEY_UP || key == KEY_DOWN ||
 		     key == '-' || key == '+' ||
+		     key == 'j' || key == 'k' ||
 		     key == KEY_PPAGE || key == KEY_NPAGE)) {
 			/* Remove highligt of current item */
 			print_item(scroll + choice, choice, FALSE);
 
-			if (key == KEY_UP || key == '-') {
+			if (key == KEY_UP || key == '-' || key == 'k') {
 				if (choice < 2 && scroll) {
 					/* Scroll menu down */
 					do_scroll(menu, &scroll, -1);
@@ -321,7 +322,7 @@ do_resize:
 				} else
 					choice = MAX(choice - 1, 0);
 
-			} else if (key == KEY_DOWN || key == '+') {
+			} else if (key == KEY_DOWN || key == '+' || key == 'j') {
 				print_item(scroll+choice, choice, FALSE);
 
 				if ((choice > max_choice - 3) &&
-- 
1.8.3.2.736.g869de25

