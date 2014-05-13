Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891AbaEMOU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:20:29 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35780 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760406AbaEMOUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:20:24 -0400
Date: Tue, 13 May 2014 16:20:16 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] shmem: support RENAME_NOREPLACE
Message-ID: <20140513142016.GE17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Expand noreplace_rename2() because next patch will implement one more flag.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 mm/shmem.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1995,6 +1995,14 @@ static int shmem_rename(struct inode *ol
 	return 0;
 }
 
+static int shmem_rename2(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry, unsigned int flags)
+{
+	if (flags & ~(RENAME_NOREPLACE))
+		return -EINVAL;
+
+	return shmem_rename(old_dir, old_dentry, new_dir, new_dentry);
+}
+
 static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 {
 	int error;
@@ -2658,6 +2666,7 @@ static const struct inode_operations shm
 	.rmdir		= shmem_rmdir,
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
+	.rename2	= shmem_rename2,
 	.tmpfile	= shmem_tmpfile,
 #endif
 #ifdef CONFIG_TMPFS_XATTR
