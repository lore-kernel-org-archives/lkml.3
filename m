Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbaGUNQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:16:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53395 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbaGUNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:16:49 -0400
Date: Mon, 21 Jul 2014 15:16:42 +0200
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Final block fixes for 3.16
Message-ID: <20140721131606.GA6399@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-20_03:2014-07-18,2014-07-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.95017352161631e-13 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407210160
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Four small fixes that should go into 3.16, have been queued up for a bit
and delayed due to vacation and other euro duties. But here they are.
The pull request contains:

- Fix for a reported crash with shared tagging on SCSI from Christoph.

- A regression fix for drbd. From Lars Ellenberg.

- Hooking up the compat ioctl for BLKZEROOUT, which requires no
  translation. From Mikulas.

- A fix for a regression where we woud crash on queue exit if the
  root_blkg is gone/not there. From Tejun.


Please pull for 3.16!


  git://git.kernel.dk/linux-block.git for-linus


----------------------------------------------------------------
Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host

Lars Ellenberg (1):
      drbd: fix regression 'out of mem, failed to invoke fence-peer helper'

Mikulas Patocka (1):
      block: provide compat ioctl for BLKZEROOUT

Tejun Heo (1):
      blkcg: don't call into policy draining if root_blkg is already gone

 block/blk-cgroup.c           |  7 +++++++
 block/blk-tag.c              | 33 +++++++--------------------------
 block/compat_ioctl.c         |  1 +
 drivers/block/drbd/drbd_nl.c |  6 ++++++
 4 files changed, 21 insertions(+), 26 deletions(-)

-- 
Jens Axboe

