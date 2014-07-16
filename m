Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbaGPM3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:29:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47854 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaGPM3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:29:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>, <tglx@linutronix.de>
Subject: [PATCH 2/2] dma: edma: Support to suppress the period interrupts in cyclic mode
Date: Wed, 16 Jul 2014 15:29:21 +0300
Message-ID: <1405513761-23739-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
References: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the client (audio) does not request interrupts for every period we can
disable them.
With updated audio driver stack we can play audio w/o the need to process
any edma interrupts.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index d5017abcf7cb..69f1f5250120 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -723,10 +723,10 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 		edesc->absync = ret;
 
 		/*
-		 * Enable interrupts for every period because callback
-		 * has to be called for every period.
+		 * Enable period interrupt only if it is requested
 		 */
-		edesc->pset[i].param.opt |= TCINTEN;
+		if (tx_flags & DMA_PREP_INTERRUPT)
+			edesc->pset[i].param.opt |= TCINTEN;
 	}
 
 	/* Place the cyclic channel to highest priority queue */
-- 
2.0.0

