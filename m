Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043Ab3BMUEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:04:08 -0500
Received: from mail1.windriver.com ([147.11.146.13]:61899 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3BMUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:04:07 -0500
Date: Wed, 13 Feb 2013 15:04:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jens Axboe <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] removal of 1980s PC-XT MFM 8bit ISA disk driver
Message-ID: <20130213200432.GA11018@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

Please pull the following to get the removal of the original IBM PC-XT
hard disk driver from the block layer (drivers/block/xd.c).

As near as I can tell, it hasn't seen a run time fix in over a dozen
years, and with drive sizes of 10-20MB, and performance of about 128kB/s
maximum, it is no surprise that it has been completely unused for well
over a decade.

The removal was originally posted[1] well over a month ago, and since
then, there has been nobody objecting to the removal, aside from someone
who had mistakenly confused it with a completely different driver (hd.c)

I've done a test merge followed by an allmodconfig/allyesconfig for
x86-64 on the "for-next" branch of:

 git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git

to ensure that there was no Makefile/Kconfig fallout since the 3.8-rc2
the original commit was created and tested on.

[1] https://patchwork.kernel.org/patch/1935381/

Thanks,
Paul.

---

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git delete-xt-disk

for you to fetch changes up to d1a6f4f19728d6e90480e53601a90fc9f6a348ad:

  block: delete super ancient PC-XT driver for 1980's hardware (2013-01-04 20:17:40 -0500)

----------------------------------------------------------------
Paul Gortmaker (1):
      block: delete super ancient PC-XT driver for 1980's hardware

 drivers/block/Kconfig  |   13 -
 drivers/block/Makefile |    1 -
 drivers/block/xd.c     | 1123 ------------------------------------------------
 drivers/block/xd.h     |  134 ------
 4 files changed, 1271 deletions(-)
 delete mode 100644 drivers/block/xd.c
 delete mode 100644 drivers/block/xd.h
