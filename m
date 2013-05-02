Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230Ab3EBU4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:56:21 -0400
Received: from relay2.sgi.com ([192.48.179.30]:50544 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762056Ab3EBU4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:56:19 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS updates for 3.10-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130502205615.52F13500B4E@whiskey.americas.sgi.com>
Date: Thu,  2 May 2013 15:56:15 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these XFS updates for 3.10-rc1.  It's a bunch of cleanups
   and bugfixes and an (for now) experimental feature from Dave Chinner,
   CRC protection for on disk metadata structures.

Thanks,
	Ben

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.10-rc1

for you to fetch changes up to cab09a81fbefcb21db5213a84461d421946f6eb8:

  xfs: fix da node magic number mismatches (2013-05-01 14:48:30 -0500)

----------------------------------------------------------------
xfs: update for v3.10-rc1

For 3.10-rc1 we have a number of bug fixes and cleanups and a currently
experimental feature from David Chinner, CRCs protection for metadata.
CRCs are enabled by using mkfs.xfs to create a filesystem with the
feature bits set.

* numerous fixes for speculative preallocation
* don't verify buffers on IO errors
* rename of random32 to prandom32
* refactoring/rearrangement in xfs_bmap.c
* removal of unused m_inode_shrink in struct xfs_mount
* fix error handling of xfs_bufs and readahead
* quota driven preallocation throttling
* fix WARN_ON in xfs_vm_releasepage
* add ratelimited printk for different alert levels
* fix spurious forced shutdowns due to freed Extent Free Intents
* remove some obsolete XLOG_CIL_HARD_SPACE_LIMIT() macros
* remove some obsoleted comments
* (experimental) CRC support for metadata

----------------------------------------------------------------
Akinobu Mita (1):
      xfs: rename random32() to prandom_u32()

Brian Foster (8):
      xfs: fix potential infinite loop in xfs_iomap_prealloc_size()
      xfs: increase prealloc size to double that of the previous extent
      xfs: reorganize xfs_iomap_prealloc_size to remove indentation
      xfs: push rounddown_pow_of_two() to after prealloc throttle
      xfs: pass xfs_dquot to xfs_qm_adjust_dqlimits() instead of xfs_disk_dquot_t
      xfs: xfs_dquot prealloc throttling watermarks and low free space
      xfs: add quota-driven speculative preallocation throttling
      xfs: xfs_iomap_prealloc_size() tracepoint

Christoph Hellwig (5):
      xfs: take inode version into account in XFS_LITINO
      xfs: add support for large btree blocks
      xfs: add CRC checks to the AGFL
      xfs: add CRC checks for quota blocks
      xfs: add version 3 inode format with CRCs

Dave Chinner (26):
      xfs: don't verify buffers after IO errors
      xfs: rearrange some code in xfs_bmap for better locality
      xfs: ensure we capture IO errors correctly
      xfs: don't free EFIs before the EFDs are committed
      xfs: increase hexdump output in xfs_corruption_error
      xfs: add CRC checks to the AGF
      xfs: add CRC checks to the AGI
      xfs: split out symlink code into it's own file.
      xfs: add CRC checks to remote symlinks
      xfs: add CRC checks to block format directory blocks
      xfs: add CRC checking to dir2 free blocks
      xfs: add CRC checking to dir2 data blocks
      xfs: add CRC checking to dir2 leaf blocks
      xfs: shortform directory offsets change for dir3 format
      xfs: add CRCs to dir2/da node blocks
      xfs: add CRCs to attr leaf blocks
      xfs: split remote attribute code out
      xfs: add CRC protection to remote attributes
      xfs: add buffer types to directory and attribute buffers
      xfs: buffer type overruns blf_flags field
      xfs: add CRC checks to the superblock
      xfs: implement extended feature masks
      xfs: add metadata CRC documentation
      xfs: Teach dquot recovery about CONFIG_XFS_QUOTA
      xfs: Remote attr validation fixes and optimisations
      xfs: fix da node magic number mismatches

Jan Kara (1):
      xfs: Fix WARN_ON(delalloc) in xfs_vm_releasepage()

Jeff Liu (3):
      xfs: Remove obsoleted m_inode_shrink from xfs_mount structure
      xfs: Remove the obsolete XLOG_CIL_HARD_SPACE_LIMIT() macros
      xfs: Update xfs_log_commit_cil() comments

Mark Tinguely (1):
      xfs: fix xfs_iomap_eof_prealloc_initial_size type

Rich Johnston (1):
      xfs: Add ratelimited printk for different alert levels

 .../filesystems/xfs-self-describing-metadata.txt   |  350 +
 fs/xfs/Makefile                                    |    6 +-
 fs/xfs/xfs_ag.h                                    |   56 +-
 fs/xfs/xfs_alloc.c                                 |  201 +-
 fs/xfs/xfs_alloc_btree.c                           |  105 +-
 fs/xfs/xfs_alloc_btree.h                           |   12 +-
 fs/xfs/xfs_aops.c                                  |   12 +-
 fs/xfs/xfs_attr.c                                  |  454 +-
 fs/xfs/xfs_attr.h                                  |    1 -
 fs/xfs/xfs_attr_leaf.c                             | 1781 ++--
 fs/xfs/xfs_attr_leaf.h                             |  122 +-
 fs/xfs/xfs_attr_remote.c                           |  541 ++
 fs/xfs/xfs_attr_remote.h                           |   46 +
 fs/xfs/xfs_bmap.c                                  | 9214 ++++++++++----------
 fs/xfs/xfs_bmap_btree.c                            |  110 +-
 fs/xfs/xfs_bmap_btree.h                            |   19 +-
 fs/xfs/xfs_btree.c                                 |  256 +-
 fs/xfs/xfs_btree.h                                 |   64 +-
 fs/xfs/xfs_buf.c                                   |   10 +-
 fs/xfs/xfs_buf_item.h                              |   64 +-
 fs/xfs/xfs_da_btree.c                              | 1501 ++--
 fs/xfs/xfs_da_btree.h                              |  130 +-
 fs/xfs/xfs_dinode.h                                |   43 +-
 fs/xfs/xfs_dir2_block.c                            |  179 +-
 fs/xfs/xfs_dir2_data.c                             |  266 +-
 fs/xfs/xfs_dir2_format.h                           |  278 +-
 fs/xfs/xfs_dir2_leaf.c                             |  898 +-
 fs/xfs/xfs_dir2_node.c                             | 1007 ++-
 fs/xfs/xfs_dir2_priv.h                             |   50 +-
 fs/xfs/xfs_dir2_sf.c                               |   12 +-
 fs/xfs/xfs_dquot.c                                 |  160 +-
 fs/xfs/xfs_dquot.h                                 |   16 +-
 fs/xfs/xfs_error.c                                 |    4 +-
 fs/xfs/xfs_extfree_item.c                          |   27 +-
 fs/xfs/xfs_extfree_item.h                          |   14 +-
 fs/xfs/xfs_file.c                                  |    2 +-
 fs/xfs/xfs_fsops.c                                 |   34 +-
 fs/xfs/xfs_ialloc.c                                |  109 +-
 fs/xfs/xfs_ialloc_btree.c                          |   87 +-
 fs/xfs/xfs_ialloc_btree.h                          |    9 +-
 fs/xfs/xfs_inode.c                                 |  212 +-
 fs/xfs/xfs_inode.h                                 |   31 +-
 fs/xfs/xfs_inode_item.c                            |    2 +-
 fs/xfs/xfs_iomap.c                                 |  165 +-
 fs/xfs/xfs_linux.h                                 |    1 +
 fs/xfs/xfs_log.c                                   |    2 +-
 fs/xfs/xfs_log_cil.c                               |    4 -
 fs/xfs/xfs_log_priv.h                              |    1 -
 fs/xfs/xfs_log_recover.c                           |  246 +-
 fs/xfs/xfs_message.h                               |   26 +
 fs/xfs/xfs_mount.c                                 |  146 +-
 fs/xfs/xfs_mount.h                                 |    2 +-
 fs/xfs/xfs_qm.c                                    |   25 +-
 fs/xfs/xfs_qm.h                                    |    4 +-
 fs/xfs/xfs_qm_syscalls.c                           |    9 +-
 fs/xfs/xfs_quota.h                                 |   11 +-
 fs/xfs/xfs_sb.h                                    |  166 +-
 fs/xfs/xfs_symlink.c                               |  730 ++
 fs/xfs/xfs_symlink.h                               |   66 +
 fs/xfs/xfs_trace.c                                 |    2 +-
 fs/xfs/xfs_trace.h                                 |   24 +
 fs/xfs/xfs_trans_buf.c                             |   63 +-
 fs/xfs/xfs_trans_dquot.c                           |   10 +-
 fs/xfs/xfs_vnodeops.c                              |  478 +-
 64 files changed, 12379 insertions(+), 8297 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-self-describing-metadata.txt
 create mode 100644 fs/xfs/xfs_attr_remote.c
 create mode 100644 fs/xfs/xfs_attr_remote.h
 create mode 100644 fs/xfs/xfs_symlink.c
 create mode 100644 fs/xfs/xfs_symlink.h
