Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaGKQNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:13:40 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:50166 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaGKQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:36 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>, Jiri Kosina <trivial@kernel.org>,
        linux-spi@vger.kernel.org
Subject: [PATCH v2 trivial 3/6] spi: topcliff-pch: Update error messages for dmaengine_prep_slave_sg() API
Date: Fri, 11 Jul 2014 18:13:25 +0200
Message-Id: <1405095208-14642-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
introduce inline wrappers") changed the code to use the new API, but forgot
to update the error messages.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-spi@vger.kernel.org
--
v2:
  - New
---
 drivers/spi/spi-topcliff-pch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index f05abf89c067..af51d6a71cc8 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1047,8 +1047,8 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 					num, DMA_DEV_TO_MEM,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_rx) {
-		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
-			__func__);
+		dev_err(&data->master->dev,
+			"%s:dmaengine_prep_slave_sg Failed\n", __func__);
 		return;
 	}
 	dma_sync_sg_for_device(&data->master->dev, sg, num, DMA_FROM_DEVICE);
@@ -1106,8 +1106,8 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 					sg, num, DMA_MEM_TO_DEV,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc_tx) {
-		dev_err(&data->master->dev, "%s:device_prep_slave_sg Failed\n",
-			__func__);
+		dev_err(&data->master->dev,
+			"%s:dmaengine_prep_slave_sg Failed\n", __func__);
 		return;
 	}
 	dma_sync_sg_for_device(&data->master->dev, sg, num, DMA_TO_DEVICE);
-- 
1.9.1

