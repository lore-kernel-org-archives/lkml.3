Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbaFIQtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:49:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:57829 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbaFIQt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:49:27 -0400
Date: Tue, 10 Jun 2014 01:49:23 +0900
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>
Subject: [GIT PULL] f2fs updates for v3.16
Message-ID: <20140609164923.GA65800@jmac.local>
Reply-To: Jaegeuk Kim <jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request on f2fs updates for v3.16.

In this round, there is no special interesting feature, but we've investigated
a couple of tuning points with respect to the I/O flow.
Several major bug fixes and a bunch of clean-ups also have been made.

Thank you very much.

The following changes since commit 38583f095c5a8138ae2a1c9173d0fd8a9f10e8aa:

  Merge branch 'akpm' (incoming from Andrew) (2014-05-06 13:07:41 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/for-f2fs-3.16

for you to fetch changes up to 9ab701349247368f9d57a993b95a5bb05bb37e10:

  f2fs: support f2fs_fiemap (2014-06-08 08:56:49 +0900)

----------------------------------------------------------------
f2fs updates for v3.16

This patch-set includes the following major enhancement patches.
 o enhance wait_on_page_writeback
 o support SEEK_DATA and SEEK_HOLE
 o enhance readahead flows
 o enhance IO flushes
 o support fiemap
 o add some tracepoints

The other bug fixes are as follows.
 o fix to support a large volume > 2TB correctly
 o recovery bug fix with respect to the fallocated space
 o fix recursive lock on xattr operations
 o fix some erroneous cases on the remount flow

And, there are a bunch of cleanups.

----------------------------------------------------------------
Changman Lee (1):
      f2fs: large volume support

Chao Yu (16):
      f2fs: introduce raw_nat_from_node_info() to simplfy codes
      f2fs: handle inline data independently in f2fs_bmap
      f2fs: introduce help macro ADDRS_PER_PAGE()
      f2fs: introduce f2fs_seek_block to support SEEK_{DATA, HOLE} in llseek
      f2fs: set errno when f2fs_iget failed in recover_dentry
      f2fs: readahead multi pages of directory for performance
      f2fs: fix to truncate inline data in inode page when setattr
      f2fs: add a tracepoint for f2fs_write_begin
      f2fs: add a tracepoint for f2fs_write_end
      f2fs: add a tracepoint for f2fs_write_{meta,node,data}_page
      f2fs: add a tracepoint for f2fs_write_{meta,node,data}_pages
      f2fs: add a tracepoint for f2fs_read_data_page
      f2fs: avoid to use slab memory in f2fs_issue_flush for efficiency
      f2fs: use inode_init_owner() to simplify codes
      f2fs: avoid overflow when large directory feathure is enabled
      f2fs: avoid crash when trace f2fs_submit_page_mbio event in ra_sum_pages

Fabian Frederick (1):
      f2fs: add static to get_max_meta_blks

Gu Zheng (6):
      f2fs: put the bio when issue_flush completed
      f2fs: use __GFP_ZERO to avoid appending set-NULL
      f2fs: enable flush_merge only in f2fs is not read-only
      f2fs: add the flush_merge handle in the remount flow
      f2fs: introduce struct flush_cmd_control to wrap the flush_merge fields
      f2fs: introduce help function {create,destroy}_flush_cmd_control

Jaegeuk Kim (25):
      f2fs: avoid to conduct roll-forward due to the remained garbage blocks
      f2fs: call redirty_page_for_writepage
      f2fs: fix to unlock f2fs_lock at the omitted error case
      f2fs: remove costly dirty_dir_inode operations
      f2fs: add available_nids to fix handling max_nid correctly
      f2fs: avoid BUG_ON when mouting corrupted image having garbage blocks
      f2fs: adjust free mem size to flush dentry blocks
      f2fs: clean up long variable names
      f2fs: pass flags field to setxattr functions
      f2fs: return errors right after checking them
      f2fs: submit bio at the reclaim path
      f2fs: return i_size if the hole is outside of i_size
      f2fs: consider fallocated space for SEEK_DATA
      f2fs: split grab_cache_page and wait_on_page_writeback for node pages
      f2fs: avoid grab_cache_page_write_begin for data pages
      f2fs: no need to wait on page writebck to meta pages
      f2fs: decrease the lock granularity during write_begin
      f2fs: deactivate inode page if the inode is evicted
      MAINTAINERS: change the email address for f2fs
      MAINTAINERS: add a co-maintainer from samsung for F2FS
      f2fs: fix recursive lock by f2fs_setxattr
      f2fs: fix to recover data written by dio
      f2fs: recover fallocated space
      f2fs: avoid not to call remove_dirty_inode
      f2fs: support f2fs_fiemap

Jingoo Han (1):
      f2fs: make recover_inline_xattr() static

Zhang Zhen (2):
      f2fs: atomically set inode->i_flags in f2fs_set_inode_flags()
      f2fs: fix checkpatch warning

 Documentation/filesystems/f2fs.txt |   8 +-
 MAINTAINERS                        |   3 +-
 fs/f2fs/acl.c                      |   2 +-
 fs/f2fs/checkpoint.c               | 118 ++++++++++++++++------------
 fs/f2fs/data.c                     |  63 +++++++++++----
 fs/f2fs/dir.c                      |  12 ++-
 fs/f2fs/f2fs.h                     |  49 +++++++++---
 fs/f2fs/file.c                     | 139 +++++++++++++++++++++++++++++++--
 fs/f2fs/inline.c                   |  40 ++++++++--
 fs/f2fs/inode.c                    |  18 +++--
 fs/f2fs/namei.c                    |  11 +--
 fs/f2fs/node.c                     | 154 ++++++++++++++++++++-----------------
 fs/f2fs/node.h                     |  19 +++--
 fs/f2fs/recovery.c                 |  35 +++++----
 fs/f2fs/segment.c                  | 134 ++++++++++++++++++++------------
 fs/f2fs/super.c                    |  32 +++++++-
 fs/f2fs/xattr.c                    | 110 ++++++++++++++------------
 fs/f2fs/xattr.h                    |   8 +-
 include/linux/f2fs_fs.h            |   8 ++
 include/trace/events/f2fs.h        | 146 ++++++++++++++++++++++++++++++++++-
 20 files changed, 797 insertions(+), 312 deletions(-)

-- 
Jaegeuk Kim
