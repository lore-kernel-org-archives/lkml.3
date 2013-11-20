Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3KTCnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 21:43:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3KTCn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 21:43:28 -0500
Date: Tue, 19 Nov 2013 19:43:25 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULL] Block fixes for 3.13-rc1
Message-ID: <20131120024325.GA30914@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Normally I'd defer my initial for-linus pull request until after the
merge window, but a race was uncovered in the virtio-blk conversion to
blk-mq that could cause hangs. So here's a small collection of fixes for
you to pull:

- The fix for the virtio-blk IO hang reported by Dave Chinner, from
  Shaohua and myself.

- Add the Insert blktrace event for blk-mq. This makes 'btt' happy when
  it is doing it's state transition analysis.

- Ensure that blk-mq has disk/partition stats enabled by default,
  instead of making it opt-in.

- A fix for __bio_add_page() and large sector counts.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus


Akinobu Mita (1):
      bio: fix argument of __bio_add_page() for max_sectors > 0xffff

Jens Axboe (2):
      blk-mq: ensure that we set REQ_IO_STAT so diskstats work
      blk-mq: add blktrace insert event trace

Shaohua Li (1):
      virtio-blk: virtqueue_kick() must be ordered with other virtqueue operations

 block/blk-mq.c             | 14 ++++++++++----
 drivers/block/virtio_blk.c |  5 +++--
 fs/bio.c                   |  2 +-
 include/linux/blkdev.h     |  3 +++
 4 files changed, 17 insertions(+), 7 deletions(-)


-- 
Jens Axboe

