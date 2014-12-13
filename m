Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaLMUSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 15:18:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34558 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbaLMUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 15:18:41 -0500
Date: Sat, 13 Dec 2014 13:18:44 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block driver updates for 3.19
Message-ID: <20141213201844.GA24677@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-13_02:2014-12-13,2014-12-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.11022302462516e-15 kscore.compositescore=0
 circleOfTrustscore=33.2965958620397 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=11
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412130209
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below is the block driver pull request for 3.19, it sits on top of the
core pull request submitted yesterday. It contains:

- NVMe updates

        - The blk-mq conversion from Matias (and others)

        - A stack of NVMe bug fixes from the nvme tree, mostly from Keith.

        - Various bug fixes from me, fixing issues in both the blk-mq
          conversion and generic bugs.

        - Abort and CPU online fix from Sam.

        - Hot add/remove fix from Indraneel.

- A couple of drbd fixes from the drbd team (Andreas, Lars, Philipp)

- With the generic IO stat accounting from 3.19/core, converting md,
  bcache, and rsxx to use those. From Gu Zheng.

- Boundary check for queue/irq mode for null_blk from Matias. Fixes
  cases where invalid values could be given, causing the device to hang.

- The xen blkfront pull request, with two bug fixes from Vitaly.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.19/drivers


----------------------------------------------------------------
Andreas Gruenbacher (2):
      drbd: Minor cleanups
      drbd: Only use drbd_msg_put_info() in drbd_nl.c

Andreea-Cristina Bernat (1):
      nvme: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Dan Carpenter (1):
      NVMe: blk_mq_alloc_request() returns error pointers

Dan McLeran (2):
      NVMe: Change nvme_enable_ctrl to set EN and manage CC thru ctrl_config.
      NVMe: Add shutdown timeout as module parameter.

Gu Zheng (4):
      md/bcache: use generic io stats accounting functions to simplify io stat accounting
      drbd: use generic io stats accounting functions to simplify io stat accounting
      md: use generic io stats accounting functions to simplify io stat accounting
      block/rsxx: use generic io stats accounting functions to simplify io stat accounting

Indraneel M (1):
      NVMe: Fix FS mount issue (hot-remove followed by hot-add)

Jens Axboe (13):
      Merge branch 'for-3.19/core' into for-3.19/drivers
      NVMe: replace blk_put_request() with blk_mq_free_request()
      NVMe: nvme_submit_async_admin_req() must use atomic rq allocation
      NVMe: enable IO stats by default
      Merge branch 'master' into for-3.19/drivers
      NVMe: make setup work for devices that don't do INTx
      NVMe: add ->exit_hctx() hook
      NVMe: fail pci initialization if the device doesn't have any BARs
      Merge branch 'for-3.19/core' into for-3.19/drivers
      NVMe: fix error return checking from blk_mq_alloc_request()
      Merge branch 'for-jens-3.19' of git://git.kernel.org/.../konrad/xen into for-3.19/drivers
      NVMe: fix retry/error logic in nvme_queue_rq()
      NVMe: fix race condition in nvme_submit_sync_cmd()

Joe Perches (1):
      block: Use dma_zalloc_coherent

Keith Busch (22):
      NVMe: Async event request
      NVMe: Mismatched host/device page size support
      NVMe: Handling devices incapable of I/O
      NVMe: Use pci_stop_and_remove_bus_device_locked()
      NVMe: Whitespace fixes
      NVMe: Skip orderly shutdown on failed devices
      NVMe: Call nvme_free_queue directly
      NVMe: Fix filesystem sync deadlock on removal
      NVMe: Reference count pci device
      NVMe: Remove duplicate compat SG_IO code
      NVMe: Fix SG_IO status values
      NVMe: Translate NVMe status to errno
      NVMe: Fix nvmeq waitqueue entry initialization
      NVMe: Add revalidate_disk callback
      NVMe: Passthrough IOCTL for IO commands
      NVMe: Updates for 1.1 spec
      NVMe: Fix device probe waiting on kthread
      NVMe: Clear QUEUE_FLAG_STACKABLE
      NVMe: Do not open disks that are being deleted
      NVMe: Do not over allocate for discard requests
      NVMe: Update module version major number
      NVMe: Fix command setup on IO retry

Lars Ellenberg (2):
      drbd: fix resync throttling initialization
      drbd: merge_bvec_fn: properly remap bvm->bi_bdev

Matias Bjorling (1):
      null_blk: boundary check queue_mode and irqmode

Matias Bjørling (1):
      NVMe: Convert to blk-mq

Matthew Wilcox (1):
      NVMe: Update list of status codes

Philipp Reisner (3):
      drbd: fix race between role change and handshake
      drbd: Fix state change in case of connection timeout
      drbd: Remove an useless copy of kernel_setsockopt()

Sam Bradshaw (2):
      NVMe: Correctly handle IOCTL_SUBMIT_IO when cpus > online queues
      NVMe: fix freeing of wrong request in abort path

Vitaly Kuznetsov (2):
      xen/blkfront: improve protection against issuing unsupported REQ_FUA
      xen/blkfront: remove redundant flush_op

kbuild test robot (1):
      NVMe: __nvme_submit_admin_cmd() can be static

 drivers/block/drbd/drbd_actlog.c   |    3 +-
 drivers/block/drbd/drbd_int.h      |   39 +-
 drivers/block/drbd/drbd_main.c     |   23 +-
 drivers/block/drbd/drbd_nl.c       |   64 +-
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_req.c      |   25 +-
 drivers/block/drbd/drbd_state.c    |   42 +-
 drivers/block/drbd/drbd_state.h    |    5 +
 drivers/block/drbd/drbd_worker.c   |    5 +-
 drivers/block/null_blk.c           |   42 +-
 drivers/block/nvme-core.c          | 1594 +++++++++++++++++-------------------
 drivers/block/nvme-scsi.c          |  162 +---
 drivers/block/rsxx/dev.c           |   29 +-
 drivers/block/xen-blkfront.c       |   65 +-
 drivers/md/bcache/request.c        |   23 +-
 drivers/md/dm.c                    |   13 +-
 drivers/md/md.c                    |    6 +-
 include/linux/drbd.h               |    2 +-
 include/linux/nvme.h               |   18 +-
 include/uapi/linux/nvme.h          |   46 +-
 20 files changed, 1009 insertions(+), 1199 deletions(-)

-- 
Jens Axboe

