Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937067Ab3DJXoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:44:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:51708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936331Ab3DJXoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="284530881"
Subject: [PATCH v2 0/5] ioatdma: Intel S1200 support patches
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 16:44:14 -0700
Message-ID: <20130410234230.9082.89305.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the updated patches from first submission series and rebased against
vinod's slave-dma git tree for-linus branch.

Patches 1 & 4 have been updated after discussion with Dan. Patch 5 was acked by
Dan but requires additional review by Dan. I had to make additional modification
to get raid6test working.

---

Dave Jiang (5):
      ioatdma: Removing hw bug workaround for CB3.x .2 and earlier
      ioatdma: Adding support for 16 src PQ ops and super extended descriptors
      ioatdma: S1200 platforms ioatdma channel 2 and 3 falsely advertise RAID cap
      ioatdma: Adding write back descriptor error status support for ioatdma 3.3
      async_tx: allow generic async_memcpy() not be effected by channel switch


 crypto/async_tx/async_memcpy.c |   76 ++++--
 drivers/dma/ioat/dma.h         |   18 +
 drivers/dma/ioat/dma_v2.h      |    2 
 drivers/dma/ioat/dma_v3.c      |  538 +++++++++++++++++++++++++++++++++++++---
 drivers/dma/ioat/hw.h          |   60 ++++
 drivers/dma/ioat/pci.c         |    3 
 drivers/dma/ioat/registers.h   |    2 
 drivers/md/raid5.c             |   15 +
 include/linux/async_tx.h       |    5 
 include/linux/dmaengine.h      |   34 ---
 10 files changed, 647 insertions(+), 106 deletions(-)
