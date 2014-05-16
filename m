Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaEPCMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 22:12:00 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:9773 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbaEPCL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 22:11:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwHAAZzdVN5LL1s/2dsb2JhbABZgwZPgm+oJwEBAQEBAQYFmhiBFBd0gmYcIxgkNAUlAzSIQNF6FoU+iDBKHYQqBIVLlAWTFYNIK4Ez
Date: Fri, 16 May 2014 12:11:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [GIT PULL] xfs: fixes for 3.15-rc6
Message-ID: <20140516021144.GK5421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the updates listed below? I found a bunch of
error sign issues while determine what we need to do to rid XFS of
this problem permanently. A couple of the bugs are in data integirty
operations, a couple more are in the new COLLAPSE_RANGE code. One of
these came in through a recent ext4 merge and so I had to update the
base tree to 3.15-rc5 before fixing the issues.

-Dave.

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.15-rc6

for you to fetch changes up to ee4eec478be4677b93775d17bc079efb5922b276:

  xfs: list_lru_init returns a negative error (2014-05-15 09:23:24 +1000)

----------------------------------------------------------------
xfs: fixes for 3.15-rc6

Code inspection of the XFS error number sign translations found a bunch of
issues, including returning incorrectly signed errors for some data integrity
operations. These leak to userspace and result in applications not getting the
errors correctly reported. Hence they need fixing sooner rather than later.

----------------------------------------------------------------
Dave Chinner (9):
      xfs: xfs_dir_fsync() returns positive errno
      xfs: fix incorrect error sign in xfs_file_aio_read
      xfs: xfs_commit_metadata returns wrong errno
      xfs: correct error sign on COLLAPSE_RANGE errors
      xfs: fix wrong errno from xfs_initxattrs
      xfs: fix wrong err sign on xfs_set_acl()
      xfs: negate mount workqueue init error value
      xfs: negate xfs_icsb_init_counters error value
      xfs: list_lru_init returns a negative error

 fs/xfs/xfs_export.c |    2 +-
 fs/xfs/xfs_file.c   |    8 ++++----
 fs/xfs/xfs_iops.c   |   12 ++++++------
 fs/xfs/xfs_qm.c     |   26 ++++++++++++++------------
 fs/xfs/xfs_super.c  |    4 ++--
 5 files changed, 27 insertions(+), 25 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
