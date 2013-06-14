Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3FNVsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:48:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:57311 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752232Ab3FNVsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:48:08 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.10-rc6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130614214804.26550500B4B@whiskey.americas.sgi.com>
Date: Fri, 14 Jun 2013 16:48:04 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these fixes for XFS.  These fixes remove shouty warnings which
   spam system logs, align dir/attr structures with CRCs correctly, set the
   block number on the new child block during a btree root split correctly, and
   the last one disables verifiers as a temporary workaround for a flaw in
   recovery.

Thanks,
	Ben

The following changes since commit 0a8aa1939777dd114479677f0044652c1fd72398:

  xfs: increase number of ACL entries for V5 superblocks (2013-06-06 10:52:15 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-v3.10-rc6

for you to fetch changes up to d302cf1d316dca5f567e89872cf5d475c9a55f74:

  xfs: don't shutdown log recovery on validation errors (2013-06-14 15:59:45 -0500)

----------------------------------------------------------------
xfs: fixes for 3.10-rc6

- Remove noisy warnings about experimental support which spams the logs
- Add padding to align directory and attr structures correctly
- Set block number on child buffer on a root btree split
- Disable verifiers during log recovery for non-CRC filesystems

----------------------------------------------------------------
Dave Chinner (4):
      xfs: don't emit v5 superblock warnings on write
      xfs: fix implicit padding in directory and attr CRC formats
      xfs: ensure btree root split sets blkno correctly
      xfs: don't shutdown log recovery on validation errors

 fs/xfs/xfs_attr_leaf.h   |  1 +
 fs/xfs/xfs_btree.c       | 10 ++++++++++
 fs/xfs/xfs_dir2_format.h |  5 +++--
 fs/xfs/xfs_log_recover.c | 19 +++++++++++++++++--
 fs/xfs/xfs_mount.c       | 18 +++++++++++-------
 5 files changed, 42 insertions(+), 11 deletions(-)
