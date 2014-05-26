Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaEZMF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:05:29 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:42182 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaEZMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:05:28 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] spi: core: Ignore unsupported spi-[tr]x-bus-width property values
Date: Mon, 26 May 2014 14:05:25 +0200
Message-Id: <1401105925-16528-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rejecting unsupported values of spi-tx-bus-width and spi-rx-bus-width
may break compatibility with future DTs. Just ignore them, falling back
to Single SPI Transfers.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I thought I sent this before, but I can't find any evidence

 drivers/spi/spi.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 074f55f5d5ec..d4f9670b51bc 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1270,11 +1270,10 @@ static void of_register_spi_devices(struct spi_master *master)
 				spi->mode |= SPI_TX_QUAD;
 				break;
 			default:
-				dev_err(&master->dev,
-					"spi-tx-bus-width %d not supported\n",
-					value);
-				spi_dev_put(spi);
-				continue;
+				dev_warn(&master->dev,
+					 "spi-tx-bus-width %d not supported\n",
+					 value);
+				break;
 			}
 		}
 
@@ -1289,11 +1288,10 @@ static void of_register_spi_devices(struct spi_master *master)
 				spi->mode |= SPI_RX_QUAD;
 				break;
 			default:
-				dev_err(&master->dev,
-					"spi-rx-bus-width %d not supported\n",
-					value);
-				spi_dev_put(spi);
-				continue;
+				dev_warn(&master->dev,
+					 "spi-rx-bus-width %d not supported\n",
+					 value);
+				break;
 			}
 		}
 
-- 
1.9.1

