Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3I1PdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 11:33:19 -0400
Received: from relay3.sgi.com ([192.48.152.1]:43747 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753789Ab3I1PdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 11:33:17 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS fixes for 3.12-rc3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130928153316.09D864266DC@whiskey.americas.sgi.com>
Date: Sat, 28 Sep 2013 10:33:16 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	Please pull these bugfixes for xfs.  There is a fix for an
	assert caused by a spurious directory block collapse, a fix for
	recovery of a block over stale metadata from a previous mkfs, a
	cleanup for the eofblocks ioctl, and fixes for locking issues in
	xfs_inode_free and log item removal from the active item list.

Thanks,
       Ben

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/xfs-for-linus-v3.12-rc3

for you to fetch changes up to 997def25e4b9cee3b01609e18a52f926bca8bd2b:

  xfs: fix node forward in xfs_node_toosmall (2013-09-26 10:38:17 -0500)

----------------------------------------------------------------
xfs: bugfixes for 3.12-rc3

- fix for directory node collapse regression
- fix for recovery over stale on disk structures
- fix for eofblocks ioctl
- fix asserts in xfs_inode_free
- lock the ail before removing an item from it

----------------------------------------------------------------
Dave Chinner (4):
      xfs: lock the AIL before removing the buffer item
      xfs: asserting lock not held during freeing not valid
      xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
      xfs: log recovery lsn ordering needs uuid check

Mark Tinguely (1):
      xfs: fix node forward in xfs_node_toosmall

 fs/xfs/xfs_buf_item.c    |  1 +
 fs/xfs/xfs_da_btree.c    |  5 ++--
 fs/xfs/xfs_fs.h          |  2 +-
 fs/xfs/xfs_icache.c      |  9 +++---
 fs/xfs/xfs_log_recover.c | 73 ++++++++++++++++++++++++++++++++++++++----------
 5 files changed, 68 insertions(+), 22 deletions(-)
