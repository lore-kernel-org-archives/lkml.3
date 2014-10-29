Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbaJ2PUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:20:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51101 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933194AbaJ2PUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:20:44 -0400
Date: Wed, 29 Oct 2014 09:20:40 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block fixes for 3.18-rc2
Message-ID: <20141029152040.GA5277@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-29_05:2014-10-28,2014-10-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=3 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410290153
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of fixes for the current kernel. This pull request
contains:

- Two error handling fixes from Jan Kara. One for null_blk on failure to
  add a device, and the other for the block/scsi_ioctl
  SCSI_IOCTL_SEND_COMMAND fixing up the error jump point.

- A commit added in the merge window for the bio integrity bits
  unfortunately disabled merging for all requests if
  CONFIG_BLK_DEV_INTEGRITY wasn't set. Reverse the logic, so that
  integrity checking wont disallow merges when not enabled.

- A fix from Ming Lei for merging and generating too many segments. This
  caused a BUG in virtio_blk.

- Two error handling printk() fixups from Robert Elliott, improving the
  information given when we rate limit.

- Error handling fixup on elevator_init() failure from Sudip Mukherjee.

- A fix from Tony Battersby, fixing up a memory leak in the scatterlist
  handling with scsi-mq.


Please pull!


  git://git.kernel.dk/linux-block.git for-linus


----------------------------------------------------------------
Jan Kara (2):
      null_blk: Cleanup error recovery in null_add_dev()
      scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND

Martin K. Petersen (1):
      block: Fix merge logic when CONFIG_BLK_DEV_INTEGRITY is not defined

Ming Lei (1):
      blk-merge: recaculate segment if it isn't less than max segments

Robert Elliott (2):
      fs: merge I/O error prints into one line
      fs: clarify rate limit suppressed buffer I/O errors

Sudip Mukherjee (1):
      block: fix wrong error return in elevator_init()

Tony Battersby (1):
      lib/scatterlist: fix memory leak with scsi-mq

 block/blk-merge.c        |  5 +++--
 block/elevator.c         |  4 +++-
 block/scsi_ioctl.c       |  3 +--
 drivers/block/null_blk.c | 14 +++++++-------
 fs/buffer.c              | 38 +++++++++-----------------------------
 include/linux/blkdev.h   |  4 ++--
 lib/scatterlist.c        |  6 +++---
 7 files changed, 28 insertions(+), 46 deletions(-)

-- 
Jens Axboe

