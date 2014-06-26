Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbaFZRRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:17:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26833 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753043AbaFZRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:17:03 -0400
Date: Thu, 26 Jun 2014 11:17:12 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block changes for 3.16-rc
Message-ID: <20140626171712.GA20475@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-26_06:2014-06-26,2014-06-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.05219216357023e-12 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=11
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=4
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406260178
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of fixes/changes for the current series. The pull
request contains:

- Removal of dead code from Gu Zheng.

- Revert of two bad fixes that went in earlier in this round, marking
  things as __init that were not purely used from init.

- A fix for blk_mq_start_hw_queue() using the __blk_mq_run_hw_queue(),
  which could place us wrongly. Make it use the non __ variant, which
  handles cases where we are called from the wrong CPU set. From me.

- A fix for drbd, which allocates discard requests without room for the
  SCSI payload. From Lars Ellenberg.

- A fix for user-after-free in the blkcg code from Tejun.

- Addition of limiting gaps in SG lists, if the hardware needs it. This
  is the last pre-req patch for blk-mq to enable the full NVMe
  conversion. Could wait until 3.17, but it's simple enough so would be
  nice to have everything we need for the NVMe port in the 3.17 release.
  From me.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Gu Zheng (1):
      bio: remove unused macro bip_vec_idx()

Jens Axboe (5):
      Merge branch 'for-jens' of git://git.kernel.org/.../jikos/linux-block into for-linus
      Revert "block: add __init to blkcg_policy_register"
      Revert "block: add __init to elv_register"
      block: add support for limiting gaps in SG lists
      blk-mq: blk_mq_start_hw_queue() should use blk_mq_run_hw_queue()

Jiri Kosina (1):
      floppy: format block0 read error message properly

Lars Ellenberg (1):
      drbd: fix NULL pointer deref in blk_add_request_payload

Tejun Heo (1):
      blkcg: fix use-after-free in __blkg_release_rcu() by making blkcg_gq refcnt an atomic_t

 block/bio.c                        |  8 ++++++++
 block/blk-cgroup.c                 |  9 +++------
 block/blk-cgroup.h                 | 21 +++++++++------------
 block/blk-merge.c                  | 10 ++++++++++
 block/blk-mq.c                     |  2 +-
 block/elevator.c                   |  2 +-
 drivers/block/drbd/drbd_receiver.c |  5 ++++-
 drivers/block/floppy.c             |  2 +-
 include/linux/bio.h                | 13 +++++++++----
 include/linux/blkdev.h             |  1 +
 include/linux/elevator.h           |  2 +-
 11 files changed, 48 insertions(+), 27 deletions(-)

-- 
Jens Axboe

