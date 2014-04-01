Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaDANJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:09:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52562 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaDANHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:12 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 11/14] dma: edma: Reduce debug print verbosity for non verbose debugging
Date: Tue, 1 Apr 2014 16:06:12 +0300
Message-ID: <1396357575-30585-12-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not print the paRAM information when verbose debugging is not asked and
also reduce the number of lines printed in edma_prep_dma_cyclic()

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index d954099650ae..e8de2e84a60a 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -141,7 +141,7 @@ static void edma_execute(struct edma_chan *echan)
 	for (i = 0; i < nslots; i++) {
 		j = i + edesc->processed;
 		edma_write_slot(echan->slot[i], &edesc->pset[j]);
-		dev_dbg(echan->vchan.chan.device->dev,
+		dev_vdbg(echan->vchan.chan.device->dev,
 			"\n pset[%d]:\n"
 			"  chnum\t%d\n"
 			"  slot\t%d\n"
@@ -558,9 +558,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	edesc->cyclic = 1;
 	edesc->pset_nr = nslots;
 
-	dev_dbg(dev, "%s: nslots=%d\n", __func__, nslots);
-	dev_dbg(dev, "%s: period_len=%d\n", __func__, period_len);
-	dev_dbg(dev, "%s: buf_len=%d\n", __func__, buf_len);
+	dev_dbg(dev, "%s: channel=%d nslots=%d period_len=%zu buf_len=%zu\n",
+		__func__, echan->ch_num, nslots, period_len, buf_len);
 
 	for (i = 0; i < nslots; i++) {
 		/* Allocate a PaRAM slot, if needed */
@@ -594,8 +593,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 		else
 			src_addr += period_len;
 
-		dev_dbg(dev, "%s: Configure period %d of buf:\n", __func__, i);
-		dev_dbg(dev,
+		dev_vdbg(dev, "%s: Configure period %d of buf:\n", __func__, i);
+		dev_vdbg(dev,
 			"\n pset[%d]:\n"
 			"  chnum\t%d\n"
 			"  slot\t%d\n"
-- 
1.9.1

