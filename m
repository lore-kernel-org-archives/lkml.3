Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaIKNVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:21:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45973 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757003AbaIKNVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:21:47 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 6/9] ARM: at91: add clk_lookup entry for RTT devices
Date: Thu, 11 Sep 2014 15:18:42 +0200
Message-Id: <1410441525-25258-7-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410441525-25258-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1410441525-25258-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First export the clk32k clk.
Then add clk_lookup entries for RTT devices so that rtc-at91sam9 driver
can retrieve and manipulate the slow clk.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9260.c | 2 ++
 arch/arm/mach-at91/at91sam9261.c | 2 ++
 arch/arm/mach-at91/at91sam9263.c | 4 ++++
 arch/arm/mach-at91/at91sam9g45.c | 2 ++
 arch/arm/mach-at91/at91sam9rl.c  | 2 ++
 arch/arm/mach-at91/clock.c       | 2 +-
 arch/arm/mach-at91/clock.h       | 1 +
 7 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 3477ba9..a853d4c 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -217,6 +217,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("pclk", "fffbc000.ssc", &ssc_clk),
 	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
 	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g20.0", &twi_clk),
+	CLKDEV_CON_DEV_ID(NULL, "rtc-at91sam9.0", &clk32k),
 	/* more usart lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
 	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
@@ -237,6 +238,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffffd20.rtc", &clk32k),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index fb164a5..3f5a299 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -192,6 +192,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_ID("pioA", &pioA_clk),
 	CLKDEV_CON_ID("pioB", &pioB_clk),
 	CLKDEV_CON_ID("pioC", &pioC_clk),
+	CLKDEV_CON_DEV_ID(NULL, "rtc-at91sam9.0", &clk32k),
 	/* more lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
 	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
@@ -209,6 +210,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffffd20.rtc", &clk32k),
 };
 
 static struct clk_lookup usart_clocks_lookups[] = {
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 810fa5f..bef5b96 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -201,6 +201,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tcb_clk),
 	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
 	CLKDEV_CON_DEV_ID(NULL, "at91sam9rl-pwm", &pwm_clk),
+	CLKDEV_CON_DEV_ID(NULL, "rtc-at91sam9.0", &clk32k),
+	CLKDEV_CON_DEV_ID(NULL, "rtc-at91sam9.1", &clk32k),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
@@ -227,6 +229,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCDE_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioCDE_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffb8000.pwm", &pwm_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffffd20.rtc", &clk32k),
+	CLKDEV_CON_DEV_ID(NULL, "fffffd50.rtc", &clk32k),
 };
 
 static struct clk_lookup usart_clocks_lookups[] = {
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 9d45496..69fdfcc 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -253,6 +253,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "atmel_tdes", &aestdessha_clk),
 	CLKDEV_CON_DEV_ID(NULL, "atmel_aes", &aestdessha_clk),
 	CLKDEV_CON_DEV_ID(NULL, "at91sam9rl-pwm", &pwm_clk),
+	CLKDEV_CON_DEV_ID(NULL, "rtc-at91sam9.0", &clk32k),
 	/* more usart lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("usart", "ffffee00.serial", &mck),
 	CLKDEV_CON_DEV_ID("usart", "fff8c000.serial", &usart0_clk),
@@ -279,6 +280,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioC_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioDE_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioDE_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffffd20.rtc", &clk32k),
 
 	CLKDEV_CON_ID("pioA", &pioA_clk),
 	CLKDEV_CON_ID("pioB", &pioB_clk),
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 878d501..a82dc61 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -205,6 +205,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_ID("pioB", &pioB_clk),
 	CLKDEV_CON_ID("pioC", &pioC_clk),
 	CLKDEV_CON_ID("pioD", &pioD_clk),
+	CLKDEV_CON_DEV_ID(NULL, "rtc-at91sam9.0", &clk32k),
 	/* more lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
 	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
@@ -223,6 +224,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioD_clk),
+	CLKDEV_CON_DEV_ID(NULL, "fffffd20.rtc", &clk32k),
 	CLKDEV_CON_ID("adc_clk", &tsc_clk),
 };
 
diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 034529d..f5cfed75 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -115,7 +115,7 @@ static u32 at91_pllb_usb_init;
  * 48 MHz (unless no USB function clocks are needed).  The main clock and
  * both PLLs are turned off to run in "slow clock mode" (system suspend).
  */
-static struct clk clk32k = {
+struct clk clk32k = {
 	.name		= "clk32k",
 	.rate_hz	= AT91_SLOW_CLOCK,
 	.users		= 1,		/* always on */
diff --git a/arch/arm/mach-at91/clock.h b/arch/arm/mach-at91/clock.h
index a98a39b..6eb825a 100644
--- a/arch/arm/mach-at91/clock.h
+++ b/arch/arm/mach-at91/clock.h
@@ -34,6 +34,7 @@ struct clk {
 extern int __init clk_register(struct clk *clk);
 extern struct clk mck;
 extern struct clk utmi_clk;
+extern struct clk clk32k;
 
 #define CLKDEV_CON_ID(_id, _clk)			\
 	{						\
-- 
1.9.1

