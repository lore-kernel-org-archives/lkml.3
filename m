Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaJOXRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:17:49 -0400
Received: from mx1.riseup.net ([198.252.153.129]:43278 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJOXRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:17:47 -0400
From: Albino Biasutti Neto <bino@riseup.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Change for codestyle and good read
Date: Wed, 15 Oct 2014 20:15:42 -0300
Message-Id: <1413414942-5338-1-git-send-email-bino@riseup.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/ext4/mmp.c |  4 +--
 fs/open.c     | 95 +++++++++++++++++++++--------------------------------------
 kernel/exit.c |  4 +--
 3 files changed, 37 insertions(+), 66 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 32bce84..906ee33 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -20,8 +20,8 @@ static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
 
 static int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
 {
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, 
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		return 1;
 
 	return mmp->mmp_checksum == ext4_mmp_csum(sb, mmp);
diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..656bf29 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -71,10 +71,8 @@ long vfs_truncate(struct path *path, loff_t length)
 	inode = path->dentry->d_inode;
 
 	/* For directories it's -EISDIR, for other non-regulars - -EINVAL */
-	if (S_ISDIR(inode->i_mode))
+	if ((S_ISDIR(inode->i_mode)) && (!S_ISREG(inode->i_mode)))
 		return -EISDIR;
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
 
 	error = mnt_want_write(path->mnt);
 	if (error)
@@ -137,14 +135,13 @@ retry:
 	return error;
 }
 
-SYSCALL_DEFINE2(truncate, const char __user *, path, long, length)
-{
+SYSCALL_DEFINE2(truncate, const char __user *, path, long, length) {
 	return do_sys_truncate(path, length);
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length)
-{
+COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, 
+		length) {
 	return do_sys_truncate(path, length);
 }
 #endif
@@ -190,38 +187,34 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (!error)
 		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, f.file);
 	sb_end_write(inode->i_sb);
+
 out_putf:
 	fdput(f);
 out:
 	return error;
 }
 
-SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
-{
+SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length) {
 	return do_sys_ftruncate(fd, length, 1);
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(ftruncate, unsigned int, fd, compat_ulong_t, length)
-{
+COMPAT_SYSCALL_DEFINE2(ftruncate, unsigned int, fd, compat_ulong_t, length) {
 	return do_sys_ftruncate(fd, length, 1);
 }
 #endif
 
 /* LFS versions of truncate are only needed on 32 bit machines */
 #if BITS_PER_LONG == 32
-SYSCALL_DEFINE2(truncate64, const char __user *, path, loff_t, length)
-{
+SYSCALL_DEFINE2(truncate64, const char __user *, path, loff_t, length) {
 	return do_sys_truncate(path, length);
 }
 
-SYSCALL_DEFINE2(ftruncate64, unsigned int, fd, loff_t, length)
-{
+SYSCALL_DEFINE2(ftruncate64, unsigned int, fd, loff_t, length) {
 	return do_sys_ftruncate(fd, length, 0);
 }
 #endif /* BITS_PER_LONG == 32 */
 
-
 int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
@@ -392,13 +385,11 @@ out:
 	return res;
 }
 
-SYSCALL_DEFINE2(access, const char __user *, filename, int, mode)
-{
+SYSCALL_DEFINE2(access, const char __user *, filename, int, mode) {
 	return sys_faccessat(AT_FDCWD, filename, mode);
 }
 
-SYSCALL_DEFINE1(chdir, const char __user *, filename)
-{
+SYSCALL_DEFINE1(chdir, const char __user *, filename) {
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
@@ -423,8 +414,7 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE1(fchdir, unsigned int, fd)
-{
+SYSCALL_DEFINE1(fchdir, unsigned int, fd) {
 	struct fd f = fdget_raw(fd);
 	struct inode *inode;
 	int error = -EBADF;
@@ -448,8 +438,7 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE1(chroot, const char __user *, filename)
-{
+SYSCALL_DEFINE1(chroot, const char __user *, filename) {
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
@@ -481,8 +470,7 @@ out:
 	return error;
 }
 
-static int chmod_common(struct path *path, umode_t mode)
-{
+static int chmod_common(struct path *path, umode_t mode) {
 	struct inode *inode = path->dentry->d_inode;
 	struct inode *delegated_inode = NULL;
 	struct iattr newattrs;
@@ -510,8 +498,7 @@ out_unlock:
 	return error;
 }
 
-SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
-{
+SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode) {
 	struct fd f = fdget(fd);
 	int err = -EBADF;
 
@@ -523,8 +510,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 	return err;
 }
 
-SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode)
-{
+SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode) {
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
@@ -541,13 +527,11 @@ retry:
 	return error;
 }
 
-SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
-{
+SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode) {
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(struct path *path, uid_t user, gid_t group)
-{
+static int chown_common(struct path *path, uid_t user, gid_t group) {
 	struct inode *inode = path->dentry->d_inode;
 	struct inode *delegated_inode = NULL;
 	int error;
@@ -620,19 +604,16 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE3(chown, const char __user *, filename, uid_t, user, gid_t, group)
-{
+SYSCALL_DEFINE3(chown, const char __user *, filename, uid_t, user, gid_t, group) {
 	return sys_fchownat(AT_FDCWD, filename, user, group, 0);
 }
 
-SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group)
-{
+SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group) {
 	return sys_fchownat(AT_FDCWD, filename, user, group,
 			    AT_SYMLINK_NOFOLLOW);
 }
 
-SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
-{
+SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group) {
 	struct fd f = fdget(fd);
 	int error = -EBADF;
 
@@ -651,8 +632,7 @@ out:
 	return error;
 }
 
-int open_check_o_direct(struct file *f)
-{
+int open_check_o_direct(struct file *f) {
 	/* NB: we're sure to have correct a_ops only after f_op->open */
 	if (f->f_flags & O_DIRECT) {
 		if (!f->f_mapping->a_ops ||
@@ -802,8 +782,7 @@ EXPORT_SYMBOL(finish_open);
  * Returns "1" which must be the return value of ->atomic_open() after having
  * called this function.
  */
-int finish_no_open(struct file *file, struct dentry *dentry)
-{
+int finish_no_open(struct file *file, struct dentry *dentry) {
 	file->f_path.dentry = dentry;
 	return 1;
 }
@@ -841,7 +820,8 @@ struct file *dentry_open(const struct path *path, int flags,
 }
 EXPORT_SYMBOL(dentry_open);
 
-static inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
+static inline int build_open_flags(int flags, umode_t mode, 
+		struct open_flags *op) 
 {
 	int lookup_flags = 0;
 	int acc_mode;
@@ -920,8 +900,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
  * have to.  But in generally you should not do this, so please move
  * along, nothing to see here..
  */
-struct file *file_open_name(struct filename *name, int flags, umode_t mode)
-{
+struct file *file_open_name(struct filename *name, int flags, umode_t mode) {
 	struct open_flags op;
 	int err = build_open_flags(flags, mode, &op);
 	return err ? ERR_PTR(err) : do_filp_open(AT_FDCWD, name, &op);
@@ -938,8 +917,7 @@ struct file *file_open_name(struct filename *name, int flags, umode_t mode)
  * have to.  But in generally you should not do this, so please move
  * along, nothing to see here..
  */
-struct file *filp_open(const char *filename, int flags, umode_t mode)
-{
+struct file *filp_open(const char *filename, int flags, umode_t mode) {
 	struct filename name = {.name = filename};
 	return file_open_name(&name, flags, mode);
 }
@@ -1012,19 +990,16 @@ SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
  * For backward compatibility?  Maybe this should be moved
  * into arch/i386 instead?
  */
-SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode)
-{
+SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode) {
 	return sys_open(pathname, O_CREAT | O_WRONLY | O_TRUNC, mode);
 }
-
 #endif
 
 /*
  * "id" is the POSIX thread ID. We use the
  * files pointer for this..
  */
-int filp_close(struct file *filp, fl_owner_t id)
-{
+int filp_close(struct file *filp, fl_owner_t id) {
 	int retval = 0;
 
 	if (!file_count(filp)) {
@@ -1050,8 +1025,7 @@ EXPORT_SYMBOL(filp_close);
  * releasing the fd. This ensures that one clone task can't release
  * an fd while another clone is opening it.
  */
-SYSCALL_DEFINE1(close, unsigned int, fd)
-{
+SYSCALL_DEFINE1(close, unsigned int, fd) {
 	int retval = __close_fd(current->files, fd);
 
 	/* can't restart close syscall because file table entry was cleared */
@@ -1069,8 +1043,7 @@ EXPORT_SYMBOL(sys_close);
  * This routine simulates a hangup on the tty, to arrange that users
  * are given clean terminals at login time.
  */
-SYSCALL_DEFINE0(vhangup)
-{
+SYSCALL_DEFINE0(vhangup) {
 	if (capable(CAP_SYS_TTY_CONFIG)) {
 		tty_vhangup_self();
 		return 0;
@@ -1084,8 +1057,7 @@ SYSCALL_DEFINE0(vhangup)
  * the caller didn't specify O_LARGEFILE.  On 64bit systems we force
  * on this flag in sys_open.
  */
-int generic_file_open(struct inode * inode, struct file * filp)
-{
+int generic_file_open(struct inode * inode, struct file * filp) {
 	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EOVERFLOW;
 	return 0;
@@ -1099,8 +1071,7 @@ EXPORT_SYMBOL(generic_file_open);
  * reason it returns an 'int' and not 'void' is so that it can be plugged
  * directly into file_operations structure.
  */
-int nonseekable_open(struct inode *inode, struct file *filp)
-{
+int nonseekable_open(struct inode *inode, struct file *filp) {
 	filp->f_mode &= ~(FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
 	return 0;
 }
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..f429fdd 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -78,8 +78,8 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 }
 
 /*
- * This function expects the tasklist_lock write-locked.
- */
+ * This function expects the tasklist_lock write-locked. 
+*/
 static void __exit_signal(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
-- 
1.9.1

