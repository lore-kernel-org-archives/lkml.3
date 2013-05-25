Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3EYPVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 11:21:14 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34649 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756883Ab3EYPVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 11:21:13 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS fixes for 3.10-rc3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130525152109.1B1FB500B50@whiskey.americas.sgi.com>
Date: Sat, 25 May 2013 10:21:09 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these XFS fixes for -rc3.  Here are fixes for corruption on
512 byte filesystems, a rounding error, a use-after-free, some flags to
fix lockdep reports, and several fixes related to CRCs.  We have a
somewhat larger post -rc1 queue than usual due to fixes related to the
CRC feature we merged for 3.10.  These few are those which made
Stephen's linux-next Tree for May 23.

Thanks,
Ben

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.10-rc3

for you to fetch changes up to 7ae077802c9f12959a81fa1a16c1ec2842dbae05:

  xfs: remote attribute lookups require the value length (2013-05-24 16:31:20 -0500)

----------------------------------------------------------------
xfs: fixes for 3.10-rc3

- Fix for corruption with FSX on 512 byte blocksize filesystems
- Fix rounding error in xfs_free_file_space
- Fix use-after-free with extent free intents
- Add several missing KM_NOFS flags to fix lockdep reports
- Several fixes for CRC related code

----------------------------------------------------------------
Dave Chinner (7):
      xfs: fix sub-page blocksize data integrity writes
      xfs: fix rounding in xfs_free_file_space
      xfs: Don't reference the EFI after it is freed
      xfs: fix missing KM_NOFS tags to keep lockdep happy
      xfs: xfs_da3_node_read_verify() doesn't handle XFS_ATTR3_LEAF_MAGIC
      xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
      xfs: remote attribute lookups require the value length

 fs/xfs/xfs_aops.c         | 19 +++++++++++++++++++
 fs/xfs/xfs_attr_leaf.c    | 27 +++++++++++++++------------
 fs/xfs/xfs_buf.c          |  2 +-
 fs/xfs/xfs_da_btree.c     |  7 +++++--
 fs/xfs/xfs_dir2_leaf.c    |  2 +-
 fs/xfs/xfs_extfree_item.c |  5 +++--
 fs/xfs/xfs_log_cil.c      |  2 +-
 fs/xfs/xfs_vnodeops.c     |  4 ++--
 8 files changed, 47 insertions(+), 21 deletions(-)
