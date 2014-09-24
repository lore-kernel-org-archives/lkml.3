Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaIXQKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:10:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19474 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458AbaIXQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:10:29 -0400
Date: Wed, 24 Sep 2014 10:10:25 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] One last block fix
Message-ID: <20140924161025.GA25787@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-24_07:2014-09-24,2014-09-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=0.000562873213808546 kscore.compositescore=0
 circleOfTrustscore=33.2965958620397 compositescore=0.9989857498195
 urlsuspect_oldscore=0.9989857498195 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.9989857498195 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409240164
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We've had an issue with scsi-mq where probing takes forever. This was
bisected down to the percpu changes for blk_mq_queue_enter(), and the
fact we now suffer an RCU grace period when killing a queue. SCSI
creates and destroys tons of queues, so this let to 10s of seconds of
stalls at boot for some.

Tejun has a real fix for this, but it's too involved for 3.17. So this
is a temporary workaround to expedite the queue killing until we can
fold in the real fix for 3.18 when that merge window opens.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to 0a30288da1aec914e158c2d7a3482a85f632750f:

  blk-mq, percpu_ref: implement a kludge for SCSI blk-mq stall during probe (2014-09-24 08:29:36 -0600)

----------------------------------------------------------------
Tejun Heo (1):
      blk-mq, percpu_ref: implement a kludge for SCSI blk-mq stall during probe

 block/blk-mq.c                  | 11 ++++++++++-
 include/linux/percpu-refcount.h |  1 +
 lib/percpu-refcount.c           | 16 ++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

-- 
Jens Axboe

