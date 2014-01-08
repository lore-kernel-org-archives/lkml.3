Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaAHVRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:17:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55489 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:17:51 -0500
Date: Wed, 8 Jan 2014 13:19:07 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] bcache for 3.14
Message-ID: <20140108211907.GD7291@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, here's the updated bcache pull, rebased and retested on top of
your latest for-3.14/drivers branch. Only other change was a one liner
in the "bcache/md: Use raid stripe size" patch to update
blk_stack_limits(), as pointed out by Mike Snitzer.


The following changes since commit 54a387cb9e600256e50cb9e2209e7e4f06f464de:

  Merge branch 'for-3.14/core' into for-3.14/drivers (2014-01-08 09:32:45 -0700)

are available in the git repository at:


  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.14

for you to fetch changes up to 9dd6358a21daf4fc6a5b2b779267a62f0d1d3181:

  bcache: Fix auxiliary search trees for key size > cacheline size (2014-01-08 13:05:15 -0800)

----------------------------------------------------------------
Kent Overstreet (32):
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

Nicholas Swenson (2):
      bcache: update bch_bkey_try_merge
      bcache: Add bch_bkey_equal_header()

 block/blk-settings.c          |   4 +
 drivers/md/bcache/Makefile    |   5 +-
 drivers/md/bcache/alloc.c     |  89 +++--
 drivers/md/bcache/bcache.h    |  82 ++--
 drivers/md/bcache/bset.c      | 904 +++++++++++++++++++++++-------------------
 drivers/md/bcache/bset.h      | 440 +++++++++++++-------
 drivers/md/bcache/btree.c     | 676 ++++++++++++-------------------
 drivers/md/bcache/btree.h     |  62 +--
 drivers/md/bcache/closure.c   |  90 +----
 drivers/md/bcache/closure.h   | 355 +++++------------
 drivers/md/bcache/debug.c     | 247 +++---------
 drivers/md/bcache/debug.h     |  27 +-
 drivers/md/bcache/extents.c   | 616 ++++++++++++++++++++++++++++
 drivers/md/bcache/extents.h   |  13 +
 drivers/md/bcache/journal.c   |  75 ++--
 drivers/md/bcache/journal.h   |   1 +
 drivers/md/bcache/movinggc.c  |   2 +-
 drivers/md/bcache/request.c   |  72 ++--
 drivers/md/bcache/request.h   |  21 +-
 drivers/md/bcache/super.c     | 103 +++--
 drivers/md/bcache/sysfs.c     |  79 ++--
 drivers/md/bcache/util.h      |   8 +
 drivers/md/raid5.c            |   1 +
 include/linux/blkdev.h        |   1 +
 include/trace/events/bcache.h |  10 +-
 include/uapi/linux/bcache.h   |   3 +-
 26 files changed, 2225 insertions(+), 1761 deletions(-)
 create mode 100644 drivers/md/bcache/extents.c
 create mode 100644 drivers/md/bcache/extents.h
