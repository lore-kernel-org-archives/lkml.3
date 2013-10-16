Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271Ab3JPRWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:22:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:21380 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760800Ab3JPRWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417850883"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:19 +0530
Message-Id: <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the DMA_SUCCESS is a misnomer as dmaengine indicates the transfer is complete and
gives no guarantee of the transfer success. Hence we should use DMA_COMPLTE
instead of DMA_SUCCESS

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/dmaengine.c   |    2 +-
 include/linux/dmaengine.h |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9162ac8..81d8765 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1062,7 +1062,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 	unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
 
 	if (!tx)
-		return DMA_SUCCESS;
+		return DMA_COMPLETE;
 
 	while (tx->cookie == -EBUSY) {
 		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0bc7275..4b460a6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -45,13 +45,13 @@ static inline int dma_submit_error(dma_cookie_t cookie)
 
 /**
  * enum dma_status - DMA transaction status
- * @DMA_SUCCESS: transaction completed successfully
+ * @DMA_COMPLETE: transaction completed
  * @DMA_IN_PROGRESS: transaction not yet processed
  * @DMA_PAUSED: transaction is paused
  * @DMA_ERROR: transaction failed
  */
 enum dma_status {
-	DMA_SUCCESS,
+	DMA_COMPLETE,
 	DMA_IN_PROGRESS,
 	DMA_PAUSED,
 	DMA_ERROR,
@@ -979,10 +979,10 @@ static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
 {
 	if (last_complete <= last_used) {
 		if ((cookie <= last_complete) || (cookie > last_used))
-			return DMA_SUCCESS;
+			return DMA_COMPLETE;
 	} else {
 		if ((cookie <= last_complete) && (cookie > last_used))
-			return DMA_SUCCESS;
+			return DMA_COMPLETE;
 	}
 	return DMA_IN_PROGRESS;
 }
@@ -1013,11 +1013,11 @@ static inline struct dma_chan *dma_find_channel(enum dma_transaction_type tx_typ
 }
 static inline enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
 {
-	return DMA_SUCCESS;
+	return DMA_COMPLETE;
 }
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
-	return DMA_SUCCESS;
+	return DMA_COMPLETE;
 }
 static inline void dma_issue_pending_all(void)
 {
-- 
1.7.0.4

