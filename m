Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab3GSUXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:23:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3GSUXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:23:05 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 10/15] ARM: shmobile: r8a73a4: add a DMAC platform device and clock for it
Date: Fri, 19 Jul 2013 22:22:51 +0200
Message-Id: <1374265376-30777-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:hwYEamo4JI1JxqARE8Vf05c/ck/N2nD2GvgIFhq38Q+
 rKb8d8iHq1GDhNk2zHo2ZEm3iW3CBqK2lvLWsSm4RdsNs3bLKV
 j+fNlllrE1PvJY4Vy2J+VyIRjK9HmJcnCZ2UGZ1QFS8M6JBuI6
 N3VquZWp0vY3zHzCcTxRcdu8xwCmrIFY/x5bmkKVvfCxXsn3Qi
 jE90LCjOVr+XMD625tkO1ZbJCycPaKC4ZUo8NYK1TYPu+rtweI
 Sa5e72n56rlnCOq8IEzcEd4B7tWJZk8I0qgqip15de2zKBgNQS
 zlZHHptFBV714qfihEMDqcIE8bdo6Prqn8WCj9CvYjeF7yc9Gr
 8stUvgGQ9fvs23/3JkgXlhdyXvor2PIpClII/DqyeedWcbmJHw
 cN0EU1cDUG03g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DMAC platform device and clock definitions for it on r8a73a4.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/mach-shmobile/clock-r8a73a4.c        |    4 +++-
 arch/arm/mach-shmobile/include/mach/r8a73a4.h |    9 +++++++++
 arch/arm/mach-shmobile/setup-r8a73a4.c        |   17 +++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletions(-)

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
index 630ea4e..ad7180e 100644
--- a/arch/arm/mach-shmobile/setup-r8a73a4.c
+++ b/arch/arm/mach-shmobile/setup-r8a73a4.c
@@ -199,12 +199,29 @@ void __init r8a73a4_add_dt_devices(void)
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
 	r8a73a4_register_irqc(0);
 	r8a73a4_register_irqc(1);
 	r8a73a4_register_thermal();
+	r8a73a4_register_dmac();
 }
 
 void __init r8a73a4_init_delay(void)
-- 
1.7.2.5

