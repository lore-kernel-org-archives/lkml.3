Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3FGPPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:15:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:45611 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3FGPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:15:31 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: at_hdmac: remove unsuded atc_cleanup_descriptors()
Date: Fri, 7 Jun 2013 17:15:29 +0200
Message-ID: <1370618129-18049-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since patch 7c407d3e54dcc0c79119553c8d5ef176c1d5bc3a (DMA: AT91:
Get residual bytes in dma buffer), the function
atc_cleanup_descriptors() is not used anymore. We remove it to prevent
warnings.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 4499dcf..50953a7 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -417,37 +417,6 @@ static void atc_complete_all(struct at_dma_chan *atchan)
 }
 
 /**
- * atc_cleanup_descriptors - cleanup up finished descriptors in active_list
- * @atchan: channel to be cleaned up
- *
- * Called with atchan->lock held and bh disabled
- */
-static void atc_cleanup_descriptors(struct at_dma_chan *atchan)
-{
-	struct at_desc	*desc, *_desc;
-	struct at_desc	*child;
-
-	dev_vdbg(chan2dev(&atchan->chan_common), "cleanup descriptors\n");
-
-	list_for_each_entry_safe(desc, _desc, &atchan->active_list, desc_node) {
-		if (!(desc->lli.ctrla & ATC_DONE))
-			/* This one is currently in progress */
-			return;
-
-		list_for_each_entry(child, &desc->tx_list, desc_node)
-			if (!(child->lli.ctrla & ATC_DONE))
-				/* Currently in progress */
-				return;
-
-		/*
-		 * No descriptors so far seem to be in progress, i.e.
-		 * this chain must be done.
-		 */
-		atc_chain_complete(atchan, desc);
-	}
-}
-
-/**
  * atc_advance_work - at the end of a transaction, move forward
  * @atchan: channel where the transaction ended
  *
-- 
1.8.2.2

