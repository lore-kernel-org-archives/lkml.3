Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaALNAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 08:00:39 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:60991 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaALNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 08:00:35 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] spi: core: Improve tx/rx_nbits check comments
Date: Sun, 12 Jan 2014 14:00:29 +0100
Message-Id: <1389531629-6026-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

  - Rephrase the comments about tx/rx_nbits validity checks,
  - Remove the stale comment about SPI_3WIRE (the code it refers to was
    removed in commit 368ca4e0c75612c0a4d6bbcef7efb944604340c2 ("spi:
    Eliminate 3WIRE spi_transfer check")).

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index eaaad9d7fa84..ccb8a00ee83d 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1667,9 +1667,8 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 		if (xfer->rx_buf && !xfer->rx_nbits)
 			xfer->rx_nbits = SPI_NBITS_SINGLE;
 		/* check transfer tx/rx_nbits:
-		 * 1. keep the value is not out of single, dual and quad
-		 * 2. keep tx/rx_nbits is contained by mode in spi_device
-		 * 3. if SPI_3WIRE, tx/rx_nbits should be in single
+		 * 1. check the value matches one of single, dual and quad
+		 * 2. check tx/rx_nbits match the mode in spi_device
 		 */
 		if (xfer->tx_buf) {
 			if (xfer->tx_nbits != SPI_NBITS_SINGLE &&
-- 
1.7.9.5

