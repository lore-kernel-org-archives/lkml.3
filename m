Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbaCUAgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:36:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965899AbaCUAIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Gabor Juhos <juhosg@openwrt.org>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 49/85] spi: spi-ath79: fix initial GPIO CS line setup
Date: Thu, 20 Mar 2014 17:09:52 -0700
Message-Id: <20140321000605.703866310@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-ath79.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -132,9 +132,9 @@ static int ath79_spi_setup_cs(struct spi
 
 		flags = GPIOF_DIR_OUT;
 		if (spi->mode & SPI_CS_HIGH)
-			flags |= GPIOF_INIT_HIGH;
-		else
 			flags |= GPIOF_INIT_LOW;
+		else
+			flags |= GPIOF_INIT_HIGH;
 
 		status = gpio_request_one(cdata->gpio, flags,
 					  dev_name(&spi->dev));


