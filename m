Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaILTRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:17:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46659 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186AbaILTRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:17:16 -0400
Date: Fri, 12 Sep 2014 13:17:11 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block updates for 3.17-rc
Message-ID: <20140912191711.GA21045@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-12_07:2014-09-12,2014-09-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=8.20892909203508e-10 kscore.compositescore=0
 circleOfTrustscore=37.7501936418875 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409120172
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of fixes for the current rc series. It contains:

- Two small blk-mq patches from Rob Elliott, cleaning up error case at
  init time.

- A fix from Ming Lei, fixing SG merging for blk-mq where
  QUEUE_FLAG_SG_NO_MERGE is the default.

- A dev_t minor lifetime fix from Keith, fixing an issue where a minor
  might be reused before all references to it were gone.

- Fix from Alan Stern where an unbalanced queue bypass caused SCSI some
  headaches when it does a series of add/del on devices without fully
  registrering the queue.

- A fix from me for improving the scaling of tag depth in blk-mq if we
  are short on memory.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to a516440542afcb9647f88d12c35640baf02d07ea:

  blk-mq: scale depth and rq map appropriate if low on memory (2014-09-10 09:02:03 -0600)

----------------------------------------------------------------
Alan Stern (1):
      Block: fix unbalanced bypass-disable in blk_register_queue

Jens Axboe (1):
      blk-mq: scale depth and rq map appropriate if low on memory

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime

Ming Lei (1):
      blk-merge: fix blk_recount_segments

Robert Elliott (2):
      blk-mq: pass along blk_mq_alloc_tag_set return values
      blk-mq: cleanup after blk_mq_init_rq_map failures

 block/blk-merge.c                 | 17 +++++---
 block/blk-mq.c                    | 91 +++++++++++++++++++++++++++++++--------
 block/blk-sysfs.c                 |  6 ++-
 block/genhd.c                     | 24 ++++++-----
 block/partition-generic.c         |  2 +-
 drivers/block/mtip32xx/mtip32xx.c |  1 -
 drivers/block/null_blk.c          | 29 +++++++++----
 7 files changed, 123 insertions(+), 47 deletions(-)

-- 
Jens Axboe

