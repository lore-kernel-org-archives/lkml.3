Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3GADOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:14:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53369 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab3GADOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:14:43 -0400
X-Sasl-enc: +we0OwiXwSUM/vXcbhKRfdIQd9R7PnxEAbZJb22lSZ7w 1372648480
Subject: [RFC PATCH 5/7] autofs - use autofs instead of autofs4 everywhere
To: linux-next@vger.kernel.org
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 11:14:36 +0800
Message-ID: <20130701031435.4423.65182.stgit@perseus.fritz.box>
In-Reply-To: <20130701031335.4423.6154.stgit@perseus.fritz.box>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update naming within autofs source to be consistent by changing occurrences
of autofs4 to autofs.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/autofs_i.h  |   92 +++++++++--------
 fs/autofs4/dev-ioctl.c |   18 ++-
 fs/autofs4/expire.c    |  128 ++++++++++++------------
 fs/autofs4/init.c      |   12 +-
 fs/autofs4/inode.c     |   46 ++++-----
 fs/autofs4/root.c      |  256 ++++++++++++++++++++++++------------------------
 fs/autofs4/symlink.c   |    6 +
 fs/autofs4/waitq.c     |   55 +++++-----
 8 files changed, 307 insertions(+), 306 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 1a79bc7..dcdd1d7 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -123,29 +123,29 @@ struct autofs_sb_info {
 	struct list_head expiring_list;
 };
 
-static inline struct autofs_sb_info *autofs4_sbi(struct super_block *sb)
+static inline struct autofs_sb_info *autofs_sbi(struct super_block *sb)
 {
 	return (struct autofs_sb_info *)(sb->s_fs_info);
 }
 
-static inline struct autofs_info *autofs4_dentry_ino(struct dentry *dentry)
+static inline struct autofs_info *autofs_dentry_ino(struct dentry *dentry)
 {
 	return (struct autofs_info *)(dentry->d_fsdata);
 }
 
-/* autofs4_oz_mode(): do we see the man behind the curtain?  (The
+/* autofs_oz_mode(): do we see the man behind the curtain?  (The
    processes which do manipulations for us in user space sees the raw
    filesystem without "magic".) */
 
-static inline int autofs4_oz_mode(struct autofs_sb_info *sbi)
+static inline int autofs_oz_mode(struct autofs_sb_info *sbi)
 {
 	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
 /* Does a dentry have some pending activity? */
-static inline int autofs4_ispending(struct dentry *dentry)
+static inline int autofs_ispending(struct dentry *dentry)
 {
-	struct autofs_info *inf = autofs4_dentry_ino(dentry);
+	struct autofs_info *inf = autofs_dentry_ino(dentry);
 
 	if (inf->flags & AUTOFS_INF_PENDING)
 		return 1;
@@ -156,25 +156,25 @@ static inline int autofs4_ispending(struct dentry *dentry)
 	return 0;
 }
 
-struct inode *autofs4_get_inode(struct super_block *, umode_t);
-void autofs4_free_ino(struct autofs_info *);
+struct inode *autofs_get_inode(struct super_block *, umode_t);
+void autofs_free_ino(struct autofs_info *);
 
 /* Expiration */
-int is_autofs4_dentry(struct dentry *);
-int autofs4_expire_wait(struct dentry *dentry);
-int autofs4_expire_run(struct super_block *, struct vfsmount *,
-		       struct autofs_sb_info *,
-		       struct autofs_packet_expire __user *);
-int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			    struct autofs_sb_info *sbi, int when);
-int autofs4_expire_multi(struct super_block *, struct vfsmount *,
-			 struct autofs_sb_info *, int __user *);
-struct dentry *autofs4_expire_direct(struct super_block *sb,
-				     struct vfsmount *mnt,
-				     struct autofs_sb_info *sbi, int how);
-struct dentry *autofs4_expire_indirect(struct super_block *sb,
-				       struct vfsmount *mnt,
-				       struct autofs_sb_info *sbi, int how);
+int is_autofs_dentry(struct dentry *);
+int autofs_expire_wait(struct dentry *dentry);
+int autofs_expire_run(struct super_block *, struct vfsmount *,
+		      struct autofs_sb_info *,
+		      struct autofs_packet_expire __user *);
+int autofs_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			   struct autofs_sb_info *sbi, int when);
+int autofs_expire_multi(struct super_block *, struct vfsmount *,
+			struct autofs_sb_info *, int __user *);
+struct dentry *autofs_expire_direct(struct super_block *sb,
+				    struct vfsmount *mnt,
+				    struct autofs_sb_info *sbi, int how);
+struct dentry *autofs_expire_indirect(struct super_block *sb,
+				      struct vfsmount *mnt,
+				      struct autofs_sb_info *sbi, int how);
 
 /* Device node initialization */
 
@@ -183,11 +183,11 @@ void autofs_dev_ioctl_exit(void);
 
 /* Operations structures */
 
-extern const struct inode_operations autofs4_symlink_inode_operations;
-extern const struct inode_operations autofs4_dir_inode_operations;
-extern const struct file_operations autofs4_dir_operations;
-extern const struct file_operations autofs4_root_operations;
-extern const struct dentry_operations autofs4_dentry_operations;
+extern const struct inode_operations autofs_symlink_inode_operations;
+extern const struct inode_operations autofs_dir_inode_operations;
+extern const struct file_operations autofs_dir_operations;
+extern const struct file_operations autofs_root_operations;
+extern const struct dentry_operations autofs_dentry_operations;
 
 /* VFS automount flags management functions */
 
@@ -265,9 +265,9 @@ static inline void managed_dentry_clear_managed(struct dentry *dentry)
 
 /* Initializing function */
 
-int autofs4_fill_super(struct super_block *, void *, int);
-struct autofs_info *autofs4_new_ino(struct autofs_sb_info *);
-void autofs4_clean_ino(struct autofs_info *);
+int autofs_fill_super(struct super_block *, void *, int);
+struct autofs_info *autofs_new_ino(struct autofs_sb_info *);
+void autofs_clean_ino(struct autofs_info *);
 
 static inline int autofs_prepare_pipe(struct file *pipe)
 {
@@ -282,16 +282,16 @@ static inline int autofs_prepare_pipe(struct file *pipe)
 
 /* Queue management functions */
 
-int autofs4_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
-int autofs4_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
-void autofs4_catatonic_mode(struct autofs_sb_info *);
+int autofs_wait(struct autofs_sb_info *,struct dentry *, enum autofs_notify);
+int autofs_wait_release(struct autofs_sb_info *,autofs_wqt_t,int);
+void autofs_catatonic_mode(struct autofs_sb_info *);
 
-static inline u32 autofs4_get_dev(struct autofs_sb_info *sbi)
+static inline u32 autofs_get_dev(struct autofs_sb_info *sbi)
 {
 	return new_encode_dev(sbi->sb->s_dev);
 }
 
-static inline u64 autofs4_get_ino(struct autofs_sb_info *sbi)
+static inline u64 autofs_get_ino(struct autofs_sb_info *sbi)
 {
 	return sbi->sb->s_root->d_inode->i_ino;
 }
@@ -301,10 +301,10 @@ static inline int simple_positive(struct dentry *dentry)
 	return dentry->d_inode && !d_unhashed(dentry);
 }
 
-static inline void __autofs4_add_expiring(struct dentry *dentry)
+static inline void __autofs_add_expiring(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		if (list_empty(&ino->expiring))
 			list_add(&ino->expiring, &sbi->expiring_list);
@@ -312,10 +312,10 @@ static inline void __autofs4_add_expiring(struct dentry *dentry)
 	return;
 }
 
-static inline void autofs4_add_expiring(struct dentry *dentry)
+static inline void autofs_add_expiring(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (list_empty(&ino->expiring))
@@ -325,10 +325,10 @@ static inline void autofs4_add_expiring(struct dentry *dentry)
 	return;
 }
 
-static inline void autofs4_del_expiring(struct dentry *dentry)
+static inline void autofs_del_expiring(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!list_empty(&ino->expiring))
@@ -338,4 +338,4 @@ static inline void autofs4_del_expiring(struct dentry *dentry)
 	return;
 }
 
-extern void autofs4_kill_sb(struct super_block *);
+extern void autofs_kill_sb(struct super_block *);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 9183821..024389a 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -160,7 +160,7 @@ static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
 
 	if (f) {
 		inode = file_inode(f);
-		sbi = autofs4_sbi(inode->i_sb);
+		sbi = autofs_sbi(inode->i_sb);
 	}
 	return sbi;
 }
@@ -217,7 +217,7 @@ static int test_by_dev(struct path *path, void *p)
 
 static int test_by_type(struct path *path, void *p)
 {
-	struct autofs_info *ino = autofs4_dentry_ino(path->dentry);
+	struct autofs_info *ino = autofs_dentry_ino(path->dentry);
 	return ino && ino->sbi->type & *(unsigned *)p;
 }
 
@@ -309,7 +309,7 @@ static int autofs_dev_ioctl_ready(struct file *fp,
 	autofs_wqt_t token;
 
 	token = (autofs_wqt_t) param->ready.token;
-	return autofs4_wait_release(sbi, token, 0);
+	return autofs_wait_release(sbi, token, 0);
 }
 
 /*
@@ -325,7 +325,7 @@ static int autofs_dev_ioctl_fail(struct file *fp,
 
 	token = (autofs_wqt_t) param->fail.token;
 	status = param->fail.status ? param->fail.status : -ENOENT;
-	return autofs4_wait_release(sbi, token, status);
+	return autofs_wait_release(sbi, token, status);
 }
 
 /*
@@ -397,7 +397,7 @@ static int autofs_dev_ioctl_catatonic(struct file *fp,
 				      struct autofs_sb_info *sbi,
 				      struct autofs_dev_ioctl *param)
 {
-	autofs4_catatonic_mode(sbi);
+	autofs_catatonic_mode(sbi);
 	return 0;
 }
 
@@ -444,10 +444,10 @@ static int autofs_dev_ioctl_requester(struct file *fp,
 	if (err)
 		goto out;
 
-	ino = autofs4_dentry_ino(path.dentry);
+	ino = autofs_dentry_ino(path.dentry);
 	if (ino) {
 		err = 0;
-		autofs4_expire_wait(path.dentry);
+		autofs_expire_wait(path.dentry);
 		spin_lock(&sbi->fs_lock);
 		param->requester.uid = from_kuid_munged(current_user_ns(), ino->uid);
 		param->requester.gid = from_kgid_munged(current_user_ns(), ino->gid);
@@ -472,7 +472,7 @@ static int autofs_dev_ioctl_expire(struct file *fp,
 	how = param->expire.how;
 	mnt = fp->f_path.mnt;
 
-	return autofs4_do_expire_multi(sbi->sb, mnt, sbi, how);
+	return autofs_do_expire_multi(sbi->sb, mnt, sbi, how);
 }
 
 /* Check if autofs mount point is in use */
@@ -686,7 +686,7 @@ static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __use
 		 * Admin needs to be able to set the mount catatonic in
 		 * order to be able to perform the re-open.
 		 */
-		if (!autofs4_oz_mode(sbi) &&
+		if (!autofs_oz_mode(sbi) &&
 		    cmd != AUTOFS_DEV_IOCTL_CATATONIC_CMD) {
 			err = -EACCES;
 			fput(fp);
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index ddee37a..58fba1b 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -14,10 +14,10 @@
 static unsigned long now;
 
 /* Check if a dentry can be expired */
-static inline int autofs4_can_expire(struct dentry *dentry,
-				     unsigned long timeout, int do_now)
+static inline int autofs_can_expire(struct dentry *dentry,
+				    unsigned long timeout, int do_now)
 {
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 
 	/* dentry in the process of being deleted */
 	if (ino == NULL)
@@ -38,7 +38,7 @@ static inline int autofs4_can_expire(struct dentry *dentry,
 }
 
 /* Check a mount point for busyness */
-static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
+static int autofs_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 {
 	struct dentry *top = dentry;
 	struct path path = {.mnt = mnt, .dentry = dentry};
@@ -52,8 +52,8 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 	if (!follow_down_one(&path))
 		goto done;
 
-	if (is_autofs4_dentry(path.dentry)) {
-		struct autofs_sb_info *sbi = autofs4_sbi(path.dentry->d_sb);
+	if (is_autofs_dentry(path.dentry)) {
+		struct autofs_sb_info *sbi = autofs_sbi(path.dentry->d_sb);
 
 		/* This is an autofs submount, we can't expire it */
 		if (autofs_type_indirect(sbi->type))
@@ -62,7 +62,7 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 
 	/* Update the expiry counter if fs is busy */
 	if (!may_umount_tree(path.mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino = autofs_dentry_ino(top);
 		ino->last_used = jiffies;
 		goto done;
 	}
@@ -80,7 +80,7 @@ done:
 static struct dentry *get_next_positive_subdir(struct dentry *prev,
 					       struct dentry *root)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
 	struct list_head *next;
 	struct dentry *q;
 
@@ -127,7 +127,7 @@ cont:
 static struct dentry *get_next_positive_dentry(struct dentry *prev,
 					       struct dentry *root)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
 	struct list_head *next;
 	struct dentry *p, *ret;
 
@@ -190,24 +190,24 @@ again:
  * The tree is not busy iff no mountpoints are busy and there are no
  * autofs submounts.
  */
-static int autofs4_direct_busy(struct vfsmount *mnt,
-			       struct dentry *top,
-			       unsigned long timeout,
-			       int do_now)
+static int autofs_direct_busy(struct vfsmount *mnt,
+			      struct dentry *top,
+			      unsigned long timeout,
+			      int do_now)
 {
 	DPRINTK("top %p %.*s",
 		top, (int) top->d_name.len, top->d_name.name);
 
 	/* If it's busy update the expiry counters */
 	if (!may_umount_tree(mnt)) {
-		struct autofs_info *ino = autofs4_dentry_ino(top);
+		struct autofs_info *ino = autofs_dentry_ino(top);
 		if (ino)
 			ino->last_used = jiffies;
 		return 1;
 	}
 
 	/* Timeout of a direct mount is determined by its top dentry */
-	if (!autofs4_can_expire(top, timeout, do_now))
+	if (!autofs_can_expire(top, timeout, do_now))
 		return 1;
 
 	return 0;
@@ -217,12 +217,12 @@ static int autofs4_direct_busy(struct vfsmount *mnt,
  * Check a directory tree of mount points for busyness
  * The tree is not busy iff no mountpoints are busy
  */
-static int autofs4_tree_busy(struct vfsmount *mnt,
-	       		     struct dentry *top,
-			     unsigned long timeout,
-			     int do_now)
+static int autofs_tree_busy(struct vfsmount *mnt,
+			    struct dentry *top,
+			    unsigned long timeout,
+			    int do_now)
 {
-	struct autofs_info *top_ino = autofs4_dentry_ino(top);
+	struct autofs_info *top_ino = autofs_dentry_ino(top);
 	struct dentry *p;
 
 	DPRINTK("top %p %.*s",
@@ -244,13 +244,13 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 		 * If the fs is busy update the expiry counter.
 		 */
 		if (d_mountpoint(p)) {
-			if (autofs4_mount_busy(mnt, p)) {
+			if (autofs_mount_busy(mnt, p)) {
 				top_ino->last_used = jiffies;
 				dput(p);
 				return 1;
 			}
 		} else {
-			struct autofs_info *ino = autofs4_dentry_ino(p);
+			struct autofs_info *ino = autofs_dentry_ino(p);
 			unsigned int ino_count = atomic_read(&ino->count);
 
 			/*
@@ -274,16 +274,16 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 	}
 
 	/* Timeout of a tree mount is ultimately determined by its top dentry */
-	if (!autofs4_can_expire(top, timeout, do_now))
+	if (!autofs_can_expire(top, timeout, do_now))
 		return 1;
 
 	return 0;
 }
 
-static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
-					   struct dentry *parent,
-					   unsigned long timeout,
-					   int do_now)
+static struct dentry *autofs_check_leaves(struct vfsmount *mnt,
+					  struct dentry *parent,
+					  unsigned long timeout,
+					  int do_now)
 {
 	struct dentry *p;
 
@@ -297,11 +297,11 @@ static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
 
 		if (d_mountpoint(p)) {
 			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, p))
+			if (autofs_mount_busy(mnt, p))
 				continue;
 
 			/* Can we expire this guy */
-			if (autofs4_can_expire(p, timeout, do_now))
+			if (autofs_can_expire(p, timeout, do_now))
 				return p;
 		}
 	}
@@ -309,10 +309,10 @@ static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
 }
 
 /* Check if we can expire a direct mount (possibly a tree) */
-struct dentry *autofs4_expire_direct(struct super_block *sb,
-				     struct vfsmount *mnt,
-				     struct autofs_sb_info *sbi,
-				     int how)
+struct dentry *autofs_expire_direct(struct super_block *sb,
+				    struct vfsmount *mnt,
+				    struct autofs_sb_info *sbi,
+				    int how)
 {
 	unsigned long timeout;
 	struct dentry *root = dget(sb->s_root);
@@ -326,12 +326,12 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 	timeout = sbi->exp_timeout;
 
 	spin_lock(&sbi->fs_lock);
-	ino = autofs4_dentry_ino(root);
+	ino = autofs_dentry_ino(root);
 	/* No point expiring a pending mount */
 	if (ino->flags & AUTOFS_INF_PENDING)
 		goto out;
-	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		struct autofs_info *ino = autofs4_dentry_ino(root);
+	if (!autofs_direct_busy(mnt, root, timeout, do_now)) {
+		struct autofs_info *ino = autofs_dentry_ino(root);
 		ino->flags |= AUTOFS_INF_EXPIRING;
 		init_completion(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
@@ -350,10 +350,10 @@ out:
  *  - it is unused by any user process
  *  - it has been unused for exp_timeout time
  */
-struct dentry *autofs4_expire_indirect(struct super_block *sb,
-				       struct vfsmount *mnt,
-				       struct autofs_sb_info *sbi,
-				       int how)
+struct dentry *autofs_expire_indirect(struct super_block *sb,
+				      struct vfsmount *mnt,
+				      struct autofs_sb_info *sbi,
+				      int how)
 {
 	unsigned long timeout;
 	struct dentry *root = sb->s_root;
@@ -373,7 +373,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 	dentry = NULL;
 	while ((dentry = get_next_positive_subdir(dentry, root))) {
 		spin_lock(&sbi->fs_lock);
-		ino = autofs4_dentry_ino(dentry);
+		ino = autofs_dentry_ino(dentry);
 		/* No point expiring a pending mount */
 		if (ino->flags & AUTOFS_INF_PENDING)
 			goto next;
@@ -389,11 +389,11 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 				(int)dentry->d_name.len, dentry->d_name.name);
 
 			/* Can we umount this guy */
-			if (autofs4_mount_busy(mnt, dentry))
+			if (autofs_mount_busy(mnt, dentry))
 				goto next;
 
 			/* Can we expire this guy */
-			if (autofs4_can_expire(dentry, timeout, do_now)) {
+			if (autofs_can_expire(dentry, timeout, do_now)) {
 				expired = dentry;
 				goto found;
 			}
@@ -410,7 +410,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			if (dentry->d_count > ino_count)
 				goto next;
 
-			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
+			if (!autofs_tree_busy(mnt, dentry, timeout, do_now)) {
 				expired = dentry;
 				goto found;
 			}
@@ -424,7 +424,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			if (dentry->d_count > ino_count)
 				goto next;
 
-			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
+			expired = autofs_check_leaves(mnt, dentry, timeout, do_now);
 			if (expired) {
 				dput(dentry);
 				goto found;
@@ -438,7 +438,7 @@ next:
 found:
 	DPRINTK("returning %p %.*s",
 		expired, (int)expired->d_name.len, expired->d_name.name);
-	ino = autofs4_dentry_ino(expired);
+	ino = autofs_dentry_ino(expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
@@ -452,10 +452,10 @@ found:
 	return expired;
 }
 
-int autofs4_expire_wait(struct dentry *dentry)
+int autofs_expire_wait(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status;
 
 	/* Block on any pending expire */
@@ -466,7 +466,7 @@ int autofs4_expire_wait(struct dentry *dentry)
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
-		status = autofs4_wait(sbi, dentry, NFY_NONE);
+		status = autofs_wait(sbi, dentry, NFY_NONE);
 		wait_for_completion(&ino->expire_complete);
 
 		DPRINTK("expire done status=%d", status);
@@ -482,10 +482,10 @@ int autofs4_expire_wait(struct dentry *dentry)
 }
 
 /* Perform an expiry operation */
-int autofs4_expire_run(struct super_block *sb,
-		       struct vfsmount *mnt,
-		       struct autofs_sb_info *sbi,
-		       struct autofs_packet_expire __user *pkt_p)
+int autofs_expire_run(struct super_block *sb,
+		      struct vfsmount *mnt,
+		      struct autofs_sb_info *sbi,
+		      struct autofs_packet_expire __user *pkt_p)
 {
 	struct autofs_packet_expire pkt;
 	struct autofs_info *ino;
@@ -497,7 +497,7 @@ int autofs4_expire_run(struct super_block *sb,
 	pkt.hdr.proto_version = sbi->version;
 	pkt.hdr.type = autofs_ptype_expire;
 
-	if ((dentry = autofs4_expire_indirect(sb, mnt, sbi, 0)) == NULL)
+	if ((dentry = autofs_expire_indirect(sb, mnt, sbi, 0)) == NULL)
 		return -EAGAIN;
 
 	pkt.len = dentry->d_name.len;
@@ -509,7 +509,7 @@ int autofs4_expire_run(struct super_block *sb,
 		ret = -EFAULT;
 
 	spin_lock(&sbi->fs_lock);
-	ino = autofs4_dentry_ino(dentry);
+	ino = autofs_dentry_ino(dentry);
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
@@ -517,23 +517,23 @@ int autofs4_expire_run(struct super_block *sb,
 	return ret;
 }
 
-int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			    struct autofs_sb_info *sbi, int when)
+int autofs_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			   struct autofs_sb_info *sbi, int when)
 {
 	struct dentry *dentry;
 	int ret = -EAGAIN;
 
 	if (autofs_type_trigger(sbi->type))
-		dentry = autofs4_expire_direct(sb, mnt, sbi, when);
+		dentry = autofs_expire_direct(sb, mnt, sbi, when);
 	else
-		dentry = autofs4_expire_indirect(sb, mnt, sbi, when);
+		dentry = autofs_expire_indirect(sb, mnt, sbi, when);
 
 	if (dentry) {
-		struct autofs_info *ino = autofs4_dentry_ino(dentry);
+		struct autofs_info *ino = autofs_dentry_ino(dentry);
 
 		/* This is synchronous because it makes the daemon a
                    little easier */
-		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
+		ret = autofs_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
@@ -549,7 +549,7 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
  * Call repeatedly until it returns -EAGAIN, meaning there's nothing
  * more to be done.
  */
-int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+int autofs_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 			struct autofs_sb_info *sbi, int __user *arg)
 {
 	int do_now = 0;
@@ -557,6 +557,6 @@ int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 	if (arg && get_user(do_now, arg))
 		return -EFAULT;
 
-	return autofs4_do_expire_multi(sb, mnt, sbi, do_now);
+	return autofs_do_expire_multi(sb, mnt, sbi, do_now);
 }
 
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index 5a66322..51232a9 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -14,18 +14,18 @@
 static struct dentry *autofs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_nodev(fs_type, flags, data, autofs4_fill_super);
+	return mount_nodev(fs_type, flags, data, autofs_fill_super);
 }
 
 static struct file_system_type autofs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "autofs",
 	.mount		= autofs_mount,
-	.kill_sb	= autofs4_kill_sb,
+	.kill_sb	= autofs_kill_sb,
 };
 MODULE_ALIAS_FS("autofs");
 
-static int __init init_autofs4_fs(void)
+static int __init init_autofs_fs(void)
 {
 	int err;
 
@@ -38,12 +38,12 @@ static int __init init_autofs4_fs(void)
 	return err;
 }
 
-static void __exit exit_autofs4_fs(void)
+static void __exit exit_autofs_fs(void)
 {
 	autofs_dev_ioctl_exit();
 	unregister_filesystem(&autofs_fs_type);
 }
 
-module_init(init_autofs4_fs) 
-module_exit(exit_autofs4_fs)
+module_init(init_autofs_fs)
+module_exit(exit_autofs_fs)
 MODULE_LICENSE("GPL");
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index eafdf6e..543389c 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -19,7 +19,7 @@
 #include "autofs_i.h"
 #include <linux/module.h>
 
-struct autofs_info *autofs4_new_ino(struct autofs_sb_info *sbi)
+struct autofs_info *autofs_new_ino(struct autofs_sb_info *sbi)
 {
 	struct autofs_info *ino = kzalloc(sizeof(*ino), GFP_KERNEL);
 	if (ino) {
@@ -31,21 +31,21 @@ struct autofs_info *autofs4_new_ino(struct autofs_sb_info *sbi)
 	return ino;
 }
 
-void autofs4_clean_ino(struct autofs_info *ino)
+void autofs_clean_ino(struct autofs_info *ino)
 {
 	ino->uid = GLOBAL_ROOT_UID;
 	ino->gid = GLOBAL_ROOT_GID;
 	ino->last_used = jiffies;
 }
 
-void autofs4_free_ino(struct autofs_info *ino)
+void autofs_free_ino(struct autofs_info *ino)
 {
 	kfree(ino);
 }
 
-void autofs4_kill_sb(struct super_block *sb)
+void autofs_kill_sb(struct super_block *sb)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(sb);
+	struct autofs_sb_info *sbi = autofs_sbi(sb);
 
 	/*
 	 * In the event of a failure in get_sb_nodev the superblock
@@ -57,7 +57,7 @@ void autofs4_kill_sb(struct super_block *sb)
 		goto out_kill_sb;
 
 	/* Free wait queues, close pipe */
-	autofs4_catatonic_mode(sbi);
+	autofs_catatonic_mode(sbi);
 
 	put_pid(sbi->oz_pgrp);
 
@@ -69,9 +69,9 @@ out_kill_sb:
 	kill_litter_super(sb);
 }
 
-static int autofs4_show_options(struct seq_file *m, struct dentry *root)
+static int autofs_show_options(struct seq_file *m, struct dentry *root)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(root->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(root->d_sb);
 	struct inode *root_inode = root->d_sb->s_root->d_inode;
 
 	if (!sbi)
@@ -99,16 +99,16 @@ static int autofs4_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
-static void autofs4_evict_inode(struct inode *inode)
+static void autofs_evict_inode(struct inode *inode)
 {
 	clear_inode(inode);
 	kfree(inode->i_private);
 }
 
-static const struct super_operations autofs4_sops = {
+static const struct super_operations autofs_sops = {
 	.statfs		= simple_statfs,
-	.show_options	= autofs4_show_options,
-	.evict_inode	= autofs4_evict_inode,
+	.show_options	= autofs_show_options,
+	.evict_inode	= autofs_evict_inode,
 };
 
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto,
@@ -203,7 +203,7 @@ static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
 	return (*pipefd < 0);
 }
 
-int autofs4_fill_super(struct super_block *s, void *data, int silent)
+int autofs_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct inode * root_inode;
 	struct dentry * root;
@@ -242,17 +242,17 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = AUTOFS_SUPER_MAGIC;
-	s->s_op = &autofs4_sops;
-	s->s_d_op = &autofs4_dentry_operations;
+	s->s_op = &autofs_sops;
+	s->s_d_op = &autofs_dentry_operations;
 	s->s_time_gran = 1;
 
 	/*
 	 * Get the root inode and dentry, but defer checking for errors.
 	 */
-	ino = autofs4_new_ino(sbi);
+	ino = autofs_new_ino(sbi);
 	if (!ino)
 		goto fail_free;
-	root_inode = autofs4_get_inode(s, S_IFDIR | 0755);
+	root_inode = autofs_get_inode(s, S_IFDIR | 0755);
 	root = d_make_root(root_inode);
 	if (!root)
 		goto fail_ino;
@@ -282,8 +282,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	if (autofs_type_trigger(sbi->type))
 		__managed_dentry_set_managed(root);
 
-	root_inode->i_fop = &autofs4_root_operations;
-	root_inode->i_op = &autofs4_dir_inode_operations;
+	root_inode->i_fop = &autofs_root_operations;
+	root_inode->i_op = &autofs_dir_inode_operations;
 
 	/* Couldn't this be tested earlier? */
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
@@ -341,7 +341,7 @@ fail_unlock:
 	return -EINVAL;
 }
 
-struct inode *autofs4_get_inode(struct super_block *sb, umode_t mode)
+struct inode *autofs_get_inode(struct super_block *sb, umode_t mode)
 {
 	struct inode *inode = new_inode(sb);
 
@@ -358,10 +358,10 @@ struct inode *autofs4_get_inode(struct super_block *sb, umode_t mode)
 
 	if (S_ISDIR(mode)) {
 		set_nlink(inode, 2);
-		inode->i_op = &autofs4_dir_inode_operations;
-		inode->i_fop = &autofs4_dir_operations;
+		inode->i_op = &autofs_dir_inode_operations;
+		inode->i_fop = &autofs_dir_operations;
 	} else if (S_ISLNK(mode)) {
-		inode->i_op = &autofs4_symlink_inode_operations;
+		inode->i_op = &autofs_symlink_inode_operations;
 	}
 
 	return inode;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index a5b3825..4b64d07 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -20,58 +20,58 @@
 
 #include "autofs_i.h"
 
-static int autofs4_dir_symlink(struct inode *,struct dentry *,const char *);
-static int autofs4_dir_unlink(struct inode *,struct dentry *);
-static int autofs4_dir_rmdir(struct inode *,struct dentry *);
-static int autofs4_dir_mkdir(struct inode *,struct dentry *,umode_t);
-static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+static int autofs_dir_symlink(struct inode *,struct dentry *,const char *);
+static int autofs_dir_unlink(struct inode *,struct dentry *);
+static int autofs_dir_rmdir(struct inode *,struct dentry *);
+static int autofs_dir_mkdir(struct inode *,struct dentry *,umode_t);
+static long autofs_root_ioctl(struct file *,unsigned int,unsigned long);
 #ifdef CONFIG_COMPAT
-static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+static long autofs_root_compat_ioctl(struct file *,unsigned int,unsigned long);
 #endif
-static int autofs4_dir_open(struct inode *inode, struct file *file);
-static struct dentry *autofs4_lookup(struct inode *,struct dentry *, unsigned int);
-static struct vfsmount *autofs4_d_automount(struct path *);
-static int autofs4_d_manage(struct dentry *, bool);
-static void autofs4_dentry_release(struct dentry *);
+static int autofs_dir_open(struct inode *inode, struct file *file);
+static struct dentry *autofs_lookup(struct inode *,struct dentry *, unsigned int);
+static struct vfsmount *autofs_d_automount(struct path *);
+static int autofs_d_manage(struct dentry *, bool);
+static void autofs_dentry_release(struct dentry *);
 
-const struct file_operations autofs4_root_operations = {
+const struct file_operations autofs_root_operations = {
 	.open		= dcache_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
 	.iterate	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
-	.unlocked_ioctl	= autofs4_root_ioctl,
+	.unlocked_ioctl	= autofs_root_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl	= autofs4_root_compat_ioctl,
+	.compat_ioctl	= autofs_root_compat_ioctl,
 #endif
 };
 
-const struct file_operations autofs4_dir_operations = {
-	.open		= autofs4_dir_open,
+const struct file_operations autofs_dir_operations = {
+	.open		= autofs_dir_open,
 	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
 	.iterate	= dcache_readdir,
 	.llseek		= dcache_dir_lseek,
 };
 
-const struct inode_operations autofs4_dir_inode_operations = {
-	.lookup		= autofs4_lookup,
-	.unlink		= autofs4_dir_unlink,
-	.symlink	= autofs4_dir_symlink,
-	.mkdir		= autofs4_dir_mkdir,
-	.rmdir		= autofs4_dir_rmdir,
+const struct inode_operations autofs_dir_inode_operations = {
+	.lookup		= autofs_lookup,
+	.unlink		= autofs_dir_unlink,
+	.symlink	= autofs_dir_symlink,
+	.mkdir		= autofs_dir_mkdir,
+	.rmdir		= autofs_dir_rmdir,
 };
 
-const struct dentry_operations autofs4_dentry_operations = {
-	.d_automount	= autofs4_d_automount,
-	.d_manage	= autofs4_d_manage,
-	.d_release	= autofs4_dentry_release,
+const struct dentry_operations autofs_dentry_operations = {
+	.d_automount	= autofs_d_automount,
+	.d_manage	= autofs_d_manage,
+	.d_release	= autofs_dentry_release,
 };
 
-static void autofs4_add_active(struct dentry *dentry)
+static void autofs_add_active(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		if (!ino->active_count) {
@@ -84,10 +84,10 @@ static void autofs4_add_active(struct dentry *dentry)
 	return;
 }
 
-static void autofs4_del_active(struct dentry *dentry)
+static void autofs_del_active(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	if (ino) {
 		spin_lock(&sbi->lookup_lock);
 		ino->active_count--;
@@ -100,15 +100,15 @@ static void autofs4_del_active(struct dentry *dentry)
 	return;
 }
 
-static int autofs4_dir_open(struct inode *inode, struct file *file)
+static int autofs_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 
 	DPRINTK("file=%p dentry=%p %.*s",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);
 
-	if (autofs4_oz_mode(sbi))
+	if (autofs_oz_mode(sbi))
 		goto out;
 
 	/*
@@ -131,10 +131,10 @@ out:
 	return dcache_dir_open(inode, file);
 }
 
-static void autofs4_dentry_release(struct dentry *de)
+static void autofs_dentry_release(struct dentry *de)
 {
-	struct autofs_info *ino = autofs4_dentry_ino(de);
-	struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(de);
+	struct autofs_sb_info *sbi = autofs_sbi(de->d_sb);
 
 	DPRINTK("releasing %p", de);
 
@@ -150,12 +150,12 @@ static void autofs4_dentry_release(struct dentry *de)
 		spin_unlock(&sbi->lookup_lock);
 	}
 
-	autofs4_free_ino(ino);
+	autofs_free_ino(ino);
 }
 
-static struct dentry *autofs4_lookup_active(struct dentry *dentry)
+static struct dentry *autofs_lookup_active(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 	struct dentry *parent = dentry->d_parent;
 	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
@@ -205,9 +205,9 @@ next:
 	return NULL;
 }
 
-static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
+static struct dentry *autofs_lookup_expiring(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 	struct dentry *parent = dentry->d_parent;
 	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
@@ -257,16 +257,16 @@ next:
 	return NULL;
 }
 
-static int autofs4_mount_wait(struct dentry *dentry)
+static int autofs_mount_wait(struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status = 0;
 
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
-		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
+		status = autofs_wait(sbi, dentry, NFY_MOUNT);
 		DPRINTK("mount wait done status=%d", status);
 	}
 	ino->last_used = jiffies;
@@ -277,26 +277,26 @@ static int do_expire_wait(struct dentry *dentry)
 {
 	struct dentry *expiring;
 
-	expiring = autofs4_lookup_expiring(dentry);
+	expiring = autofs_lookup_expiring(dentry);
 	if (!expiring)
-		return autofs4_expire_wait(dentry);
+		return autofs_expire_wait(dentry);
 	else {
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete, but the directory has been removed
 		 * so it must have been successful, just wait for it.
 		 */
-		autofs4_expire_wait(expiring);
-		autofs4_del_expiring(expiring);
+		autofs_expire_wait(expiring);
+		autofs_del_expiring(expiring);
 		dput(expiring);
 	}
 	return 0;
 }
 
-static struct dentry *autofs4_mountpoint_changed(struct path *path)
+static struct dentry *autofs_mountpoint_changed(struct path *path)
 {
 	struct dentry *dentry = path->dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 
 	/*
 	 * If this is an indirect mount the dentry could have gone away
@@ -308,7 +308,7 @@ static struct dentry *autofs4_mountpoint_changed(struct path *path)
 		struct dentry *new = d_lookup(parent, &dentry->d_name);
 		if (!new)
 			return NULL;
-		ino = autofs4_dentry_ino(new);
+		ino = autofs_dentry_ino(new);
 		ino->last_used = jiffies;
 		dput(path->dentry);
 		path->dentry = new;
@@ -316,18 +316,18 @@ static struct dentry *autofs4_mountpoint_changed(struct path *path)
 	return path->dentry;
 }
 
-static struct vfsmount *autofs4_d_automount(struct path *path)
+static struct vfsmount *autofs_d_automount(struct path *path)
 {
 	struct dentry *dentry = path->dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status;
 
 	DPRINTK("dentry=%p %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	/* The daemon never triggers a mount. */
-	if (autofs4_oz_mode(sbi))
+	if (autofs_oz_mode(sbi))
 		return NULL;
 
 	/*
@@ -346,7 +346,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry);
+		status = autofs_mount_wait(dentry);
 		if (status)
 			return ERR_PTR(status);
 		goto done;
@@ -387,7 +387,7 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
-		status = autofs4_mount_wait(dentry);
+		status = autofs_mount_wait(dentry);
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_PENDING;
 		if (status) {
@@ -398,24 +398,24 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 	spin_unlock(&sbi->fs_lock);
 done:
 	/* Mount succeeded, check if we ended up with a new dentry */
-	dentry = autofs4_mountpoint_changed(path);
+	dentry = autofs_mountpoint_changed(path);
 	if (!dentry)
 		return ERR_PTR(-ENOENT);
 
 	return NULL;
 }
 
-static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
+static int autofs_d_manage(struct dentry *dentry, bool rcu_walk)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status;
 
 	DPRINTK("dentry=%p %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	/* The daemon never waits. */
-	if (autofs4_oz_mode(sbi)) {
+	if (autofs_oz_mode(sbi)) {
 		if (rcu_walk)
 			return 0;
 		if (!d_mountpoint(dentry))
@@ -434,7 +434,7 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 	 * This dentry may be under construction so wait on mount
 	 * completion.
 	 */
-	status = autofs4_mount_wait(dentry);
+	status = autofs_mount_wait(dentry);
 	if (status)
 		return status;
 
@@ -463,7 +463,7 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir,
+static struct dentry *autofs_lookup(struct inode *dir,
 				     struct dentry *dentry, unsigned int flags)
 {
 	struct autofs_sb_info *sbi;
@@ -476,13 +476,13 @@ static struct dentry *autofs4_lookup(struct inode *dir,
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	sbi = autofs4_sbi(dir->i_sb);
+	sbi = autofs_sbi(dir->i_sb);
 
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		current->pid, task_pgrp_nr(current), sbi->catatonic,
-		autofs4_oz_mode(sbi));
+		autofs_oz_mode(sbi));
 
-	active = autofs4_lookup_active(dentry);
+	active = autofs_lookup_active(dentry);
 	if (active) {
 		return active;
 	} else {
@@ -492,33 +492,33 @@ static struct dentry *autofs4_lookup(struct inode *dir,
 		 * can return fail immediately.  The daemon however does need
 		 * to create directories within the file system.
 		 */
-		if (!autofs4_oz_mode(sbi) && !IS_ROOT(dentry->d_parent))
+		if (!autofs_oz_mode(sbi) && !IS_ROOT(dentry->d_parent))
 			return ERR_PTR(-ENOENT);
 
 		/* Mark entries in the root as mount triggers */
 		if (autofs_type_indirect(sbi->type) && IS_ROOT(dentry->d_parent))
 			__managed_dentry_set_managed(dentry);
 
-		ino = autofs4_new_ino(sbi);
+		ino = autofs_new_ino(sbi);
 		if (!ino)
 			return ERR_PTR(-ENOMEM);
 
 		dentry->d_fsdata = ino;
 		ino->dentry = dentry;
 
-		autofs4_add_active(dentry);
+		autofs_add_active(dentry);
 
 		d_instantiate(dentry, NULL);
 	}
 	return NULL;
 }
 
-static int autofs4_dir_symlink(struct inode *dir, 
+static int autofs_dir_symlink(struct inode *dir,
 			       struct dentry *dentry,
 			       const char *symname)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	struct inode *inode;
 	size_t size = strlen(symname);
@@ -527,14 +527,14 @@ static int autofs4_dir_symlink(struct inode *dir,
 	DPRINTK("%s <- %.*s", symname,
 		dentry->d_name.len, dentry->d_name.name);
 
-	if (!autofs4_oz_mode(sbi))
+	if (!autofs_oz_mode(sbi))
 		return -EACCES;
 
 	BUG_ON(!ino);
 
-	autofs4_clean_ino(ino);
+	autofs_clean_ino(ino);
 
-	autofs4_del_active(dentry);
+	autofs_del_active(dentry);
 
 	cp = kmalloc(size + 1, GFP_KERNEL);
 	if (!cp)
@@ -542,7 +542,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 
 	strcpy(cp, symname);
 
-	inode = autofs4_get_inode(dir->i_sb, S_IFLNK | 0555);
+	inode = autofs_get_inode(dir->i_sb, S_IFLNK | 0555);
 	if (!inode) {
 		kfree(cp);
 		if (!dentry->d_fsdata)
@@ -555,7 +555,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 
 	dget(dentry);
 	atomic_inc(&ino->count);
-	p_ino = autofs4_dentry_ino(dentry->d_parent);
+	p_ino = autofs_dentry_ino(dentry->d_parent);
 	if (p_ino && dentry->d_parent != dentry)
 		atomic_inc(&p_ino->count);
 
@@ -577,20 +577,20 @@ static int autofs4_dir_symlink(struct inode *dir,
  * If a process is blocked on the dentry waiting for the expire to finish,
  * it will invalidate the dentry and try to mount with a new one.
  *
- * Also see autofs4_dir_rmdir()..
+ * Also see autofs_dir_rmdir()..
  */
-static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
+static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	
 	/* This allows root to remove symlinks */
-	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
+	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs4_dentry_ino(dentry->d_parent);
+		p_ino = autofs_dentry_ino(dentry->d_parent);
 		if (p_ino && dentry->d_parent != dentry)
 			atomic_dec(&p_ino->count);
 	}
@@ -602,7 +602,7 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 	dir->i_mtime = CURRENT_TIME;
 
 	spin_lock(&sbi->lookup_lock);
-	__autofs4_add_expiring(dentry);
+	__autofs_add_expiring(dentry);
 	d_drop(dentry);
 	spin_unlock(&sbi->lookup_lock);
 
@@ -661,16 +661,16 @@ static void autofs_clear_leaf_automount_flags(struct dentry *dentry)
 	return;
 }
 
-static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
+static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	
 	DPRINTK("dentry %p, removing %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
-	if (!autofs4_oz_mode(sbi))
+	if (!autofs_oz_mode(sbi))
 		return -EACCES;
 
 	spin_lock(&sbi->lookup_lock);
@@ -678,7 +678,7 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOTEMPTY;
 	}
-	__autofs4_add_expiring(dentry);
+	__autofs_add_expiring(dentry);
 	d_drop(dentry);
 	spin_unlock(&sbi->lookup_lock);
 
@@ -686,7 +686,7 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 		autofs_clear_leaf_automount_flags(dentry);
 
 	if (atomic_dec_and_test(&ino->count)) {
-		p_ino = autofs4_dentry_ino(dentry->d_parent);
+		p_ino = autofs_dentry_ino(dentry->d_parent);
 		if (p_ino && dentry->d_parent != dentry)
 			atomic_dec(&p_ino->count);
 	}
@@ -700,14 +700,14 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	return 0;
 }
 
-static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+static int autofs_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
+	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	struct inode *inode;
 
-	if (!autofs4_oz_mode(sbi))
+	if (!autofs_oz_mode(sbi))
 		return -EACCES;
 
 	DPRINTK("dentry %p, creating %.*s",
@@ -715,11 +715,11 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t m
 
 	BUG_ON(!ino);
 
-	autofs4_clean_ino(ino);
+	autofs_clean_ino(ino);
 
-	autofs4_del_active(dentry);
+	autofs_del_active(dentry);
 
-	inode = autofs4_get_inode(dir->i_sb, S_IFDIR | 0555);
+	inode = autofs_get_inode(dir->i_sb, S_IFDIR | 0555);
 	if (!inode)
 		return -ENOMEM;
 	d_add(dentry, inode);
@@ -729,7 +729,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t m
 
 	dget(dentry);
 	atomic_inc(&ino->count);
-	p_ino = autofs4_dentry_ino(dentry->d_parent);
+	p_ino = autofs_dentry_ino(dentry->d_parent);
 	if (p_ino && dentry->d_parent != dentry)
 		atomic_inc(&p_ino->count);
 	inc_nlink(dir);
@@ -740,7 +740,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t m
 
 /* Get/set timeout ioctl() operation */
 #ifdef CONFIG_COMPAT
-static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
+static inline int autofs_compat_get_set_timeout(struct autofs_sb_info *sbi,
 						 compat_ulong_t __user *p)
 {
 	int rv;
@@ -759,7 +759,7 @@ static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
 }
 #endif
 
-static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
+static inline int autofs_get_set_timeout(struct autofs_sb_info *sbi,
 					  unsigned long __user *p)
 {
 	int rv;
@@ -778,14 +778,14 @@ static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 }
 
 /* Return protocol version */
-static inline int autofs4_get_protover(struct autofs_sb_info *sbi,
+static inline int autofs_get_protover(struct autofs_sb_info *sbi,
 				       int __user *p)
 {
 	return put_user(sbi->version, p);
 }
 
 /* Return protocol sub version */
-static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi,
+static inline int autofs_get_protosubver(struct autofs_sb_info *sbi,
 					  int __user *p)
 {
 	return put_user(sbi->sub_version, p);
@@ -794,7 +794,7 @@ static inline int autofs4_get_protosubver(struct autofs_sb_info *sbi,
 /*
 * Tells the daemon whether it can umount the autofs mount.
 */
-static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
+static inline int autofs_ask_umount(struct vfsmount *mnt, int __user *p)
 {
 	int status = 0;
 
@@ -808,14 +808,14 @@ static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
 	return status;
 }
 
-/* Identify autofs4_dentries - this is so we can tell if there's
+/* Identify autofs_dentries - this is so we can tell if there's
    an extra dentry refcount or not.  We only hold a refcount on the
    dentry if its non-negative (ie, d_inode != NULL)
 */
-int is_autofs4_dentry(struct dentry *dentry)
+int is_autofs_dentry(struct dentry *dentry)
 {
 	return dentry && dentry->d_inode &&
-		dentry->d_op == &autofs4_dentry_operations &&
+		dentry->d_op == &autofs_dentry_operations &&
 		dentry->d_fsdata != NULL;
 }
 
@@ -823,10 +823,10 @@ int is_autofs4_dentry(struct dentry *dentry)
  * ioctl()'s on the root directory is the chief method for the daemon to
  * generate kernel reactions
  */
-static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
+static int autofs_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 				       unsigned int cmd, unsigned long arg)
 {
-	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;
 
 	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
@@ -836,61 +836,61 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
 		return -ENOTTY;
 	
-	if (!autofs4_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
+	if (!autofs_oz_mode(sbi) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	
 	switch(cmd) {
 	case AUTOFS_IOC_READY:	/* Wait queue: go ahead and retry */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,0);
+		return autofs_wait_release(sbi,(autofs_wqt_t)arg,0);
 	case AUTOFS_IOC_FAIL:	/* Wait queue: fail with ENOENT */
-		return autofs4_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
+		return autofs_wait_release(sbi,(autofs_wqt_t)arg,-ENOENT);
 	case AUTOFS_IOC_CATATONIC: /* Enter catatonic mode (daemon shutdown) */
-		autofs4_catatonic_mode(sbi);
+		autofs_catatonic_mode(sbi);
 		return 0;
 	case AUTOFS_IOC_PROTOVER: /* Get protocol version */
-		return autofs4_get_protover(sbi, p);
+		return autofs_get_protover(sbi, p);
 	case AUTOFS_IOC_PROTOSUBVER: /* Get protocol sub version */
-		return autofs4_get_protosubver(sbi, p);
+		return autofs_get_protosubver(sbi, p);
 	case AUTOFS_IOC_SETTIMEOUT:
-		return autofs4_get_set_timeout(sbi, p);
+		return autofs_get_set_timeout(sbi, p);
 #ifdef CONFIG_COMPAT
 	case AUTOFS_IOC_SETTIMEOUT32:
-		return autofs4_compat_get_set_timeout(sbi, p);
+		return autofs_compat_get_set_timeout(sbi, p);
 #endif
 
 	case AUTOFS_IOC_ASKUMOUNT:
-		return autofs4_ask_umount(filp->f_path.mnt, p);
+		return autofs_ask_umount(filp->f_path.mnt, p);
 
 	/* return a single thing to expire */
 	case AUTOFS_IOC_EXPIRE:
-		return autofs4_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs_expire_run(inode->i_sb,filp->f_path.mnt,sbi, p);
 	/* same as above, but can send multiple expires through pipe */
 	case AUTOFS_IOC_EXPIRE_MULTI:
-		return autofs4_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
+		return autofs_expire_multi(inode->i_sb,filp->f_path.mnt,sbi, p);
 
 	default:
 		return -ENOSYS;
 	}
 }
 
-static long autofs4_root_ioctl(struct file *filp,
+static long autofs_root_ioctl(struct file *filp,
 			       unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
-	return autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
+	return autofs_root_ioctl_unlocked(inode, filp, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
-static long autofs4_root_compat_ioctl(struct file *filp,
+static long autofs_root_compat_ioctl(struct file *filp,
 				      unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	int ret;
 
 	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
-		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
+		ret = autofs_root_ioctl_unlocked(inode, filp, cmd, arg);
 	else
-		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd,
+		ret = autofs_root_ioctl_unlocked(inode, filp, cmd,
 					      (unsigned long) compat_ptr(arg));
 
 	return ret;
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
index 063b240..9d728bf 100644
--- a/fs/autofs4/symlink.c
+++ b/fs/autofs4/symlink.c
@@ -9,13 +9,13 @@
 
 #include "autofs_i.h"
 
-static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *autofs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	nd_set_link(nd, dentry->d_inode->i_private);
 	return NULL;
 }
 
-const struct inode_operations autofs4_symlink_inode_operations = {
+const struct inode_operations autofs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
-	.follow_link	= autofs4_follow_link
+	.follow_link	= autofs_follow_link
 };
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index f1fb9d7..1725e3f 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -16,12 +16,12 @@
 
 /* We make this a static variable rather than a part of the superblock; it
    is better if we don't reassign numbers easily even across filesystems */
-static autofs_wqt_t autofs4_next_wait_queue = 1;
+static autofs_wqt_t autofs_next_wait_queue = 1;
 
 /* These are the signals we allow interrupting a pending mount */
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL) | sigmask(SIGINT) | sigmask(SIGQUIT))
 
-void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
+void autofs_catatonic_mode(struct autofs_sb_info *sbi)
 {
 	struct autofs_wait_queue *wq, *nwq;
 
@@ -51,8 +51,8 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 	mutex_unlock(&sbi->wq_mutex);
 }
 
-static int autofs4_write(struct autofs_sb_info *sbi,
-			 struct file *file, const void *addr, int bytes)
+static int autofs_write(struct autofs_sb_info *sbi,
+			struct file *file, const void *addr, int bytes)
 {
 	unsigned long sigpipe, flags;
 	mm_segment_t fs;
@@ -87,7 +87,7 @@ static int autofs4_write(struct autofs_sb_info *sbi,
 	return (bytes > 0);
 }
 	
-static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
+static void autofs_notify_daemon(struct autofs_sb_info *sbi,
 				 struct autofs_wait_queue *wq,
 				 int type)
 {
@@ -167,7 +167,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		break;
 	}
 	default:
-		printk("autofs4_notify_daemon: bad type %d!\n", type);
+		printk("autofs_notify_daemon: bad type %d!\n", type);
 		mutex_unlock(&sbi->wq_mutex);
 		return;
 	}
@@ -176,13 +176,13 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 
 	mutex_unlock(&sbi->wq_mutex);
 
-	if (autofs4_write(sbi, pipe, &pkt, pktsz))
-		autofs4_catatonic_mode(sbi);
+	if (autofs_write(sbi, pipe, &pkt, pktsz))
+		autofs_catatonic_mode(sbi);
 	fput(pipe);
 }
 
-static int autofs4_getpath(struct autofs_sb_info *sbi,
-			   struct dentry *dentry, char **name)
+static int autofs_getpath(struct autofs_sb_info *sbi,
+			  struct dentry *dentry, char **name)
 {
 	struct dentry *root = sbi->sb->s_root;
 	struct dentry *tmp;
@@ -227,7 +227,7 @@ rename_retry:
 }
 
 static struct autofs_wait_queue *
-autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
+autofs_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
 {
 	struct autofs_wait_queue *wq;
 
@@ -261,7 +261,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 		return -ENOENT;
 
 	/* Wait in progress, continue; */
-	wq = autofs4_find_wait(sbi, qstr);
+	wq = autofs_find_wait(sbi, qstr);
 	if (wq) {
 		*wait = wq;
 		return 1;
@@ -270,7 +270,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 	*wait = NULL;
 
 	/* If we don't yet have any info this is a new request */
-	ino = autofs4_dentry_ino(dentry);
+	ino = autofs_dentry_ino(dentry);
 	if (!ino)
 		return 1;
 
@@ -295,7 +295,7 @@ static int validate_request(struct autofs_wait_queue **wait,
 			if (sbi->catatonic)
 				return -ENOENT;
 
-			wq = autofs4_find_wait(sbi, qstr);
+			wq = autofs_find_wait(sbi, qstr);
 			if (wq) {
 				*wait = wq;
 				return 1;
@@ -344,8 +344,8 @@ static int validate_request(struct autofs_wait_queue **wait,
 	return 1;
 }
 
-int autofs4_wait(struct autofs_sb_info *sbi,
-		 struct dentry *dentry, enum autofs_notify notify)
+int autofs_wait(struct autofs_sb_info *sbi,
+		struct dentry *dentry, enum autofs_notify notify)
 {
 	struct autofs_wait_queue *wq;
 	struct qstr qstr;
@@ -391,7 +391,7 @@ int autofs4_wait(struct autofs_sb_info *sbi,
 	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
 		qstr.len = sprintf(name, "%p", dentry);
 	else {
-		qstr.len = autofs4_getpath(sbi, dentry, &name);
+		qstr.len = autofs_getpath(sbi, dentry, &name);
 		if (!qstr.len) {
 			kfree(name);
 			return -ENOENT;
@@ -422,15 +422,15 @@ int autofs4_wait(struct autofs_sb_info *sbi,
 			return -ENOMEM;
 		}
 
-		wq->wait_queue_token = autofs4_next_wait_queue;
-		if (++autofs4_next_wait_queue == 0)
-			autofs4_next_wait_queue = 1;
+		wq->wait_queue_token = autofs_next_wait_queue;
+		if (++autofs_next_wait_queue == 0)
+			autofs_next_wait_queue = 1;
 		wq->next = sbi->queues;
 		sbi->queues = wq;
 		init_waitqueue_head(&wq->queue);
 		memcpy(&wq->name, &qstr, sizeof(struct qstr));
-		wq->dev = autofs4_get_dev(sbi);
-		wq->ino = autofs4_get_ino(sbi);
+		wq->dev = autofs_get_dev(sbi);
+		wq->ino = autofs_get_ino(sbi);
 		wq->uid = current_uid();
 		wq->gid = current_gid();
 		wq->pid = pid;
@@ -459,8 +459,8 @@ int autofs4_wait(struct autofs_sb_info *sbi,
 			(unsigned long) wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 
-		/* autofs4_notify_daemon() may block */
-		autofs4_notify_daemon(sbi, wq, type);
+		/* autofs_notify_daemon() may block */
+		autofs_notify_daemon(sbi, wq, type);
 	} else {
 		wq->wait_ctr++;
 		mutex_unlock(&sbi->wq_mutex);
@@ -511,12 +511,12 @@ int autofs4_wait(struct autofs_sb_info *sbi,
 		struct dentry *de = NULL;
 
 		/* direct mount or browsable map */
-		ino = autofs4_dentry_ino(dentry);
+		ino = autofs_dentry_ino(dentry);
 		if (!ino) {
 			/* If not lookup actual dentry used */
 			de = d_lookup(dentry->d_parent, &dentry->d_name);
 			if (de)
-				ino = autofs4_dentry_ino(de);
+				ino = autofs_dentry_ino(de);
 		}
 
 		/* Set mount requester */
@@ -541,7 +541,8 @@ int autofs4_wait(struct autofs_sb_info *sbi,
 }
 
 
-int autofs4_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_token, int status)
+int autofs_wait_release(struct autofs_sb_info *sbi,
+			autofs_wqt_t wait_queue_token, int status)
 {
 	struct autofs_wait_queue *wq, **wql;
 

