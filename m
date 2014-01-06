Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbaAFW5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:57:06 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53076 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbaAFW5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:57:00 -0500
Date: Mon, 6 Jan 2014 14:56:56 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] Bcache for 3.14
Message-ID: <20140106225656.GG9037@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - here's the bcache pull for 3.14, on top of your for-3.14/drivers branch.

First 11 patches are duplicates of the bcache patches in v3.13-rc5 but not your
for-3.14 drivers branch.

The following changes since commit 8586ea96b4f919a9b38929040bc9ce57c9998fc4:

  pktcdvd: fix error return code (2014-01-03 10:05:34 +0100)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.14

for you to fetch changes up to e793d59db9369522b676365fae553897ea1846a7:

  bcache: Fix auxiliary search trees for key size > cacheline size (2014-01-06 14:52:09 -0800)

----------------------------------------------------------------
Kent Overstreet (36):
      bcache: Use uninterruptible sleep in writeback
      bcache: Fix dirty_data accounting
      bcache: bugfix for race between moving_gc and bucket_invalidate
      bcache: New writeback PD controller
      bcache: Data corruption fix
      bcache: Minor journal fix
      bcache: Performance fix for when journal entry is full
      bcache: Minor btree cache fix
      bcache: Don't touch bucket gen for dirty ptrs
      bcache: Zero less memory
      bcache: kill closure locking usage
      bcache: kill closure locking code
      bcache: Rework allocator reserves
      bcache: Do bkey_put() in btree_split() error path
      bcache/md: Use raid stripe size
      bcache: Trivial error handling fix
      bcache: kill index()
      bcache: Btree verify code improvements
      bcache: Use a mempool for mergesort temporary space
      bcache: Remove/fix some header dependencies
      bcache: Make bch_keylist_realloc() take u64s, not nptrs
      bcache: Bkey indexing renaming
      bcache: Split out sort_extent_cmp()
      bcache: Add struct bset_sort_state
      bcache: Rename/shuffle various code around
      bcache: Abstract out stuff needed for sorting
      bcache: Add struct btree_keys
      bcache: Add bch_btree_keys_u64s_remaining()
      bcache: Refactor bset_tree sysfs stats
      bcache: Convert btree_iter to struct btree_keys
      bcache: Convert debug code to btree_keys
      bcache: Convert sorting to btree_keys
      bcache: Move insert_fixup() to btree_keys_ops
      bcache: Improve bucket_prio() calculation
      bcache: Don't return -EINTR when insert finished
      bcache: Fix auxiliary search trees for key size > cacheline size

Nicholas Swenson (7):
      bcache: Fix for can_attach_cache()
      bcache: Fix heap_peek() macro
      bcache: fix for gc crashing when no sectors are used
      bcache: bugfix - moving_gc now moves only correct buckets
      bcache: fix for gc and writeback race
      bcache: update bch_bkey_try_merge
      bcache: Add bch_bkey_equal_header()

Stefan Priebe (1):
      bcache: kthread don't set writeback task to INTERUPTIBLE

Wei Yongjun (1):
      bcache: fix sparse non static symbol warning

 drivers/md/bcache/Makefile    |   5 +-
 drivers/md/bcache/alloc.c     |  91 +++--
 drivers/md/bcache/bcache.h    |  94 ++---
 drivers/md/bcache/bset.c      | 904 +++++++++++++++++++++++-------------------
 drivers/md/bcache/bset.h      | 440 +++++++++++++-------
 drivers/md/bcache/btree.c     | 699 +++++++++++++-------------------
 drivers/md/bcache/btree.h     |  62 +--
 drivers/md/bcache/closure.c   |  90 +----
 drivers/md/bcache/closure.h   | 355 +++++------------
 drivers/md/bcache/debug.c     | 247 +++---------
 drivers/md/bcache/debug.h     |  27 +-
 drivers/md/bcache/extents.c   | 616 ++++++++++++++++++++++++++++
 drivers/md/bcache/extents.h   |  13 +
 drivers/md/bcache/journal.c   |  75 ++--
 drivers/md/bcache/journal.h   |   1 +
 drivers/md/bcache/movinggc.c  |  23 +-
 drivers/md/bcache/request.c   |  72 ++--
 drivers/md/bcache/request.h   |  21 +-
 drivers/md/bcache/super.c     | 105 +++--
 drivers/md/bcache/sysfs.c     | 129 +++---
 drivers/md/bcache/util.c      |   8 +-
 drivers/md/bcache/util.h      |  10 +-
 drivers/md/bcache/writeback.c |  53 ++-
 drivers/md/raid5.c            |   1 +
 include/linux/blkdev.h        |   1 +
 include/trace/events/bcache.h |  10 +-
 include/uapi/linux/bcache.h   |   3 +-
 27 files changed, 2330 insertions(+), 1825 deletions(-)
 create mode 100644 drivers/md/bcache/extents.c
 create mode 100644 drivers/md/bcache/extents.h
