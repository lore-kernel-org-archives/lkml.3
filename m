Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaGHL7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:59:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18950 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbaGHL7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:59:39 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-34-53bbdd299941
From: Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com
Subject: [PATCH 1/3] fs: Add support IOC_MOV_DATA ioctl
Date: Tue, 08 Jul 2014 20:59:37 +0900
Message-id: <003e01cf9aa4$176da750$4648f5f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+aosMnVzxFR0gxRXO+9qFSHQEpIA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkUFfr7u5gg1/NTBZLJ15itnj3ucpi
	y7F7jBanJyxislj2YDOLxcx5d9gs9uw9yWJxedccNovWnp/sFov6bjE6cHmcWiThsXmFlkfT
	maPMHqsvbGX0eL/vKptH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZaxZ/I+1oM+8Ym/LR5YG
	xt3aXYycHBICJhIfznQxQdhiEhfurWcDsYUEljJKbF/vAVfz9DN7FyMXUHw6o8Seq3vZIJy/
	jBLnJ1xm7mLk4GAT0Jb4s0UUpEFEwFVi3t3vjCA1zAJrmSROzfzMCFIjLGAuceQkN0gNi4Cq
	xIS3n5hBbF4BS4nJ59ZC2YISPybfYwEpZxbQkfg6KQIkzCwgL7F5zVtmiHsUJHacfc0IsUpP
	ov3OXVaIGhGJfS/ega2VEPjKLjH54H9WiF0CEt8mHwKbKSEgK7HpANQcSYmDK26wTGAUm4Vk
	8yyEzbOQbJ6FZMMCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIFRe/rfs74djDcPWB9i
	TAbaPpFZSjQ5Hxj1eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qB0TwpmL25YMu5R7Gv1uw1e5wha7JnUs/OVVfZb+v8WduyfFJv7A3WDxkLw4xX
	uSYZ9cXFxfzyCrKZxDctvjVwrlmNyPZV+2Kv7+l/u1+b+8J75bSrTeZPYn0fBJVGz/w2OXlj
	W6RhV/2trAVTI3mbN9x+s+r95U3rtaatmcIWU/jL8Lm4n0ecvBJLcUaioRZzUXEiABdJsCzw	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoK7m3d3BBrO+mFosnXiJ2eLd5yqL
	LcfuMVqcnrCIyWLZg80sFjPn3WGz2LP3JIvF5V1z2Cxae36yWyzqu8XowOVxapGEx+YVWh5N
	Z44ye6y+sJXR4/2+q2wefVtWMXp83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjFjzeJ/rAV95hV7Wz6yNDDu1u5i5OSQEDCR+PD0MzuELSZx4d56ti5GLg4hgemM
	Enuu7oVy/jJKnJ9wmbmLkYODTUBb4s8WUZAGEQFXiXl3vzOC1DALrGWSODXzMyNIjbCAucSR
	k9wgNSwCqhIT3n5iBrF5BSwlJp9bC2ULSvyYfI8FpJxZQEfi66QIkDCzgLzE5jVvmSHuUZDY
	cfY1I8QqPYn2O3dZIWpEJPa9eMc4gVFgFpJJsxAmzUIyaRaSjgWMLKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgpPCM6kdjCsbLA4xCnAwKvHwrji4K1iINbGsuDL3EKMEB7OSCO+XU7uD
	hXhTEiurUovy44tKc1KLDzGaAv05kVlKNDkfmLDySuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJ
	pCeWpGanphakFsH0MXFwSjUwbu4PcArnrqy/l7Llt7qS8L3naW6c6o2Cl63dXDPrPbI3x7sw
	+Bwvqt94TW5Cne3srz+cKq5UWB0p5eF6YHlnesH9dufXy7ZUOJiKxs8IXS+dbH+f47tv17Q0
	9dP7N159U+eloxTk5K5REsXOIxDavHhH5slzF2RyTvy/Hj4hkvOXJKP8FDUlluKMREMt5qLi
	RAAO9HG8IAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For speeding non linear media editing operations, we have already implemeted
FALLOC_FL_COLLAPSE_RANGE (merged in kernel since 3.15) and 
FALLOC_FL_INSERT_RANGE (currently awaiting review).
Both of these fallocate flags are used to remove/insert data within same file.
In continuation of our effort of speeding non linear media editing
(although the use case is not limited to just media editing) we introduce here
an ioctl FS_IOC_MOV_DATA which moves arbitrary (but fs block size aligned
as of now) bytes of data from one file into other file .

The movement takes place by transfering complete extents from donor file to
receiver file and leaves a hole in the donor file at the point from where
the blocks are moved. To eliminate the hole from donor, user can call
COLLAPSE_RANGE after the ioctl is finished if contiguous file space is required.

The main data structure for this ioctl is:
struct mov_data {
       int     donor_fd;               /* fd of donor file */
       int     receiver_fd;            /* fd of receiver file */
       loff_t  donor_offset;           /* offset into donor file */
       loff_t  receiver_offset;        /* offset into receiver file */
       loff_t  length;                 /* data length to be moved */
       loff_t  moved_len;              /* data length actually moved after completion */
       int     flags;                  /* Currently unused */
};

FS_IOC_MOV_DATA will move length bytes of data from donor_fd's donor_offset
to receiver_fd's receiver_offset. The prerequisite is that there must be 
atleast length size hole present @receiver_offset.

For inserting hole within file size at receiver_offset, FALLOC_FL_INSERT_RANGE
can be used. We will shortly post new version of FALLOC_FL_INSERT_RANGE which
enables inserting hole instead of current behavior of allocating unwritten
extents. If the requirement is to create hole at the end of file, truncate(2)
will suffice.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ioctl.c              | 108 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |   2 +
 include/uapi/linux/fs.h |  13 ++++++
 3 files changed, 123 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad..a1508f8 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -215,6 +215,111 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	return error;
 }
 
+static int ioctl_mov_data(struct file *filp, unsigned long arg)
+{
+	int error;
+	struct mov_data m_data;
+	struct mov_data __user *um_data = (struct mov_data __user *) arg;
+	struct inode *donor, *receiver;
+	struct fd donor_fd, receiver_fd;
+
+	if (copy_from_user(&m_data, um_data, sizeof(struct mov_data)))
+		return -EFAULT;
+
+	if (m_data.donor_offset < 0 || m_data.receiver_offset < 0 ||
+	    m_data.length <= 0)
+		return -EINVAL;
+
+	donor_fd = fdget(m_data.donor_fd);
+	if (!donor_fd.file) {
+		error = -EINVAL;
+		goto out1;
+	}
+
+	if (!(donor_fd.file->f_mode & FMODE_WRITE) ||
+	    !(donor_fd.file->f_mode & FMODE_READ) ||
+	    (donor_fd.file->f_flags & O_APPEND)) {
+		error = -EBADF;
+		goto out1;
+	}
+
+	receiver_fd = fdget(m_data.receiver_fd);
+	if (!receiver_fd.file) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	if (!(receiver_fd.file->f_mode & FMODE_WRITE) ||
+	    !(receiver_fd.file->f_mode & FMODE_READ) ||
+	    (receiver_fd.file->f_flags & O_APPEND)) {
+		error = -EBADF;
+		goto out2;
+	}
+
+	donor = file_inode(donor_fd.file);
+	receiver = file_inode(receiver_fd.file);
+
+	if (donor->i_sb != receiver->i_sb) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	if (donor == receiver) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	error = security_file_permission(donor_fd.file, MAY_WRITE);
+	if (error)
+		goto out2;
+
+	error = security_file_permission(receiver_fd.file, MAY_WRITE);
+	if (error)
+		goto out2;
+
+	if (IS_IMMUTABLE(donor) || IS_IMMUTABLE(receiver)) {
+		error = -EPERM;
+		goto out2;
+	}
+
+	if (IS_SWAPFILE(donor) || IS_SWAPFILE(receiver)) {
+		error = -EINVAL;
+		goto out2;
+	}
+
+	if (S_ISFIFO(donor->i_mode) | S_ISFIFO(receiver->i_mode)) {
+		error = -ESPIPE;
+		goto out2;
+	}
+
+	if (!S_ISREG(donor->i_mode) || !S_ISREG(receiver->i_mode)) {
+		error = -ENODEV;
+		goto out2;
+	}
+
+	if (!donor->i_op->mov_data) {
+		error = -EOPNOTSUPP;
+		goto out2;
+	}
+
+	m_data.moved_len = 0;
+	sb_start_write(donor->i_sb);
+	error = donor->i_op->mov_data(donor, receiver, m_data.donor_offset,
+				      m_data.receiver_offset, m_data.length,
+				      &m_data.moved_len);
+	sb_end_write(donor->i_sb);
+
+	if (copy_to_user(um_data, &m_data, sizeof(struct mov_data)))
+		error = -EFAULT;
+
+out2:
+	fdput(receiver_fd);
+out1:
+	fdput(donor_fd);
+
+	return error;
+}
+
 #ifdef CONFIG_BLOCK
 
 static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
@@ -591,6 +696,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FS_IOC_MOV_DATA:
+		return ioctl_mov_data(filp, arg);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1649d9d..a13afe3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1520,6 +1520,8 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
+	int (*mov_data)(struct inode *, struct inode *, loff_t, loff_t,
+			loff_t, loff_t *);
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index ca1a11b..6766d12 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -57,6 +57,18 @@ struct inodes_stat_t {
 	long dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
+/*
+ * Structure passed to IOC_MOV_DATA
+ */
+struct mov_data {
+	int	donor_fd;		/* fd of donor file */
+	int	receiver_fd;		/* fd of receiver file */
+	loff_t	donor_offset;		/* offset into donor file */
+	loff_t	receiver_offset;	/* offset into receiver file */
+	loff_t	length;			/* data length to be moved */
+	loff_t	moved_len;		/* successfully moved length */
+	int	flags;			/* option to expand new feature */
+};
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -162,6 +174,7 @@ struct inodes_stat_t {
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
+#define FS_IOC_MOV_DATA			_IOWR('f', 12, struct mov_data)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
-- 
1.7.11-rc0

