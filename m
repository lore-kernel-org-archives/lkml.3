Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaHEAIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 20:08:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:59400 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaHEAIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 20:08:53 -0400
Date: Mon, 4 Aug 2014 17:09:24 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Dev Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
	<linux-f2fs-devel@lists.sourceforge.net>
Subject: [GIT PULL] f2fs updates for v3.17
Message-ID: <20140805000924.GA10520@jaegeuk-mac02>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request on f2fs updates for v3.17.

In this round, one mount option and two new interfaces are added. And we
enhanced the fdatasync performances, which still has some tuning points though.
Please pull this patch-set.

Thanks you,

The following changes since commit 191d385f253a317ed905b06137b48e5990e700cf:

  Merge tag 'f2fs-fixes-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs (2014-07-09 09:46:58 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/for-f2fs-3.17

for you to fetch changes up to b65ee14818e67127aa242fe1dbd3711b9c095cc0:

  f2fs: use for_each_set_bit to simplify the code (2014-08-04 13:20:53 -0700)

----------------------------------------------------------------
f2fs updates for v3.17

This series includes patches to:
 o add nobarrier mount option
 o support tmpfile and rename2
 o enhance the fdatasync behavior
 o fix the error path
 o fix the recovery routine
 o refactor a part of the checkpoint procedure
 o reduce some lock contentions

----------------------------------------------------------------
Chao Yu (18):
      f2fs: avoid unneeded SetPageUptodate in f2fs_write_end
      f2fs: avoid to truncate non-updated page partially
      f2fs: support ->tmpfile()
      f2fs: refactor flush_nat_entries codes for reducing NAT writes
      f2fs: reduce region of f2fs_lock_op covered for better concurrency
      f2fs: introduce f2fs_write_failed to handle error case when write
      f2fs: use inner macro and function to clean up codes
      f2fs: check name_len of dir entry to prevent from deadloop
      f2fs: reduce searching region of segmap when free section
      f2fs: support ->rename2()
      f2fs: avoid use invalid mapping of node_inode when evict meta inode
      f2fs: fix to put root inode in error path of fill_super
      f2fs: reduce competition among node page writes
      f2fs: add tracepoint for f2fs_direct_IO
      f2fs: avoid skipping recover_inline_xattr after recover_inline_data
      f2fs: invalidate xattr node page when evict inode
      f2fs: add f2fs_balance_fs for expand_inode_data
      f2fs: use for_each_set_bit to simplify the code

Dongho Sim (1):
      f2fs: remove redundant lines in allocate_data_block

Fabian Frederick (1):
      f2fs: replace count*size kzalloc by kcalloc

Gu Zheng (5):
      f2fs: remove the redundant validation check of acl
      f2fs: remove the needless point-cast
      f2fs: arguments cleanup of finding file flow functions
      f2fs: cleanup the needless return of f2fs_create_root_stats
      f2fs: remove the unused stat_lock

Huang Ying (1):
      f2fs: add f2fs_balance_fs for direct IO

Jaegeuk Kim (14):
      f2fs: introduce f2fs_do_tmpfile for code consistency
      f2fs: clean up an unused parameter and assignment
      f2fs: add nobarrier mount option
      f2fs: punch the core function for inode management
      f2fs: add infra for ino management
      f2fs: use radix_tree for ino management
      f2fs: add info of appended or updated data writes
      f2fs: skip unnecessary data writes during fsync
      f2fs: enable in-place-update for fdatasync
      f2fs: fix wrong condition for unlikely
      f2fs: test before set/clear bits
      f2fs: avoid retrying wrong recovery routine when error was occurred
      f2fs: add tracepoint for f2fs_issue_flush
      f2fs: fix coding style

 Documentation/filesystems/f2fs.txt |   5 +
 fs/f2fs/acl.c                      |   6 -
 fs/f2fs/checkpoint.c               | 178 +++++++++++++++---------
 fs/f2fs/data.c                     |  59 ++++++--
 fs/f2fs/debug.c                    |  19 +--
 fs/f2fs/dir.c                      |  87 ++++++++----
 fs/f2fs/f2fs.h                     |  50 +++++--
 fs/f2fs/file.c                     |  45 ++++--
 fs/f2fs/gc.c                       |   7 +-
 fs/f2fs/hash.c                     |   4 +-
 fs/f2fs/inline.c                   |   1 +
 fs/f2fs/inode.c                    |  12 +-
 fs/f2fs/namei.c                    | 246 ++++++++++++++++++++++++++++++---
 fs/f2fs/node.c                     | 273 +++++++++++++++++++++++++------------
 fs/f2fs/node.h                     |   7 +
 fs/f2fs/recovery.c                 |  22 ++-
 fs/f2fs/segment.c                  |  38 +++---
 fs/f2fs/segment.h                  |   8 +-
 fs/f2fs/super.c                    |  21 ++-
 include/trace/events/f2fs.h        |  87 ++++++++++++
 20 files changed, 883 insertions(+), 292 deletions(-)

Reply-To: 

