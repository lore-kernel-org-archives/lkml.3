Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaA3SHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:07:51 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49371 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbaA3SHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:07:49 -0500
From: Richard Yao <ryao@gentoo.org>
To: Rob Landley <rob@landley.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Jeff Layton <jlayton@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Linux Documentation Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gentoo Kernel Team <kernel@gentoo.org>,
        Matthew Thode <mthode@mthode.org>, Richard Yao <ryao@gentoo.org>
Subject: [PATCH] vfs: Update file_operations documentation
Date: Thu, 30 Jan 2014 13:07:42 -0500
Message-Id: <1391105262-10327-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->readv, ->writev and ->sendfile have been removed while ->show_fdinfo
has been added. The documentation should reflect this.

Signed-off-by: Richard Yao <ryao@gentoo.org>
---
 Documentation/filesystems/vfs.txt | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index deb48b5..c53784c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -782,7 +782,7 @@ struct file_operations
 ----------------------
 
 This describes how the VFS can manipulate an open file. As of kernel
-3.5, the following members are defined:
+3.12, the following members are defined:
 
 struct file_operations {
 	struct module *owner;
@@ -803,9 +803,6 @@ struct file_operations {
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
-	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long, loff_t *);
-	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long, loff_t *);
-	ssize_t (*sendfile) (struct file *, loff_t *, size_t, read_actor_t, void *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	int (*check_flags)(int);
@@ -814,6 +811,7 @@ struct file_operations {
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long arg, struct file_lock **);
 	long (*fallocate)(struct file *, int mode, loff_t offset, loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -864,12 +862,6 @@ otherwise noted.
   lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
   	commands
 
-  readv: called by the readv(2) system call
-
-  writev: called by the writev(2) system call
-
-  sendfile: called by the sendfile(2) system call
-
   get_unmapped_area: called by the mmap(2) system call
 
   check_flags: called by the fcntl(2) system call for F_SETFL command
-- 
1.8.3.2

