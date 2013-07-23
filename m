Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3GWKvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:51:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3GWKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:50:20 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v4 15/15] ARM: shmobile: r8a7740: add support for 2 RTDMACs
Date: Tue, 23 Jul 2013 12:50:09 +0200
Message-Id: <1374576609-27748-16-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:Ealqi6RsZtcNWH4Vfflak1vS8fAh0g6//qFnMkBLOkc
 Q+C/bAhOKTjl4uhBAW/cqkqNEgI1exE869DKo3RXe720MYfpmG
 6f2x1J/ghsVigLhEDED2oKyMz2KAJQopjtJ6lqJWsicl+tuTXY
 vAlgv1xohzJQXwRYdYr0YrgWAZzSGQV02vy4wy17KhEmeRGYIM
 QW7bZT05YujyBVn1cMhdeXTU7K073i95SN+XIQoKmSl1p67llu
 xIwnH7w2gAWoJ2fMTcOhBbc+jcAa0HUNixfXgUGC5UN5cXyq+v
 ECRqYLpbrxEoI4HlnaSRsWyh2A5eQ1Vg4kgDLt0l/cPbELcyp8
 19Nlflka19R50Fztr6Qu1FjAheOLe7BScjIlaNxf4oJMEjcdHv
 zGNH02sNutngLx2vY4iywCV2nuF+Q9+xAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to 3 SYS-DMACs, r817740 SoCs also have 2 RT-DMACs. This patch
adds support for them in both DT- amd non-DT-modes.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v4: update documentation

 Documentation/devicetree/bindings/dma/shdma.txt |    2 +-
 arch/arm/boot/dts/r8a7740.dtsi                  |   34 +++++++++++
 arch/arm/mach-shmobile/clock-r8a7740.c          |    8 +++
 arch/arm/mach-shmobile/setup-r8a7740.c          |   72 +++++++++++++++++++++++
 4 files changed, 115 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/shdma.txt b/Documentation/devicetree/bindings/dma/shdma.txt
index aeed9b8..5ff154d 100644
--- a/Documentation/devicetree/bindings/dma/shdma.txt
+++ b/Documentation/devicetree/bindings/dma/shdma.txt
@@ -24,7 +24,7 @@ Optional properties (currently unused):
 Required properties:
 - compatible:	should be one of
 		"renesas,shdma-r8a73a4" for the system DMAC on r8a73a4 SoC
-		"renesas,shdma-r8a7740" for the DMACs (not RTDMAC) on r8a7740
+		"renesas,shdma-r8a7740" for the DMACs and RTDMACs on r8a7740
 		"renesas,shdma-sh73a0" for the DMACs on sh73a0
 
 Optional properties:
diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 4797f1e..638ada2 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -175,6 +175,40 @@
 					"ch0", "ch1", "ch2", "ch3",
 					"ch4", "ch5";
 		};
+
+		dma3: dma-controller@ffc18020 {
+			compatible = "renesas,shdma-r8a7740";
+			reg = <0xffc18020 0x270>,
+				<0xffc19000 0xc>;
+			interrupt-parent = <&gic>;
+			interrupts = <0 196 4
+					0 190 4
+					0 191 4
+					0 192 4
+					0 193 4
+					0 194 4
+					0 195 4>;
+			interrupt-names = "error",
+					"ch0", "ch1", "ch2", "ch3",
+					"ch4", "ch5";
+		};
+
+		dma4: dma-controller@ffc28020 {
+			compatible = "renesas,shdma-r8a7740";
+			reg = <0xffc28020 0x270>,
+				<0xffc29000 0xc>;
+			interrupt-parent = <&gic>;
+			interrupts = <0 158 4
+					0 152 4
+					0 153 4
+					0 154 4
+					0 155 4
+					0 156 4
+					0 157 4>;
+			interrupt-names = "error",
+					"ch0", "ch1", "ch2", "ch3",
+					"ch4", "ch5";
+		};
 	};
 
 	i2c0: i2c@fff20000 {
diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index b355018..c4a8309 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -451,6 +451,8 @@ static struct clk fsidivs[] = {
 
 /* MSTP */
 enum {
+	MSTP023, MSTP021,
+
 	MSTP128, MSTP127, MSTP125,
 	MSTP116, MSTP111, MSTP100, MSTP117,
 
@@ -469,6 +471,8 @@ enum {
 };
 
 static struct clk mstp_clks[MSTP_NR] = {
+	[MSTP021] = SH_CLK_MSTP32(&div4_clks[DIV4_S],	SMSTPCR0, 21, 0), /* RT-DMAC1 */
+	[MSTP023] = SH_CLK_MSTP32(&div4_clks[DIV4_S],	SMSTPCR0, 23, 0), /* RT-DMAC2 */
 	[MSTP128] = SH_CLK_MSTP32(&div4_clks[DIV4_S],	SMSTPCR1, 28, 0), /* CEU21 */
 	[MSTP127] = SH_CLK_MSTP32(&div4_clks[DIV4_S],	SMSTPCR1, 27, 0), /* CEU20 */
 	[MSTP125] = SH_CLK_MSTP32(&div6_clks[DIV6_SUB],	SMSTPCR1, 25, 0), /* TMU0 */
@@ -547,6 +551,10 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("sub_clk",		&div6_clks[DIV6_SUB]),
 
 	/* MSTP32 clocks */
+	CLKDEV_DEV_ID("shdma-r8a7740.4",	&mstp_clks[MSTP021]),
+	CLKDEV_DEV_ID("ffc18020.dma-controller",&mstp_clks[MSTP021]),
+	CLKDEV_DEV_ID("shdma-r8a7740.5",	&mstp_clks[MSTP023]),
+	CLKDEV_DEV_ID("ffc28020.dma-controller",&mstp_clks[MSTP023]),
 	CLKDEV_DEV_ID("sh_mobile_lcdc_fb.0",	&mstp_clks[MSTP100]),
 	CLKDEV_DEV_ID("sh_tmu.3",		&mstp_clks[MSTP111]),
 	CLKDEV_DEV_ID("sh_tmu.4",		&mstp_clks[MSTP111]),
diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index 01dcb3b..2dc2d652 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -626,6 +626,62 @@ static struct resource r8a7740_dmae2_resources[] = {
 	},
 };
 
+/* Resource order important! */
+static struct resource r8a7740_rtdma0_resources[] = {
+	{
+		/* Channel registers and DMAOR */
+		.start	= 0xffc18020,
+		.end	= 0xffc1828f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMARSx */
+		.start	= 0xffc19000,
+		.end	= 0xffc1900b,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.name	= "error_irq",
+		.start	= gic_spi(196),
+		.end	= gic_spi(196),
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		/* IRQ for channels 0-5 */
+		.start	= gic_spi(190),
+		.end	= gic_spi(195),
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+/* Resource order important! */
+static struct resource r8a7740_rtdma1_resources[] = {
+	{
+		/* Channel registers and DMAOR */
+		.start	= 0xffc28020,
+		.end	= 0xffc2828f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMARSx */
+		.start	= 0xffc29000,
+		.end	= 0xffc2900b,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.name	= "error_irq",
+		.start	= gic_spi(158),
+		.end	= gic_spi(158),
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		/* IRQ for channels 0-5 */
+		.start	= gic_spi(152),
+		.end	= gic_spi(157),
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
 static struct platform_device dma0_device = {
 	.name		= "shdma-r8a7740",
 	.id		= 0,
@@ -647,6 +703,20 @@ static struct platform_device dma2_device = {
 	.num_resources	= ARRAY_SIZE(r8a7740_dmae2_resources),
 };
 
+static struct platform_device rtdma0_device = {
+	.name		= "shdma-r8a7740",
+	.id		= 4,
+	.resource	= r8a7740_rtdma0_resources,
+	.num_resources	= ARRAY_SIZE(r8a7740_rtdma0_resources),
+};
+
+static struct platform_device rtdma1_device = {
+	.name		= "shdma-r8a7740",
+	.id		= 5,
+	.resource	= r8a7740_rtdma1_resources,
+	.num_resources	= ARRAY_SIZE(r8a7740_rtdma1_resources),
+};
+
 /* USB-DMAC */
 static const struct sh_dmae_channel r8a7740_usb_dma_channels[] = {
 	{
@@ -781,6 +851,8 @@ static struct platform_device *r8a7740_late_devices[] __initdata = {
 	&dma0_device,
 	&dma1_device,
 	&dma2_device,
+	&rtdma0_device,
+	&rtdma1_device,
 	&usb_dma_device,
 	&pmu_device,
 };
-- 
1.7.2.5

