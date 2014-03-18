Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbaCRT4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:56:10 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58382 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbaCRT4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:56:07 -0400
Date: Tue, 18 Mar 2014 12:56:03 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [GIT PULL] bcache changes for 3.15
Message-ID: <20140318195603.GI11655@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, here's the bcache changes for 3.15. Lots of bugfixes, and some refactoring
and cleanups.

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.15

for you to fetch changes up to cb85114956dc88b287afca2872658f562acbc302:

  bcache: remove nested function usage (2014-03-18 12:39:28 -0700)

----------------------------------------------------------------
John Sheu (1):
      bcache: remove nested function usage

Kent Overstreet (21):
      bcache: Fix another compiler warning on m68k
      bcache: Fix flash_dev_cache_miss() for real this time
      bcache: Fix a shutdown bug
      bcache: Fix a lockdep splat in an error path
      bcache: Fix a null ptr deref in journal replay
      bcache: Fix a journalling reclaim after recovery bug
      bcache: Fix a bug recovering from unclean shutdown
      bcache: Fix another bug recovering from unclean shutdown
      bcache: Fix discard granularity
      bcache: Fix moving_pred()
      bcache: Kill dead cgroup code
      bcache: Better alloc tracepoints
      bcache: Improve priority_stats
      bcache: Add bch_keylist_init_single()
      bcache: Add a real GC_MARK_RECLAIMABLE
      bcache: Fix a race when freeing btree nodes
      bcache: btree locking rework
      bcache: Kill btree_io_wq
      bcache: Rework btree cache reserve handling
      bcache: Kill unused freelist
      bcache: Kill bucket->gc_gen

Nicholas Swenson (2):
      bcache: Fix moving_gc deadlocking with a foreground write
      bcache: stop moving_gc marking buckets that can't be moved.

 drivers/md/bcache/Kconfig     |   8 -
 drivers/md/bcache/alloc.c     | 173 +++++-------
 drivers/md/bcache/bcache.h    |  56 ++--
 drivers/md/bcache/bset.c      |   4 +-
 drivers/md/bcache/bset.h      |   6 +
 drivers/md/bcache/btree.c     | 592 ++++++++++++++++++++++++------------------
 drivers/md/bcache/btree.h     |  12 +-
 drivers/md/bcache/extents.c   |  36 +--
 drivers/md/bcache/journal.c   |  46 ++--
 drivers/md/bcache/journal.h   |   1 +
 drivers/md/bcache/movinggc.c  |  18 +-
 drivers/md/bcache/request.c   | 201 +-------------
 drivers/md/bcache/request.h   |  19 +-
 drivers/md/bcache/stats.c     |   3 -
 drivers/md/bcache/super.c     |  64 ++---
 drivers/md/bcache/sysfs.c     | 155 ++++++-----
 drivers/md/bcache/trace.c     |   2 +-
 include/trace/events/bcache.h |  52 ++--
 18 files changed, 664 insertions(+), 784 deletions(-)
