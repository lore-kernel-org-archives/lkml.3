Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3IVVzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:55:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3IVVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:55:22 -0400
Date: Sun, 22 Sep 2013 15:55:20 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block IO fixes for 3.12
Message-ID: <20130922215520.GE31014@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After merge window, no new stuff this time only a collection of neatly
confined and simple fixes. Please pull!


  git://git.kernel.dk/linux-block.git for-3.12/core

for you to fetch changes up to f3cff25f05f2ac29b2ee355e611b0657482f6f1d:

  cfq: explicitly use 64bit divide operation for 64bit arguments (2013-09-22 12:43:47 -0600)

----------------------------------------------------------------
Anatol Pomozov (1):
      cfq: explicitly use 64bit divide operation for 64bit arguments

Bjorn Helgaas (1):
      bio-integrity: Fix use of bs->bio_integrity_pool after free

Jianpeng Ma (1):
      block: trace all devices plug operation

Joe Perches (1):
      block: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

Jun'ichi Nomura (1):
      block: Add nr_bios to block_rq_remap tracepoint

Mike Christie (1):
      If the queue is dying then we only call the rq->end_io callout.     This leaves bios setup on the request, because the caller assumes when     the blk_execute_rq_nowait/blk_execute_rq call has completed that     the rq->bios have been cleaned up.

Tejun Heo (1):
      blkcg: relocate root_blkg setting and clearing

 block/blk-cgroup.c           | 25 +++++++++++++++----------
 block/blk-core.c             |  6 ++----
 block/blk-exec.c             |  4 ++--
 block/cfq-iosched.c          |  4 ++--
 block/deadline-iosched.c     |  2 +-
 block/elevator.c             |  2 +-
 block/genhd.c                |  3 +--
 fs/bio-integrity.c           |  2 +-
 include/linux/blkdev.h       | 11 +++++++++++
 include/trace/events/block.h |  6 ++++--
 10 files changed, 40 insertions(+), 25 deletions(-)

-- 
Jens Axboe

