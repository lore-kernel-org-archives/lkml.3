Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaLVTf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:35:28 -0500
Received: from mail-ig0-f201.google.com ([209.85.213.201]:64190 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaLVTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:35:20 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH V2 1/2] spi: img-spfi: Increase DMA burst size
Date: Mon, 22 Dec 2014 11:35:15 -0800
Message-Id: <1419276916-28433-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 1-byte burst size is rather inefficient and has been shown to cause
TX issues during testing.  Increase the DMA burst size to 4-bytes for
both RX and TX DMA when using the 8-bit FIFO.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/spi/spi-img-spfi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index cd14556..aad6683 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -341,7 +341,7 @@ static int img_spfi_start_dma(struct spi_master *master,
 		default:
 			rxconf.src_addr = spfi->phys + SPFI_RX_8BIT_VALID_DATA;
 			rxconf.src_addr_width = 1;
-			rxconf.src_maxburst = 1;
+			rxconf.src_maxburst = 4;
 		}
 		dmaengine_slave_config(spfi->rx_ch, &rxconf);
 
@@ -368,7 +368,7 @@ static int img_spfi_start_dma(struct spi_master *master,
 		default:
 			txconf.dst_addr = spfi->phys + SPFI_TX_8BIT_VALID_DATA;
 			txconf.dst_addr_width = 1;
-			txconf.dst_maxburst = 1;
+			txconf.dst_maxburst = 4;
 			break;
 		}
 		dmaengine_slave_config(spfi->tx_ch, &txconf);
-- 
2.2.0.rc0.207.ga3a616c

