Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461Ab3CUQiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:38:15 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60407 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934306Ab3CUQgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:40 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 26/33] aio: don't include aio.h in sched.h
Date: Thu, 21 Mar 2013 09:35:47 -0700
Message-Id: <1363883754-27966-27-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Faster kernel compiles by way of fewer unnecessary includes.

[akpm@linux-foundation.org: fix fallout]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/s390/hypfs/inode.c                      | 1 +
 block/scsi_ioctl.c                           | 1 +
 drivers/char/mem.c                           | 1 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c | 1 +
 drivers/infiniband/hw/qib/qib_file_ops.c     | 2 +-
 drivers/scsi/sg.c                            | 1 +
 drivers/staging/android/logger.c             | 1 +
 fs/9p/vfs_addr.c                             | 1 +
 fs/afs/write.c                               | 1 +
 fs/block_dev.c                               | 1 +
 fs/btrfs/file.c                              | 1 +
 fs/btrfs/inode.c                             | 1 +
 fs/ceph/file.c                               | 1 +
 fs/compat.c                                  | 1 +
 fs/direct-io.c                               | 1 +
 fs/ecryptfs/file.c                           | 1 +
 fs/ext2/inode.c                              | 1 +
 fs/ext3/inode.c                              | 1 +
 fs/ext4/file.c                               | 1 +
 fs/ext4/indirect.c                           | 1 +
 fs/ext4/inode.c                              | 1 +
 fs/ext4/page-io.c                            | 1 +
 fs/f2fs/data.c                               | 1 +
 fs/fat/inode.c                               | 1 +
 fs/fuse/cuse.c                               | 1 +
 fs/fuse/dev.c                                | 1 +
 fs/fuse/file.c                               | 1 +
 fs/gfs2/aops.c                               | 1 +
 fs/gfs2/file.c                               | 1 +
 fs/hfs/inode.c                               | 1 +
 fs/hfsplus/inode.c                           | 1 +
 fs/jfs/inode.c                               | 1 +
 fs/nilfs2/inode.c                            | 2 +-
 fs/ntfs/file.c                               | 1 +
 fs/ntfs/inode.c                              | 1 +
 fs/ocfs2/aops.h                              | 2 ++
 fs/ocfs2/inode.h                             | 2 ++
 fs/pipe.c                                    | 1 +
 fs/read_write.c                              | 1 +
 fs/reiserfs/inode.c                          | 1 +
 fs/ubifs/file.c                              | 1 +
 fs/udf/inode.c                               | 1 +
 fs/xfs/xfs_aops.c                            | 1 +
 fs/xfs/xfs_file.c                            | 1 +
 include/linux/cgroup.h                       | 1 +
 include/linux/pid_namespace.h                | 1 +
 include/linux/sched.h                        | 2 --
 include/linux/writeback.h                    | 1 +
 kernel/fork.c                                | 1 +
 kernel/printk.c                              | 1 +
 kernel/ptrace.c                              | 1 +
 mm/page_io.c                                 | 1 +
 mm/shmem.c                                   | 1 +
 mm/swap.c                                    | 1 +
 security/keys/internal.h                     | 2 ++
 security/keys/keyctl.c                       | 1 +
 sound/core/pcm_native.c                      | 2 +-
 57 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 5f7d7ba..7a539f4 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/aio.h>
 #include <asm/ebcdic.h>
 #include "hypfs.h"
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9a87daa..a5ffcc9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -27,6 +27,7 @@
 #include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/times.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index e49265f..1ccbe94 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -28,6 +28,7 @@
 #include <linux/pfn.h>
 #include <linux/export.h>
 #include <linux/io.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index aed8afe..6d7f453 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <linux/aio.h>
 #include <linux/jiffies.h>
 #include <linux/cpu.h>
 #include <asm/pgtable.h>
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 4f7aa30..b56c942 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -39,7 +39,7 @@
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/jiffies.h>
 #include <asm/pgtable.h>
 #include <linux/delay.h>
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9f0c465..df5e961 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -35,6 +35,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/aio.h>
 #include <linux/errno.h>
 #include <linux/mtio.h>
 #include <linux/ioctl.h>
diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index dbc63cb..b4a313c 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <linux/aio.h>
 #include "logger.h"
 
 #include <asm/ioctls.h>
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 0ad61c6..055562c 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -33,6 +33,7 @@
 #include <linux/pagemap.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 7e03ead..a890db4 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
+#include <linux/aio.h>
 #include "internal.h"
 
 static int afs_write_back_from_locked_page(struct afs_writeback *wb,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index aea605c..8fcd407 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
+#include <linux/aio.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5b4ea5f..85e5576 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/mpage.h>
+#include <linux/aio.h>
 #include <linux/falloc.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca1b767..ca26188 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/writeback.h>
 #include <linux/statfs.h>
 #include <linux/compat.h>
+#include <linux/aio.h>
 #include <linux/bit_spinlock.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index bf338d9..eb09f41 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -7,6 +7,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 
 #include "super.h"
 #include "mds_client.h"
diff --git a/fs/compat.c b/fs/compat.c
index d487985..00e7874 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -48,6 +48,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff --git a/fs/direct-io.c b/fs/direct-io.c
index f853263..4348b01 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -37,6 +37,7 @@
 #include <linux/uio.h>
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
+#include <linux/aio.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 63b1f54..201f0a0 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
+#include <linux/aio.h>
 #include "ecryptfs_kernel.h"
 
 /**
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fe60cc1..0a87bb1 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -31,6 +31,7 @@
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index d512c4b..eac4f04 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -27,6 +27,7 @@
 #include <linux/writeback.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include "ext3.h"
 #include "xattr.h"
 #include "acl.h"
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 64848b5..4959e29 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -23,6 +23,7 @@
 #include <linux/jbd2.h>
 #include <linux/mount.h>
 #include <linux/path.h>
+#include <linux/aio.h>
 #include <linux/quotaops.h>
 #include <linux/pagevec.h>
 #include "ext4.h"
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index b505a14..21de123 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -20,6 +20,7 @@
  *	(sct@redhat.com), 1993, 1998
  */
 
+#include <linux/aio.h>
 #include "ext4_jbd2.h"
 #include "truncate.h"
 #include "ext4_extents.h"	/* Needed for EXT_MAX_BLOCKS */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ea0cde..f513f3d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -37,6 +37,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/aio.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 809b310..d9903af 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -18,6 +18,7 @@
 #include <linux/pagevec.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
+#include <linux/aio.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
 #include <linux/workqueue.h>
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7bd22a2..d0ed4ba 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -12,6 +12,7 @@
 #include <linux/f2fs_fs.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
+#include <linux/aio.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index acf6e47..d1d502a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -20,6 +20,7 @@
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
 #include <linux/mount.h>
+#include <linux/aio.h>
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/uio.h>
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 6f96a8d..06b5e08 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -38,6 +38,7 @@
 #include <linux/device.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/aio.h>
 #include <linux/kdev_t.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 11dfa0c..06c569e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -19,6 +19,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/swap.h>
 #include <linux/splice.h>
+#include <linux/aio.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 34b80ba..42b265b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/compat.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 24f414f..371bd14 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -20,6 +20,7 @@
 #include <linux/swap.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/backing-dev.h>
+#include <linux/aio.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 019f45e..1b78c78 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -25,6 +25,7 @@
 #include <asm/uaccess.h>
 #include <linux/dlm.h>
 #include <linux/dlm_plock.h>
+#include <linux/aio.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 3031dfd..a9d60d4 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 
 #include "hfs_fs.h"
 #include "btree.h"
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 160ccc9..cdd181d 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
+#include <linux/aio.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index b7dc47b..1781f06 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
 #include "jfs_filsys.h"
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6b49f14..1e92930 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -25,7 +25,7 @@
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include "nilfs.h"
 #include "btnode.h"
 #include "segment.h"
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 5b2d4f0..600af8f 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -27,6 +27,7 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
+#include <linux/aio.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index d3e118c..2778b02 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/log2.h>
+#include <linux/aio.h>
 
 #include "aops.h"
 #include "attrib.h"
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index ffb2da3..f671e49 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -22,6 +22,8 @@
 #ifndef OCFS2_AOPS_H
 #define OCFS2_AOPS_H
 
+#include <linux/aio.h>
+
 handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 							 struct page *page,
 							 unsigned from,
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 88924a3..c765bdf 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -28,6 +28,8 @@
 
 #include "extent_map.h"
 
+struct iocb;
+
 /* OCFS2 Inode Private Data */
 struct ocfs2_inode_info
 {
diff --git a/fs/pipe.c b/fs/pipe.c
index 2234f3f..34a643d 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
diff --git a/fs/read_write.c b/fs/read_write.c
index 0dabcf7..f2e6108 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -9,6 +9,7 @@
 #include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
 #include <linux/export.h>
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ea5061f..77d6d47 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -18,6 +18,7 @@
 #include <linux/writeback.h>
 #include <linux/quotaops.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 int reiserfs_commit_write(struct file *f, struct page *page,
 			  unsigned from, unsigned to);
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index f12189d..1437453 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -50,6 +50,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/aio.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7a12e48..b6d15d3 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/crc-itu-t.h>
 #include <linux/mpage.h>
+#include <linux/aio.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5f707e5..c24ce0e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -31,6 +31,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f03bf1a..af5b84f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 
+#include <linux/aio.h>
 #include <linux/dcache.h>
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 900af59..906e5c5 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -27,6 +27,7 @@ struct cgroup_subsys;
 struct inode;
 struct cgroup;
 struct css_id;
+struct eventfd_ctx;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 215e5e3..6051177 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
+#include <linux/workqueue.h>
 #include <linux/threads.h>
 #include <linux/nsproxy.h>
 #include <linux/kref.h>
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..8d72706 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -325,8 +325,6 @@ extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 struct nsproxy;
 struct user_namespace;
 
-#include <linux/aio.h>
-
 #ifdef CONFIG_MMU
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9a9367c..579a500 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -5,6 +5,7 @@
 #define WRITEBACK_H
 
 #include <linux/sched.h>
+#include <linux/workqueue.h>
 #include <linux/fs.h>
 
 DECLARE_PER_CPU(int, dirty_throttle_leaks);
diff --git a/kernel/fork.c b/kernel/fork.c
index 1766d32..a0aa193 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -70,6 +70,7 @@
 #include <linux/khugepaged.h>
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
+#include <linux/aio.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/kernel/printk.c b/kernel/printk.c
index 0b31715..61e2c60 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
+#include <linux/aio.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
 #include <linux/kdb.h>
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index acbd284..5d4b4d7 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -17,6 +17,7 @@
 #include <linux/ptrace.h>
 #include <linux/security.h>
 #include <linux/signal.h>
+#include <linux/uio.h>
 #include <linux/audit.h>
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..c535d39 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -20,6 +20,7 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/frontswap.h>
+#include <linux/aio.h>
 #include <asm/pgtable.h>
 
 static struct bio *get_swap_bio(gfp_t gfp_flags,
diff --git a/mm/shmem.c b/mm/shmem.c
index 1c44af7..96b49bf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/swap.h>
+#include <linux/aio.h>
 
 static struct vfsmount *shm_mnt;
 
diff --git a/mm/swap.c b/mm/swap.c
index 8a529a0..92a9be5 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -30,6 +30,7 @@
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
+#include <linux/uio.h>
 
 #include "internal.h"
 
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 8bbefc3..d4f1468 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -16,6 +16,8 @@
 #include <linux/key-type.h>
 #include <linux/task_work.h>
 
+struct iovec;
+
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 4b5c948..33cfd27 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -22,6 +22,7 @@
 #include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
+#include <linux/uio.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 71ae86c..d470c35 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/pm_qos.h>
-#include <linux/uio.h>
+#include <linux/aio.h>
 #include <linux/dma-mapping.h>
 #include <sound/core.h>
 #include <sound/control.h>
-- 
1.8.1.3

