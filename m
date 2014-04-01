Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaDALQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaDALQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gabor Juhos <juhosg@openwrt.org>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 027/144] spi: spi-ath79: fix initial GPIO CS line setup
Date: Tue,  1 Apr 2014 12:13:51 +0100
Message-Id: <1396350948-29910-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit 61d1cf163c8653934cc8cd5d0b2a562d0990c265 upstream.

The 'ath79_spi_setup_cs' function initializes the chip
select line of a given SPI device in order to make sure
that the device is inactive.

If the SPI_CS_HIGH bit is set for a given device, it
means that the CS line of that device is active HIGH
so it must be set to LOW initially. In case of GPIO
CS lines, the 'ath79_spi_setup_cs' function does the
opposite of that due to the wrong GPIO flags.

Fix the code to use the correct GPIO flags.

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-ath79.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-ath79.c b/drivers/spi/spi-ath79.c
index 0e06407..696599a 100644
--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -132,9 +132,9 @@ static int ath79_spi_setup_cs(struct spi_device *spi)
 
 		flags = GPIOF_DIR_OUT;
 		if (spi->mode & SPI_CS_HIGH)
-			flags |= GPIOF_INIT_HIGH;
-		else
 			flags |= GPIOF_INIT_LOW;
+		else
+			flags |= GPIOF_INIT_HIGH;
 
 		status = gpio_request_one(cdata->gpio, flags,
 					  dev_name(&spi->dev));
-- 
1.9.1

