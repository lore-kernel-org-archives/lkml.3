Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3FLVA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:00:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3FLVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:00:58 -0400
Date: Wed, 12 Jun 2013 15:00:56 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block fixes for 3.10 final
Message-ID: <20130612210056.GL2600@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the final block bits for 3.10. Outside of bcache (which really
isn't super big), these are all few-liners. There are a few important
fixes in here:

- Fix blk pm sleeping when holding the queue lock

- A small collection of bcache fixes that have been done and tested
  since bcache was included in this merge window.

- A fix for a raid5 regression introduced with the bio changes.

- Two important fixes for mtip32xx, fixing an oops and potential data
  corruption (or hang) due to wrong bio iteration on stacked devices.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Aaron Lu (1):
      blkpm: avoid sleep when holding queue lock

Dan Carpenter (1):
      pktcdvd: silence static checker warning

Emil Goode (1):
      bcache: Fix incompatible pointer type warning

Gabriel (1):
      bcache: clarify free/available/unused space

Jens Axboe (2):
      Merge branch 'bcache-for-upstream' of git://evilpiepirate.org/~kent/linux-bcache into for-linus
      Merge branch 'for-jens' of git://git.kernel.org/.../jikos/linux-block into for-linus

Kent Overstreet (2):
      bcache: Fix error handling in init code
      raid5: Initialize bi_vcnt

Linus Walleij (1):
      block: remove refs to XD disks from documentation

Paul Bolle (1):
      bcache: drop "select CLOSURES"

Rusty Russell (1):
      scatterlist: sg_set_buf() argument must be in linear mapping

Sam Bradshaw (2):
      mtip32xx: Fix NULL pointer dereference during module unload
      mtip32xx: Correctly handle bio->bi_idx != 0 conditions

 Documentation/bcache.txt              |   12 ++-
 Documentation/devices.txt             |    8 +-
 Documentation/kernel-parameters.txt   |    3 -
 Documentation/m68k/kernel-options.txt |    2 -
 block/blk-core.c                      |    2 +-
 drivers/block/mtip32xx/mtip32xx.c     |    8 +-
 drivers/block/pktcdvd.c               |    3 +-
 drivers/md/bcache/Kconfig             |    1 -
 drivers/md/bcache/bcache.h            |    2 +-
 drivers/md/bcache/stats.c             |   34 +++---
 drivers/md/bcache/super.c             |  185 +++++++++++++++------------------
 drivers/md/bcache/writeback.c         |    2 +-
 drivers/md/raid5.c                    |    2 +
 include/linux/scatterlist.h           |    3 +
 14 files changed, 124 insertions(+), 143 deletions(-)

-- 
Jens Axboe

