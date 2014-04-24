Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaDXHaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:30:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39924 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaDXHaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:30:20 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>,
        <joelf@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RESEND] dmaengine: edma: Add channel number to debug prints
Date: Thu, 24 Apr 2014 10:29:50 +0300
Message-ID: <1398324590-31752-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
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
Hi Vinod,

rebased on:
git://git.infradead.org/users/vkoul/slave-dma.git next

On top of:
406efb1a745c dmaengine: edma: No need save/restore interrupt flags during...

Regards,
Peter

 drivers/dma/edma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index fa87fd52b0ad..473155d34d7b 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -183,7 +183,8 @@ static void edma_execute(struct edma_chan *echan)
 	}
 
 	if (edesc->processed <= MAX_NR_SG) {
-		dev_dbg(dev, "first transfer starting %d\n", echan->ch_num);
+		dev_dbg(dev, "first transfer starting on channel %d\n",
+			echan->ch_num);
 		edma_start(echan->ch_num);
 	} else {
 		dev_dbg(dev, "chan: %d: completed %d elements, resuming\n",
@@ -197,7 +198,7 @@ static void edma_execute(struct edma_chan *echan)
 	 * MAX_NR_SG
 	 */
 	if (echan->missed) {
-		dev_dbg(dev, "missed event in execute detected\n");
+		dev_dbg(dev, "missed event on channel %d\n", echan->ch_num);
 		edma_clean_channel(echan->ch_num);
 		edma_stop(echan->ch_num);
 		edma_start(echan->ch_num);
@@ -779,7 +780,7 @@ static int edma_alloc_chan_resources(struct dma_chan *chan)
 	echan->alloced = true;
 	echan->slot[0] = echan->ch_num;
 
-	dev_dbg(dev, "allocated channel for %u:%u\n",
+	dev_dbg(dev, "allocated channel %d for %u:%u\n", echan->ch_num,
 		EDMA_CTLR(echan->ch_num), EDMA_CHAN_SLOT(echan->ch_num));
 
 	return 0;
-- 
1.9.2

