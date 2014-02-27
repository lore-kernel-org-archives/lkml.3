Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaB0LWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:22:35 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44153 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751202AbaB0LWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:22:33 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 1/9] ARM: at91: prepare at91sam9rl DT transition
Date: Thu, 27 Feb 2014 12:22:07 +0100
Message-Id: <1393500135-29636-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393500135-29636-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new names, coming from DT, for the clock lookups.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9rl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 3651517abedf..d6ee8bb47213 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -196,6 +196,22 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_ID("pioB", &pioB_clk),
 	CLKDEV_CON_ID("pioC", &pioC_clk),
 	CLKDEV_CON_ID("pioD", &pioD_clk),
+	/* more lookup table for DT entries */
+	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
+	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
+	CLKDEV_CON_DEV_ID("usart", "ffffb400.serial", &usart1_clk),
+	CLKDEV_CON_DEV_ID("usart", "ffffb800.serial", &usart2_clk),
+	CLKDEV_CON_DEV_ID("usart", "ffffbc00.serial", &usart3_clk),
+	CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
+	CLKDEV_CON_DEV_ID("t1_clk", "fffa0000.timer", &tc1_clk),
+	CLKDEV_CON_DEV_ID("t2_clk", "fffa0000.timer", &tc2_clk),
+	CLKDEV_CON_DEV_ID("mci_clk", "fffa4000.mmc", &mmc_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffa8000.i2c", &twi0_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffac000.i2c", &twi1_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioD_clk),
 };
 
 static struct clk_lookup usart_clocks_lookups[] = {
-- 
1.8.3.2

