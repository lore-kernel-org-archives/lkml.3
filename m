Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbaLJCS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:18:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:44320 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbaLJCSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:18:25 -0500
Date: Tue, 9 Dec 2014 18:18:20 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Dev Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
	<linux-f2fs-devel@lists.sourceforge.net>
Subject: [GIT PULL] f2fs updates for v3.19
Message-ID: <20141210021820.GA41187@jaegeuk-mac02.mot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch-set includes lots of bug fixes based on clean-ups and refactored
codes. And inline_dir was introduced and two minor mount options were added.

Please, pull the following patches.

Thank you,

The following changes since commit f4ca536f71ad69d9a974d0156d43b24b3f3112de:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k (2014-11-03 14:09:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/for-f2fs-3.19

for you to fetch changes up to 635aee1fefef921ae4124b127fced62ea6008839:

  f2fs: avoid to ra unneeded blocks in recover flow (2014-12-08 14:19:09 -0800)

----------------------------------------------------------------
f2fs updates for v3.19

This series includes the following enhancement with refactored flows.
 o fix inmemory page operations
 o fix wrong inline_data & inline_dir logics
 o enhance memory and IO control under memory pressure
 o consider preemption on radix_tree operation
 o fix memory leaks and deadlocks

But also, there are a couple of new features:
 o support inline_dir to store dentries inside inode page
 o add -o fastboot to reduce booting time
 o implement -o dirsync

And a lot of clean-ups and minor bug fixes as well.

----------------------------------------------------------------
Changman Lee (8):
      f2fs: fix wrong data structure when create slab
      f2fs: check dirty_nat_cnt before flushing nat entries in journal
      f2fs: no more dirty_nat_entires when flushing
      f2fs: cleanup if-statement of phase in gc_data_segment
      f2fs: cleanup redundant macro
      f2fs: more fast lookup for gc_inode list
      f2fs: check if inode state is dirty at fsync
      f2fs: cleanup path to need cp at fsync

Chao Yu (14):
      f2fs: add infra struct and helper for inline dir
      f2fs: add a new mount option for inline dir
      f2fs: export dir operations for inline dir
      f2fs: add key function to handle inline dir
      f2fs: enable inline dir handling
      f2fs: update f2fs documentation for inline dir support
      f2fs: avoid unable to restart gc thread in remount
      f2fs: remove unneeded check code with option in f2fs_remount
      f2fs: introduce struct inode_management to wrap inner fields
      f2fs: fix to return correct error number in f2fs_write_begin
      f2fs: use atomic for counting inode with inline_{dir,inode} flag
      f2fs: fix to enable readahead for SSA/CP blocks
      f2fs: introduce is_valid_blkaddr to cleanup codes in ra_meta_pages
      f2fs: avoid to ra unneeded blocks in recover flow

Gu Zheng (6):
      f2fs: remove the seems unneeded argument 'type' from __get_victim
      f2fs: remove the redundant function cond_clear_inode_flag
      f2fs: introduce f2fs_change_bit to simplify the change bit logic
      f2fs: set raw_super default to NULL to avoid compile warning
      f2fs: rename f2fs_set/clear_bit to f2fs_test_and_set/clear_bit
      f2fs: use current_sit_addr to replace the open code

Jaegeuk Kim (56):
      f2fs: do not make dirty any inmemory pages
      f2fs: invalidate inmemory page
      f2fs: should truncate any allocated block for inline_data write
      f2fs: fix race conditon on truncation with inline_data
      f2fs: use highmem for directory pages
      f2fs: avoid to allocate when inline_data was written
      f2fs: fix to call f2fs_unlock_op
      f2fs: avoid build warning
      f2fs: avoid infinite loop at cp_error
      f2fs: reuse room_for_filename for inline dentry operation
      f2fs: reuse find_in_block code for find_in_inline_dir
      f2fs: fix to wait correct block type
      f2fs: avoid deadlock on init_inode_metadata
      f2fs: add stat info for inline_dentry inodes
      f2fs: fix counting inline_data inode numbers
      f2fs: reuse core function in f2fs_readdir for inline_dentry
      f2fs: should not truncate any inline_dentry
      f2fs: introduce f2fs_dentry_ptr structure for code clean-up
      f2fs: reuse make_empty_dir code for inline_dentry
      f2fs: use kmap_atomic instead of kmap
      f2fs: declare f2fs_convert_inline_dir as a static function
      f2fs: call write_checkpoint under disabled gc
      f2fs: flush_dcache_page for inline data
      f2fs: do not discard data protected by the previous checkpoint
      f2fs: revisit inline_data to avoid data races and potential bugs
      f2fs: send discard commands in larger extent
      f2fs: avoid race condition in handling wait_io
      f2fs: remove unnecessary macro
      f2fs: introduce -o fastboot for reducing booting time only
      f2fs: disable roll-forward when active_logs = 2
      f2fs: introduce the number of inode entries
      f2fs: control the memory footprint used by ino entries
      f2fs: write node pages if checkpoint is not doing
      f2fs: do not skip any writes under memory pressure
      f2fs: implement -o dirsync
      f2fs: reduce the number of inline_data inode before clearing it
      f2fs: fix deadlock to grab 0'th data page
      f2fs: convert inline_data when i_size becomes large
      f2fs: fix to call put_page at the error handling routine
      f2fs: put the inode page when error was occurred
      f2fs: submit bio for node blocks in the reclaim path
      f2fs: write SSA pages under memory pressure
      f2fs: call flush_dcache_page when the page was updated
      f2fs: introduce f2fs_dentry_kunmap to clean up
      f2fs: fix livelock calling f2fs_iget during f2fs_evict_inode
      f2fs: fix deadlock during inline_data conversion
      f2fs: make clean the page before writing
      f2fs: fix to recover converted inline_data
      f2fs: fix missing kmem_cache_free
      f2fs: use rw_semaphore for nat entry lock
      f2fs: call radix_tree_preload before radix_tree_insert
      f2fs: do retry operations with cond_resched
      f2fs: count inline_xx in do_read_inode
      f2fs: set page private for inmemory pages for truncation
      f2fs: release inmemory pages when the file was closed
      f2fs: count the number of inmemory pages

Jan Kara (3):
      f2fs: avoid returning uninitialized value to userspace from f2fs_trim_fs()
      f2fs: fix possible data corruption in f2fs_write_begin()
      f2fs: remove pointless bit testing in f2fs_delete_entry()

Markus Elfring (1):
      f2fs: fix typos for the word "destroy" in jump labels

 Documentation/filesystems/f2fs.txt |   7 +
 fs/f2fs/acl.c                      | 148 +++++++++++-
 fs/f2fs/acl.h                      |   5 +-
 fs/f2fs/checkpoint.c               | 186 ++++++++------
 fs/f2fs/data.c                     | 166 ++++++-------
 fs/f2fs/debug.c                    |  15 +-
 fs/f2fs/dir.c                      | 308 +++++++++++++++---------
 fs/f2fs/f2fs.h                     | 176 +++++++++++---
 fs/f2fs/file.c                     | 212 ++++++++++------
 fs/f2fs/gc.c                       |  89 +++----
 fs/f2fs/gc.h                       |   5 +
 fs/f2fs/inline.c                   | 482 +++++++++++++++++++++++++++++--------
 fs/f2fs/inode.c                    |  44 +++-
 fs/f2fs/namei.c                    |  58 +++--
 fs/f2fs/node.c                     | 163 +++++++------
 fs/f2fs/node.h                     |   8 +-
 fs/f2fs/recovery.c                 |  14 +-
 fs/f2fs/segment.c                  | 122 +++++++---
 fs/f2fs/segment.h                  |   8 +-
 fs/f2fs/super.c                    |  29 ++-
 fs/f2fs/xattr.c                    |   6 +-
 fs/f2fs/xattr.h                    |   6 +-
 include/linux/f2fs_fs.h            |  27 ++-
 23 files changed, 1578 insertions(+), 706 deletions(-)

