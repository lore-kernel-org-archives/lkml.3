Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3F0Q04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:26:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35492 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3F0Q0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:26:54 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] vfs: export do_splice_direct() to modules -- fix
Date: Thu, 27 Jun 2013 17:26:43 +0100
Message-Id: <1372350404-10359-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372350404-10359-1-git-send-email-apw@canonical.com>
References: <1372350404-10359-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit below moved the prototype for do_splice_direct to
fs/internal.h expose it:

  commit 7995bd287134f6c8f80d94bebe7396f05a9bc42b
  Author: Al Viro <viro@zeniv.linux.org.uk>
  Date:   Thu Jun 20 18:58:36 2013 +0400

    splice: don't pass the address of ->f_pos to methods

[This should be merged down into:
 vfs: export do_splice_direct() to modules.]

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/internal.h      | 6 ------
 include/linux/fs.h | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 6dd0ffd..6c9ec69 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -127,12 +127,6 @@ extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
 extern ssize_t __kernel_write(struct file *, const char *, size_t, loff_t *);
 
 /*
- * splice.c
- */
-extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
-		loff_t *opos, size_t len, unsigned int flags);
-
-/*
  * pipe.c
  */
 extern const struct file_operations pipefifo_fops;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e623f11..baf1175 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2703,4 +2703,10 @@ static inline void inode_has_no_xattr(struct inode *inode)
 		inode->i_flags |= S_NOSEC;
 }
 
+/*
+ * splice.c
+ */
+extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
+		loff_t *opos, size_t len, unsigned int flags);
+
 #endif /* _LINUX_FS_H */
-- 
1.8.3.1

