Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3EITXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:23:42 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36287 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751854Ab3EITXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:23:41 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS updates (#2) for 3.10-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130509192336.EB1A7500B4B@whiskey.americas.sgi.com>
Date: Thu,  9 May 2013 14:23:36 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these three stragglers for 3.10-rc1.  CONFIG_XFS_WARN will be
helpful in environments which are having trouble, and where full
CONFIG_XFS_DEBUG isn't appropriate.  There are two fixes for issues with
extended attribtues seen with xfsdump.

Thanks,
	Ben

The following changes since commit cab09a81fbefcb21db5213a84461d421946f6eb8:

  xfs: fix da node magic number mismatches (2013-05-01 14:48:30 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.10-rc1-2

for you to fetch changes up to 7dfbcbefad4b24d9822d04dbd7b5dd5c3fd45076:

  xfs: fallback to vmalloc for large buffers in xfs_compat_attrlist_by_handle (2013-05-07 19:00:10 -0500)

----------------------------------------------------------------
xfs: update (#2) for v3.10-rc1

* add CONFIG_XFS_WARN, a step between zero debugging and CONFIG_XFS_DEBUG.
* fix attrmulti and attrlist to fall back to vmalloc when kmalloc fails.

----------------------------------------------------------------
Dave Chinner (1):
      xfs: introduce CONFIG_XFS_WARN

Eric Sandeen (2):
      xfs: fallback to vmalloc for large buffers in xfs_attrlist_by_handle
      xfs: fallback to vmalloc for large buffers in xfs_compat_attrlist_by_handle

 fs/xfs/Kconfig            |   13 +++++++++++++
 fs/xfs/mrlock.h           |   12 ++++++------
 fs/xfs/xfs.h              |    5 +++++
 fs/xfs/xfs_alloc_btree.c  |    4 ++--
 fs/xfs/xfs_bmap_btree.c   |    4 ++--
 fs/xfs/xfs_btree.h        |    2 +-
 fs/xfs/xfs_dir2_node.c    |    4 ++--
 fs/xfs/xfs_ialloc_btree.c |    4 ++--
 fs/xfs/xfs_inode.c        |    2 +-
 fs/xfs/xfs_ioctl.c        |   14 ++++++++++----
 fs/xfs/xfs_ioctl32.c      |   14 ++++++++++----
 fs/xfs/xfs_linux.h        |   24 ++++++++++++++++++------
 fs/xfs/xfs_message.c      |    8 ++++++++
 fs/xfs/xfs_message.h      |    1 +
 fs/xfs/xfs_trans.h        |    4 ++--
 15 files changed, 83 insertions(+), 32 deletions(-)
