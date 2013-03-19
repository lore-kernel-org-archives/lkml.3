Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab3CSHxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:53:41 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:44905 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752152Ab3CSHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:53:40 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>,
        <richard.genoud@gmail.com>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>, <linux@arm.linux.org.uk>,
        <linux@maxim.org.za>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 11/14] ARM: at91: add clocks for spi dt entries
Date: Tue, 19 Mar 2013 15:49:57 +0800
Message-ID: <1363679397-4125-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[<wenyou.yang@atmel.com: declare the spi clocks for sam9260, at91sam9g45, and at91sam9n12]
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux@maxim.org.za
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-at91/at91sam9260.c |    2 ++
 arch/arm/mach-at91/at91sam9g45.c |    2 ++
 arch/arm/mach-at91/at91sam9n12.c |    2 ++
 arch/arm/mach-at91/at91sam9x5.c  |    2 ++
 4 files changed, 8 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index b67cd53..44199bc 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -232,6 +232,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("t2_clk", "fffdc000.timer", &tc5_clk),
 	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &ohci_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index d3addee..2ec5efe 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -262,6 +262,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("mci_clk", "fffd0000.mmc", &mmc1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fff84000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fff88000.i2c", &twi1_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffa4000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffa8000.spi", &spi1_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &uhphs_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff200.gpio", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index 5dfc8fd..ccd0783 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -172,6 +172,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0000000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0004000.spi", &spi1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCD_clk),
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 44a9a62..a200d8a 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -237,6 +237,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8018000.i2c", &twi2_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0000000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0004000.spi", &spi1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCD_clk),
-- 
1.7.9.5

