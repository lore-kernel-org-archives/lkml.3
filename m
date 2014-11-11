Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKKBaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:30:46 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53600 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbaKKBaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:30:03 -0500
X-Sasl-enc: 7v3e6+9EJ9kZC7cgmk0v7SWnxOGHfFQ2oc7gYvsi5HQ9 1415669402
Subject: [PATCH 2/3] autofs - change log prints to not insert newline
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 09:30:00 +0800
Message-ID: <20141111013000.25773.64448.stgit@perseus.themaw.net>
In-Reply-To: <20141111012954.25773.4002.stgit@perseus.themaw.net>
References: <20141111012954.25773.4002.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common kernel coding practice is to include the newline of log
prints within the log text rather than hidden away in a macro.

To avoid introducing inconsistencies as changes are made change
the log macros to not include the newline.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Joe Perches <joe@perches.com>
---
 fs/autofs/autofs_i.h  |    6 +++---
 fs/autofs/dev-ioctl.c |   14 +++++++-------
 fs/autofs/expire.c    |   24 ++++++++++++------------
 fs/autofs/inode.c     |   16 ++++++++--------
 fs/autofs/root.c      |   26 +++++++++++++-------------
 fs/autofs/waitq.c     |   10 +++++-----
 6 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
index fd93fdc..84d5060 100644
--- a/fs/autofs/autofs_i.h
+++ b/fs/autofs/autofs_i.h
@@ -37,15 +37,15 @@
 /* #define DEBUG */
 
 #define DPRINTK(fmt, ...)				\
-	pr_debug(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",\
+	pr_debug(KBUILD_MODNAME ":pid:%d:%s: " fmt,	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_WARN(fmt, ...)				\
-	pr_warn(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
+	pr_warn(KBUILD_MODNAME ":pid:%d:%s: " fmt,	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_ERROR(fmt, ...)				\
-	pr_err(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
+	pr_err(KBUILD_MODNAME ":pid:%d:%s: " fmt,	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 /*
diff --git a/fs/autofs/dev-ioctl.c b/fs/autofs/dev-ioctl.c
index eb16fe4..15ce91b 100644
--- a/fs/autofs/dev-ioctl.c
+++ b/fs/autofs/dev-ioctl.c
@@ -75,7 +75,7 @@ static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
 	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
 	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
 		AUTOFS_WARN("ioctl control interface version mismatch: "
-		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
+		     "kernel(%u.%u), user(%u.%u), cmd(%d)\n",
 		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
 		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
 		     param->ver_major, param->ver_minor, cmd);
@@ -126,7 +126,7 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 	err = check_dev_ioctl_version(cmd, param);
 	if (err) {
 		AUTOFS_WARN("invalid device control module version "
-		     "supplied for cmd(0x%08x)", cmd);
+		     "supplied for cmd(0x%08x)\n", cmd);
 		goto out;
 	}
 
@@ -134,14 +134,14 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 		err = invalid_str(param->path, param->size - sizeof(*param));
 		if (err) {
 			AUTOFS_WARN(
-			  "path string terminator missing for cmd(0x%08x)",
+			  "path string terminator missing for cmd(0x%08x)\n",
 			  cmd);
 			goto out;
 		}
 
 		err = check_name(param->path);
 		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
+			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)\n",
 				    cmd);
 			goto out;
 		}
@@ -369,7 +369,7 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 		new_pid = get_task_pid(current, PIDTYPE_PGID);
 
 		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
-			AUTOFS_WARN("not allowed to change PID namespace");
+			AUTOFS_WARN("not allowed to change PID namespace\n");
 			err = -EINVAL;
 			goto out;
 		}
@@ -657,7 +657,7 @@ static int _autofs_dev_ioctl(unsigned int command,
 
 	fn = lookup_dev_ioctl(cmd);
 	if (!fn) {
-		AUTOFS_WARN("unknown command 0x%08x", command);
+		AUTOFS_WARN("unknown command 0x%08x\n", command);
 		return -ENOTTY;
 	}
 
@@ -750,7 +750,7 @@ int __init autofs_dev_ioctl_init(void)
 
 	r = misc_register(&_autofs_dev_ioctl_misc);
 	if (r) {
-		AUTOFS_ERROR("misc_register failed for control device");
+		AUTOFS_ERROR("misc_register failed for control device\n");
 		return r;
 	}
 
diff --git a/fs/autofs/expire.c b/fs/autofs/expire.c
index c3090b4..99f51cf 100644
--- a/fs/autofs/expire.c
+++ b/fs/autofs/expire.c
@@ -38,7 +38,7 @@ static int autofs_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 	struct path path = {.mnt = mnt, .dentry = dentry};
 	int status = 1;
 
-	DPRINTK("dentry %p %.*s",
+	DPRINTK("dentry %p %.*s\n",
 		dentry, (int)dentry->d_name.len, dentry->d_name.name);
 
 	path_get(&path);
@@ -65,7 +65,7 @@ static int autofs_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 
 	status = 0;
 done:
-	DPRINTK("returning = %d", status);
+	DPRINTK("returning = %d\n", status);
 	path_put(&path);
 	return status;
 }
@@ -191,7 +191,7 @@ static int autofs_direct_busy(struct vfsmount *mnt,
 			      unsigned long timeout,
 			      int do_now)
 {
-	DPRINTK("top %p %.*s",
+	DPRINTK("top %p %.*s\n",
 		top, (int) top->d_name.len, top->d_name.name);
 
 	/* If it's busy update the expiry counters */
@@ -223,7 +223,7 @@ static int autofs_tree_busy(struct vfsmount *mnt,
 	struct autofs_info *top_ino = autofs_dentry_ino(top);
 	struct dentry *p;
 
-	DPRINTK("top %p %.*s",
+	DPRINTK("top %p %.*s\n",
 		top, (int)top->d_name.len, top->d_name.name);
 
 	/* Negative dentry - give up */
@@ -232,7 +232,7 @@ static int autofs_tree_busy(struct vfsmount *mnt,
 
 	p = NULL;
 	while ((p = get_next_positive_dentry(p, top))) {
-		DPRINTK("dentry %p %.*s",
+		DPRINTK("dentry %p %.*s\n",
 			p, (int) p->d_name.len, p->d_name.name);
 
 		/*
@@ -279,12 +279,12 @@ static struct dentry *autofs_check_leaves(struct vfsmount *mnt,
 {
 	struct dentry *p;
 
-	DPRINTK("parent %p %.*s",
+	DPRINTK("parent %p %.*s\n",
 		parent, (int)parent->d_name.len, parent->d_name.name);
 
 	p = NULL;
 	while ((p = get_next_positive_dentry(p, parent))) {
-		DPRINTK("dentry %p %.*s",
+		DPRINTK("dentry %p %.*s\n",
 			p, (int) p->d_name.len, p->d_name.name);
 
 		if (d_mountpoint(p)) {
@@ -370,7 +370,7 @@ static struct dentry *should_expire(struct dentry *dentry,
 	 *	   offset (autofs-5.0+).
 	 */
 	if (d_mountpoint(dentry)) {
-		DPRINTK("checking mountpoint %p %.*s", dentry,
+		DPRINTK("checking mountpoint %p %.*s\n", dentry,
 			(int) dentry->d_name.len, dentry->d_name.name);
 
 		/* Can we umount this guy */
@@ -384,7 +384,7 @@ static struct dentry *should_expire(struct dentry *dentry,
 	}
 
 	if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
-		DPRINTK("checking symlink %p %.*s",
+		DPRINTK("checking symlink %p %.*s\n",
 			dentry, (int)dentry->d_name.len, dentry->d_name.name);
 		/*
 		 * A symlink can't be "busy" in the usual sense so
@@ -482,7 +482,7 @@ struct dentry *autofs_expire_indirect(struct super_block *sb,
 	return NULL;
 
 found:
-	DPRINTK("returning %p %.*s",
+	DPRINTK("returning %p %.*s\n",
 		expired, (int)expired->d_name.len, expired->d_name.name);
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	smp_mb();
@@ -515,13 +515,13 @@ int autofs_expire_wait(struct dentry *dentry, int rcu_walk)
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
 
-		DPRINTK("waiting for expire %p name=%.*s",
+		DPRINTK("waiting for expire %p name=%.*s\n",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
 		status = autofs_wait(sbi, dentry, NFY_NONE);
 		wait_for_completion(&ino->expire_complete);
 
-		DPRINTK("expire done status=%d", status);
+		DPRINTK("expire done status=%d\n", status);
 
 		if (d_unhashed(dentry))
 			return -EAGAIN;
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index 5012f21..976fd5b 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -61,7 +61,7 @@ void autofs_kill_sb(struct super_block *sb)
 		put_pid(sbi->oz_pgrp);
 	}
 
-	DPRINTK("shutting down");
+	DPRINTK("shutting down\n");
 	kill_litter_super(sb);
 	if (sbi)
 		kfree_rcu(sbi, rcu);
@@ -217,7 +217,7 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
-	DPRINTK("starting up, sbi = %p", sbi);
+	DPRINTK("starting up, sbi = %p\n", sbi);
 
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
@@ -266,14 +266,14 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
 			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
 			  &sbi->max_proto)) {
-		AUTOFS_ERROR("called with bogus options");
+		AUTOFS_ERROR("called with bogus options\n");
 		goto fail_dput;
 	}
 
 	if (pgrp_set) {
 		sbi->oz_pgrp = find_get_pid(pgrp);
 		if (!sbi->oz_pgrp) {
-			AUTOFS_ERROR("could not find process group %d",
+			AUTOFS_ERROR("could not find process group %d\n",
 				pgrp);
 			goto fail_dput;
 		}
@@ -291,7 +291,7 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
 	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
 		AUTOFS_ERROR("kernel does not match daemon version "
-			     "daemon (%d, %d) kernel (%d, %d)",
+			     "daemon (%d, %d) kernel (%d, %d)\n",
 			sbi->min_proto, sbi->max_proto,
 			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
 		goto fail_dput;
@@ -304,11 +304,11 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_nr(sbi->oz_pgrp));
+	DPRINTK("pipe fd = %d, pgrp = %u\n", pipefd, pid_nr(sbi->oz_pgrp));
 	pipe = fget(pipefd);
 
 	if (!pipe) {
-		AUTOFS_ERROR("could not open pipe file descriptor");
+		AUTOFS_ERROR("could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
 	ret = autofs_prepare_pipe(pipe);
@@ -329,7 +329,7 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	 */
 fail_fput:
 	AUTOFS_ERROR(
-		"pipe file descriptor does not contain proper ops");
+		"pipe file descriptor does not contain proper ops\n");
 	fput(pipe);
 	/* fall through */
 fail_dput:
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 8204ef3..0dd77eb 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -109,7 +109,7 @@ static int autofs_dir_open(struct inode *inode, struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs_sbi(dentry->d_sb);
 
-	DPRINTK("file=%p dentry=%p %.*s",
+	DPRINTK("file=%p dentry=%p %.*s\n",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);
 
 	if (autofs_oz_mode(sbi))
@@ -140,7 +140,7 @@ static void autofs_dentry_release(struct dentry *de)
 	struct autofs_info *ino = autofs_dentry_ino(de);
 	struct autofs_sb_info *sbi = autofs_sbi(de->d_sb);
 
-	DPRINTK("releasing %p", de);
+	DPRINTK("releasing %p\n", de);
 
 	if (!ino)
 		return;
@@ -280,10 +280,10 @@ static int autofs_mount_wait(struct dentry *dentry, bool rcu_walk)
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		if (rcu_walk)
 			return -ECHILD;
-		DPRINTK("waiting for mount name=%.*s",
+		DPRINTK("waiting for mount name=%.*s\n",
 			dentry->d_name.len, dentry->d_name.name);
 		status = autofs_wait(sbi, dentry, NFY_MOUNT);
-		DPRINTK("mount wait done status=%d", status);
+		DPRINTK("mount wait done status=%d\n", status);
 	}
 	ino->last_used = jiffies;
 	return status;
@@ -343,7 +343,7 @@ static struct vfsmount *autofs_d_automount(struct path *path)
 	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status;
 
-	DPRINTK("dentry=%p %.*s",
+	DPRINTK("dentry=%p %.*s\n",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	/* The daemon never triggers a mount. */
@@ -431,7 +431,7 @@ static int autofs_d_manage(struct dentry *dentry, bool rcu_walk)
 	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	int status;
 
-	DPRINTK("dentry=%p %.*s",
+	DPRINTK("dentry=%p %.*s\n",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	/* The daemon never waits. */
@@ -509,7 +509,7 @@ static struct dentry *autofs_lookup(struct inode *dir,
 	struct autofs_info *ino;
 	struct dentry *active;
 
-	DPRINTK("name = %.*s", dentry->d_name.len, dentry->d_name.name);
+	DPRINTK("name = %.*s\n", dentry->d_name.len, dentry->d_name.name);
 
 	/* File name too long to exist */
 	if (dentry->d_name.len > NAME_MAX)
@@ -517,7 +517,7 @@ static struct dentry *autofs_lookup(struct inode *dir,
 
 	sbi = autofs_sbi(dir->i_sb);
 
-	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
+	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d\n",
 		current->pid, task_pgrp_nr(current), sbi->catatonic,
 		autofs_oz_mode(sbi));
 
@@ -564,7 +564,7 @@ static int autofs_dir_symlink(struct inode *dir,
 	size_t size = strlen(symname);
 	char *cp;
 
-	DPRINTK("%s <- %.*s", symname,
+	DPRINTK("%s <- %.*s\n", symname,
 		dentry->d_name.len, dentry->d_name.name);
 
 	if (!autofs_oz_mode(sbi))
@@ -705,7 +705,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
-	DPRINTK("dentry %p, removing %.*s",
+	DPRINTK("dentry %p, removing %.*s\n",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	if (!autofs_oz_mode(sbi))
@@ -749,7 +749,7 @@ static int autofs_dir_mkdir(struct inode *dir,
 	if (!autofs_oz_mode(sbi))
 		return -EACCES;
 
-	DPRINTK("dentry %p, creating %.*s",
+	DPRINTK("dentry %p, creating %.*s\n",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	BUG_ON(!ino);
@@ -840,7 +840,7 @@ static inline int autofs_ask_umount(struct vfsmount *mnt, int __user *p)
 	if (may_umount(mnt))
 		status = 1;
 
-	DPRINTK("returning %d", status);
+	DPRINTK("returning %d\n", status);
 
 	status = put_user(status, p);
 
@@ -868,7 +868,7 @@ static int autofs_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;
 
-	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
+	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",
 		cmd, arg, sbi, task_pgrp_nr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index 0fb2791..26d5e5e 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -31,7 +31,7 @@ void autofs_catatonic_mode(struct autofs_sb_info *sbi)
 		return;
 	}
 
-	DPRINTK("entering catatonic mode");
+	DPRINTK("entering catatonic mode\n");
 
 	sbi->catatonic = 1;
 	wq = sbi->queues;
@@ -99,7 +99,7 @@ static void autofs_notify_daemon(struct autofs_sb_info *sbi,
 	struct file *pipe = NULL;
 	size_t pktsz;
 
-	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
+	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d\n",
 		(unsigned long) wq->wait_queue_token,
 		wq->name.len, wq->name.name, type);
 
@@ -162,7 +162,7 @@ static void autofs_notify_daemon(struct autofs_sb_info *sbi,
 		break;
 	}
 	default:
-		AUTOFS_WARN("bad type %d!", type);
+		AUTOFS_WARN("bad type %d!\n", type);
 		mutex_unlock(&sbi->wq_mutex);
 		return;
 	}
@@ -460,7 +460,7 @@ int autofs_wait(struct autofs_sb_info *sbi,
 		autofs_notify_daemon(sbi, wq, type);
 	} else {
 		wq->wait_ctr++;
-		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
+		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d\n",
 			(unsigned long) wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 		mutex_unlock(&sbi->wq_mutex);
@@ -489,7 +489,7 @@ int autofs_wait(struct autofs_sb_info *sbi,
 		recalc_sigpending();
 		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 	} else {
-		DPRINTK("skipped sleeping");
+		DPRINTK("skipped sleeping\n");
 	}
 
 	status = wq->status;

