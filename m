Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564Ab3JPRYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:24:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:18190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761448Ab3JPRX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851400"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 26/28] async_tx: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:44 +0530
Message-Id: <1381940926-25564-27-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 crypto/async_tx/async_tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 7be3424..39ea479 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -128,7 +128,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 		}
 		device->device_issue_pending(chan);
 	} else {
-		if (dma_wait_for_async_tx(depend_tx) != DMA_SUCCESS)
+		if (dma_wait_for_async_tx(depend_tx) != DMA_COMPLETE)
 			panic("%s: DMA error waiting for depend_tx\n",
 			      __func__);
 		tx->tx_submit(tx);
@@ -280,7 +280,7 @@ void async_tx_quiesce(struct dma_async_tx_descriptor **tx)
 		 * we are referring to the correct operation
 		 */
 		BUG_ON(async_tx_test_ack(*tx));
-		if (dma_wait_for_async_tx(*tx) != DMA_SUCCESS)
+		if (dma_wait_for_async_tx(*tx) != DMA_COMPLETE)
 			panic("%s: DMA error waiting for transaction\n",
 			      __func__);
 		async_tx_ack(*tx);
-- 
1.7.0.4

