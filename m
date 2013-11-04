Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3KDUHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:07:52 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34976 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3KDUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:07:50 -0500
Date: Mon, 4 Nov 2013 12:07:47 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] bcache changes for 3.13
Message-ID: <20131104200747.GD27129@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens, sorry for being late with this - anyways, it's roughly the same set of
patches you had queued up before plus a few minor fixes, but it's been rebased
onto your for-3.13/core branch.


The following changes since commit febca1baea1cfe2d7a0271385d89b03d5fb34f94:

  block: setup bi_vcnt on clones (2013-10-31 13:32:42 -0600)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.13

for you to fetch changes up to 0bb953dba5d295b03bb035bfc2d28ed4155df377:

  bcache: defensively handle format strings (2013-11-01 18:03:20 -0700)

----------------------------------------------------------------
Kees Cook (1):
      bcache: defensively handle format strings

Kent Overstreet (53):
      bcache: Fixed incorrect order of arguments to bio_alloc_bioset()
      bcache: Convert bch_data_verify() to immutable biovecs
      bcache: Fix a journalling performance bug
      bcache: Fix a lockdep splat
      bcache: Use blkdev_issue_discard()
      bcache: Add on error panic/unregister setting
      bcache: Stripe size isn't necessarily a power of two
      bcache: Remove unnecessary check in should_split()
      bcache: Explicitly track btree node's parent
      bcache: Add btree_insert_node()
      bcache: Insert multiple keys at a time
      bcache: Convert btree_insert_check_key() to btree_insert_node()
      bcache: Add explicit keylist arg to btree_insert()
      bcache: Clean up keylist code
      bcache: Refactor request_write()
      bcache: Refactor read request code a bit
      bcache: Refactor journalling flow control
      bcache: Move keylist out of btree_op
      bcache: Convert try_wait to wait_queue_head_t
      bcache: Convert bucket_wait to wait_queue_head_t
      bcache: Convert gc to a kthread
      bcache: Convert writeback to a kthread
      bcache: Add btree_map() functions
      bcache: Move some stuff to btree.c
      bcache: Convert bch_btree_read_async() to bch_btree_map_keys()
      bcache: Clean up cache_lookup_fn
      bcache: Prune struct btree_op
      bcache: Kill op->cl
      bcache: Drop some closure stuff
      bcache: Kill op->replace
      bcache: Don't use op->insert_collision
      bcache: Convert bch_btree_insert() to bch_btree_map_leaf_nodes()
      bcache: Break up struct search
      bcache: Move sector allocator to alloc.c
      bcache: Pull on disk data structures out into a separate header
      bcache: Fix bch_ptr_bad()
      bcache: Debug code improvements
      bcache: Don't bother with bucket refcount for btree node allocations
      bcache: bch_(btree|extent)_ptr_invalid()
      bcache: PRECEDING_KEY()
      bcache: Add btree_node_write_sync()
      bcache: Add make_btree_freeing_key()
      bcache: Incremental gc
      bcache: Avoid deadlocking in garbage collection
      bcache: Kill bch_next_recurse_key()
      bcache: Kill sequential_merge option
      bcache: Move spinlock into struct time_stats
      bcache: Have btree_split() insert into parent directly
      bcache: Better full stripe scanning
      bcache: Fix sysfs splat on shutdown with flash only devs
      bcache: Use ida for bcache block dev minor
      bcache: Delete some slower inline asm
      bcache: Bypass torture test

 drivers/md/bcache/Kconfig     |   11 +-
 drivers/md/bcache/alloc.c     |  383 +++++++-----
 drivers/md/bcache/bcache.h    |  327 +---------
 drivers/md/bcache/bset.c      |  289 ++++-----
 drivers/md/bcache/bset.h      |   93 +--
 drivers/md/bcache/btree.c     | 1386 ++++++++++++++++++++++-------------------
 drivers/md/bcache/btree.h     |  195 ++----
 drivers/md/bcache/closure.c   |  103 +--
 drivers/md/bcache/closure.h   |  183 +-----
 drivers/md/bcache/debug.c     |  202 +++---
 drivers/md/bcache/debug.h     |   50 +-
 drivers/md/bcache/journal.c   |  293 +++++----
 drivers/md/bcache/journal.h   |   52 +-
 drivers/md/bcache/movinggc.c  |   85 ++-
 drivers/md/bcache/request.c   | 1106 ++++++++++++++++----------------
 drivers/md/bcache/request.h   |   42 +-
 drivers/md/bcache/stats.c     |   26 +-
 drivers/md/bcache/stats.h     |   13 +-
 drivers/md/bcache/super.c     |  190 +++---
 drivers/md/bcache/sysfs.c     |   42 +-
 drivers/md/bcache/trace.c     |    1 -
 drivers/md/bcache/util.c      |   12 +-
 drivers/md/bcache/util.h      |   15 +-
 drivers/md/bcache/writeback.c |  455 +++++++-------
 drivers/md/bcache/writeback.h |   46 +-
 include/trace/events/bcache.h |   47 +-
 include/uapi/linux/bcache.h   |  373 +++++++++++
 27 files changed, 3006 insertions(+), 3014 deletions(-)
 create mode 100644 include/uapi/linux/bcache.h
