Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab3GLNoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:44:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821Ab3GLNoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:44:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 4/8] ARM: shmobile: r8a73a4: add a DMAC platform device and clock for it
Date: Fri, 12 Jul 2013 15:43:54 +0200
Message-Id: <1373636638-18496-5-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:PGfX2BiiHppc67ZvfmmFQSMZscL4qNT6Kn9ym6I5uWo
 46CVrXCSzKgFB4DipZwSmLfCeRWV5pH2km/UPaK8t1jmIIQ8yo
 CKmT2wF9avk9AVu7wN+46rpZlwISuTcPbiKzQOByiT1NvjAszo
 UZlvk43LWG5EqGvHr4ifUtKY29KAzghwlmOtaQVIEdN8wkJH9o
 UTVFHTV5jcYzHxGo83Yb0lvKO/e81PjtMy7rrObKIOINKEN3Iy
 xStLTu7OB1PjCReSNYS2VARLlS1YDj4cM9oQtgKF3fXQt5Xs0/
 rt/CEENg9yv47b775mEN8mgi5Ha8itjwI0P1aBpViwlYWNGB2t
 GiLDLk8AnN9Ajx4HZN38IpXA6Vh8r/KdBi+RaL+7AtsX39BZU5
 UJwGp5hkxzo4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DMAC platform device and clock definitions for it on r8a73a4.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

Simon: this patch supersedes my earlier patch "ARM: shmobile: r8a73a4: add 
a DMAC platform device and clock for it". With this approach we also don't 
have a build dependency on the DMA tree: the configuration data now 
belongs to the driver and will also go via the DMA tree. This patch can be 
applied independently, it just won't work until the driver is updated.

 arch/arm/mach-shmobile/clock-r8a73a4.c        |    4 +++-
 arch/arm/mach-shmobile/include/mach/r8a73a4.h |    9 +++++++++
 arch/arm/mach-shmobile/setup-r8a73a4.c        |   16 ++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a73a4.c b/arch/arm/mach-shmobile/clock-r8a73a4.c
index 8ea5ef6..cd62b11 100644
--- a/arch/arm/mach-shmobile/clock-r8a73a4.c
+++ b/arch/arm/mach-shmobile/clock-r8a73a4.c
@@ -504,7 +504,7 @@ static struct clk div6_clks[DIV6_NR] = {
 
 /* MSTP */
 enum {
-	MSTP217, MSTP216, MSTP207, MSTP206, MSTP204, MSTP203,
+	MSTP218, MSTP217, MSTP216, MSTP207, MSTP206, MSTP204, MSTP203,
 	MSTP329, MSTP323, MSTP318, MSTP317, MSTP316,
 	MSTP315, MSTP314, MSTP313, MSTP312, MSTP305, MSTP300,
 	MSTP411, MSTP410, MSTP409,
@@ -519,6 +519,7 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP207] = SH_CLK_MSTP32(&div6_clks[DIV6_MP],	SMSTPCR2, 7, 0), /* SCIFB1 */
 	[MSTP216] = SH_CLK_MSTP32(&div6_clks[DIV6_MP],	SMSTPCR2, 16, 0), /* SCIFB2 */
 	[MSTP217] = SH_CLK_MSTP32(&div6_clks[DIV6_MP],	SMSTPCR2, 17, 0), /* SCIFB3 */
+	[MSTP218] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR2, 18, 0), /* DMAC */
 	[MSTP300] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR3, 0, 0), /* IIC2 */
 	[MSTP305] = SH_CLK_MSTP32(&div6_clks[DIV6_MMC1],SMSTPCR3, 5, 0), /* MMCIF1 */
 	[MSTP312] = SH_CLK_MSTP32(&div6_clks[DIV6_SDHI2],SMSTPCR3, 12, 0), /* SDHI2 */
@@ -578,6 +579,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-sci.3", &mstp_clks[MSTP207]),
 	CLKDEV_DEV_ID("sh-sci.4", &mstp_clks[MSTP216]),
 	CLKDEV_DEV_ID("sh-sci.5", &mstp_clks[MSTP217]),
+	CLKDEV_DEV_ID("shdma-r8a73a4.0", &mstp_clks[MSTP218]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("e6520000.i2c", &mstp_clks[MSTP300]),
 	CLKDEV_DEV_ID("sh_mmcif.1", &mstp_clks[MSTP305]),
diff --git a/arch/arm/mach-shmobile/include/mach/r8a73a4.h b/arch/arm/mach-shmobile/include/mach/r8a73a4.h
index f3a9b70..3a0ea48 100644
--- a/arch/arm/mach-shmobile/include/mach/r8a73a4.h
+++ b/arch/arm/mach-shmobile/include/mach/r8a73a4.h
@@ -1,6 +1,15 @@
 #ifndef __ASM_R8A73A4_H__
 #define __ASM_R8A73A4_H__
 
+/* DMA slave IDs */
+enum {
+	SHDMA_SLAVE_INVALID,
+	SHDMA_SLAVE_MMCIF0_TX,
+	SHDMA_SLAVE_MMCIF0_RX,
+	SHDMA_SLAVE_MMCIF1_TX,
+	SHDMA_SLAVE_MMCIF1_RX,
+};
+
 void r8a73a4_add_standard_devices(void);
 void r8a73a4_add_dt_devices(void);
 void r8a73a4_clock_init(void);
diff --git a/arch/arm/mach-shmobile/setup-r8a73a4.c b/arch/arm/mach-shmobile/setup-r8a73a4.c
index 630ea4e..86af8b1 100644
--- a/arch/arm/mach-shmobile/setup-r8a73a4.c
+++ b/arch/arm/mach-shmobile/setup-r8a73a4.c
@@ -199,6 +199,22 @@ void __init r8a73a4_add_dt_devices(void)
 	r8a7790_register_cmt(10);
 }
 
+/* DMA */
+static struct resource dma_resources[] = {
+	DEFINE_RES_MEM(0xe6700020, 0x89e0),
+	DEFINE_RES_IRQ_NAMED(gic_spi(220), "error_irq"),
+	{
+		/* IRQ for channels 0-19 */
+		.start  = gic_spi(200),
+		.end    = gic_spi(219),
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+#define r8a73a4_register_dmac()							\
+	platform_device_register_simple("shdma-r8a73a4", 0,			\
+				dma_resources, ARRAY_SIZE(dma_resources))
+
 void __init r8a73a4_add_standard_devices(void)
 {
 	r8a73a4_add_dt_devices();
-- 
1.7.2.5

