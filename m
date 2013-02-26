Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3BZQUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:20:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:30316 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953Ab3BZQUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:20:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,742,1355126400"; 
   d="scan'208";a="296136788"
Subject: [PATCH] ioatdma: allow all channels to have irq coalescing support
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Feb 2013 09:20:36 -0700
Message-ID: <20130226162036.4996.78263.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like only the RAID channels are allowed to have irq coalescing support
in the existing code. Fixing that. The ioat3 cleanup code can handle memcpy
ops anyways

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 47588dc..368a184 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1268,15 +1268,9 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	}
 
 
-	if (is_raid_device) {
-		dma->device_tx_status = ioat3_tx_status;
-		device->cleanup_fn = ioat3_cleanup_event;
-		device->timer_fn = ioat3_timer_event;
-	} else {
-		dma->device_tx_status = ioat_dma_tx_status;
-		device->cleanup_fn = ioat2_cleanup_event;
-		device->timer_fn = ioat2_timer_event;
-	}
+	dma->device_tx_status = ioat3_tx_status;
+	device->cleanup_fn = ioat3_cleanup_event;
+	device->timer_fn = ioat3_timer_event;
 
 	#ifdef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
 	dma_cap_clear(DMA_PQ_VAL, dma->cap_mask);

