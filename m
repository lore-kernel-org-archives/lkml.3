Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3G3MUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:20:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48564 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3G3MUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:20:05 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Tue, 30 Jul 2013 13:19:55 +0100
Message-Id: <1375186795-28823-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm831x: Remove erronious bits per word set
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Since the conversion to the regmap API setting bits per word will lead to
data corruption since the regmap API already configures the bits per word
appropriately.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/wm831x-spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index e7ed14f66..07de3cc 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -34,7 +34,6 @@ static int wm831x_spi_probe(struct spi_device *spi)
 	if (wm831x == NULL)
 		return -ENOMEM;
 
-	spi->bits_per_word = 16;
 	spi->mode = SPI_MODE_0;
 
 	spi_set_drvdata(spi, wm831x);
-- 
1.8.3.2

