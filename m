Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3ETPs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:48:27 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39218 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3ETPsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:48:14 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Gouders <dirk@gouders.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 2/2] mconf: handle keys in empty dialogs
Date: Mon, 20 May 2013 17:48:03 +0200
Message-Id: <8f9c6f75f603132869375a203d22e5b445f6294f.1369064712.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1369064712.git.yann.morin.1998@free.fr>
References: <cover.1369064712.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1369064712.git.yann.morin.1998@free.fr>
References: <cover.1369064712.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Gouders <dirk@gouders.net>

When entering an empty dialog, using the movement keys resulted in
unexpected characters beeing displayed, other keys like "z" and "h"
did not work as expected.

This patch handles the movement keys as well as other keys, especially
"z", "h" and "/".

Signed-off-by: Dirk Gouders <dirk@gouders.net>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/lxdialog/menubox.c |  8 ++++----
 scripts/kconfig/mconf.c            | 11 ++++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 48d382e..eda0350 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -303,10 +303,10 @@ do_resize:
 				}
 		}
 
-		if (i < max_choice ||
-		    key == KEY_UP || key == KEY_DOWN ||
-		    key == '-' || key == '+' ||
-		    key == KEY_PPAGE || key == KEY_NPAGE) {
+		if ((i < max_choice ||
+		     key == KEY_UP || key == KEY_DOWN ||
+		     key == '-' || key == '+' ||
+		     key == KEY_PPAGE || key == KEY_NPAGE) && item_count() != 0) {
 			/* Remove highligt of current item */
 			print_item(scroll + choice, choice, FALSE);
 
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 387dc8d..a69cbd7 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -670,11 +670,12 @@ static void conf(struct menu *menu, struct menu *active_menu)
 				  active_menu, &s_scroll);
 		if (res == 1 || res == KEY_ESC || res == -ERRDISPLAYTOOSMALL)
 			break;
-		if (!item_activate_selected())
-			continue;
-		if (!item_tag())
-			continue;
-
+		if (item_count() != 0) {
+			if (!item_activate_selected())
+				continue;
+			if (!item_tag())
+				continue;
+		}
 		submenu = item_data();
 		active_menu = item_data();
 		if (submenu)
-- 
1.8.1.2

