Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3LSV0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:26:04 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49149 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab3LSV0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:26:03 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS bugfixes for 3.13-rc5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20131219212557.EDAB14266AC@whiskey.americas.sgi.com>
Date: Thu, 19 Dec 2013 15:25:57 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull these fixes for XFS.  This contains fixes for some asserts
   related to project quotas, a memory leak, a hang when disabling group or
   project quotas before disabling user quotas, Dave's email address, several
   fixes for the alignment of file allocation to stripe unit/width geometry, a
   fix for an assertion with xfs_zero_remaining_bytes, and the behavior of
   metadata writeback in the face of IO errors.

Thanks,
	Ben

The following changes since commit f94c44573e7c22860e2c3dfe349c45f72ba35ad3:

  xfs: growfs overruns AGFL buffer on V4 filesystems (2013-12-10 10:04:27 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.13-rc5

for you to fetch changes up to ac8809f9ab01a73de1a47b5a37bd8dcca8712fb3:

  xfs: abort metadata writeback on permanent errors (2013-12-17 09:40:23 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.13-rc5

- fix memory leak in xfs_dir2_node_removename
- fix quota assertion in xfs_setattr_size
- fix quota assertions in xfs_qm_vop_create_dqattach
- fix for hang when disabling group and project quotas before
  disabling user quotas
- fix Dave Chinner's email address in MAINTAINERS
- fix for file allocation alignment
- fix for assertion in xfs_buf_stale by removing xfsbdstrat
- fix for alignment with swalloc mount option
- fix for "retry forever" semantics on IO errors

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: remove xfsbdstrat error

Dave Chinner (3):
      xfs: align initial file allocations correctly
      xfs: swalloc doesn't align allocations properly
      xfs: abort metadata writeback on permanent errors

Jie Liu (3):
      xfs: fix false assertion at xfs_qm_vop_create_dqattach
      xfs: fix assertion failure at xfs_setattr_nonsize
      xfs: fix infinite loop by detaching the group/project hints from user dquot

Mark Tinguely (1):
      xfs: fix memory leak in xfs_dir2_node_removename

Namjae Jeon (1):
      MAINTAINERS: fix incorrect mail address of XFS maintainer

 MAINTAINERS              |  2 +-
 fs/xfs/xfs_bmap.c        | 32 ++++++++++++++-----
 fs/xfs/xfs_bmap_util.c   | 14 +++++++--
 fs/xfs/xfs_buf.c         | 37 +++++++++-------------
 fs/xfs/xfs_buf.h         | 11 ++++---
 fs/xfs/xfs_buf_item.c    | 21 +++++++++++--
 fs/xfs/xfs_dir2_node.c   | 26 ++++++++--------
 fs/xfs/xfs_iops.c        |  3 +-
 fs/xfs/xfs_log_recover.c | 13 ++++++--
 fs/xfs/xfs_qm.c          | 80 ++++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_trans_buf.c   | 13 +++++++-
 11 files changed, 168 insertions(+), 84 deletions(-)
