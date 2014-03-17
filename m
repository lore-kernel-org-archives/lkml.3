Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaCQQcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:32:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57246 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbaCQQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:32:45 -0400
Date: Mon, 17 Mar 2014 10:32:41 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Final (final) block IO fixes for 3.14
Message-ID: <20140317163241.GA23606@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-17_02:2014-03-14,2014-03-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.55111512312578e-17 kscore.compositescore=0
 circleOfTrustscore=6.94282017626843 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=12
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1403170084
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Yes, the last round was final. This one is final final. The mtip32xx fix
could have waited, but it's so simple and gets rid of two warning
spewages on load. The two block flush fixes are critical for blk-mq, and
are the primary reason for this late pull request.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to 7f328908f9cb69a72ce1c9279508c786cf85f1f5:

  mtip32xx: fix bad use of smp_processor_id() (2014-03-10 14:32:47 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      mtip32xx: fix bad use of smp_processor_id()

Mike Snitzer (2):
      block: fix q->flush_rq NULL pointer crash on dm-mpath flush
      block: change flush sequence list addition back to front add

 block/blk-core.c                  | 17 ++++++-----------
 block/blk-flush.c                 | 11 +++++++----
 drivers/block/mtip32xx/mtip32xx.c |  2 +-
 3 files changed, 14 insertions(+), 16 deletions(-)

-- 
Jens Axboe

