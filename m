Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265Ab3BHQfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:35:51 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:35810 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760218Ab3BHQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:35:47 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <FlorianSchandinat@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jhovold@gmail.com>,
        <jacmet@sunsite.dk>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/5] ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
Date: Fri, 8 Feb 2013 17:35:16 +0100
Message-ID: <a8b6b6e8dcee64943273143dab76db716d4dc3d4.1360340791.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1360340791.git.nicolas.ferre@atmel.com>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

Add hclk entry for the atmel_lcdfb bus clock.

On at91sam9261, at91sam9g10 and at32ap the bus clock has to be enabled
as well as the peripheral clock. Add the appropriate lookup entries to
these SOCs and fake clocks to the SOCs that do not use it.

This allows us to get rid of the conditional enabling of the clocks in
the driver which relied on the cpu_is macros.

Tested on at91sam9263 and at91sam9g45, compile-tested for other
AT91-SOCs, and untested for AVR32.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9261.c    |  1 +
 arch/arm/mach-at91/at91sam9263.c    |  1 +
 arch/arm/mach-at91/at91sam9g45.c    |  1 +
 arch/arm/mach-at91/at91sam9rl.c     |  1 +
 arch/avr32/mach-at32ap/at32ap700x.c |  4 ++--
 drivers/video/atmel_lcdfb.c         | 23 ++++++++---------------
 6 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 2998a08..5838f12 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -169,6 +169,7 @@ static struct clk *periph_clocks[] __initdata = {
 };
 
 static struct clk_lookup periph_clocks_lookups[] = {
+	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &hck1),
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index b9fc60d..520a63d 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -190,6 +190,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.1", &ssc1_clk),
 	CLKDEV_CON_DEV_ID("pclk", "fff98000.ssc", &ssc0_clk),
 	CLKDEV_CON_DEV_ID("pclk", "fff9c000.ssc", &ssc1_clk),
+	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &lcdc_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.0", &mmc0_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.1", &mmc1_clk),
 	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index d3addee..ea6b62b 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -228,6 +228,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_ID("hclk", &macb_clk),
 	/* One additional fake clock for ohci */
 	CLKDEV_CON_ID("ohci_clk", &uhphs_clk),
+	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &lcdc_clk),
 	CLKDEV_CON_DEV_ID("ehci_clk", "atmel-ehci", &uhphs_clk),
 	CLKDEV_CON_DEV_ID("hclk", "atmel_usba_udc", &utmi_clk),
 	CLKDEV_CON_DEV_ID("pclk", "atmel_usba_udc", &udphs_clk),
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index eb98704..4cd4fa9 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -179,6 +179,7 @@ static struct clk *periph_clocks[] __initdata = {
 };
 
 static struct clk_lookup periph_clocks_lookups[] = {
+	CLKDEV_CON_DEV_ID("hclk", "atmel_lcdfb.0", &lcdc_clk),
 	CLKDEV_CON_DEV_ID("hclk", "atmel_usba_udc", &utmi_clk),
 	CLKDEV_CON_DEV_ID("pclk", "atmel_usba_udc", &udphs_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index b323d8d..cd25b01 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1453,7 +1453,7 @@ static struct resource atmel_lcdfb0_resource[] = {
 	},
 };
 DEFINE_DEV_DATA(atmel_lcdfb, 0);
-DEV_CLK(hck1, atmel_lcdfb0, hsb, 7);
+DEV_CLK(hclk, atmel_lcdfb0, hsb, 7);
 static struct clk atmel_lcdfb0_pixclk = {
 	.name		= "lcdc_clk",
 	.dev		= &atmel_lcdfb0_device.dev,
@@ -2246,7 +2246,7 @@ static __initdata struct clk *init_clocks[] = {
 	&atmel_twi0_pclk,
 	&atmel_mci0_pclk,
 #if defined(CONFIG_CPU_AT32AP7000) || defined(CONFIG_CPU_AT32AP7002)
-	&atmel_lcdfb0_hck1,
+	&atmel_lcdfb0_hclk,
 	&atmel_lcdfb0_pixclk,
 #endif
 	&ssc0_pclk,
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 025428e..c5883ca 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -821,15 +821,13 @@ static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
 
 static void atmel_lcdfb_start_clock(struct atmel_lcdfb_info *sinfo)
 {
-	if (sinfo->bus_clk)
-		clk_enable(sinfo->bus_clk);
+	clk_enable(sinfo->bus_clk);
 	clk_enable(sinfo->lcdc_clk);
 }
 
 static void atmel_lcdfb_stop_clock(struct atmel_lcdfb_info *sinfo)
 {
-	if (sinfo->bus_clk)
-		clk_disable(sinfo->bus_clk);
+	clk_disable(sinfo->bus_clk);
 	clk_disable(sinfo->lcdc_clk);
 }
 
@@ -888,13 +886,10 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	info->fix = atmel_lcdfb_fix;
 
 	/* Enable LCDC Clocks */
-	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()
-	 || cpu_is_at32ap7000()) {
-		sinfo->bus_clk = clk_get(dev, "hck1");
-		if (IS_ERR(sinfo->bus_clk)) {
-			ret = PTR_ERR(sinfo->bus_clk);
-			goto free_info;
-		}
+	sinfo->bus_clk = clk_get(dev, "hclk");
+	if (IS_ERR(sinfo->bus_clk)) {
+		ret = PTR_ERR(sinfo->bus_clk);
+		goto free_info;
 	}
 	sinfo->lcdc_clk = clk_get(dev, "lcdc_clk");
 	if (IS_ERR(sinfo->lcdc_clk)) {
@@ -1055,8 +1050,7 @@ stop_clk:
 	atmel_lcdfb_stop_clock(sinfo);
 	clk_put(sinfo->lcdc_clk);
 put_bus_clk:
-	if (sinfo->bus_clk)
-		clk_put(sinfo->bus_clk);
+	clk_put(sinfo->bus_clk);
 free_info:
 	framebuffer_release(info);
 out:
@@ -1081,8 +1075,7 @@ static int __exit atmel_lcdfb_remove(struct platform_device *pdev)
 	unregister_framebuffer(info);
 	atmel_lcdfb_stop_clock(sinfo);
 	clk_put(sinfo->lcdc_clk);
-	if (sinfo->bus_clk)
-		clk_put(sinfo->bus_clk);
+	clk_put(sinfo->bus_clk);
 	fb_dealloc_cmap(&info->cmap);
 	free_irq(sinfo->irq_base, info);
 	iounmap(sinfo->mmio);
-- 
1.8.0

