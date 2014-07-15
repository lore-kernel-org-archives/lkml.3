Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbaGOR1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:27:45 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47377 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbaGORCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:07 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Tomasz Figa <t.figa@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 09/94] clk: s3c64xx: Hookup SPI clocks correctly
Date: Tue, 15 Jul 2014 20:00:24 +0300
Message-Id: <1405443709-15288-9-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

In the move to this clock driver the hookups for the SPI clocks were
dropped, which causes my system Cragganmore (s3c6410 based) to be unable
to locate any spibus clocks. This patch adds them back in.

When taking the clock from the epll clock (SCLK) the rates on the SPI
bus are incorrect, this needs further debugging but the hookup here
should be correct and the problem should be else where.

The USBCLK case has been dropped because this requires the USB PHY to be
enabled.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/samsung/clk-s3c64xx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
1.7.10.4

