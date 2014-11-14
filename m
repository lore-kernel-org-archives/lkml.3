Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161750AbaKNUaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:30:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47303 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbaKNUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:30:23 -0500
Date: Fri, 14 Nov 2014 13:30:14 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block fixes for 3.18-rc
Message-ID: <20141114203014.GA18280@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-14_08:2014-11-14,2014-11-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.09832151654155e-14 kscore.compositescore=0
 circleOfTrustscore=37.7501936418875 compositescore=0.98609165920913
 urlsuspect_oldscore=0.98609165920913 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411140151
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

4 small fixes that should be merged for the current 3.18-rc series. This
pull request contains:

- A minor bugfix for computation of best IO priority given two merging
  requests. From Jan Kara.

- The final (final) merge count issue that has been plaguing virtio-blk.
  From Ming Lei.

- Enable parallel reinit notify for blk-mq queues, to combine the cost
  of an RCU grace period across lots of devices. From Tejun Heo.

- An error handling fix for the SCSI_IOCTL_SEND_COMMAND ioctl. From Tony
  Battersby.

Please pull!


  git://git.kernel.dk/linux-block.git for-linus


----------------------------------------------------------------
Jan Kara (1):
      block: Fix computation of merged request priority

Ming Lei (1):
      block: blk-merge: fix blk_recount_segments()

Tejun Heo (1):
      blk-mq: make mq_queue_reinit_notify() freeze queues in parallel

Tony Battersby (1):
      scsi: Fix more error handling in SCSI_IOCTL_SEND_COMMAND

 block/blk-merge.c  | 19 +++++++++++--------
 block/blk-mq.c     | 41 +++++++++++++++++++++++++++++++++--------
 block/ioprio.c     | 14 ++++++++------
 block/scsi_ioctl.c |  8 +++++---
 4 files changed, 57 insertions(+), 25 deletions(-)

-- 
Jens Axboe

