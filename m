Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaFDVCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:02:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12825 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbaFDVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:02:48 -0400
Date: Wed, 4 Jun 2014 15:02:43 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block core followup bits for -rc1
Message-ID: <20140604210243.GA32698@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-04_04:2014-06-04,2014-06-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=4.37500036198912e-12 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=58
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406040264
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few minor (but important) fixes for blk-mq for the -rc1 window.

- Hot removal potential oops fix for single queue devices. From me.

- Two merged patches in late May meant that we accidentally lost a fix
  for freeing an active queue. Fix that up. From me.

- A change of the blk_mq_tag_to_rq() API, passing in blk_mq_tags, to
  make life considerably easier for scsi-mq. From me.

- A schedule-while-atomic fix from Ming Lei, which would hit if the tag
  space was exhausted.

- Missing __percpu annotation in one place in blk-mq. Found by the magic
  Wu compile bot due to code being moved around by the previous patch,
  but it's actually an older issue. From Ming Lei.

- Clearing of tag of a flush request at end_io time. From Ming Lei.

Please pull!


  git://git.kernel.dk/linux-block.git for-linus


----------------------------------------------------------------
Jens Axboe (3):
      blk-mq: handle NULL req return from blk_map_request in single queue mode
      blk-mq: fix regression from commit 624dbe475416
      blk-mq: let blk_mq_tag_to_rq() take blk_mq_tags as the main parameter

Ming Lei (4):
      blk-mq: move blk_mq_get_ctx/blk_mq_put_ctx to mq private header
      blk-mq: fix schedule from atomic context
      blk-mq: fix sparse warning on missed __percpu annotation
      block: mq flush: clear flush_rq's tag in flush_end_io()

 block/blk-flush.c                 |  2 +-
 block/blk-mq-tag.c                | 48 ++++++++++++++--------
 block/blk-mq-tag.h                |  2 +-
 block/blk-mq.c                    | 83 +++++++++++++++++++--------------------
 block/blk-mq.h                    | 45 +++++++++++++++++++++
 drivers/block/mtip32xx/mtip32xx.c |  4 +-
 include/linux/blk-mq.h            |  2 +-
 include/linux/blkdev.h            |  2 +-
 8 files changed, 123 insertions(+), 65 deletions(-)

-- 
Jens Axboe

