Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab3BTA3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:29:44 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36434 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934923Ab3BTAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:22:53 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk
Subject: [PATCH 00/27] Block cleanups - prep work for immutable bio vecs/dio rewrite
Date: Tue, 19 Feb 2013 16:22:14 -0800
Message-Id: <1361319761-23873-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - this is the patch series I was working on a couple months ago,
and then got sidetracked on.

I rebased it onto your for-3.9/core branch. Nothing's changed (besides a
few random merge conflicts) since the last time I mailed it out - I
think all this stuff is ready.


Kent Overstreet (27):
  block: Reorder struct bio_set
  block: Avoid deadlocks with bio allocation by stacking drivers
  block: Fix a buffer overrun in bio_integrity_split()
  block: Convert integrity to bvec_alloc_bs()
  block: Add bio_advance()
  block: Refactor blk_update_request()
  md: Convert md_trim_bio() to use bio_advance()
  block: Add bio_end_sector()
  block: Use bio_sectors() more consistently
  block: Change bio_split() to respect the current value of bi_idx
  block: Remove bi_idx references
  block: Remove some unnecessary bi_vcnt usage
  block: Add submit_bio_wait(), remove from md
  raid10: Use bio_reset()
  raid1: use bio_reset()
  raid5: use bio_reset()
  raid1: Refactor narrow_write_error() to not use bi_idx
  block: Add bio_copy_data()
  pktcdvd: use bio_copy_data()
  pktcdvd: Use bio_reset() in disabled code to kill bi_idx usage
  raid1: use bio_copy_data()
  bounce: Refactor __blk_queue_bounce to not use bi_io_vec
  block: Add bio_for_each_segment_all()
  block: Convert some code to bio_for_each_segment_all()
  block: Add bio_alloc_pages()
  block: Add an explicit bio flag for bios that own their bvec
  bio-integrity: Add explicit field for owner of bip_buf

 block/blk-core.c                         |  82 ++-----
 block/cfq-iosched.c                      |   7 +-
 block/deadline-iosched.c                 |   2 +-
 drivers/block/aoe/aoecmd.c               |   2 +-
 drivers/block/brd.c                      |   3 +-
 drivers/block/floppy.c                   |   1 -
 drivers/block/pktcdvd.c                  | 102 ++-------
 drivers/block/rbd.c                      |   2 +-
 drivers/md/dm-crypt.c                    |   3 +-
 drivers/md/dm-raid1.c                    |   2 +-
 drivers/md/dm-stripe.c                   |   2 +-
 drivers/md/dm-verity.c                   |   4 +-
 drivers/md/faulty.c                      |   6 +-
 drivers/md/linear.c                      |   3 +-
 drivers/md/md.c                          |  17 +-
 drivers/md/raid0.c                       |   9 +-
 drivers/md/raid1.c                       | 133 ++++-------
 drivers/md/raid10.c                      |  78 ++-----
 drivers/md/raid5.c                       |  49 ++---
 drivers/message/fusion/mptsas.c          |   6 +-
 drivers/s390/block/dcssblk.c             |   3 +-
 drivers/scsi/libsas/sas_expander.c       |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  10 +-
 fs/bio-integrity.c                       | 144 +++++-------
 fs/bio.c                                 | 366 +++++++++++++++++++++++++++----
 fs/btrfs/extent_io.c                     |   3 +-
 fs/btrfs/volumes.c                       |   2 +-
 fs/buffer.c                              |   1 -
 fs/direct-io.c                           |   8 +-
 fs/exofs/ore.c                           |   2 +-
 fs/exofs/ore_raid.c                      |   2 +-
 fs/gfs2/lops.c                           |   2 +-
 fs/jfs/jfs_logmgr.c                      |   2 -
 fs/logfs/dev_bdev.c                      |   5 -
 include/linux/bio.h                      | 115 ++++++----
 include/linux/blk_types.h                |   3 +
 include/trace/events/block.h             |  12 +-
 mm/bounce.c                              |  75 ++-----
 mm/page_io.c                             |   1 -
 39 files changed, 645 insertions(+), 630 deletions(-)

-- 
1.7.12

