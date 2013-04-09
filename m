Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936093Ab3DIGae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:30:34 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49791 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934585Ab3DIGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:30:20 -0400
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 14:30:19 +0800
Message-ID: <CAPgLHd8qC7XNYGzzozXjFXLmu6VER=20D46N7LMqfNDy3jx1LA@mail.gmail.com>
Subject: [PATCH -next] mei: convert to use simple_open()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: tomas.winkler@intel.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This removes an open coded simple_open() function and
replaces file operations references to the function
with simple_open() instead.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/mei/debugfs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index 7135a718..e3870f2 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -24,12 +24,6 @@
 #include "mei_dev.h"
 #include "hw.h"
 
-static int mei_dbgfs_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 					size_t cnt, loff_t *ppos)
 {
@@ -76,7 +70,7 @@ out:
 }
 
 static const struct file_operations mei_dbgfs_fops_meclients = {
-	.open = mei_dbgfs_open,
+	.open = simple_open,
 	.read = mei_dbgfs_read_meclients,
 	.llseek = generic_file_llseek,
 };
@@ -100,7 +94,7 @@ static ssize_t mei_dbgfs_read_devstate(struct file *fp, char __user *ubuf,
 	return ret;
 }
 static const struct file_operations mei_dbgfs_fops_devstate = {
-	.open = mei_dbgfs_open,
+	.open = simple_open,
 	.read = mei_dbgfs_read_devstate,
 	.llseek = generic_file_llseek,
 };

