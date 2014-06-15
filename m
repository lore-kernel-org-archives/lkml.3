Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaFOVC4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:02:56 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:45593 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaFOVCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:02:55 -0400
From: Mathias Krause <minipli@googlemail.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] agp: remove read/write stubs
Date: Sun, 15 Jun 2014 23:02:45 +0200
Message-Id: <1402866165-17408-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFS layer handles those in the very same way, if unset. No need for
additional stubs.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/agp/frontend.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index b29703324e..09f17eb734 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -710,19 +710,6 @@ static int agp_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-
-static ssize_t agp_read(struct file *file, char __user *buf,
-			size_t count, loff_t * ppos)
-{
-	return -EINVAL;
-}
-
-static ssize_t agp_write(struct file *file, const char __user *buf,
-			 size_t count, loff_t * ppos)
-{
-	return -EINVAL;
-}
-
 static int agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)
 {
 	struct agp_info userinfo;
@@ -1047,8 +1034,6 @@ static const struct file_operations agp_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.read		= agp_read,
-	.write		= agp_write,
 	.unlocked_ioctl	= agp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_agp_ioctl,
-- 
1.7.10.4

