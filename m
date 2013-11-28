Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3K1E3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:29:36 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35800 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab3K1E2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:28:37 -0500
From: Thomas Behan <thomas.behan@gmail.com>
To: linux-spi@vger.kernel.org
Cc: broonie@linaro.org, linux-kernel@vger.kernel.org,
        Thomas Behan <thomas.behan@gmail.com>
Subject: [PATCH 1/4] spi: omap-100k: Fixed spacing on while loops
Date: Wed, 27 Nov 2013 23:27:21 -0500
Message-Id: <1385612844-22482-2-git-send-email-thomas.behan@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385612844-22482-1-git-send-email-thomas.behan@gmail.com>
References: <1385612844-22482-1-git-send-email-thomas.behan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl generated several errors from "while(" statements which should
have read "while (" to comply with the style guide. These errors have been
fixed.

Signed-off-by: Thomas Behan <thomas.behan@gmail.com>
---
 drivers/spi/spi-omap-100k.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index b6ed82b..bdf6696 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -147,7 +147,7 @@ static void spi100k_write_data(struct spi_master *master, int len, int data)
 	       spi100k->base + SPI_CTRL);
 
 	/* Wait for bit ack send change */
-	while((readw(spi100k->base + SPI_STATUS) & SPI_STATUS_WE) != SPI_STATUS_WE);
+	while ((readw(spi100k->base + SPI_STATUS) & SPI_STATUS_WE) != SPI_STATUS_WE);
 	udelay(1000);
 
 	spi100k_disable_clock(master);
@@ -168,7 +168,7 @@ static int spi100k_read_data(struct spi_master *master, int len)
 	       SPI_CTRL_RD,
 	       spi100k->base + SPI_CTRL);
 
-	while((readw(spi100k->base + SPI_STATUS) & SPI_STATUS_RD) != SPI_STATUS_RD);
+	while ((readw(spi100k->base + SPI_STATUS) & SPI_STATUS_RD) != SPI_STATUS_RD);
 	udelay(1000);
 
 	dataL = readw(spi100k->base + SPI_RX_LSB);
@@ -226,7 +226,7 @@ omap1_spi100k_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				spi100k_write_data(spi->master, word_len, *tx++);
 			if (xfer->rx_buf != NULL)
 				*rx++ = spi100k_read_data(spi->master, word_len);
-		} while(c);
+		} while (c);
 	} else if (word_len <= 16) {
 		u16             *rx;
 		const u16       *tx;
@@ -239,7 +239,7 @@ omap1_spi100k_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				spi100k_write_data(spi->master,word_len, *tx++);
 			if (xfer->rx_buf != NULL)
 				*rx++ = spi100k_read_data(spi->master,word_len);
-		} while(c);
+		} while (c);
 	} else if (word_len <= 32) {
 		u32             *rx;
 		const u32       *tx;
@@ -252,7 +252,7 @@ omap1_spi100k_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				spi100k_write_data(spi->master,word_len, *tx);
 			if (xfer->rx_buf != NULL)
 				*rx = spi100k_read_data(spi->master,word_len);
-		} while(c);
+		} while (c);
 	}
 	return count - c;
 }
-- 
1.8.1.2

