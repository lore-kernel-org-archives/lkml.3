Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3GQOzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:55:40 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:44039 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755697Ab3GQOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:55:39 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 18/42] ARM: at91: move at91sam9n12 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 16:49:53 +0200
Message-Id: <1374072593-19740-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 12608108633274480748
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all references to the old at91 clks for at91sam9n12 SoC.
This SoC only supports dt boards: we can remove register_clocks
(all clocks are defined in dt).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91sam9n12.c |  194 --------------------------------------
 1 file changed, 194 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index c270503..e4863fc 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -19,202 +19,9 @@
 #include "board.h"
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 
 /* --------------------------------------------------------------------
- *  Clocks
- * -------------------------------------------------------------------- */
-
-/*
- * The peripheral clocks.
- */
-static struct clk pioAB_clk = {
-	.name		= "pioAB_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_PIOAB,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioCD_clk = {
-	.name		= "pioCD_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_PIOCD,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart0_clk = {
-	.name		= "usart0_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_USART0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart1_clk = {
-	.name		= "usart1_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_USART1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart2_clk = {
-	.name		= "usart2_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_USART2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart3_clk = {
-	.name		= "usart3_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_USART3,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk twi0_clk = {
-	.name		= "twi0_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_TWI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk twi1_clk = {
-	.name		= "twi1_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_TWI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk mmc_clk = {
-	.name		= "mci_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_MCI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi0_clk = {
-	.name		= "spi0_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_SPI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi1_clk = {
-	.name		= "spi1_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_SPI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk uart0_clk = {
-	.name		= "uart0_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_UART0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk uart1_clk = {
-	.name		= "uart1_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_UART1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tcb_clk = {
-	.name		= "tcb_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_TCB,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pwm_clk = {
-	.name		= "pwm_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_PWM,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk adc_clk = {
-	.name		= "adc_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_ADC,
-	.type	= CLK_TYPE_PERIPHERAL,
-};
-static struct clk dma_clk = {
-	.name		= "dma_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_DMA,
-	.type	= CLK_TYPE_PERIPHERAL,
-};
-static struct clk uhp_clk = {
-	.name		= "uhp",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_UHP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk udp_clk = {
-	.name		= "udp_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_UDP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk lcdc_clk = {
-	.name		= "lcdc_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_LCDC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ssc_clk = {
-	.name		= "ssc_clk",
-	.pmc_mask	= 1 << AT91SAM9N12_ID_SSC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-
-static struct clk *periph_clocks[] __initdata = {
-	&pioAB_clk,
-	&pioCD_clk,
-	&usart0_clk,
-	&usart1_clk,
-	&usart2_clk,
-	&usart3_clk,
-	&twi0_clk,
-	&twi1_clk,
-	&mmc_clk,
-	&spi0_clk,
-	&spi1_clk,
-	&lcdc_clk,
-	&uart0_clk,
-	&uart1_clk,
-	&tcb_clk,
-	&pwm_clk,
-	&adc_clk,
-	&dma_clk,
-	&uhp_clk,
-	&udp_clk,
-	&ssc_clk,
-};
-
-static struct clk_lookup periph_clocks_lookups[] = {
-	/* lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
-	CLKDEV_CON_DEV_ID("usart", "f801c000.serial", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "f8020000.serial", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "f8024000.serial", &usart2_clk),
-	CLKDEV_CON_DEV_ID("usart", "f8028000.serial", &usart3_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "f8008000.timer", &tcb_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "f800c000.timer", &tcb_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "f0008000.mmc", &mmc_clk),
-	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma_clk),
-	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
-	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "f0000000.spi", &spi0_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "f0004000.spi", &spi1_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioAB_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCD_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioCD_clk),
-	/* additional fake clock for macb_hclk */
-	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &uhp_clk),
-	CLKDEV_CON_DEV_ID("ohci_clk", "500000.ohci", &uhp_clk),
-};
-
-/*
- * The two programmable clocks.
- * You must configure pin multiplexing to bring these signals out.
- */
-static struct clk pck0 = {
-	.name		= "pck0",
-	.pmc_mask	= AT91_PMC_PCK0,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 0,
-};
-static struct clk pck1 = {
-	.name		= "pck1",
-	.pmc_mask	= AT91_PMC_PCK1,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 1,
-};
-
-static void __init at91sam9n12_register_clocks(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
-		clk_register(periph_clocks[i]);
-	clk_register(&pck0);
-	clk_register(&pck1);
-
-	clkdev_add_table(periph_clocks_lookups,
-			 ARRAY_SIZE(periph_clocks_lookups));
-
-}
-
-/* --------------------------------------------------------------------
  *  AT91SAM9N12 processor initialization
  * -------------------------------------------------------------------- */
 
@@ -225,5 +32,4 @@ static void __init at91sam9n12_map_io(void)
 
 AT91_SOC_START(at91sam9n12)
 	.map_io = at91sam9n12_map_io,
-	.register_clocks = at91sam9n12_register_clocks,
 AT91_SOC_END
-- 
1.7.9.5

