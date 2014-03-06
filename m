Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaCFQxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:53:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64848 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbaCFQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:53:05 -0500
Date: Thu, 6 Mar 2014 09:53:02 -0700
From: Jens Axboe <axboe@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Final block fixes for 3.14
Message-ID: <20140306165302.GA26301@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-06_05:2014-03-05,2014-03-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=7.0302659978126
 compositescore=0.998049563855454 urlsuspect_oldscore=0.998049563855454
 suspectscore=2 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1403060077
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Small collection of fixes for 3.14-rc. It contains:

- Three minor update to blk-mq from Christoph.

- Reduce number of unaligned (< 4kb) in-flight writes on mtip32xx to 2.
  From Micron.

- Make the blk-mq CPU notify spinlock raw, since it can't be a sleeper
  spinlock on RT. From Mike Galbraith.

- Drop now bogus BUG_ON() for bio iteration with blk integrity. From Nic
  Bellinger.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Asai Thambi S P (1):
      mtip32xx: Reduce the number of unaligned writes to 2

Christoph Hellwig (3):
      blk-mq: remove blk_mq_alloc_rq
      blk-mq: merge blk_mq_insert_request and blk_mq_run_request
      blk-mq: support partial I/O completions

Mike Galbraith (1):
      rt,blk,mq: Make blk_mq_cpu_notify_lock a raw spinlock

Nicholas Bellinger (1):
      bio-integrity: Drop bio_integrity_verify BUG_ON in post bip->bip_iter world

 block/blk-exec.c                  |   2 +-
 block/blk-flush.c                 |   4 +-
 block/blk-mq-cpu.c                |  14 +++---
 block/blk-mq.c                    | 100 +++++++-------------------------------
 block/blk-mq.h                    |   1 -
 drivers/block/mtip32xx/mtip32xx.h |   2 +-
 fs/bio-integrity.c                |   5 +-
 include/linux/blk-mq.h            |  11 +++--
 8 files changed, 37 insertions(+), 102 deletions(-)

-- 
Jens Axboe

