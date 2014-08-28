Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaH1UXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:23:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3058 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbaH1UXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:23:51 -0400
Date: Thu, 28 Aug 2014 14:23:50 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block fixes for 3.17
Message-ID: <20140828202350.GA26869@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-28_04:2014-08-28,2014-08-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.36516634558137e-08 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408280233
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Smaller collection of fixes that have come up since the initial merge
window pull request. It contains:

- Error handling cleanup and support for larger than 16 byte cdbs in
  sg_io() from Christoph. The latter just matches what bsg and friends
  support, sg_io() got left out in the merge.

- An option for brd to expose partitions in /proc/partitions. They are
  hidden by default for compat reasons. From Dmitry Monakhov.

- A few blk-mq fixes from me - killing a dead/unused flag, fix for
  merging happening even if turned off, and correction of a few
  comments.

- Removal of unnecessary ->owner setting in systemace. From Michal
  Simek.

- Two related fixes for a problem with nesting freezing of queues in
  blk-mq. One from Ming Lei removing an unecessary freeze operation, and
  another from Tejun fixing the nesting regression introduced in the
  merge window.

- Fix for a BUG_ON() at bio_endio time when protection info is attached
  and the IO has an error. From Sagi Grimberg.

- Two scsi_ioctl bug fixes for regressions with scsi-mq from Tony
  Battersby.

- A cfq weight update fix and subsequent comment update from Toshiaki
  Makita.


Please pull!

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Christoph Hellwig (2):
      block: cleanup error handling in sg_io
      block: support > 16 byte CDBs for SG_IO

Dmitry Monakhov (1):
      brd: add ram disk visibility option

Jens Axboe (3):
      blk-mq: get rid of unused BLK_MQ_F_SHOULD_SORT flag
      blk-mq: don't allow merges if turned off for the queue
      blk-mq: correct a few wrong/bad comments

Michal Simek (1):
      block: systemace: Remove .owner field for driver

Ming Lei (1):
      blk-mq: fix WARNING "percpu_ref_kill() called more than once!"

Sabrina Dubroca (1):
      block: fix error handling in sg_io

Sagi Grimberg (1):
      block: Fix BUG_ON when pi errors occur

Tejun Heo (1):
      blk-mq: blk_mq_freeze_queue() should allow nesting

Tony Battersby (2):
      scsi-mq: fix requests that use a separate CDB buffer
      fix regression in SCSI_IOCTL_SEND_COMMAND

Toshiaki Makita (2):
      cfq-iosched: Fix wrong children_weight calculation
      cfq-iosched: Add comments on update timing of weight

 block/bio-integrity.c   |  2 +-
 block/blk-core.c        |  1 -
 block/blk-mq.c          | 36 ++++++++++++++++++++++--------------
 block/cfq-iosched.c     | 19 ++++++++++++++++---
 block/scsi_ioctl.c      | 40 +++++++++++++++++++++++++++-------------
 drivers/block/brd.c     |  6 +++++-
 drivers/block/xsysace.c |  1 -
 drivers/scsi/scsi_lib.c |  1 -
 include/linux/blk-mq.h  |  7 +++----
 9 files changed, 74 insertions(+), 39 deletions(-)


-- 
Jens Axboe

