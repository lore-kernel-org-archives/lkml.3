Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaF2AVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 20:21:13 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:46631 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751989AbaF2AUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 20:20:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:69:327:355:379:541:960:966:968:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:1981:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2731:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4385:4605:5007:6261:6299:7875:7903:8603:9592:10004:10026:10848:11026:11914:12043:12291:12296:12438:12517:12519:12555:12683:13142:13230:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wrist68_21aca4bcca415
X-Filterd-Recvd-Size: 31003
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] fs.h: A few more whitespace neatenings
Date: Sat, 28 Jun 2014 17:20:15 -0700
Message-Id: <a48497d0a9a668f60fd0beb8199058ad757ffa09.1403999769.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403999769.git.joe@perches.com>
References: <cover.1403999769.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some line removals and line wrapping to 80 columns along
with few trivial other whitespace changes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/fs.h | 257 +++++++++++++++++++++++++++--------------------------
 1 file changed, 133 insertions(+), 124 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a3e748e..8a9e7f8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_FS_H
 #define _LINUX_FS_H
 
-
 #include <linux/linkage.h>
 #include <linux/wait.h>
 #include <linux/kdev_t.h>
@@ -412,25 +411,25 @@ struct request_queue;
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
 	int			bd_openers;
-	struct inode *		bd_inode;	/* will die */
-	struct super_block *	bd_super;
+	struct inode		*bd_inode;	/* will die */
+	struct super_block	*bd_super;
 	struct mutex		bd_mutex;	/* open/close mutex */
 	struct list_head	bd_inodes;
-	void *			bd_claiming;
-	void *			bd_holder;
+	void			*bd_claiming;
+	void			*bd_holder;
 	int			bd_holders;
 	bool			bd_write_holder;
 #ifdef CONFIG_SYSFS
 	struct list_head	bd_holder_disks;
 #endif
-	struct block_device *	bd_contains;
+	struct block_device	*bd_contains;
 	unsigned		bd_block_size;
-	struct hd_struct *	bd_part;
+	struct hd_struct	*bd_part;
 	/* number of times partitions within this device have been opened. */
 	unsigned		bd_part_count;
 	int			bd_invalidated;
-	struct gendisk *	bd_disk;
-	struct request_queue *  bd_queue;
+	struct gendisk		*bd_disk;
+	struct request_queue	*bd_queue;
 	struct list_head	bd_list;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
@@ -461,8 +460,8 @@ int mapping_tagged(struct address_space *mapping, int tag);
  */
 static inline int mapping_mapped(struct address_space *mapping)
 {
-	return	!RB_EMPTY_ROOT(&mapping->i_mmap) ||
-		!list_empty(&mapping->i_mmap_nonlinear);
+	return !RB_EMPTY_ROOT(&mapping->i_mmap) ||
+	       !list_empty(&mapping->i_mmap_nonlinear);
 }
 
 /*
@@ -609,8 +608,7 @@ static inline int inode_unhashed(struct inode *inode)
  * The locking order between these classes is
  * parent -> child -> normal -> xattr -> second non-directory
  */
-enum inode_i_mutex_lock_class
-{
+enum inode_i_mutex_lock_class {
 	I_MUTEX_NORMAL,
 	I_MUTEX_PARENT,
 	I_MUTEX_CHILD,
@@ -803,7 +801,7 @@ static inline struct file *get_file(struct file *f)
 /* Page cache limit. The filesystems should put that into their s_maxbytes
    limits, otherwise bad things can happen in VM. */
 #if BITS_PER_LONG == 32
-#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1)
+#define MAX_LFS_FILESIZE	(((loff_t)PAGE_CACHE_SIZE << (BITS_PER_LONG - 1)) - 1)
 #elif BITS_PER_LONG == 64
 #define MAX_LFS_FILESIZE	((loff_t)0x7fffffffffffffffLL)
 #endif
@@ -894,7 +892,7 @@ struct file_lock {
 	loff_t fl_start;
 	loff_t fl_end;
 
-	struct fasync_struct *	fl_fasync; /* for lease break notifications */
+	struct fasync_struct *fl_fasync; /* for lease break notifications */
 	/* for lease breaks: */
 	unsigned long fl_break_time;
 	unsigned long fl_downgrade_time;
@@ -939,7 +937,7 @@ int fcntl_getlease(struct file *filp);
 /* fs/locks.c */
 void locks_free_lock(struct file_lock *fl);
 void locks_init_lock(struct file_lock *);
-struct file_lock * locks_alloc_lock(void);
+struct file_lock *locks_alloc_lock(void);
 void locks_copy_lock(struct file_lock *, struct file_lock *);
 void __locks_copy_lock(struct file_lock *, const struct file_lock *);
 void locks_remove_posix(struct file *, fl_owner_t);
@@ -950,7 +948,8 @@ int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
 int posix_lock_file_wait(struct file *, struct file_lock *);
 int posix_unblock_lock(struct file_lock *);
 int vfs_test_lock(struct file *, struct file_lock *);
-int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
+int vfs_lock_file(struct file *, unsigned int, struct file_lock *,
+		  struct file_lock *);
 int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
 int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
@@ -998,32 +997,26 @@ static inline int fcntl_getlease(struct file *filp)
 
 static inline void locks_init_lock(struct file_lock *fl)
 {
-	return;
 }
 
 static inline void __locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 {
-	return;
 }
 
 static inline void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 {
-	return;
 }
 
 static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
 {
-	return;
 }
 
 static inline void locks_remove_file(struct file *filp)
 {
-	return;
 }
 
 static inline void posix_test_lock(struct file *filp, struct file_lock *fl)
 {
-	return;
 }
 
 static inline int posix_lock_file(struct file *filp, struct file_lock *fl,
@@ -1064,14 +1057,14 @@ static inline int flock_lock_file_wait(struct file *filp,
 	return -ENOLCK;
 }
 
-static inline int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
+static inline int __break_lease(struct inode *inode, unsigned int mode,
+				unsigned int type)
 {
 	return 0;
 }
 
 static inline void lease_get_mtime(struct inode *inode, struct timespec *time)
 {
-	return;
 }
 
 static inline int generic_setlease(struct file *filp, long arg,
@@ -1104,7 +1097,6 @@ static inline int lock_may_write(struct inode *inode, loff_t start,
 }
 #endif /* !CONFIG_FILE_LOCKING */
 
-
 struct fasync_struct {
 	spinlock_t		fa_lock;
 	int			magic;
@@ -1118,7 +1110,9 @@ struct fasync_struct {
 
 /* SMP safe fasync helpers: */
 int fasync_helper(int, struct file *, int, struct fasync_struct **);
-struct fasync_struct *fasync_insert_entry(int, struct file *, struct fasync_struct **, struct fasync_struct *);
+struct fasync_struct *fasync_insert_entry(int, struct file *,
+					  struct fasync_struct **,
+					  struct fasync_struct *);
 int fasync_remove_entry(struct file *, struct fasync_struct **);
 struct fasync_struct *fasync_alloc(void);
 void fasync_free(struct fasync_struct *);
@@ -1376,7 +1370,6 @@ static inline void sb_start_intwrite(struct super_block *sb)
 	__sb_start_write(sb, SB_FREEZE_FS, true);
 }
 
-
 bool inode_owner_or_capable(const struct inode *inode);
 
 /*
@@ -1389,7 +1382,8 @@ int vfs_symlink(struct inode *, struct dentry *, const char *);
 int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
 int vfs_rmdir(struct inode *, struct dentry *);
 int vfs_unlink(struct inode *, struct dentry *, struct inode **);
-int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
+int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *,
+	       struct inode **, unsigned int);
 
 /*
  * VFS dentry helper functions.
@@ -1458,8 +1452,10 @@ struct file_operations {
 	loff_t (*llseek)(struct file *, loff_t, int);
 	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
-	ssize_t (*aio_read)(struct kiocb *, const struct iovec *, unsigned long, loff_t);
-	ssize_t (*aio_write)(struct kiocb *, const struct iovec *, unsigned long, loff_t);
+	ssize_t (*aio_read)(struct kiocb *, const struct iovec *,
+			    unsigned long, loff_t);
+	ssize_t (*aio_write)(struct kiocb *, const struct iovec *,
+			     unsigned long, loff_t);
 	ssize_t (*read_iter)(struct kiocb *, struct iov_iter *);
 	ssize_t (*write_iter)(struct kiocb *, struct iov_iter *);
 	int (*iterate)(struct file *, struct dir_context *);
@@ -1474,12 +1470,17 @@ struct file_operations {
 	int (*aio_fsync)(struct kiocb *, int datasync);
 	int (*fasync)(int, struct file *, int);
 	int (*lock)(struct file *, int, struct file_lock *);
-	ssize_t (*sendpage)(struct file *, struct page *, int, size_t, loff_t *, int);
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	ssize_t (*sendpage)(struct file *, struct page *, int, size_t,
+			    loff_t *, int);
+	unsigned long (*get_unmapped_area)(struct file *, unsigned long,
+					   unsigned long, unsigned long,
+					   unsigned long);
 	int (*check_flags)(int);
 	int (*flock)(struct file *, int, struct file_lock *);
-	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
-	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
+	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *,
+				loff_t *, size_t, unsigned int);
+	ssize_t (*splice_read)(struct file *, loff_t *,
+			       struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
@@ -1487,10 +1488,10 @@ struct file_operations {
 };
 
 struct inode_operations {
-	struct dentry * (*lookup)(struct inode *, struct dentry *, unsigned int);
-	void * (*follow_link)(struct dentry *, struct nameidata *);
+	struct dentry *(*lookup)(struct inode *, struct dentry *, unsigned int);
+	void *(*follow_link)(struct dentry *, struct nameidata *);
 	int (*permission)(struct inode *, int);
-	struct posix_acl *(*get_acl)(struct inode *, int);
+	struct posix_acl * (*get_acl)(struct inode *, int);
 
 	int (*readlink)(struct dentry *, char __user *, int);
 	void (*put_link)(struct dentry *, struct nameidata *, void *);
@@ -1508,7 +1509,8 @@ struct inode_operations {
 		       struct inode *, struct dentry *, unsigned int);
 	int (*setattr)(struct dentry *, struct iattr *);
 	int (*getattr)(struct vfsmount *mnt, struct dentry *, struct kstat *);
-	int (*setxattr)(struct dentry *, const char *, const void *, size_t, int);
+	int (*setxattr)(struct dentry *, const char *, const void *, size_t,
+			int);
 	ssize_t (*getxattr)(struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr)(struct dentry *, char *, size_t);
 	int (*removexattr)(struct dentry *, const char *);
@@ -1522,17 +1524,17 @@ struct inode_operations {
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
 } ____cacheline_aligned;
 
-ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
+ssize_t rw_copy_check_uvector(int type, const struct iovec __user *uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
 			      struct iovec **ret_pointer);
 
 ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
-ssize_t vfs_readv(struct file *, const struct iovec __user *,
-		  unsigned long, loff_t *);
-ssize_t vfs_writev(struct file *, const struct iovec __user *,
-		   unsigned long, loff_t *);
+ssize_t vfs_readv(struct file *, const struct iovec __user *, unsigned long,
+		  loff_t *);
+ssize_t vfs_writev(struct file *, const struct iovec __user *, unsigned long,
+		   loff_t *);
 
 struct super_operations {
 	struct inode *(*alloc_inode)(struct super_block *sb);
@@ -1555,8 +1557,10 @@ struct super_operations {
 	int (*show_path)(struct seq_file *, struct dentry *);
 	int (*show_stats)(struct seq_file *, struct dentry *);
 #ifdef CONFIG_QUOTA
-	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
-	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+	ssize_t (*quota_read)(struct super_block *, int, char *, size_t,
+			      loff_t);
+	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t,
+			       loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	long (*nr_cached_objects)(struct super_block *, int);
@@ -1760,7 +1764,7 @@ struct file_system_type {
 				const char *, void *);
 	void (*kill_sb)(struct super_block *);
 	struct module *owner;
-	struct file_system_type * next;
+	struct file_system_type *next;
 	struct hlist_head fs_supers;
 
 	struct lock_class_key s_lock_key;
@@ -1776,7 +1780,8 @@ struct file_system_type {
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)
 
 struct dentry *mount_ns(struct file_system_type *fs_type, int flags,
-			void *data, int (*fill_super)(struct super_block *, void *, int));
+			void *data,
+			int (*fill_super)(struct super_block *, void *, int));
 struct dentry *mount_bdev(struct file_system_type *fs_type,
 			  int flags, const char *dev_name, void *data,
 			  int (*fill_super)(struct super_block *, void *, int));
@@ -1808,7 +1813,7 @@ struct dentry *mount_pseudo(struct file_system_type *, char *,
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops)							\
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-#define fops_put(fops)						\
+#define fops_put(fops)							\
 	do { if (fops) module_put((fops)->owner); } while (0)
 /*
  * This one is to be used *ONLY* from ->open() instances.
@@ -1845,7 +1850,7 @@ bool fs_fully_visible(struct file_system_type *);
 
 int current_umask(void);
 
-void ihold(struct inode * inode);
+void ihold(struct inode *inode);
 void iput(struct inode *);
 
 static inline struct inode *file_inode(struct file *f)
@@ -1932,7 +1937,8 @@ static inline int break_deleg(struct inode *inode, unsigned int mode)
 	return 0;
 }
 
-static inline int try_break_deleg(struct inode *inode, struct inode **delegated_inode)
+static inline int try_break_deleg(struct inode *inode,
+				  struct inode **delegated_inode)
 {
 	int ret;
 
@@ -1998,7 +2004,8 @@ static inline int break_deleg(struct inode *inode, unsigned int mode)
 	return 0;
 }
 
-static inline int try_break_deleg(struct inode *inode, struct inode **delegated_inode)
+static inline int try_break_deleg(struct inode *inode,
+				  struct inode **delegated_inode)
 {
 	return 0;
 }
@@ -2023,15 +2030,13 @@ struct filename {
 long vfs_truncate(struct path *, loff_t);
 int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		struct file *filp);
-int do_fallocate(struct file *file, int mode, loff_t offset,
-		 loff_t len);
-long do_sys_open(int dfd, const char __user *filename, int flags,
-		 umode_t mode);
+int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len);
+long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode);
 struct file *file_open_name(struct filename *, int, umode_t);
 struct file *filp_open(const char *, int, umode_t);
-struct file *file_open_root(struct dentry *, struct vfsmount *,
-			    const char *, int);
-struct file * dentry_open(const struct path *, int, const struct cred *);
+struct file *file_open_root(struct dentry *, struct vfsmount *, const char *,
+			    int);
+struct file *dentry_open(const struct path *, int, const struct cred *);
 int filp_close(struct file *, fl_owner_t id);
 
 struct filename *getname(const char __user *);
@@ -2042,8 +2047,7 @@ enum {
 	FILE_OPENED = 2
 };
 int finish_open(struct file *file, struct dentry *dentry,
-		int (*open)(struct inode *, struct file *),
-		int *opened);
+		int (*open)(struct inode *, struct file *), int *opened);
 int finish_no_open(struct file *file, struct dentry *dentry);
 
 /* fs/ioctl.c */
@@ -2124,8 +2128,7 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode,
 void blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
-void bd_unlink_disk_holder(struct block_device *bdev,
-			   struct gendisk *disk);
+void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
@@ -2194,8 +2197,7 @@ int is_bad_inode(struct inode *);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
-void check_disk_size_change(struct gendisk *disk,
-			    struct block_device *bdev);
+void check_disk_size_change(struct gendisk *disk, struct block_device *bdev);
 int revalidate_disk(struct gendisk *);
 int check_disk_change(struct block_device *);
 int __invalidate_device(struct block_device *, bool);
@@ -2217,8 +2219,7 @@ int write_inode_now(struct inode *, int);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
 int filemap_fdatawait(struct address_space *);
-int filemap_fdatawait_range(struct address_space *, loff_t lstart,
-			    loff_t lend);
+int filemap_fdatawait_range(struct address_space *, loff_t lstart, loff_t lend);
 int filemap_write_and_wait(struct address_space *mapping);
 int filemap_write_and_wait_range(struct address_space *mapping,
 				 loff_t lstart, loff_t lend);
@@ -2227,8 +2228,7 @@ int __filemap_fdatawrite_range(struct address_space *mapping,
 int filemap_fdatawrite_range(struct address_space *mapping,
 			     loff_t start, loff_t end);
 
-int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
-		    int datasync);
+int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync);
 int vfs_fsync(struct file *file, int datasync);
 static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
 {
@@ -2297,7 +2297,7 @@ static inline int deny_write_access(struct file *file)
 	struct inode *inode = file_inode(file);
 	return atomic_dec_unless_positive(&inode->i_writecount) ? 0 : -ETXTBSY;
 }
-static inline void put_write_access(struct inode * inode)
+static inline void put_write_access(struct inode *inode)
 {
 	atomic_dec(&inode->i_writecount);
 }
@@ -2324,18 +2324,16 @@ static inline void i_readcount_inc(struct inode *inode)
 #else
 static inline void i_readcount_dec(struct inode *inode)
 {
-	return;
 }
 static inline void i_readcount_inc(struct inode *inode)
 {
-	return;
 }
 #endif
 int do_pipe_flags(int *, int);
 
 int kernel_read(struct file *, loff_t, char *, unsigned long);
 ssize_t kernel_write(struct file *, const char *, size_t, loff_t);
-struct file * open_exec(const char *);
+struct file *open_exec(const char *);
 
 /* fs/dcache.c -- generic fs support functions */
 int is_subdir(struct dentry *, struct dentry *);
@@ -2351,7 +2349,7 @@ loff_t vfs_llseek(struct file *file, loff_t offset, int whence);
 int inode_init_always(struct super_block *, struct inode *);
 void inode_init_once(struct inode *);
 void address_space_init_once(struct address_space *mapping);
-struct inode * igrab(struct inode *);
+struct inode *igrab(struct inode *);
 ino_t iunique(struct super_block *, ino_t);
 int inode_needs_sync(struct inode *inode);
 int generic_delete_inode(struct inode *inode);
@@ -2360,16 +2358,18 @@ static inline int generic_drop_inode(struct inode *inode)
 	return !inode->i_nlink || inode_unhashed(inode);
 }
 
-struct inode *ilookup5_nowait(struct super_block *sb,
-			      unsigned long hashval, int (*test)(struct inode *, void *),
-			      void *data);
+struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
+			      int (*test)(struct inode *, void *), void *data);
 struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		       int (*test)(struct inode *, void *), void *data);
 struct inode *ilookup(struct super_block *sb, unsigned long ino);
 
-struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
-struct inode * iget_locked(struct super_block *, unsigned long);
-int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
+struct inode *iget5_locked(struct super_block *, unsigned long,
+			   int (*test)(struct inode *, void *),
+			   int (*set)(struct inode *, void *), void *);
+struct inode *iget_locked(struct super_block *, unsigned long);
+int insert_inode_locked4(struct inode *, unsigned long,
+			 int (*test)(struct inode *, void *), void *);
 int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void lockdep_annotate_inode_mutex_key(struct inode *inode);
@@ -2379,7 +2379,7 @@ static inline void lockdep_annotate_inode_mutex_key(struct inode *inode) { };
 void unlock_new_inode(struct inode *);
 unsigned int get_next_ino(void);
 
-void __iget(struct inode * inode);
+void __iget(struct inode *inode);
 void iget_failed(struct inode *);
 void clear_inode(struct inode *);
 void __destroy_inode(struct inode *);
@@ -2415,57 +2415,64 @@ int sb_min_blocksize(struct super_block *, int);
 int generic_file_mmap(struct file *, struct vm_area_struct *);
 int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 static inline int generic_file_remap_pages(struct vm_area_struct *vma,
-					   unsigned long addr, unsigned long size, pgoff_t pgoff)
+					   unsigned long addr,
+					   unsigned long size, pgoff_t pgoff)
 {
 	BUG();
 	return 0;
 }
-int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
+int generic_write_checks(struct file *file, loff_t *pos, size_t *count,
+			 int isblk);
 ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
 ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *, loff_t);
 ssize_t generic_perform_write(struct file *, struct iov_iter *, loff_t);
-ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
-ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
-ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
-ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
+ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len,
+		     loff_t *ppos);
+ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len,
+		      loff_t *ppos);
+ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len,
+		      loff_t *ppos);
+ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len,
+		       loff_t *ppos);
 
 /* fs/block_dev.c */
 ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from);
-int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
-		 int datasync);
+int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync);
 void block_sync_page(struct page *page);
 
 /* fs/splice.c */
 ssize_t generic_file_splice_read(struct file *, loff_t *,
-				 struct pipe_inode_info *, size_t, unsigned int);
+				 struct pipe_inode_info *, size_t,
+				 unsigned int);
 ssize_t default_file_splice_read(struct file *, loff_t *,
-				 struct pipe_inode_info *, size_t, unsigned int);
-ssize_t iter_file_splice_write(struct pipe_inode_info *,
-			       struct file *, loff_t *, size_t, unsigned int);
-ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
-				struct file *out, loff_t *, size_t len, unsigned int flags);
-
-void
-file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
+				 struct pipe_inode_info *, size_t,
+				 unsigned int);
+ssize_t iter_file_splice_write(struct pipe_inode_info *, struct file *,
+			       loff_t *, size_t, unsigned int);
+ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
+				loff_t *, size_t len, unsigned int flags);
+
+void file_ra_state_init(struct file_ra_state *ra,
+			struct address_space *mapping);
 loff_t noop_llseek(struct file *file, loff_t offset, int whence);
 loff_t no_llseek(struct file *file, loff_t offset, int whence);
 loff_t vfs_setpos(struct file *file, loff_t offset, loff_t maxsize);
 loff_t generic_file_llseek(struct file *file, loff_t offset, int whence);
-loff_t generic_file_llseek_size(struct file *file, loff_t offset,
-				int whence, loff_t maxsize, loff_t eof);
-loff_t fixed_size_llseek(struct file *file, loff_t offset,
-			 int whence, loff_t size);
-int generic_file_open(struct inode * inode, struct file * filp);
-int nonseekable_open(struct inode * inode, struct file * filp);
+loff_t generic_file_llseek_size(struct file *file, loff_t offset, int whence,
+				loff_t maxsize, loff_t eof);
+loff_t fixed_size_llseek(struct file *file, loff_t offset, int whence,
+			 loff_t size);
+int generic_file_open(struct inode *inode, struct file *filp);
+int nonseekable_open(struct inode *inode, struct file *filp);
 
 #ifdef CONFIG_FS_XIP
 ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
 		      loff_t *ppos);
-int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
-ssize_t xip_file_write(struct file *filp, const char __user *buf,
-		       size_t len, loff_t *ppos);
+int xip_file_mmap(struct file *file, struct vm_area_struct *vma);
+ssize_t xip_file_write(struct file *filp, const char __user *buf, size_t len,
+		       loff_t *ppos);
 int xip_truncate_page(struct address_space *mapping, loff_t from);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
@@ -2492,12 +2499,14 @@ enum {
 void dio_end_io(struct bio *bio, int error);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-			     struct block_device *bdev, struct iov_iter *iter, loff_t offset,
-			     get_block_t get_block, dio_iodone_t end_io,
-			     dio_submit_t submit_io,	int flags);
+			     struct block_device *bdev, struct iov_iter *iter,
+			     loff_t offset, get_block_t get_block,
+			     dio_iodone_t end_io, dio_submit_t submit_io,
+			     int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-					 struct inode *inode, struct iov_iter *iter, loff_t offset,
+					 struct inode *inode,
+					 struct iov_iter *iter, loff_t offset,
 					 get_block_t get_block)
 {
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
@@ -2520,8 +2529,7 @@ int readlink_copy(char __user *, int, const char *);
 int page_readlink(struct dentry *, char __user *, int);
 void *page_follow_link_light(struct dentry *, struct nameidata *);
 void page_put_link(struct dentry *, struct nameidata *, void *);
-int __page_symlink(struct inode *inode, const char *symname, int len,
-		   int nofs);
+int __page_symlink(struct inode *inode, const char *symname, int len, int nofs);
 int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
 void kfree_put_link(struct dentry *, struct nameidata *, void *);
@@ -2548,11 +2556,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		 unsigned long arg);
 int __generic_block_fiemap(struct inode *inode,
 			   struct fiemap_extent_info *fieinfo,
-			   loff_t start, loff_t len,
-			   get_block_t *get_block);
+			   loff_t start, loff_t len, get_block_t *get_block);
 int generic_block_fiemap(struct inode *inode,
-			 struct fiemap_extent_info *fieinfo, u64 start,
-			 u64 len, get_block_t *get_block);
+			 struct fiemap_extent_info *fieinfo,
+			 u64 start, u64 len, get_block_t *get_block);
 
 void get_filesystem(struct file_system_type *fs);
 void put_filesystem(struct file_system_type *fs);
@@ -2576,7 +2583,8 @@ int simple_open(struct inode *inode, struct file *file);
 int simple_link(struct dentry *, struct inode *, struct dentry *);
 int simple_unlink(struct inode *, struct dentry *);
 int simple_rmdir(struct inode *, struct dentry *);
-int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+int simple_rename(struct inode *, struct dentry *, struct inode *,
+		  struct dentry *);
 int noop_fsync(struct file *, loff_t, loff_t, int);
 int simple_empty(struct dentry *);
 int simple_readpage(struct file *file, struct page *page);
@@ -2590,18 +2598,20 @@ int always_delete_dentry(const struct dentry *);
 struct inode *alloc_anon_inode(struct super_block *);
 extern const struct dentry_operations simple_dentry_operations;
 
-struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned int flags);
+struct dentry *simple_lookup(struct inode *, struct dentry *,
+			     unsigned int flags);
 ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
 int simple_fill_super(struct super_block *, unsigned long, struct tree_descr *);
-int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
+int simple_pin_fs(struct file_system_type *, struct vfsmount **mount,
+		  int *count);
 void simple_release_fs(struct vfsmount **mount, int *count);
 
-ssize_t simple_read_from_buffer(void __user *to, size_t count,
-				loff_t *ppos, const void *from, size_t available);
+ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
+				const void *from, size_t available);
 ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 			       const void __user *from, size_t count);
 
@@ -2611,8 +2621,7 @@ int generic_file_fsync(struct file *, loff_t, loff_t, int);
 int generic_check_addressable(unsigned, u64);
 
 #ifdef CONFIG_MIGRATION
-int buffer_migrate_page(struct address_space *,
-			struct page *, struct page *,
+int buffer_migrate_page(struct address_space *, struct page *, struct page *,
 			enum migrate_mode);
 #else
 #define buffer_migrate_page NULL
-- 
1.8.1.2.459.gbcd45b4.dirty

