Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782AbaKMV3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:38 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37133 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934527AbaKMV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:34 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Jan Harkes <jaharkes@cs.cmu.edu>,
        coda@cs.cmu.edu (maintainer:CODA FILE SYSTEM),
        codalist@TELEMANN.coda.cs.cmu.edu (open list:CODA FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 15/56] fs/coda: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:52 +0100
Message-Id: <1415913813-362-16-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from coda when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/coda/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/coda/file.c b/fs/coda/file.c
index d244d74..a9d8c5d 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -42,6 +42,7 @@ coda_file_read(struct file *coda_file, char __user *buf, size_t count, loff_t *p
 	return host_file->f_op->read(host_file, buf, count, ppos);
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static ssize_t
 coda_file_splice_read(struct file *coda_file, loff_t *ppos,
 		      struct pipe_inode_info *pipe, size_t count,
@@ -62,6 +63,7 @@ coda_file_splice_read(struct file *coda_file, loff_t *ppos,
 
 	return splice_read(host_file, ppos, pipe, count, flags);
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static ssize_t
 coda_file_write(struct file *coda_file, const char __user *buf, size_t count, loff_t *ppos)
@@ -237,6 +239,6 @@ const struct file_operations coda_file_operations = {
 	.open		= coda_open,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
-	.splice_read	= coda_file_splice_read,
+	SPLICE_READ_INIT(coda_file_splice_read)
 };
 
-- 
1.9.1

