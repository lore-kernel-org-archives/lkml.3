Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaDANLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:11:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54424 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaDANHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 10/14] dma: edma: Simplify direction configuration in edma_config_pset()
Date: Tue, 1 Apr 2014 16:06:11 +0300
Message-ID: <1396357575-30585-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only support DEV_TO_MEM or MEM_TO_DEV directions with edma driver and the
check for the direction has been already done in the function calling
edma_config_pset().
The error reporting is redundant and also the "else if ()" can be removed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 855766672aa9..d954099650ae 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -372,14 +372,12 @@ static int edma_config_pset(struct dma_chan *chan, struct edmacc_param *pset,
 		src_cidx = cidx;
 		dst_bidx = 0;
 		dst_cidx = 0;
-	} else if (direction == DMA_DEV_TO_MEM)  {
+	} else {
+		/* DMA_DEV_TO_MEM */
 		src_bidx = 0;
 		src_cidx = 0;
 		dst_bidx = acnt;
 		dst_cidx = cidx;
-	} else {
-		dev_err(dev, "%s: direction not implemented yet\n", __func__);
-		return -EINVAL;
 	}
 
 	pset->opt = EDMA_TCC(EDMA_CHAN_SLOT(echan->ch_num));
-- 
1.9.1

