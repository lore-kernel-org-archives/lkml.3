Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3EaT0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:26:23 -0400
Received: from relay3.sgi.com ([192.48.152.1]:60427 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754036Ab3EaT0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:26:16 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS fixes for 3.10-rc4
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130531192615.2D48D500B4B@whiskey.americas.sgi.com>
Date: Fri, 31 May 2013 14:26:15 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these XFS fixes for-rc4.  There are fixes for a nested
   transaction in quota code, clearing of suid/sgid bits on truncate, and a fix
   for recovery.  There are also some fixes for CRC enabled filesystems: a fix
   for the reserved block count of remote symlinks, and a fix for corruption in
   freespace blocks.  We're adding support for userspace detection of CRC
   enabled filesystems with a fsgeom flag, and disabling the swap extents ioctl
   on CRC enabled filesystems since it is unimplemented and causes corruption.

Thanks,
	Ben

The following changes since commit 7ae077802c9f12959a81fa1a16c1ec2842dbae05:

  xfs: remote attribute lookups require the value length (2013-05-24 16:31:20 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.10-rc4

for you to fetch changes up to e400d27d1690d609f203f2d7d8efebc98cbc3089:

  xfs: fix dir3 freespace block corruption (2013-05-30 17:22:54 -0500)

----------------------------------------------------------------
xfs: fixes for 3.10-rc4

- Fix nested transactions in xfs_qm_scall_setqlim
- Clear suid/sgid bits when we truncate with size update
- Fix recovery for split buffers
- Fix block count on remote symlinks
- Add fsgeom flag for v5 superblock support
- Disable XFS_IOC_SWAPEXT for CRC enabled filesystems
- Fix dirv3 freespace block corruption

----------------------------------------------------------------
Dave Chinner (7):
      xfs: avoid nesting transactions in xfs_qm_scall_setqlim()
      xfs: kill suid/sgid through the truncate path.
      xfs: fix split buffer vector log recovery support
      xfs: fix incorrect remote symlink block count
      xfs: add fsgeom flag for v5 superblock support.
      xfs: disable swap extents ioctl on CRC enabled filesystems
      xfs: fix dir3 freespace block corruption

 fs/xfs/xfs_buf_item.c    |  7 +------
 fs/xfs/xfs_dfrag.c       |  8 ++++++++
 fs/xfs/xfs_dir2_format.h |  1 +
 fs/xfs/xfs_dir2_node.c   | 13 ++++++-------
 fs/xfs/xfs_fs.h          |  1 +
 fs/xfs/xfs_fsops.c       |  4 +++-
 fs/xfs/xfs_iops.c        | 47 ++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_log_recover.c | 11 +++++++++++
 fs/xfs/xfs_qm_syscalls.c | 40 +++++++++++++++++++++++-----------------
 fs/xfs/xfs_symlink.c     | 20 ++++++--------------
 10 files changed, 92 insertions(+), 60 deletions(-)
