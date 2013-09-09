Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3IISK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:10:29 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59882 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3IISK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:10:28 -0400
From: Tom Gundersen <teg@jklm.no>
To: fuse-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        Kay Sievers <kay@vrfy.org>, Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] cuse: creat 'dead' device node for on-demand module loading
Date: Mon,  9 Sep 2013 20:11:38 +0200
Message-Id: <1378750298-965-1-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows udev (or more recently systemd-tmpfiles) to create /dev/cuse on
boot, in the same way as /dev/fuse is currently created, and the corresponding
module to be loaded on first access.

The corresponding functionalty was introduced for fuse in commit 578454f.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---
 fs/fuse/cuse.c             | 5 ++++-
 include/linux/miscdevice.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index adbfd66..24da581 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -589,11 +589,14 @@ static struct attribute *cuse_class_dev_attrs[] = {
 ATTRIBUTE_GROUPS(cuse_class_dev);
 
 static struct miscdevice cuse_miscdev = {
-	.minor		= MISC_DYNAMIC_MINOR,
+	.minor		= CUSE_MINOR,
 	.name		= "cuse",
 	.fops		= &cuse_channel_fops,
 };
 
+MODULE_ALIAS_MISCDEV(CUSE_MINOR);
+MODULE_ALIAS("devname:cuse");
+
 static int __init cuse_init(void)
 {
 	int i, rc;
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index cb35835..65c8619 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -39,6 +39,7 @@
 #define MISC_MCELOG_MINOR	227
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
+#define CUSE_MINOR		230
 #define KVM_MINOR		232
 #define BTRFS_MINOR		234
 #define AUTOFS_MINOR		235
-- 
1.8.4

