Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab3JOMfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:35:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52641 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759132Ab3JOMft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:35:49 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: mturquette@linaro.org
Cc: tomasz.figa@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: s3c64xx: Correct spi bus clock hookups
Date: Tue, 15 Oct 2013 13:26:22 +0100
Message-Id: <1381839982-3026-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the SPI bus clock hookups to match their state before the switch
to this driver. With out this patch my system (based on an s3c6410)
can't locate any spibus clock.

Note, I only have a passing familiarity with this driver and subsystem
so this patch could probably use a careful eye.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/clk/samsung/clk-s3c64xx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-s3c64xx.c b/drivers/clk/samsung/clk-s3c64xx.c
index 7d2c842..f6ac974 100644
--- a/drivers/clk/samsung/clk-s3c64xx.c
+++ b/drivers/clk/samsung/clk-s3c64xx.c
@@ -356,8 +356,12 @@ static struct samsung_clock_alias s3c64xx_clock_aliases[] = {
 	ALIAS(SCLK_MMC2, "s3c-sdhci.2", "mmc_busclk.2"),
 	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
 	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
-	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi-bus"),
-	ALIAS(SCLK_SPI0, "s3c6410-spi.0", "spi-bus"),
+	ALIAS(PCLK_SPI1, "s3c6410-spi.1", "spi_busclk0"),
+	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi_busclk1"),
+	ALIAS(SCLK_SPI1_48, "s3c6410-spi.1", "spi_busclk2"),
+	ALIAS(PCLK_SPI0, "s3c6410-spi.0", "spi_busclk0"),
+	ALIAS(SCLK_SPI0, "s3c6410-spi.0", "spi_busclk1"),
+	ALIAS(SCLK_SPI0_48, "s3c6410-spi.0", "spi_busclk2"),
 	ALIAS(SCLK_AUDIO1, "samsung-pcm.1", "audio-bus"),
 	ALIAS(SCLK_AUDIO1, "samsung-i2s.1", "audio-bus"),
 	ALIAS(SCLK_AUDIO0, "samsung-pcm.0", "audio-bus"),
-- 
1.7.2.5

