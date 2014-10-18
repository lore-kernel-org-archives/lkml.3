Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaJROx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:53:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44601 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbaJROx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:53:27 -0400
Date: Sat, 18 Oct 2014 08:53:18 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block driver pull for 3.18
Message-ID: <20141018145318.GB31955@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-18_02:2014-10-17,2014-10-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=33.2965958620397
 compositescore=0.9989857498195 urlsuspect_oldscore=0.9989857498195
 suspectscore=3 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.9989857498195 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410180155
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the block driver pull request for 3.18. Not a lot in there this
round, and nothing earth shattering.

- A round of drbd fixes from the linbit team, and an improvement in
  asender performance.

- Removal of deprecated (and unused) IRQF_DISABLED flag in rsxx and hd
  from Michael Opdenacker.

- Disable entropy collection from flash devices by default, from Mike
  Snitzer.

- A small collection of xen blkfront/back fixes from Roger Pau Monné and
  Vitaly Kuznetsov.

Please pull!

  git://git.kernel.dk/linux-block.git for-3.18/drivers

----------------------------------------------------------------
Andreas Gruenbacher (5):
      drbd: Use better variable names
      drbd: Use consistent names for all the bi_end_io callbacks
      drbd: Avoid inconsistent locking warning
      drbd: Get rid of the __no_warn and __cond_lock macros
      drbd: Get rid of the WORK_PENDING macro

Arianna Avanzini (1):
      xen, blkfront: factor out flush-related checks from do_blkif_request()

Jens Axboe (1):
      Merge branch 'stable/for-jens-3.18' of git://git.kernel.org/.../konrad/xen into for-3.18/drivers

Lai Jiangshan (2):
      drbd: compute the end before rb_insert_augmented()
      drbd: use RB_DECLARE_CALLBACKS() to define augment callbacks

Lars Ellenberg (2):
      drbd: Improve asender performance
      drbd: reduce lock contention in drbd_worker

Michael Opdenacker (2):
      block: hd: remove deprecated IRQF_DISABLED
      rsxx: Remove deprecated IRQF_DISABLED

Mike Snitzer (1):
      block: disable entropy contributions for nonrot devices

Philipp Marek (1):
      drbd: Remove superfluous newline from "resync_extents" debugfs entry.

Philipp Reisner (1):
      drbd: Add missing newline in resync progress display in /proc/drbd

Roger Pau Monné (1):
      xen-blkback: fix leak on grant map error path

Roger Pau Monné (1):
Vitaly Kuznetsov (1):
      xen/blkback: unmap all persistent grants when frontend gets disconnected

 drivers/block/drbd/drbd_actlog.c    |  4 +--
 drivers/block/drbd/drbd_bitmap.c    |  6 ++---
 drivers/block/drbd/drbd_debugfs.c   |  2 +-
 drivers/block/drbd/drbd_int.h       | 19 +++++++-------
 drivers/block/drbd/drbd_interval.c  | 40 +++++-----------------------
 drivers/block/drbd/drbd_main.c      | 28 ++++++++++----------
 drivers/block/drbd/drbd_proc.c      |  4 ++-
 drivers/block/drbd/drbd_receiver.c  | 52 +++++++++++++++++++++----------------
 drivers/block/drbd/drbd_req.c       |  2 +-
 drivers/block/drbd/drbd_state.c     | 18 ++++++-------
 drivers/block/drbd/drbd_worker.c    | 51 +++++++++++++++---------------------
 drivers/block/hd.c                  | 12 +--------
 drivers/block/mtip32xx/mtip32xx.c   |  1 +
 drivers/block/nbd.c                 |  1 +
 drivers/block/null_blk.c            |  1 +
 drivers/block/nvme-core.c           |  1 +
 drivers/block/rsxx/core.c           |  2 +-
 drivers/block/rsxx/dev.c            |  1 +
 drivers/block/skd_main.c            |  1 +
 drivers/block/xen-blkback/blkback.c |  1 +
 drivers/block/xen-blkback/xenbus.c  |  6 ++---
 drivers/block/xen-blkfront.c        | 12 ++++++---
 drivers/block/zram/zram_drv.c       |  1 +
 drivers/ide/ide-disk.c              |  4 ++-
 drivers/md/bcache/super.c           |  1 +
 drivers/mmc/card/queue.c            |  1 +
 drivers/mtd/mtd_blkdevs.c           |  1 +
 drivers/s390/block/scm_blk.c        |  1 +
 drivers/s390/block/xpram.c          |  1 +
 drivers/scsi/sd.c                   |  4 ++-
 30 files changed, 132 insertions(+), 147 deletions(-)
-- 
Jens Axboe

