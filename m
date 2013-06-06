Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3FFRhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:37:17 -0400
Received: from relay2.sgi.com ([192.48.179.30]:41230 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751190Ab3FFRhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:37:15 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.10-rc5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130606173711.80340500B5E@whiskey.americas.sgi.com>
Date: Thu,  6 Jun 2013 12:37:11 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these updates for XFS.  Here are several fixes for
filesystems with CRC support turned on:  fixes for quota, remote
attributes, and recovery.  There is also some feature work related to
CRCs:  the implementation of CRCs for the inode unlinked lists,
disabling noattr2/attr2 options when appropriate, and bumping the
maximum number of ACLs.

I would have preferred to defer this last category of items to 3.11.
This would require setting a feature bit for the on-disk changes, so
there is some pressure to get these in 3.10.  I believe this represents
the end of the CRC related queue.

Thanks,
Ben

The following changes since commit 7bc0dc271e494e12be3afd3c6431e5216347c624:

  xfs: rework remote attr CRCs (2013-05-30 17:26:31 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-v3.10-rc5

for you to fetch changes up to 0a8aa1939777dd114479677f0044652c1fd72398:

  xfs: increase number of ACL entries for V5 superblocks (2013-06-06 10:52:15 -0500)

----------------------------------------------------------------
xfs: update for 3.10-rc5

- Rework of dquot CRCs
- Fix for remote attribute invalidation of a leaf
- Fix ordering of transaction replay in recovery
- Implement CRCs for inode unlinked list
- Disable noattr2/attr2 mount options when CRCs are enabled
- Bump the limitation of ACL entries for v5 superblocks

----------------------------------------------------------------
Dave Chinner (6):
      xfs: rework dquot CRCs
      xfs: fix remote attribute invalidation for a leaf
      xfs: fix log recovery transaction item reordering
      xfs: inode unlinked list needs to recalculate the inode CRC
      xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
      xfs: increase number of ACL entries for V5 superblocks

 Documentation/filesystems/xfs.txt |  3 ++
 fs/xfs/xfs_acl.c                  | 31 +++++++++------
 fs/xfs/xfs_acl.h                  | 31 +++++++++++----
 fs/xfs/xfs_attr_leaf.c            |  2 +-
 fs/xfs/xfs_dquot.c                | 37 ++++++++---------
 fs/xfs/xfs_inode.c                | 16 ++++++++
 fs/xfs/xfs_log_recover.c          | 84 +++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_qm.c                   | 40 ++++++++++++++-----
 fs/xfs/xfs_quota.h                |  2 +
 fs/xfs/xfs_super.c                | 11 +++++
 10 files changed, 198 insertions(+), 59 deletions(-)
