Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbaGPMaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:30:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47859 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226AbaGPM3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:29:37 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>, <tglx@linutronix.de>
Subject: [PATCH 1/2] dma: edma: Update caps->residue_granularity to match with reality
Date: Wed, 16 Jul 2014 15:29:20 +0300
Message-ID: <1405513761-23739-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
References: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edma can report accurate DMA position so update the residue_granularity
to DMA_RESIDUE_GRANULARITY_BURST.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index fe55f78ea137..d5017abcf7cb 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -1001,7 +1001,7 @@ static int edma_dma_device_slave_caps(struct dma_chan *dchan,
 	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
 	caps->cmd_pause = true;
 	caps->cmd_terminate = true;
-	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
+	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
 
 	return 0;
 }
-- 
2.0.0

