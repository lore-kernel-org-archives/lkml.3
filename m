Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbaFRKBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:01:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47931 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965903AbaFRKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:01:07 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: t.figa@samsung.com, mturquette@linaro.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: s3c64xx: Hookup SPI clocks correctly
Date: Wed, 18 Jun 2014 10:52:23 +0100
Message-Id: <1403085143-3257-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the move to this clock driver the hookups for the SPI clocks were
dropped, which causes my system Cragganmore (s3c6410 based) to be unable
to locate any spibus clocks. This patch adds them back in.

When taking the clock from the epll clock (SCLK) the rates on the SPI
bus are incorrect, this needs further debugging but the hookup here
should be correct and the problem should be else where.

The USBCLK case has been dropped because this requires the USB PHY to be
enabled.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/clk/samsung/clk-s3c64xx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-s3c64xx.c b/drivers/clk/samsung/clk-s3c64xx.c
index efa16ee..8889ff1c 100644
--- a/drivers/clk/samsung/clk-s3c64xx.c
+++ b/drivers/clk/samsung/clk-s3c64xx.c
@@ -418,8 +418,10 @@ static struct samsung_clock_alias s3c64xx_clock_aliases[] = {
 	ALIAS(SCLK_MMC2, "s3c-sdhci.2", "mmc_busclk.2"),
 	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
 	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
-	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi-bus"),
-	ALIAS(SCLK_SPI0, "s3c6410-spi.0", "spi-bus"),
+	ALIAS(PCLK_SPI1, "s3c6410-spi.1", "spi_busclk0"),
+	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi_busclk2"),
+	ALIAS(PCLK_SPI0, "s3c6410-spi.0", "spi_busclk0"),
+	ALIAS(SCLK_SPI0, "s3c6410-spi.0", "spi_busclk2"),
 	ALIAS(SCLK_AUDIO1, "samsung-pcm.1", "audio-bus"),
 	ALIAS(SCLK_AUDIO1, "samsung-i2s.1", "audio-bus"),
 	ALIAS(SCLK_AUDIO0, "samsung-pcm.0", "audio-bus"),
-- 
1.7.2.5

