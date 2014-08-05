Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaHEEdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:33:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40979 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaHEEdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:33:13 -0400
Date: Mon, 4 Aug 2014 21:33:46 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] bcache changes for 3.17
Message-ID: <20140805043346.GF541@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens, here's the pull request for 3.17 - typically late, but lots of tasty
fixes in this one :)

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  http://evilpiepirate.org/git/linux-bcache.git for-jens

for you to fetch changes up to 0781c8748cf1ea2b0dcd966571103909528c4efa:

  bcache: Drop unneeded blk_sync_queue() calls (2014-08-04 15:23:04 -0700)

----------------------------------------------------------------
Jianjian Huo (1):
      bcache: add mutex lock for bch_is_open

Kent Overstreet (7):
      bcache: Fix a bug when detaching
      bcache: Fix a journal replay bug
      bcache: Make sure to pass GFP_WAIT to mempool_alloc()
      bcache: Allocate bounce buffers with GFP_NOWAIT
      bcache: Fix an infinite loop in journal replay
      bcache: Fix more early shutdown bugs
      bcache: Drop unneeded blk_sync_queue() calls

Slava Pestov (12):
      bcache allocator: send discards with correct size
      bcache: fix lockdep warnings on shutdown
      bcache: fix crash on shutdown in passthrough mode
      bcache: wait for buckets when allocating new btree root
      bcache: fix uninterruptible sleep in writeback thread
      bcache: fix typo in bch_bkey_equal_header
      bcache: bcache_write tracepoint was crashing
      bcache: fix crash in bcache_btree_node_alloc_fail tracepoint
      bcache: fix use-after-free in btree_gc_coalesce()
      bcache: fix crash with incomplete cache set
      bcache: fix memory corruption in init error path
      bcache: try to set b->parent properly

Surbhi Palande (2):
      bcache: Fix to remove the rcu_sched stalls.
      bcache: Correct printing of btree_gc_max_duration_ms

 drivers/md/bcache/alloc.c     |  2 +-
 drivers/md/bcache/bcache.h    |  4 +++
 drivers/md/bcache/bset.c      |  2 +-
 drivers/md/bcache/bset.h      |  2 +-
 drivers/md/bcache/btree.c     | 50 ++++++++++++++++++++++---------------
 drivers/md/bcache/btree.h     |  5 ++--
 drivers/md/bcache/extents.c   | 13 +++++++---
 drivers/md/bcache/extents.h   |  1 +
 drivers/md/bcache/journal.c   | 24 +++++++++++-------
 drivers/md/bcache/request.c   |  3 ++-
 drivers/md/bcache/super.c     | 57 ++++++++++++++++++++++++++++---------------
 drivers/md/bcache/util.h      |  4 +--
 drivers/md/bcache/writeback.c | 14 ++++++++---
 drivers/md/bcache/writeback.h |  3 ++-
 include/trace/events/bcache.h | 21 +++++++++-------
 15 files changed, 131 insertions(+), 74 deletions(-)
