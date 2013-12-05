Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3LEVio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:38:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60952 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3LEVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:38:43 -0500
Date: Thu, 5 Dec 2013 14:38:40 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block fixes for 3.13-rc
Message-ID: <20131205213840.GA5051@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of fixes for the current series. It contains:

- A fix for a use-after-free of a request in blk-mq. From Ming Lei.

- A fix for a blk-mq bug that could attempt to dereference a NULL rq if
  allocation failed.

- Two xen-blkfront small fixes.

- Cleanup of submit_bio_wait() type uses in the kernel, unifying that.
  From Kent.

- A fix for 32-bit blkg_rwstat reading. I apologize for this one looking
  mangled in the shortlog, it's entirely my fault for missing an empty
  line between the description and body of the text.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Felipe Pena (1):
      block: xen-blkfront: Fix possible NULL ptr dereference

Hong Zhiguo (1):
      Update of blkg_stat and blkg_rwstat may happen in bh context.     While u64_stats_fetch_retry is only preempt_disable on 32bit     UP system. This is not enough to avoid preemption by bh and     may read strange 64 bit value.

Jeff Moyer (1):
      blk-mq: fix dereference of rq->mq_ctx if allocation fails

Jens Axboe (1):
      Merge branch 'stable/for-jens-3.13-take-two' of git://git.kernel.org/.../xen/tip into for-linus

Kent Overstreet (1):
      block: submit_bio_wait() conversions

Ming Lei (1):
      blk-mq: fix use-after-free of request

Tim Gardner (1):
      xen-blkfront: Silence pfn maybe-uninitialized warning

 block/blk-cgroup.h           |  8 ++++----
 block/blk-flush.c            | 19 +------------------
 block/blk-mq.c               | 16 ++++++++++------
 drivers/block/xen-blkfront.c |  7 ++++++-
 drivers/md/md.c              | 12 +-----------
 fs/btrfs/check-integrity.c   | 32 +++++++++++++-------------------
 fs/btrfs/check-integrity.h   |  2 ++
 fs/btrfs/extent_io.c         | 12 +-----------
 fs/btrfs/scrub.c             | 33 ++++-----------------------------
 fs/hfsplus/wrapper.c         | 17 +----------------
 fs/logfs/dev_bdev.c          | 13 +------------
 11 files changed, 44 insertions(+), 127 deletions(-)

-- 
Jens Axboe

