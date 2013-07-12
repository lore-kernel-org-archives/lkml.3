Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965340Ab3GLTIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:08:46 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50216 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965199Ab3GLTIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:08:45 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update (#2) for 3.11-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130712190837.A5C0B500B4B@whiskey.americas.sgi.com>
Date: Fri, 12 Jul 2013 14:08:37 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull a few more XFS updates for 3.11-rc1.

   Here are a fix for xfs_fsr, a cleanup in bulkstat, a cleanup in
   xfs_open_by_handle, updated mount options documentation, a cleanup in
   xfs_bmapi_write, a fix for the size of dquot log reservations, a fix
   for sgid inheritance when acls are in use, a fix for cleaning up
   quotainfo structures, and some more of the work which allows group
   and project quotas to be used together.

   We had a few more in this last quota category that we might have
   liked to get in, but it looks there are still a few items that need
   to be addressed.

Thanks,
       Ben

The following changes since commit 83e782e1a1cc0159888e58e14dfc8f3289663338:

  xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD (2013-06-28 17:39:22 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-v3.11-rc1-2

for you to fetch changes up to c31ad439e8d111bf911c9cc80619cebde411a44d:

  xfs: Fix the logic check for all quotas being turned off (2013-07-11 16:49:10 -0500)

----------------------------------------------------------------
xfs: update (#2) for 3.11-rc1

- fix for xfs_fsr returning -EINVAL
- cleanup in xfs_bulkstat
- cleanup in xfs_open_by_handle
- update mount options documentation
- clean up local format handling in xfs_bmapi_write
- fix dquot log reservations which were too small
- fix sgid inheritance for subdirectories when default acls are in use
- add project quota fields to various structures
- fix teardown of quotainfo structures when quotas are turned off

----------------------------------------------------------------
Carlos Maiolino (1):
      xfs: fix sgid inheritance for subdirectories inheriting default acls [V3]

Chandra Seetharaman (2):
      xfs: Add pquota fields where gquota is used.
      xfs: Fix the logic check for all quotas being turned off

Dave Chinner (3):
      xfs: update mount options documentation
      xfs: remove local fork format handling from xfs_bmapi_write()
      xfs: dquot log reservations are too small

Eric Sandeen (1):
      xfs: use XFS_BMAP_BMDR_SPACE vs. XFS_BROOT_SIZE_ADJ

Jie Liu (1):
      xfs: clean up unused codes at xfs_bulkstat()

Yann Droneaud (1):
      xfs: use get_unused_fd_flags(0) instead of get_unused_fd()

 Documentation/filesystems/xfs.txt | 317 +++++++++++++++++++++++++-------------
 fs/xfs/xfs_attr_leaf.c            |   2 +
 fs/xfs/xfs_bmap.c                 | 199 ++++++++++--------------
 fs/xfs/xfs_bmap.h                 |   1 +
 fs/xfs/xfs_dinode.h               |   3 -
 fs/xfs/xfs_dir2_block.c           |  20 ++-
 fs/xfs/xfs_dquot.c                |  15 +-
 fs/xfs/xfs_dquot.h                |   7 +-
 fs/xfs/xfs_icache.c               |   1 +
 fs/xfs/xfs_inode.c                |  14 +-
 fs/xfs/xfs_inode.h                |   1 +
 fs/xfs/xfs_ioctl.c                |  16 +-
 fs/xfs/xfs_iops.c                 |  24 +--
 fs/xfs/xfs_itable.c               |  28 +---
 fs/xfs/xfs_qm.c                   | 243 ++++++++++++++++++++---------
 fs/xfs/xfs_qm.h                   |  20 ++-
 fs/xfs/xfs_qm_bhv.c               |  10 +-
 fs/xfs/xfs_qm_syscalls.c          |  24 ++-
 fs/xfs/xfs_quota.h                |  65 ++++----
 fs/xfs/xfs_symlink.c              |  10 +-
 fs/xfs/xfs_trans_dquot.c          |  35 +++--
 fs/xfs/xfs_vnodeops.c             |  13 +-
 22 files changed, 644 insertions(+), 424 deletions(-)
