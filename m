Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3GLGu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:50:27 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:57594 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3GLGu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:50:26 -0400
From: Camelia Groza <camelia.groza@gmail.com>
To: hiralpat@cisco.com
Cc: sramars@cisco.com, buchino@cisco.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Camelia Groza <camelia.groza@gmail.com>
Subject: [PATCH] fnic: use simple_open instead of fnic_trace_ctrl_open
Date: Fri, 12 Jul 2013 09:50:08 +0300
Message-Id: <1373611808-4959-1-git-send-email-camelia.groza@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the open coded fnic_trace_ctrl_open() function
and replaces file operations references to the function
with simple_open() instead.

Found using coccinelle.

Signed-off-by: Camelia Groza <camelia.groza@gmail.com>
---
 drivers/scsi/fnic/fnic_debugfs.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index cbcb012..ddc7e94 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -25,23 +25,6 @@ static struct dentry *fnic_trace_debugfs_file;
 static struct dentry *fnic_trace_enable;
 
 /*
- * fnic_trace_ctrl_open - Open the trace_enable file
- * @inode: The inode pointer.
- * @file: The file pointer to attach the trace enable/disable flag.
- *
- * Description:
- * This routine opens a debugsfs file trace_enable.
- *
- * Returns:
- * This function returns zero if successful.
- */
-static int fnic_trace_ctrl_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-/*
  * fnic_trace_ctrl_read - Read a trace_enable debugfs file
  * @filp: The file pointer to read from.
  * @ubuf: The buffer to copy the data to.
@@ -222,7 +205,7 @@ static int fnic_trace_debugfs_release(struct inode *inode,
 
 static const struct file_operations fnic_trace_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.open = fnic_trace_ctrl_open,
+	.open = simple_open,
 	.read = fnic_trace_ctrl_read,
 	.write = fnic_trace_ctrl_write,
 };
-- 
1.7.10.4

