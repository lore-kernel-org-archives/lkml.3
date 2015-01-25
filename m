Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbbAYAQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 19:16:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48779 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbbAYAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 19:16:17 -0500
Date: Sat, 24 Jan 2015 17:16:13 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Two block IO fixes for 3.19
Message-ID: <20150125001613.GA20174@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-24_03:2015-01-24,2015-01-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.80189196896663e-13 kscore.compositescore=0
 circleOfTrustscore=37.7501936418875 compositescore=0.98609165920913
 urlsuspect_oldscore=0.98609165920913 suspectscore=11
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501250001
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two small patches that should make it into 3.19:

- A fixup from me for NVMe, making the cq_vector a signed variable.
  Otherwise our -1 comparison fails, and commit 2b25d981790b doesn't do
  what it was supposed to.

- A fixup for the hotplug handling for blk-mq from Ming Lei, using the
  proper kobject referencing to ensure we release resources at the right
  time.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Jens Axboe (1):
      NVMe: cq_vector should be signed

Ming Lei (1):
      blk-mq: fix hctx/ctx kobject use-after-free

 block/blk-mq-sysfs.c      | 25 +++++++++++++++++++++++--
 block/blk-mq.c            |  6 +-----
 drivers/block/nvme-core.c |  2 +-
 3 files changed, 25 insertions(+), 8 deletions(-)

-- 
Jens Axboe

