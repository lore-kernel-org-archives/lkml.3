Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3LXR11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 12:27:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34603 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3LXR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 12:27:25 -0500
Date: Tue, 24 Dec 2013 10:27:23 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Final block fixes for 3.13
Message-ID: <20131224172706.GE1321@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A smallish collection of fixes destined for the 3.13 kernel. The pull
request contains:

- Fix for a memory leak on certain unplug events.

- A collection of bcache fixes from Kent and Nicolas.

- A few null_blk fixes and updates form Matias.

- A marking of static of functions in the stec pci-e driver.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus


Andrey Vagin (1):
      block: fix memory leaks on unplugging block device

Jens Axboe (1):
      Merge branch 'bcache-for-3.13' of git://evilpiepirate.org/~kent/linux-bcache into for-linus

Kent Overstreet (4):
      bcache: Use uninterruptible sleep in writeback
      bcache: Fix dirty_data accounting
      bcache: bugfix for race between moving_gc and bucket_invalidate
      bcache: New writeback PD controller

Matias Bjorling (4):
      null_blk: mem garbage on NUMA systems during init
      null_blk: documentation
      null_blk: refactor init and init errors code paths
      null_blk: warning on ignored submit_queues param

Matias Bjørling (3):
      null_blk: corrections to documentation
      null_blk: set use_per_node_hctx param to false
      null_blk: support submit_queues on use_per_node_hctx

Nicholas Swenson (5):
      bcache: Fix for can_attach_cache()
      bcache: Fix heap_peek() macro
      bcache: fix for gc crashing when no sectors are used
      bcache: bugfix - moving_gc now moves only correct buckets
      bcache: fix for gc and writeback race

Rashika Kheria (1):
      drivers: block: Mark the functions as static in skd_main.c

Stefan Priebe (1):
      bcache: kthread don't set writeback task to INTERUPTIBLE

Wei Yongjun (1):
      bcache: fix sparse non static symbol warning

 Documentation/block/null_blk.txt |  72 ++++++++++++++++++++++++++
 block/blk-mq-sysfs.c             |  13 +++++
 drivers/block/null_blk.c         | 107 ++++++++++++++++++++++++++++-----------
 drivers/block/skd_main.c         |   4 +-
 drivers/md/bcache/alloc.c        |   2 +
 drivers/md/bcache/bcache.h       |  12 ++---
 drivers/md/bcache/btree.c        |  27 +++++++++-
 drivers/md/bcache/movinggc.c     |  21 +++++---
 drivers/md/bcache/super.c        |   2 +-
 drivers/md/bcache/sysfs.c        |  50 ++++++++++--------
 drivers/md/bcache/util.c         |   8 ++-
 drivers/md/bcache/util.h         |   2 +-
 drivers/md/bcache/writeback.c    |  53 +++++++++----------
 13 files changed, 275 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/block/null_blk.txt

-- 
Jens Axboe

