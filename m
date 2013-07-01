Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3GADOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:14:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60149 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab3GADON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:14:13 -0400
X-Sasl-enc: M6HQGiZyuGtned4027I/FU5w5aC1uVUVYMyeq0pQ6Wos 1372648451
Subject: [RFC PATCH 1/7] autofs4 - coding style fixes
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 11:14:08 +0800
Message-ID: <20130701031407.4423.78552.stgit@perseus.fritz.box>
In-Reply-To: <20130701031335.4423.6154.stgit@perseus.fritz.box>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try and make the coding style completely consistent throughtout the
autofs module and inline with kernel coding style recommendations.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/autofs_i.h   |   30 +++++++++++++++---------------
 fs/autofs4/expire.c     |   38 +++++++++++++++++++-------------------
 fs/autofs4/init.c       |    5 +----
 fs/autofs4/inode.c      |    5 +----
 fs/autofs4/root.c       |   22 +++++++++++-----------
 fs/autofs4/symlink.c    |    5 +----
 fs/autofs4/waitq.c      |   14 ++++++--------
 include/linux/auto_fs.h |    5 +----
 8 files changed, 55 insertions(+), 69 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 16d3288..76b8097 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -1,7 +1,4 @@
-/* -*- c -*- ------------------------------------------------------------- *
- *   
- * linux/fs/autofs/autofs_i.h
- *
+/*
  *   Copyright 1997-1998 Transmeta Corporation - All Rights Reserved
  *   Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
@@ -51,12 +48,14 @@
 	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
-/* Unified info structure.  This is pointed to by both the dentry and
-   inode structures.  Each file in the filesystem has an instance of this
-   structure.  It holds a reference to the dentry, so dentries are never
-   flushed while the file exists.  All name lookups are dealt with at the
-   dentry level, although the filesystem can interfere in the validation
-   process.  Readdir is implemented by traversing the dentry lists. */
+/*
+ * Unified info structure.  This is pointed to by both the dentry and
+ * inode structures.  Each file in the filesystem has an instance of this
+ * structure.  It holds a reference to the dentry, so dentries are never
+ * flushed while the file exists.  All name lookups are dealt with at the
+ * dentry level, although the filesystem can interfere in the validation
+ * process.  Readdir is implemented by traversing the dentry lists.
+ */
 struct autofs_info {
 	struct dentry	*dentry;
 	struct inode	*inode;
@@ -78,7 +77,7 @@ struct autofs_info {
 	kgid_t gid;
 };
 
-#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
+#define AUTOFS_INF_EXPIRING	(1<<0) /* dentry in the process of expiring */
 #define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
 
 struct autofs_wait_queue {
@@ -138,7 +137,8 @@ static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
    processes which do manipulations for us in user space sees the raw
    filesystem without "magic".) */
 
-static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
+static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
+{
 	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
@@ -163,12 +163,12 @@ void autofs4_free_ino(struct autofs_info *);
 int is_autofs4_dentry(struct dentry *);
 int autofs4_expire_wait(struct dentry *dentry);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *,
-			struct autofs_packet_expire __user *);
+		       struct autofs_sb_info *,
+		       struct autofs_packet_expire __user *);
 int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 			    struct autofs_sb_info *sbi, int when);
 int autofs4_expire_multi(struct super_block *, struct vfsmount *,
-			struct autofs_sb_info *, int __user *);
+			 struct autofs_sb_info *, int __user *);
 struct dentry *autofs4_expire_direct(struct super_block *sb,
 				     struct vfsmount *mnt,
 				     struct autofs_sb_info *sbi, int how);
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 13ddec9..ddee37a 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/expire.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
  *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
@@ -18,7 +15,7 @@ static unsigned long now;
 
 /* Check if a dentry can be expired */
 static inline int autofs4_can_expire(struct dentry *dentry,
-					unsigned long timeout, int do_now)
+				     unsigned long timeout, int do_now)
 {
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 
@@ -81,7 +78,7 @@ done:
  * Calculate and dget next entry in the subdirs list under root.
  */
 static struct dentry *get_next_positive_subdir(struct dentry *prev,
-						struct dentry *root)
+					       struct dentry *root)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
 	struct list_head *next;
@@ -128,7 +125,7 @@ cont:
  * Calculate and dget next entry in top down tree traversal.
  */
 static struct dentry *get_next_positive_dentry(struct dentry *prev,
-						struct dentry *root)
+					       struct dentry *root)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
 	struct list_head *next;
@@ -194,9 +191,9 @@ again:
  * autofs submounts.
  */
 static int autofs4_direct_busy(struct vfsmount *mnt,
-				struct dentry *top,
-				unsigned long timeout,
-				int do_now)
+			       struct dentry *top,
+			       unsigned long timeout,
+			       int do_now)
 {
 	DPRINTK("top %p %.*s",
 		top, (int) top->d_name.len, top->d_name.name);
@@ -216,7 +213,8 @@ static int autofs4_direct_busy(struct vfsmount *mnt,
 	return 0;
 }
 
-/* Check a directory tree of mount points for busyness
+/*
+ * Check a directory tree of mount points for busyness
  * The tree is not busy iff no mountpoints are busy
  */
 static int autofs4_tree_busy(struct vfsmount *mnt,
@@ -387,8 +385,8 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		 *	   offset (autofs-5.0+).
 		 */
 		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s",
-				dentry, (int)dentry->d_name.len, dentry->d_name.name);
+			DPRINTK("checking mountpoint %p %.*s", dentry,
+				(int)dentry->d_name.len, dentry->d_name.name);
 
 			/* Can we umount this guy */
 			if (autofs4_mount_busy(mnt, dentry))
@@ -485,9 +483,9 @@ int autofs4_expire_wait(struct dentry *dentry)
 
 /* Perform an expiry operation */
 int autofs4_expire_run(struct super_block *sb,
-		      struct vfsmount *mnt,
-		      struct autofs_sb_info *sbi,
-		      struct autofs_packet_expire __user *pkt_p)
+		       struct vfsmount *mnt,
+		       struct autofs_sb_info *sbi,
+		       struct autofs_packet_expire __user *pkt_p)
 {
 	struct autofs_packet_expire pkt;
 	struct autofs_info *ino;
@@ -507,7 +505,7 @@ int autofs4_expire_run(struct super_block *sb,
 	pkt.name[pkt.len] = '\0';
 	dput(dentry);
 
-	if ( copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)) )
+	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
 		ret = -EFAULT;
 
 	spin_lock(&sbi->fs_lock);
@@ -547,8 +545,10 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 	return ret;
 }
 
-/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
-   more to be done */
+/*
+ * Call repeatedly until it returns -EAGAIN, meaning there's nothing
+ * more to be done.
+ */
 int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 			struct autofs_sb_info *sbi, int __user *arg)
 {
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index b3db517..5a66322 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/init.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 1b045ec..eafdf6e 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/inode.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 2005-2006 Ian Kent <raven@themaw.net>
  *
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index ca8e555..a5b3825 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/root.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
  *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
@@ -466,7 +463,8 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
+static struct dentry *autofs4_lookup(struct inode *dir,
+				     struct dentry *dentry, unsigned int flags)
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
@@ -743,7 +741,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t m
 /* Get/set timeout ioctl() operation */
 #ifdef CONFIG_COMPAT
 static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
-					 compat_ulong_t __user *p)
+						 compat_ulong_t __user *p)
 {
 	int rv;
 	unsigned long ntimeout;
@@ -762,7 +760,7 @@ static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
 #endif
 
 static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
-					 unsigned long __user *p)
+					  unsigned long __user *p)
 {
 	int rv;
 	unsigned long ntimeout;
@@ -780,13 +778,15 @@ static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 }
 
 /* Return protocol version */
-static inline int autofs4_get_protover(struct autofs_sb_info *sbi, int __user *p)
+static inline int autofs4_get_protover(struct autofs_sb_info *sbi,
+				       int __user *p)
 {
 	return put_user(sbi->version, p);
 }
 
 /* Return protocol sub version */
-static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi, int __user *p)
+static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi,
+					  int __user *p)
 {
 	return put_user(sbi->sub_version, p);
 }
@@ -882,7 +882,7 @@ static long autofs4_root_ioctl(struct file *filp,
 
 #ifdef CONFIG_COMPAT
 static long autofs4_root_compat_ioctl(struct file *filp,
-			     unsigned int cmd, unsigned long arg)
+				      unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	int ret;
@@ -891,7 +891,7 @@ static long autofs4_root_compat_ioctl(struct file *filp,
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 	else
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd,
-			(unsigned long)compat_ptr(arg));
+					      (unsigned long) compat_ptr(arg));
 
 	return ret;
 }
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
index f27c094..063b240 100644
--- a/fs/autofs4/symlink.c
+++ b/fs/autofs4/symlink.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/symlink.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 309ca6b..f1fb9d7 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -1,7 +1,4 @@
-/* -*- c -*- --------------------------------------------------------------- *
- *
- * linux/fs/autofs/waitq.c
- *
+/*
  *  Copyright 1997-1998 Transmeta Corporation -- All Rights Reserved
  *  Copyright 2001-2006 Ian Kent <raven@themaw.net>
  *
@@ -103,7 +100,8 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		(unsigned long) wq->wait_queue_token, wq->name.len, wq->name.name, type);
+		(unsigned long) wq->wait_queue_token,
+		wq->name.len, wq->name.name, type);
 
 	memset(&pkt,0,sizeof pkt); /* For security reasons */
 
@@ -237,7 +235,7 @@ autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
 		if (wq->name.hash == qstr->hash &&
 		    wq->name.len == qstr->len &&
 		    wq->name.name &&
-			 !memcmp(wq->name.name, qstr->name, qstr->len))
+		    !memcmp(wq->name.name, qstr->name, qstr->len))
 			break;
 	}
 	return wq;
@@ -346,8 +344,8 @@ static int validate_request(struct autofs_wait_queue **wait,
 	return 1;
 }
 
-int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
-		enum autofs_notify notify)
+int autofs4_wait(struct autofs_sb_info *sbi,
+		 struct dentry *dentry, enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
 	struct qstr qstr;
diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
index fcd704d..077f2c4 100644
--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -1,7 +1,4 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *   
- * linux/include/linux/auto_fs.h
- *
+/*
  *   Copyright 1997 Transmeta Corporation - All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under

