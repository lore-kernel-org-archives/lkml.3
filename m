Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaCMJXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:23:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33055 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaCMJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:19:50 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 09/18] dma: edma: Simplify direction configuration in edma_config_pset()
Date: Thu, 13 Mar 2014 11:18:31 +0200
Message-ID: <1394702320-21743-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
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
index 1877319379fc..e4f4a0cef58c 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -368,14 +368,12 @@ static int edma_config_pset(struct dma_chan *chan, struct edmacc_param *pset,
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
1.9.0

