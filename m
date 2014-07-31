Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaGaKMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:12:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43018 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbaGaKMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:12:45 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 1/2] dmaengine: edma: Do not change the error code returned from edma_alloc_slot
Date: Thu, 31 Jul 2014 13:12:37 +0300
Message-ID: <1406801558-13126-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of edma_alloc_slot() failure during probe we should return the error
unchanged to make debugging easier.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 69f1f5250120..2953de0f53f3 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -1048,7 +1048,7 @@ static int edma_probe(struct platform_device *pdev)
 	ecc->dummy_slot = edma_alloc_slot(ecc->ctlr, EDMA_SLOT_ANY);
 	if (ecc->dummy_slot < 0) {
 		dev_err(&pdev->dev, "Can't allocate PaRAM dummy slot\n");
-		return -EIO;
+		return ecc->dummy_slot;
 	}
 
 	dma_cap_zero(ecc->dma_slave.cap_mask);
-- 
2.0.2

