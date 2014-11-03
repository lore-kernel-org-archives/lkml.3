Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaKCIM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:12:27 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41961 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbaKCIMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:12:24 -0500
X-Sasl-enc: WsifzjzuW76VsWzSSGfYGgKDnukdckHuMFSgN9mo17gX 1415002341
Subject: [PATCH 01/13] autofs4 - coding style fixes
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 03 Nov 2014 16:12:18 +0800
Message-ID: <20141103081218.6215.85903.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
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
 fs/autofs4/autofs_i.h          |   42 +++++++++++----------
 fs/autofs4/dev-ioctl.c         |   24 ++++++++----
 fs/autofs4/expire.c            |   54 +++++++++++++++------------
 fs/autofs4/init.c              |    5 +--
 fs/autofs4/inode.c             |   18 +++++----
 fs/autofs4/root.c              |   80 +++++++++++++++++++++++-----------------
 fs/autofs4/symlink.c           |    6 +--
 fs/autofs4/waitq.c             |   30 ++++++++-------
 include/linux/auto_dev-ioctl.h |    1 -
 include/linux/auto_fs.h        |    5 +--
 include/uapi/linux/auto_fs.h   |   19 ++++------
 include/uapi/linux/auto_fs4.h  |   15 ++------
 12 files changed, 152 insertions(+), 147 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 8e98cf9..0a1fcdc 100644
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
@@ -35,7 +32,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <asm/current.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /* #define DEBUG */
 
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
 #define AUTOFS_INF_NO_RCU	(1<<1) /* the dentry is being considered
 					* for expiry, so RCU_walk is
 					* not permitted
@@ -143,7 +142,8 @@ static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
    processes which do manipulations for us in user space sees the raw
    filesystem without "magic".) */
 
-static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
+static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
+{
 	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
@@ -154,12 +154,12 @@ void autofs4_free_ino(struct autofs_info *);
 int is_autofs4_dentry(struct dentry *);
 int autofs4_expire_wait(struct dentry *dentry, int rcu_walk);
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
@@ -224,8 +224,8 @@ static inline int autofs_prepare_pipe(struct file *pipe)
 
 /* Queue management functions */
 
-int autofs4_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
-int autofs4_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
+int autofs4_wait(struct autofs_sb_info *, struct dentry *, enum autofs_notify);
+int autofs4_wait_release(struct autofs_sb_info *, autofs_wqt_t, int);
 void autofs4_catatonic_mode(struct autofs_sb_info *);
 
 static inline u32 autofs4_get_dev(struct autofs_sb_info *sbi)
@@ -247,37 +247,37 @@ static inline void __autofs4_add_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
 	if (ino) {
 		if (list_empty(&ino->expiring))
 			list_add(&ino->expiring, &sbi->expiring_list);
 	}
-	return;
 }
 
 static inline void autofs4_add_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (list_empty(&ino->expiring))
 			list_add(&ino->expiring, &sbi->expiring_list);
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 static inline void autofs4_del_expiring(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
 			list_del_init(&ino->expiring);
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 extern void autofs4_kill_sb(struct super_block *);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index aaf96cb..5c1b8a1 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -93,7 +93,8 @@ static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
  * Copy parameter control struct, including a possible path allocated
  * at the end of the struct.
  */
-static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
+static struct autofs_dev_ioctl *
+		copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
 {
 	struct autofs_dev_ioctl tmp;
 
@@ -112,7 +113,6 @@ static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *i
 static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
 {
 	kfree(param);
-	return;
 }
 
 /*
@@ -193,7 +193,9 @@ static int find_autofs_mount(const char *pathname,
 			     void *data)
 {
 	struct path path;
-	int err = kern_path_mountpoint(AT_FDCWD, pathname, &path, 0);
+	int err;
+
+	err = kern_path_mountpoint(AT_FDCWD, pathname, &path, 0);
 	if (err)
 		return err;
 	err = -ENOENT;
@@ -221,6 +223,7 @@ static int test_by_dev(struct path *path, void *p)
 static int test_by_type(struct path *path, void *p)
 {
 	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
+
 	return ino && ino->sbi->type & *(unsigned *)p;
 }
 
@@ -452,8 +455,10 @@ static int autofs_dev_ioctl_requester(struct file *fp,
 		err = 0;
 		autofs4_expire_wait(path.dentry, 0);
 		spin_lock(&sbi->fs_lock);
-		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
-		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
+		param->requester.uid =
+			from_kuid_munged(current_user_ns(), ino->uid);
+		param->requester.gid =
+			from_kgid_munged(current_user_ns(), ino->gid);
 		spin_unlock(&sbi->fs_lock);
 	}
 	path_put(&path);
@@ -615,7 +620,8 @@ static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
 }
 
 /* ioctl dispatcher */
-static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __user *user)
+static int _autofs_dev_ioctl(unsigned int command,
+			     struct autofs_dev_ioctl __user *user)
 {
 	struct autofs_dev_ioctl *param;
 	struct file *fp;
@@ -707,6 +713,7 @@ out:
 static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
 {
 	int err;
+
 	err = _autofs_dev_ioctl(command, (struct autofs_dev_ioctl __user *) u);
 	return (long) err;
 }
@@ -729,8 +736,8 @@ static const struct file_operations _dev_ioctl_fops = {
 
 static struct miscdevice _autofs_dev_ioctl_misc = {
 	.minor		= AUTOFS_MINOR,
-	.name  		= AUTOFS_DEVICE_NAME,
-	.fops  		= &_dev_ioctl_fops
+	.name		= AUTOFS_DEVICE_NAME,
+	.fops		= &_dev_ioctl_fops
 };
 
 MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
@@ -753,6 +760,5 @@ int __init autofs_dev_ioctl_init(void)
 void autofs_dev_ioctl_exit(void)
 {
 	misc_deregister(&_autofs_dev_ioctl_misc);
-	return;
 }
 
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 683a5b9..52be1c9 100644
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
 
@@ -59,7 +56,9 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 
 	/* Update the expiry counter if fs is busy */
 	if (!may_umount_tree(path.mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino;
+
+		ino = autofs4_dentry_ino(top);
 		ino->last_used = jiffies;
 		goto done;
 	}
@@ -75,7 +74,7 @@ done:
  * Calculate and dget next entry in the subdirs list under root.
  */
 static struct dentry *get_next_positive_subdir(struct dentry *prev,
-						struct dentry *root)
+					       struct dentry *root)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
 	struct list_head *next;
@@ -122,7 +121,7 @@ cont:
  * Calculate and dget next entry in top down tree traversal.
  */
 static struct dentry *get_next_positive_dentry(struct dentry *prev,
-						struct dentry *root)
+					       struct dentry *root)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
 	struct list_head *next;
@@ -188,16 +187,18 @@ again:
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
 
 	/* If it's busy update the expiry counters */
 	if (!may_umount_tree(mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino;
+
+		ino = autofs4_dentry_ino(top);
 		if (ino)
 			ino->last_used = jiffies;
 		return 1;
@@ -210,7 +211,8 @@ static int autofs4_direct_busy(struct vfsmount *mnt,
 	return 0;
 }
 
-/* Check a directory tree of mount points for busyness
+/*
+ * Check a directory tree of mount points for busyness
  * The tree is not busy iff no mountpoints are busy
  */
 static int autofs4_tree_busy(struct vfsmount *mnt,
@@ -368,8 +370,8 @@ static struct dentry *should_expire(struct dentry *dentry,
 	 *	   offset (autofs-5.0+).
 	 */
 	if (d_mountpoint(dentry)) {
-		DPRINTK("checking mountpoint %p %.*s",
-			dentry, (int)dentry->d_name.len, dentry->d_name.name);
+		DPRINTK("checking mountpoint %p %.*s", dentry,
+			(int) dentry->d_name.len, dentry->d_name.name);
 
 		/* Can we umount this guy */
 		if (autofs4_mount_busy(mnt, dentry))
@@ -412,6 +414,7 @@ static struct dentry *should_expire(struct dentry *dentry,
 	} else {
 		/* Path walk currently on this dentry? */
 		struct dentry *expired;
+
 		ino_count = atomic_read(&ino->count) + 1;
 		if (d_count(dentry) > ino_count)
 			return NULL;
@@ -532,21 +535,22 @@ int autofs4_expire_wait(struct dentry *dentry, int rcu_walk)
 
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
 	struct dentry *dentry;
 	int ret = 0;
 
-	memset(&pkt,0,sizeof pkt);
+	memset(&pkt, 0, sizeof(pkt));
 
 	pkt.hdr.proto_version = sbi->version;
 	pkt.hdr.type = autofs_ptype_expire;
 
-	if ((dentry = autofs4_expire_indirect(sb, mnt, sbi, 0)) == NULL)
+	dentry = autofs4_expire_indirect(sb, mnt, sbi, 0);
+	if (!dentry)
 		return -EAGAIN;
 
 	pkt.len = dentry->d_name.len;
@@ -554,7 +558,7 @@ int autofs4_expire_run(struct super_block *sb,
 	pkt.name[pkt.len] = '\0';
 	dput(dentry);
 
-	if ( copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)) )
+	if (copy_to_user(pkt_p, &pkt, sizeof(struct autofs_packet_expire)))
 		ret = -EFAULT;
 
 	spin_lock(&sbi->fs_lock);
@@ -583,7 +587,7 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 		struct autofs_info *ino = autofs4_dentry_ino(dentry);
 
 		/* This is synchronous because it makes the daemon a
-                   little easier */
+		 * little easier */
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
@@ -598,8 +602,10 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
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
index 1c55388..e855334 100644
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
@@ -24,7 +21,9 @@
 
 struct autofs_info *autofs4_new_ino(struct autofs_sb_info *sbi)
 {
-	struct autofs_info *ino = kzalloc(sizeof(*ino), GFP_KERNEL);
+	struct autofs_info *ino;
+
+	ino = kzalloc(sizeof(*ino), GFP_KERNEL);
 	if (ino) {
 		INIT_LIST_HEAD(&ino->active);
 		INIT_LIST_HEAD(&ino->expiring);
@@ -147,6 +146,7 @@ static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
+
 		if (!*p)
 			continue;
 
@@ -204,9 +204,9 @@ static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
 
 int autofs4_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct inode * root_inode;
-	struct dentry * root;
-	struct file * pipe;
+	struct inode *root_inode;
+	struct dentry *root;
+	struct file *pipe;
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
@@ -217,7 +217,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
-	DPRINTK("starting up, sbi = %p",sbi);
+	DPRINTK("starting up, sbi = %p", sbi);
 
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index d76d083..373be98 100644
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
@@ -23,16 +20,18 @@
 
 #include "autofs_i.h"
 
-static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
-static int autofs4_dir_unlink(struct inode *,struct dentry *);
-static int autofs4_dir_rmdir(struct inode *,struct dentry *);
-static int autofs4_dir_mkdir(struct inode *,struct dentry *,umode_t);
-static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+static int autofs4_dir_symlink(struct inode *, struct dentry *, const char *);
+static int autofs4_dir_unlink(struct inode *, struct dentry *);
+static int autofs4_dir_rmdir(struct inode *, struct dentry *);
+static int autofs4_dir_mkdir(struct inode *, struct dentry *, umode_t);
+static long autofs4_root_ioctl(struct file *, unsigned int, unsigned long);
 #ifdef CONFIG_COMPAT
-static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+static long autofs4_root_compat_ioctl(struct file *,
+				      unsigned int, unsigned long);
 #endif
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs4_lookup(struct inode *,struct dentry *, unsigned int);
+static struct dentry *autofs4_lookup(struct inode *,
+				     struct dentry *, unsigned int);
 static struct vfsmount *autofs4_d_automount(struct path *);
 static int autofs4_d_manage(struct dentry *, bool);
 static void autofs4_dentry_release(struct dentry *);
@@ -74,7 +73,9 @@ const struct dentry_operations autofs4_dentry_operations = {
 static void autofs4_add_active(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *ino;
+
+	ino = autofs4_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!ino->active_count) {
@@ -84,13 +85,14 @@ static void autofs4_add_active(struct dentry *dentry)
 		ino->active_count++;
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 static void autofs4_del_active(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *ino;
+
+	ino = autofs4_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		ino->active_count--;
@@ -100,7 +102,6 @@ static void autofs4_del_active(struct dentry *dentry)
 		}
 		spin_unlock(&sbi->lookup_lock);
 	}
-	return;
 }
 
 static int autofs4_dir_open(struct inode *inode, struct file *file)
@@ -322,7 +323,9 @@ static struct dentry *autofs4_mountpoint_changed(struct path *path)
 	if (autofs_type_indirect(sbi->type) && d_unhashed(dentry)) {
 		struct dentry *parent = dentry->d_parent;
 		struct autofs_info *ino;
-		struct dentry *new = d_lookup(parent, &dentry->d_name);
+		struct dentry *new;
+
+		new = d_lookup(parent, &dentry->d_name);
 		if (!new)
 			return NULL;
 		ino = autofs4_dentry_ino(new);
@@ -459,6 +462,7 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 		 * a mount-trap.
 		 */
 		struct inode *inode;
+
 		if (ino->flags & (AUTOFS_INF_EXPIRING | AUTOFS_INF_NO_RCU))
 			return 0;
 		if (d_mountpoint(dentry))
@@ -498,7 +502,8 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
+static struct dentry *autofs4_lookup(struct inode *dir,
+				     struct dentry *dentry, unsigned int flags)
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
@@ -517,9 +522,9 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, u
 		autofs4_oz_mode(sbi));
 
 	active = autofs4_lookup_active(dentry);
-	if (active) {
+	if (active)
 		return active;
-	} else {
+	else {
 		/*
 		 * A dentry that is not within the root can never trigger a
 		 * mount operation, unless the directory already exists, so we
@@ -530,7 +535,8 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, u
 			return ERR_PTR(-ENOENT);
 
 		/* Mark entries in the root as mount triggers */
-		if (autofs_type_indirect(sbi->type) && IS_ROOT(dentry->d_parent))
+		if (IS_ROOT(dentry->d_parent) &&
+		    autofs_type_indirect(sbi->type))
 			__managed_dentry_set_managed(dentry);
 
 		ino = autofs4_new_ino(sbi);
@@ -669,7 +675,6 @@ static void autofs_set_leaf_automount_flags(struct dentry *dentry)
 	if (IS_ROOT(parent->d_parent))
 		return;
 	managed_dentry_clear_managed(parent);
-	return;
 }
 
 static void autofs_clear_leaf_automount_flags(struct dentry *dentry)
@@ -692,7 +697,6 @@ static void autofs_clear_leaf_automount_flags(struct dentry *dentry)
 	if (d_child->next == &parent->d_subdirs &&
 	    d_child->prev == &parent->d_subdirs)
 		managed_dentry_set_managed(parent);
-	return;
 }
 
 static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
@@ -734,7 +738,8 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	return 0;
 }
 
-static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+static int autofs4_dir_mkdir(struct inode *dir,
+			     struct dentry *dentry, umode_t mode)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
@@ -775,7 +780,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t m
 /* Get/set timeout ioctl() operation */
 #ifdef CONFIG_COMPAT
 static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
-					 compat_ulong_t __user *p)
+						 compat_ulong_t __user *p)
 {
 	int rv;
 	unsigned long ntimeout;
@@ -794,7 +799,7 @@ static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
 #endif
 
 static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
-					 unsigned long __user *p)
+					  unsigned long __user *p)
 {
 	int rv;
 	unsigned long ntimeout;
@@ -812,13 +817,15 @@ static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
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
@@ -862,7 +869,7 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	void __user *p = (void __user *)arg;
 
 	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
-		cmd,arg,sbi,task_pgrp_nr(current));
+		cmd, arg, sbi, task_pgrp_nr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
@@ -871,11 +878,11 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	
-	switch(cmd) {
+	switch (cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,0);
+		return autofs4_wait_release(sbi, (autofs_wqt_t) arg, 0);
 	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
+		return autofs4_wait_release(sbi, (autofs_wqt_t) arg, -ENOENT);
 	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
 		autofs4_catatonic_mode(sbi);
 		return 0;
@@ -895,10 +902,12 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 
 	/* return a single thing to expire */
 	case AUTOFS_IOC_EXPIRE:
-		return autofs4_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs4_expire_run(inode->i_sb,
+					  filp->f_path.mnt, sbi, p);
 	/* same as above, but can send multiple expires through pipe */
 	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs4_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs4_expire_multi(inode->i_sb,
+					    filp->f_path.mnt, sbi, p);
 
 	default:
 		return -ENOSYS;
@@ -909,12 +918,13 @@ static long autofs4_root_ioctl(struct file *filp,
 			       unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
+
 	return autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
 static long autofs4_root_compat_ioctl(struct file *filp,
-			     unsigned int cmd, unsigned long arg)
+				      unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	int ret;
@@ -923,7 +933,7 @@ static long autofs4_root_compat_ioctl(struct file *filp,
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 	else
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd,
-			(unsigned long)compat_ptr(arg));
+					      (unsigned long) compat_ptr(arg));
 
 	return ret;
 }
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
index 1e8ea19..ed59c38 100644
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
@@ -16,6 +13,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+
 	if (ino && !autofs4_oz_mode(sbi))
 		ino->last_used = jiffies;
 	nd_set_link(nd, dentry->d_inode->i_private);
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 116fd38..a0b6a97 100644
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
@@ -70,7 +67,7 @@ static int autofs4_write(struct autofs_sb_info *sbi,
 
 	mutex_lock(&sbi->pipe_mutex);
 	while (bytes &&
-	       (wr = file->f_op->write(file,data,bytes,&file->f_pos)) > 0) {
+	       (wr = file->f_op->write(file, data, bytes, &file->f_pos)) > 0) {
 		data += wr;
 		bytes -= wr;
 	}
@@ -103,9 +100,10 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		(unsigned long) wq->wait_queue_token, wq->name.len, wq->name.name, type);
+		(unsigned long) wq->wait_queue_token,
+		wq->name.len, wq->name.name, type);
 
-	memset(&pkt,0,sizeof pkt); /* For security reasons */
+	memset(&pkt, 0, sizeof(pkt)); /* For security reasons */
 
 	pkt.hdr.proto_version = sbi->version;
 	pkt.hdr.type = type;
@@ -126,7 +124,8 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	}
 	case autofs_ptype_expire_multi:
 	{
-		struct autofs_packet_expire_multi *ep = &pkt.v4_pkt.expire_multi;
+		struct autofs_packet_expire_multi *ep =
+					&pkt.v4_pkt.expire_multi;
 
 		pktsz = sizeof(*ep);
 
@@ -231,7 +230,7 @@ autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
 		if (wq->name.hash == qstr->hash &&
 		    wq->name.len == qstr->len &&
 		    wq->name.name &&
-			 !memcmp(wq->name.name, qstr->name, qstr->len))
+		    !memcmp(wq->name.name, qstr->name, qstr->len))
 			break;
 	}
 	return wq;
@@ -248,7 +247,7 @@ autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
 static int validate_request(struct autofs_wait_queue **wait,
 			    struct autofs_sb_info *sbi,
 			    struct qstr *qstr,
-			    struct dentry*dentry, enum autofs_notify notify)
+			    struct dentry *dentry, enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
 	struct autofs_info *ino;
@@ -324,6 +323,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 		if (!IS_ROOT(dentry)) {
 			if (dentry->d_inode && d_unhashed(dentry)) {
 				struct dentry *parent = dentry->d_parent;
+
 				new = d_lookup(parent, &dentry->d_name);
 				if (new)
 					dentry = new;
@@ -340,8 +340,8 @@ static int validate_request(struct autofs_wait_queue **wait,
 	return 1;
 }
 
-int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
-		enum autofs_notify notify)
+int autofs4_wait(struct autofs_sb_info *sbi,
+		 struct dentry *dentry, enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
 	struct qstr qstr;
@@ -411,7 +411,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 
 	if (!wq) {
 		/* Create a new wait queue */
-		wq = kmalloc(sizeof(struct autofs_wait_queue),GFP_KERNEL);
+		wq = kmalloc(sizeof(struct autofs_wait_queue), GFP_KERNEL);
 		if (!wq) {
 			kfree(qstr.name);
 			mutex_unlock(&sbi->wq_mutex);
@@ -454,7 +454,9 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 			(unsigned long) wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 
-		/* autofs4_notify_daemon() may block; it will unlock ->wq_mutex */
+		/*
+		 * autofs4_notify_daemon() may block; it will unlock ->wq_mutex
+		 */
 		autofs4_notify_daemon(sbi, wq, type);
 	} else {
 		wq->wait_ctr++;
diff --git a/include/linux/auto_dev-ioctl.h b/include/linux/auto_dev-ioctl.h
index 850f39b..6427816 100644
--- a/include/linux/auto_dev-ioctl.h
+++ b/include/linux/auto_dev-ioctl.h
@@ -125,7 +125,6 @@ static inline void init_autofs_dev_ioctl(struct autofs_dev_ioctl *in)
 	in->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
 	in->size = sizeof(struct autofs_dev_ioctl);
 	in->ioctlfd = -1;
-	return;
 }
 
 /*
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
diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
index bb991df..5fe176a 100644
--- a/include/uapi/linux/auto_fs.h
+++ b/include/uapi/linux/auto_fs.h
@@ -1,7 +1,4 @@
-/* -*- linux-c -*- ------------------------------------------------------- *
- *   
- * linux/include/linux/auto_fs.h
- *
+/*
  *   Copyright 1997 Transmeta Corporation - All Rights Reserved
  *
  * This file is part of the Linux kernel and is made available under
@@ -63,12 +60,12 @@ struct autofs_packet_expire {
 	char name[NAME_MAX+1];
 };
 
-#define AUTOFS_IOC_READY      _IO(0x93,0x60)
-#define AUTOFS_IOC_FAIL       _IO(0x93,0x61)
-#define AUTOFS_IOC_CATATONIC  _IO(0x93,0x62)
-#define AUTOFS_IOC_PROTOVER   _IOR(0x93,0x63,int)
-#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,compat_ulong_t)
-#define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93,0x64,unsigned long)
-#define AUTOFS_IOC_EXPIRE     _IOR(0x93,0x65,struct autofs_packet_expire)
+#define AUTOFS_IOC_READY      _IO(0x93, 0x60)
+#define AUTOFS_IOC_FAIL       _IO(0x93, 0x61)
+#define AUTOFS_IOC_CATATONIC  _IO(0x93, 0x62)
+#define AUTOFS_IOC_PROTOVER   _IOR(0x93, 0x63, int)
+#define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93, 0x64, compat_ulong_t)
+#define AUTOFS_IOC_SETTIMEOUT _IOWR(0x93, 0x64, unsigned long)
+#define AUTOFS_IOC_EXPIRE     _IOR(0x93, 0x65, struct autofs_packet_expire)
 
 #endif /* _UAPI_LINUX_AUTO_FS_H */
diff --git a/include/uapi/linux/auto_fs4.h b/include/uapi/linux/auto_fs4.h
index e02982f..924fb1a 100644
--- a/include/uapi/linux/auto_fs4.h
+++ b/include/uapi/linux/auto_fs4.h
@@ -1,6 +1,4 @@
-/* -*- c -*-
- * linux/include/linux/auto_fs4.h
- *
+/*
  * Copyright 1999-2000 Jeremy Fitzhardinge <jeremy@goop.org>
  *
  * This file is part of the Linux kernel and is made available under
@@ -38,7 +36,6 @@
 static inline void set_autofs_type_indirect(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_INDIRECT;
-	return;
 }
 
 static inline unsigned int autofs_type_indirect(unsigned int type)
@@ -49,7 +46,6 @@ static inline unsigned int autofs_type_indirect(unsigned int type)
 static inline void set_autofs_type_direct(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_DIRECT;
-	return;
 }
 
 static inline unsigned int autofs_type_direct(unsigned int type)
@@ -60,7 +56,6 @@ static inline unsigned int autofs_type_direct(unsigned int type)
 static inline void set_autofs_type_offset(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_OFFSET;
-	return;
 }
 
 static inline unsigned int autofs_type_offset(unsigned int type)
@@ -81,7 +76,6 @@ static inline unsigned int autofs_type_trigger(unsigned int type)
 static inline void set_autofs_type_any(unsigned int *type)
 {
 	*type = AUTOFS_TYPE_ANY;
-	return;
 }
 
 static inline unsigned int autofs_type_any(unsigned int type)
@@ -154,11 +148,10 @@ union autofs_v5_packet_union {
 	autofs_packet_expire_direct_t expire_direct;
 };
 
-#define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93,0x66,int)
+#define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93, 0x66, int)
 #define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI
-#define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93,0x67,int)
-#define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93,0x70,int)
-
+#define AUTOFS_IOC_PROTOSUBVER		_IOR(0x93, 0x67, int)
+#define AUTOFS_IOC_ASKUMOUNT		_IOR(0x93, 0x70, int)
 
 #endif /* _LINUX_AUTO_FS4_H */

