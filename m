Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbaBUQ33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:29:29 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:56216 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874AbaBUQ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:29:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 3/4] spi: rspi: Remove empty rspi_cleanup()
Date: Fri, 21 Feb 2014 17:29:17 +0100
Message-Id: <1393000158-6622-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393000158-6622-1-git-send-email-geert@linux-m68k.org>
References: <1393000158-6622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

If spi_master.cleanup() is not needed, it can be left unimplemented.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 04528888a53f..4a1f978c3381 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -893,10 +893,6 @@ static int rspi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static void rspi_cleanup(struct spi_device *spi)
-{
-}
-
 static u16 qspi_transfer_mode(const struct spi_transfer *xfer)
 {
 	if (xfer->tx_buf)
@@ -1255,7 +1251,6 @@ static int rspi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->setup = rspi_setup;
 	master->transfer_one = ops->transfer_one;
-	master->cleanup = rspi_cleanup;
 	master->prepare_message = rspi_prepare_message;
 	master->unprepare_message = rspi_unprepare_message;
 	master->mode_bits = ops->mode_bits;
-- 
1.7.9.5

