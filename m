Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422AbaKMV27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:28:59 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62793 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418AbaKMV25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:28:57 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 04/56] fs: Macros to define splice file_operations
Date: Thu, 13 Nov 2014 22:22:41 +0100
Message-Id: <1415913813-362-5-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides a CONFIG_SYSCALL_SPLICE compatible way of defining the .splice_read
and .splice_write file_operations so that they can later be compiled out when
the kernel is configured without the splice-family syscalls

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 include/linux/fs.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9418772..a88de9f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1512,6 +1512,32 @@ struct file_operations {
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
+#ifdef CONFIG_SYSCALL_SPLICE
+
+/*
+ * Define and init the splice_read member of a file_operations struct
+ */
+#define SPLICE_READ_INIT(read) .splice_read = read,
+
+/*
+ * Define and init the splice_read member of a file_operations struct
+ */
+#define SPLICE_WRITE_INIT(write) .splice_write = write,
+
+#else /* #ifdef CONFIG_SYSCALL_SPLICE */
+
+/*
+ * Define and init the splice_read member of a file_operations struct
+ */
+#define SPLICE_READ_INIT(read)
+
+/*
+ * Define and init the splice_read member of a file_operations struct
+ */
+#define SPLICE_WRITE_INIT(write)
+
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
+
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
-- 
1.9.1

