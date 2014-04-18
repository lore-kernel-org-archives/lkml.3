Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaDRAQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:16:01 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:44361 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbaDRAP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:15:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmNyAM1tUFN5LEcvPGdsb2JhbABZgwY7gxmFCqI8BgSTdoVggSIXAwEBAQE4NYJmHCMYJDQFJQMHLYd7zDsWjgJKHYQiBIU4kzWWESuBLg
Date: Fri, 18 Apr 2014 10:15:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [GIT PULL] xfs: fixes for 3.15-rc2
Message-ID: <20140418001552.GZ15995@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the updates listed below? The fixes are for data
corruption issues, memory corruption and regressions for changes
merged in -rc1. More detail is in the tag below.

FYI, there have been some recent problems with oss.sgi.com resetting
connections on git pulls. Hopefully that has been resolved, but if
you have problems pulling the changes please let me know.

-Dave.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.15-rc2

for you to fetch changes up to 330033d697ed8d296fa52b5303db9d802ad901cc:

  xfs: fix tmpfile/selinux deadlock and initialize security (2014-04-17 08:15:30 +1000)

----------------------------------------------------------------
xfs: bug fixes for 3.15-rc2

Data corruption fixes:
- fix a bunch of delayed allocation state mismatches
- fix collapse/zero range bugs
- fix a direct IO block mapping bug @ EOF

Other fixes:
- fix a use after free on metadata IO error
- fix a use after free on IO error during unmount
- fix an incorrect error sign on direct IO write errors
- add missing O_TMPFILE inode security context initialisation

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix tmpfile/selinux deadlock and initialize security

Dave Chinner (8):
      xfs: kill buffers over failed write ranges properly
      xfs: write failure beyond EOF truncates too much data
      xfs: xfs_vm_write_end truncates too much on failure
      xfs: zeroing space needs to punch delalloc blocks
      xfs: don't map ranges that span EOF for direct IO
      xfs: collapse range is delalloc challenged
      xfs: unmount does not wait for shutdown during unmount
      xfs: wrong error sign conversion during failed DIO writes

Eric Sandeen (1):
      xfs: fix buffer use after free on IO error

 fs/xfs/xfs_aops.c      |   51 ++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_bmap.c      |   17 ++++++++++------
 fs/xfs/xfs_bmap_util.c |   13 +++++++++++-
 fs/xfs/xfs_buf.c       |   16 +++++++++++----
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_inode.c     |    5 +++--
 fs/xfs/xfs_inode.h     |    2 +-
 fs/xfs/xfs_iops.c      |   20 +++++++++++++++---
 fs/xfs/xfs_log.c       |   53 ++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_trace.h     |    1 +
 10 files changed, 147 insertions(+), 33 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
