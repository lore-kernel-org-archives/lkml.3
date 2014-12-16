Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaLPVFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:05:51 -0500
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58802 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLPVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:05:49 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 1/3] spi: img-spfi: Enable controller before starting TX DMA
Date: Tue, 16 Dec 2014 13:05:44 -0800
Message-Id: <1418763946-22260-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is recommended that the SPFI controller be enabled (i.e. setting
SPFI_EN in SPFI_CONTROL) before TX DMA begins.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/spi/spi-img-spfi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index 43781c9..e7e79e6 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -390,14 +390,14 @@ static int img_spfi_start_dma(struct spi_master *master,
 		dma_async_issue_pending(spfi->rx_ch);
 	}
 
+	spfi_start(spfi);
+
 	if (xfer->tx_buf) {
 		spfi->tx_dma_busy = true;
 		dmaengine_submit(txdesc);
 		dma_async_issue_pending(spfi->tx_ch);
 	}
 
-	spfi_start(spfi);
-
 	return 1;
 
 stop_dma:
-- 
2.2.0.rc0.207.ga3a616c

