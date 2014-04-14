Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaDNLnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:43:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45781 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbaDNLm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:42:58 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>,
        <joelf@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v3 09/10] dmaengine: edma: Add channel number to debug prints
Date: Mon, 14 Apr 2014 14:42:04 +0300
Message-ID: <1397475725-5036-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps to identify issues if we have some information regarding to the
channel which the event is associated.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index bc8175c92e0c..4aa5eb005b5c 100644
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
@@ -735,7 +736,7 @@ static int edma_alloc_chan_resources(struct dma_chan *chan)
 	echan->alloced = true;
 	echan->slot[0] = echan->ch_num;
 
-	dev_dbg(dev, "allocated channel for %u:%u\n",
+	dev_dbg(dev, "allocated channel %d for %u:%u\n", echan->ch_num,
 		EDMA_CTLR(echan->ch_num), EDMA_CHAN_SLOT(echan->ch_num));
 
 	return 0;
-- 
1.9.2

