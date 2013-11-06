Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3KFBrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:47:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50957 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab3KFBrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:47:24 -0500
X-IronPort-AV: E=Sophos;i="4.93,643,1378828800"; 
   d="scan'208";a="8956362"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] [SCSI] fnic: convert to use simple_open()
Date: Wed, 6 Nov 2013 09:45:09 +0800
Message-Id: <1383702309-3866-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 09:45:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 09:45:30,
	Serialize complete at 2013/11/06 09:45:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes an open code simple_open() function and replaces file
operations references to the function with simple_open() instead.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/scsi/fnic/fnic_debugfs.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index b6073f8..9852e4f 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -77,23 +77,6 @@ void fnic_debugfs_terminate(void)
 }
 
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
@@ -274,7 +257,7 @@ static int fnic_trace_debugfs_release(struct inode *inode,
 
 static const struct file_operations fnic_trace_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.open = fnic_trace_ctrl_open,
+	.open = simple_open,
 	.read = fnic_trace_ctrl_read,
 	.write = fnic_trace_ctrl_write,
 };
-- 
1.8.3.1

