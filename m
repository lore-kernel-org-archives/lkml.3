Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3CQImr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:42:47 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42476 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3CQImq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:42:46 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] net: bluetooth: Use PTR_RET function
Date: Sat, 16 Mar 2013 16:10:03 +0200
Message-Id: <1363443003-13839-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 net/bluetooth/hci_sysfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 23b4e24..ff38561 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -590,10 +590,8 @@ int __init bt_sysfs_init(void)
 	bt_debugfs = debugfs_create_dir("bluetooth", NULL);
 
 	bt_class = class_create(THIS_MODULE, "bluetooth");
-	if (IS_ERR(bt_class))
-		return PTR_ERR(bt_class);
 
-	return 0;
+	return PTR_RET(bt_class);
 }
 
 void bt_sysfs_cleanup(void)
-- 
1.7.9.5

