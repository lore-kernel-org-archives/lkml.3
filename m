Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbAOLhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:37:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14152 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAOLg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:36:58 -0500
X-AuditID: cbfee68e-f79b46d000002b74-8d-54b7a6577013
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>
Cc: Brian Foster <bfoster@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] fs: file freeze support
Date: Thu, 15 Jan 2015 20:36:55 +0900
Message-id: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAwtlXoUaawJWQaRW+FG8CXLiKddg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkRDdi2fYQg7WX2CyWTrzEbPHuc5XF
	lmP3GC1OzPS0WPZgM4vFnr0nWSwu75rDZtHa85Pd4vzf46wOnB6nFkl4NJ05yuwx6fBnJo/3
	+66yefRtWcXo8XmTnMemJ2+ZAtijuGxSUnMyy1KL9O0SuDK2tV9jLFgRXjF103HGBsZr7l2M
	nBwSAiYSHy8+YoGwxSQu3FvP1sXIxSEksJRR4trXJ6wwRXPebGWHSCxilGiZdY8ZJCEk8JdR
	YsZB5S5GDg42AW2JP1tEQcIiAsUSW/+8AKtnFvjEKHF/UxMTSEJYQEdi0rLVbCA2i4CqxOrW
	l2BxXgFLiXO3jrND2IISPybfYwGZyQxU/3VSBEiYWUBeYvOat8wQ9yhI7Dj7mhFil57Ekqn/
	mCBqRCT2vXjHCFHzll3i1T5/iFUCEt8mHwIbKSEgK7HpANQYSYmDK26wTGAUm4Vk8SyExbOQ
	LJ6FZMECRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIGxevrfs74djDcPWB9iFOBgVOLh
	XeG9PUSINbGsuDL3EKMp0EETmaVEk/OBCSGvJN7Q2MzIwtTE1NjI3NJMSZw3QepnsJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGNVrSLp/ErPn4mYQSlNemC4uF/nyRccW/aGVz82YPo03P
	uOLeSwl1TpT3/lhf5xJ0LbT27rnHhnsuWig+cdu2z3nibrU/ezckc/2YYZDz1eLSp52pifP6
	M/71TeRbxz7losflRQZ/ttm7H9wn+a9vy49SO/Fik64o5l91X3g0Wtb/+Ny4t7xHiaU4I9FQ
	i7moOBEAGahObtACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgG74su0hBsfWWFosnXiJ2eLd5yqL
	LcfuMVqcmOlpsezBZhaLPXtPslhc3jWHzaK15ye7xfm/x1kdOD1OLZLwaDpzlNlj0uHPTB7v
	911l8+jbsorR4/MmOY9NT94yBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGHM2NZ+jbFgRXjF1E3HGRsYr7l3MXJySAiYSMx5s5UdwhaTuHBvPVsXIxeHkMAiRomWWfeY
	QRJCAn8ZJWYcVO5i5OBgE9CW+LNFFCQsIlAssfXPC3aQemaBT4wS9zc1MYEkhAV0JCYtW80G
	YrMIqEqsbn0JFucVsJQ4d+s4O4QtKPFj8j0WkJnMQPVfJ0WAhJkF5CU2r3nLDHGPgsSOs68Z
	IXbpSSyZ+o8JokZEYt+Ld4wTGAVmIZk0C2HSLCSTZiHpWMDIsopRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOBU8k9rBuLLB4hCjAAejEg8vg9/2ECHWxLLiytxDjBIczEoivJ05QCHelMTK
	qtSi/Pii0pzU4kOMpkB/TmSWEk3OB6apvJJ4Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTEktTs
	1NSC1CKYPiYOTqkGRu6iNQvKf23Y18X76ZoM1+46ha3ljMulutO/CXovPP0i5Z3YxDeHv12a
	q/UsL3MaU8qTNrv/13bEZm/IvbRJ68yb5I3Fv+f+d8+Q6knqOC+rfiu5S8zo7cG1k9aeaXNM
	E+p3T//UZVn2xTWqUkZacdJ5BzHbqKdMH1pZbfd+Y9OyTxBLuv/qvxJLcUaioRZzUXEiAIQF
	MtsbAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce per-file freeze feature for unifying defrag ext4 and xfs
as first ingredient. We get the idea courtesy of Dave Chinner
(https://lkml.org/lkml/2014/7/14/759)
per-file freeze will be used to avoid that file is not modified while
userspace is doing the defrag.

This patch tries to implement file write freeze functionality.
Introduce new inode state, I_WRITE_FREEZED.
When this state is set, any process which tries to modify the file's address
space, either by pagefault mmap writes or using write(2), will block until
the this state is cleared. I_WRITE_FREEZED is set by calling FS_IOC_FWFREEZE
ioctl and clear by FS_IOC_FWTHAW ioctl.

File write freeze functionality, when used in conjunction with
inode's immutable flag can be used for creating truly stable file snapshots
wherein write freeze will prevent any modification to the file from already
open file descriptors and immutable flag will prevent any new modification
to the file. One of the intended uses for stable file snapshots would be in
the defragmentation applications which defrags single file.

For implementation purpose, initially we tried to keep percpu usage counters
inside struct inode just like there is struct sb_writers in super_block.
But considering that it will significantly bloat up struct inode when actually
the usage of file write freeze will be infrequent, we dropped this idea.
Instead we have tried to use already present filesystem freezing infrastructure.
Current approach makes it possible for implementing file write freeze without
bloating any of struct super_block/inode.
In FS_IOC_FWFREEZE, we wait for complete fs to be frozen, set I_WRITE_FREEZED to
inode's state and unfreeze the fs. 

TODO : prevent inode eviction when I_WRITE_FREEZED state is set.
TODO : xfstests testcase for file freeze.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/btrfs/inode.c        |  1 +
 fs/buffer.c             |  1 +
 fs/ext4/inode.c         |  1 +
 fs/f2fs/file.c          |  1 +
 fs/gfs2/file.c          |  1 +
 fs/inode.c              | 19 ++++++++++++++++++
 fs/ioctl.c              | 30 +++++++++++++++++++++++++++++
 fs/nilfs2/file.c        |  1 +
 fs/ocfs2/mmap.c         |  1 +
 fs/super.c              | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      | 13 +++++++++++++
 include/uapi/linux/fs.h |  2 ++
 mm/filemap.c            |  1 +
 13 files changed, 123 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0..357c749 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8262,6 +8262,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 page_start;
 	u64 page_end;
 
+	inode_start_write(inode);
 	sb_start_pagefault(inode->i_sb);
 	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (!ret) {
diff --git a/fs/buffer.c b/fs/buffer.c
index 20805db..966d50b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2444,6 +2444,7 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	int ret;
 	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
 
+	inode_start_write(file_inode(vma->vm_file));
 	sb_start_pagefault(sb);
 
 	/*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5653fa4..7e1e41e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4981,6 +4981,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	get_block_t *get_block;
 	int retries = 0;
 
+	inode_start_write(inode);
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
 	/* Delalloc case is easy... */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f172ddc4..9e23f8d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -40,6 +40,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 
 	f2fs_balance_fs(sbi);
 
+	inode_start_write(inode);
 	sb_start_pagefault(inode->i_sb);
 
 	f2fs_bug_on(sbi, f2fs_has_inline_data(inode));
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 6e600ab..bddf66b 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -393,6 +393,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	loff_t size;
 	int ret;
 
+	inode_start_write(inode);
 	sb_start_pagefault(inode->i_sb);
 
 	/* Update file times before taking page lock */
diff --git a/fs/inode.c b/fs/inode.c
index aa149e7..82a96d0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1929,3 +1929,22 @@ void inode_set_flags(struct inode *inode, unsigned int flags,
 				  new_flags) != old_flags));
 }
 EXPORT_SYMBOL(inode_set_flags);
+
+void inode_start_write(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+retry:
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & I_WRITE_FREEZED) {
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
+				TASK_UNINTERRUPTIBLE);
+		spin_unlock(&inode->i_lock);
+		schedule();
+		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
+		goto retry;
+	}
+	spin_unlock(&inode->i_lock);
+}
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 214c3c1..c8e9ae3 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -540,6 +540,28 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_super(sb);
 }
 
+static int ioctl_filefreeze(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	/* Freeze */
+	return file_write_freeze(inode);
+}
+
+static int ioctl_filethaw(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	/* Thaw */
+	return file_write_unfreeze(inode);
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -589,6 +611,14 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		error = ioctl_fsthaw(filp);
 		break;
 
+	case FS_IOC_FWFREEZE:
+		error = ioctl_filefreeze(filp);
+		break;
+
+	case FS_IOC_FWTHAW:
+		error = ioctl_filethaw(filp);
+		break;
+
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, arg);
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 3a03e0a..5110d9d 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -66,6 +66,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
 		return VM_FAULT_SIGBUS; /* -ENOSPC */
 
+	inode_start_write(file_inode(vma->vm_file));
 	sb_start_pagefault(inode->i_sb);
 	lock_page(page);
 	if (page->mapping != inode->i_mapping ||
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 10d66c7..d073fc2 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -136,6 +136,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	sigset_t oldset;
 	int ret;
 
+	inode_start_write(inode);
 	sb_start_pagefault(inode->i_sb);
 	ocfs2_block_signals(&oldset);
 
diff --git a/fs/super.c b/fs/super.c
index eae088f..5e44e42 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1393,3 +1393,54 @@ out:
 	return 0;
 }
 EXPORT_SYMBOL(thaw_super);
+
+int file_write_freeze(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	int ret = 0;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	spin_lock(&inode->i_lock);
+
+	if (inode->i_state & I_WRITE_FREEZED)
+		ret = -EBUSY;
+	spin_unlock(&inode->i_lock);
+	if (ret)
+		return ret;
+
+	ret = freeze_super(sb);
+	if (ret)
+		return ret;
+
+	spin_lock(&inode->i_lock);
+	inode->i_state |= I_WRITE_FREEZED;
+	smp_wmb();
+	spin_unlock(&inode->i_lock);
+
+	return thaw_super(sb);
+}
+EXPORT_SYMBOL(file_write_freeze);
+
+int file_write_unfreeze(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	spin_lock(&inode->i_lock);
+
+	if (!(inode->i_state & I_WRITE_FREEZED)) {
+		spin_unlock(&inode->i_lock);
+		return -EINVAL;
+	}
+
+	inode->i_state &= ~I_WRITE_FREEZED;
+	smp_wmb();
+	wake_up(&sb->s_writers.wait_unfrozen);
+	spin_unlock(&inode->i_lock);
+	return 0;
+}
+EXPORT_SYMBOL(file_write_unfreeze);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8639770..13eba85 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1313,8 +1313,12 @@ extern struct timespec current_fs_time(struct super_block *sb);
  * Snapshotting support.
  */
 
+int file_write_freeze(struct inode *inode);
+int file_write_unfreeze(struct inode *inode);
+
 void __sb_end_write(struct super_block *sb, int level);
 int __sb_start_write(struct super_block *sb, int level, bool wait);
+void inode_start_write(struct inode *inode);
 
 /**
  * sb_end_write - drop write access to a superblock
@@ -1730,6 +1734,12 @@ struct super_operations {
  *
  * I_DIO_WAKEUP		Never set.  Only used as a key for wait_on_bit().
  *
+ * I_WRITE_FREEZED	This bit is set by calling file_write_freeze ioctl and
+ *			unset by file_write_thaw ioctl. If this is set, the
+ *			processes which have already open the file and try to
+ *			modify the file address space will block until the bit
+ *			is cleared.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -1746,6 +1756,7 @@ struct super_operations {
 #define __I_DIO_WAKEUP		9
 #define I_DIO_WAKEUP		(1 << I_DIO_WAKEUP)
 #define I_LINKABLE		(1 << 10)
+#define I_WRITE_FREEZED	(1 << 11)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
@@ -2321,6 +2332,7 @@ static inline void file_start_write(struct file *file)
 {
 	if (!S_ISREG(file_inode(file)->i_mode))
 		return;
+	inode_start_write(file_inode(file));
 	__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
 }
 
@@ -2328,6 +2340,7 @@ static inline bool file_start_write_trylock(struct file *file)
 {
 	if (!S_ISREG(file_inode(file)->i_mode))
 		return true;
+	inode_start_write(file_inode(file));
 	return __sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, false);
 }
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3735fa0..3f529a7 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -167,6 +167,8 @@ struct inodes_stat_t {
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
+#define FS_IOC_FWFREEZE		_IOWR('X', 122, int) /* File Freeze */
+#define FS_IOC_FWTHAW			_IOWR('X', 123, int) /* File Thaw */
 
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
diff --git a/mm/filemap.c b/mm/filemap.c
index bd8543c..b07a873 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2066,6 +2066,7 @@ int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct inode *inode = file_inode(vma->vm_file);
 	int ret = VM_FAULT_LOCKED;
 
+	inode_start_write(inode);
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
 	lock_page(page);
-- 
1.8.5.5

