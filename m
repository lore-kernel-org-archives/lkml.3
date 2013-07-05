Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab3GELgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 07:36:53 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36667 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3GELgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 07:36:51 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [PATCH] menuconfig: Allow j/k to move down/up the menu
Date: Fri,  5 Jul 2013 17:02:59 +0530
Message-Id: <1373023979-20537-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.722.g3244e19.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like in Vim.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Unsure why nobody has done this yet.

 scripts/kconfig/lxdialog/menubox.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 38cd69c..17fd936 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -307,11 +307,12 @@ do_resize:
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
@@ -320,7 +321,7 @@ do_resize:
 				} else
 					choice = MAX(choice - 1, 0);
 
-			} else if (key == KEY_DOWN || key == '+') {
+			} else if (key == KEY_DOWN || key == '+' || key == 'j') {
 				print_item(scroll+choice, choice, FALSE);
 
 				if ((choice > max_choice - 3) &&
-- 
1.8.3.2.722.g3244e19.dirty

