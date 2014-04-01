Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaDANH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:07:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54519 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaDANHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:21 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 13/14] dma: edma: Add channel number to debug prints
Date: Tue, 1 Apr 2014 16:06:14 +0300
Message-ID: <1396357575-30585-14-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps to identify issues if we have some information regarding to the
channel which the event is associated.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 7feb6231276e..2413237840f8 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -185,7 +185,8 @@ static void edma_execute(struct edma_chan *echan)
 	edma_resume(echan->ch_num);
 
 	if (edesc->processed <= MAX_NR_SG) {
-		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
+		dev_dbg(dev, "first transfer starting on channel %d\n",
+			echan->ch_num);
 		edma_start(echan->ch_num);
 	}
 
@@ -195,7 +196,7 @@ static void edma_execute(struct edma_chan *echan)
 	 * MAX_NR_SG
 	 */
 	if (echan->missed) {
-		dev_dbg(dev, "missed event in execute detected\n");
+		dev_dbg(dev, "missed event on channel %d\n", echan->ch_num);
 		edma_clean_channel(echan->ch_num);
 		edma_stop(echan->ch_num);
 		edma_start(echan->ch_num);
@@ -736,7 +737,7 @@ static int edma_alloc_chan_resources(struct dma_chan *chan)
 	echan->alloced = true;
 	echan->slot[0] = echan->ch_num;
 
-	dev_dbg(dev, "allocated channel for %u:%u\n",
+	dev_dbg(dev, "allocated channel %d for %u:%u\n", echan->ch_num,
 		EDMA_CTLR(echan->ch_num), EDMA_CHAN_SLOT(echan->ch_num));
 
 	return 0;
-- 
1.9.1

