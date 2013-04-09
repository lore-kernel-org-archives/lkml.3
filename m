Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936716Ab3DIOu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:50:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33171 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab3DIOu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:50:26 -0400
Date: Tue, 9 Apr 2013 16:50:07 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Final block fixes for 3.9
Message-ID: <20130409145007.GI12244@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I've got a few smaller fixes queued up for 3.9 that should go in. The
major one is the loop regression, the others are nice fixes on their own
though. It contains:

- Fix for unitialized var in the block sysfs code, courtesy of Arnd and
  gcc-4.8.

- Two fixes for mtip32xx, fixing probe and command timeout. Also a debug
  measure that could have waited for 3.10, but it's driver only, so I
  let it slip in.

- Revert the loop partition cleanup fix, it could cause a deadlock on
  auto-teardown as part of umount. The fix is clear, but at this point
  we just want to revert it and get a real fix in for 3.10.

Please pull! Tag is signed.

  git://git.kernel.dk/linux-block.git tags/for-linus-20130409

----------------------------------------------------------------
for-linus-20130409

----------------------------------------------------------------
Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store

Asai Thambi S P (3):
      mtip32xx: recovery from command timeout
      mtip32xx: return 0 from pci probe in case of rebuild
      mtip32xx: Add debugfs entry device_status

Jens Axboe (2):
      mtip32xx: fix two smatch warnings
      Revert "loop: cleanup partitions when detaching loop device"

 block/blk-sysfs.c                 |   2 +
 block/partition-generic.c         |   1 -
 drivers/block/loop.c              |  21 +--
 drivers/block/mtip32xx/mtip32xx.c | 327 +++++++++++++++++++++++++++-----------
 drivers/block/mtip32xx/mtip32xx.h |  18 ++-
 5 files changed, 247 insertions(+), 122 deletions(-)

-- 
Jens Axboe

