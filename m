Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaGKQOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:14:49 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:50165 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbaGKQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:37 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH v2 6/6] spi: atmel: Use dmaengine_prep_slave_sg() API
Date: Fri, 11 Jul 2014 18:13:28 +0200
Message-Id: <1405095208-14642-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the inline wrapper introduced by commit
16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave: introduce
inline wrappers").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org
--
v2:
  - New
---
 drivers/spi/spi-atmel.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 92a6f0d93233..1fb90dda299b 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -597,21 +597,15 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 		goto err_exit;
 
 	/* Send both scatterlists */
-	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
-					&as->dma.sgrx,
-					1,
-					DMA_FROM_DEVICE,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
-					NULL);
+	rxdesc = dmaengine_prep_slave_sg(rxchan, &as->dma.sgrx, 1,
+					 DMA_FROM_DEVICE,
+					 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!rxdesc)
 		goto err_dma;
 
-	txdesc = txchan->device->device_prep_slave_sg(txchan,
-					&as->dma.sgtx,
-					1,
-					DMA_TO_DEVICE,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
-					NULL);
+	txdesc = dmaengine_prep_slave_sg(txchan, &as->dma.sgtx, 1,
+					 DMA_TO_DEVICE,
+					 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!txdesc)
 		goto err_dma;
 
-- 
1.9.1

