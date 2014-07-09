Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaGIOIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:08:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:46441 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbaGIOII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:08:08 -0400
Date: Wed, 9 Jul 2014 07:08:03 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Dev Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
	<linux-f2fs-devel@lists.sourceforget.net>
Subject: [GIT PULL] f2fs fixes for 3.16
Message-ID: <20140709140803.GA5248@jmac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request on f2fs bug fixes for v3.16, which includes a couple of
bug fixes found by xfstests.
In addition, one critical bug was reported by Brian Chadwick, which is falling
into the infinite loop in balance_dirty_pages. And it turned out due to the IO
merging policy in f2fs, which was newly merged in 3.16.

Thank you very much.

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/f2fs-fixes-3.16

for you to fetch changes up to 50e1f8d22199b557337b3d1ec8520e4c5aa5c76e:

  f2fs: avoid to access NULL pointer in issue_flush_thread (2014-07-09 05:59:55 -0700)

----------------------------------------------------------------
f2fs bugfixes for 3.16

o fix to get out of the infinite loop in balance_dirty_pages
o fix normal and recovery path for fallocated regions
o fix error case mishandling
o recover renamed fsync inodes correctly
o fix kernel NULL pointer error

----------------------------------------------------------------
Chao Yu (5):
      f2fs: remove unused variables in f2fs_sm_info
      f2fs: check lower bound nid value in check_nid_range
      f2fs: fix error path in init_inode_metadata
      f2fs: release new entry page correctly in error path of f2fs_rename
      f2fs: avoid to access NULL pointer in issue_flush_thread

Jaegeuk Kim (5):
      f2fs: fix to report newly allocate region as extent
      f2fs: recover fallocated data and its i_size together
      f2fs: fix not to allocate unnecessary blocks during fallocate
      f2fs: do checkpoint for the renamed inode
      f2fs: check bdi->dirty_exceeded when trying to skip data writes

 fs/f2fs/data.c    | 23 ++++++++++++++++++-----
 fs/f2fs/dir.c     |  2 +-
 fs/f2fs/f2fs.h    |  6 ++----
 fs/f2fs/file.c    | 12 ++++++++----
 fs/f2fs/inode.c   |  1 +
 fs/f2fs/namei.c   | 13 ++++++-------
 fs/f2fs/node.c    |  2 ++
 fs/f2fs/segment.c |  5 ++---
 fs/f2fs/super.c   |  4 +---
 9 files changed, 41 insertions(+), 27 deletions(-)

-- 
Jaegeuk Kim
