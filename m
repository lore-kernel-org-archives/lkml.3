Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3AaKNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:13:04 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:44225 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3AaKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:13:01 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Brian Lilly <brian@crystalfontz.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: spi-gpio: fix compilation warning on 64 bits systems
Date: Thu, 31 Jan 2013 11:12:56 +0100
Message-Id: <1359627176-22706-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPI_GPIO_NO_MOSI and SPI_GPIO_NO_MISO flags are type casted to unsigned
long, yet, they are to be stored in an unsigned int field in the
spi_gpio_platform_data structure.

This leads to the following warning during compilation on 64 bits systems:
warning: large integer implicitly truncated to unsigned type [-Woverflow]

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 include/linux/spi/spi_gpio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/spi/spi_gpio.h b/include/linux/spi/spi_gpio.h
index 369b3d7..1634ce3 100644
--- a/include/linux/spi/spi_gpio.h
+++ b/include/linux/spi/spi_gpio.h
@@ -62,8 +62,8 @@
  */
 struct spi_gpio_platform_data {
 	unsigned	sck;
-	unsigned	mosi;
-	unsigned	miso;
+	unsigned long	mosi;
+	unsigned long	miso;
 
 	u16		num_chipselect;
 };
-- 
1.7.10.4

