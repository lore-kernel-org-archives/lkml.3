Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3EKLcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 07:32:14 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50549 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab3EKLcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 07:32:12 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Dan Williams <djbw@fb.com>
Subject: [RFC 3/4] ARM: S3C24XX: add platform-devices for new dma driver for s3c2412 and s3c2443
Date: Sat, 11 May 2013 13:32:08 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
References: <201305111330.05046.heiko@sntech.de>
In-Reply-To: <201305111330.05046.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305111332.08484.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes defining the mapping for the request sources.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/mach-s3c24xx/common.c |  103 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-s3c24xx/common.h |    3 +
 2 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
index c157103..9f64037 100644
--- a/arch/arm/mach-s3c24xx/common.c
+++ b/arch/arm/mach-s3c24xx/common.c
@@ -30,6 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/platform_data/dma-s3c24xx.h>
 
 #include <mach/hardware.h>
 #include <mach/regs-clock.h>
@@ -302,3 +303,105 @@ void __init_or_cpufreq s3c24xx_setup_clocks(unsigned long fclk,
 	clk_p.rate = pclk;
 	clk_f.rate = fclk;
 }
+
+#if defined(CONFIG_CPU_S3C2410) || defined(CONFIG_CPU_S3C2412) || \
+    defined(CONFIG_CPUS_3C2440) || defined(CONFIG_CPUS_3C2442)
+static struct resource s3c2410_dma_resource[] = {
+	[0] = DEFINE_RES_MEM(S3C24XX_PA_DMA, S3C24XX_SZ_DMA),
+	[1] = DEFINE_RES_IRQ(IRQ_DMA0),
+	[2] = DEFINE_RES_IRQ(IRQ_DMA1),
+	[3] = DEFINE_RES_IRQ(IRQ_DMA2),
+	[4] = DEFINE_RES_IRQ(IRQ_DMA3),
+};
+#endif
+
+#ifdef CONFIG_CPU_S3C2412
+static int s3c2412_dma_reqsel[S3C24XX_DMACH_MAX] = {
+	[S3C24XX_DMACH_XD0] = 17,
+	[S3C24XX_DMACH_XD1] = 18,
+	[S3C24XX_DMACH_SDI] = 10,
+	[S3C24XX_DMACH_SPI0_RX] = 1,
+	[S3C24XX_DMACH_SPI0_TX] = 0,
+	[S3C24XX_DMACH_SPI1_RX] = 3,
+	[S3C24XX_DMACH_SPI1_TX] = 2,
+	[S3C24XX_DMACH_UART0] = 19,
+	[S3C24XX_DMACH_UART1] = 21,
+	[S3C24XX_DMACH_UART2] = 23,
+	[S3C24XX_DMACH_UART0_SRC2] = 20,
+	[S3C24XX_DMACH_UART1_SRC2] = 22,
+	[S3C24XX_DMACH_UART2_SRC2] = 24,
+	[S3C24XX_DMACH_TIMER] = 9,
+	[S3C24XX_DMACH_I2S_RX] = 5,
+	[S3C24XX_DMACH_I2S_TX] = 4,
+	[S3C24XX_DMACH_USB_EP1] = 13,
+	[S3C24XX_DMACH_USB_EP2] = 14,
+	[S3C24XX_DMACH_USB_EP3] = 15,
+	[S3C24XX_DMACH_USB_EP4] = 16,
+};
+
+static struct s3c24xx_dma_platdata s3c2412_dma_platdata = {
+	.num_phy_channels = 4,
+	.reqsel_map = s3c2412_dma_reqsel,
+};
+
+struct platform_device s3c2412_device_dma = {
+	.name		= "s3c2412-dma",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(s3c2410_dma_resource),
+	.resource	= s3c2410_dma_resource,
+	.dev	= {
+		.platform_data	= &s3c2412_dma_platdata,
+	},
+};
+#endif
+
+#if defined(CONFIG_CPUS_3C2443) || defined(CONFIG_CPU_S3C2416)
+static struct resource s3c2443_dma_resource[] = {
+	[0] = DEFINE_RES_MEM(S3C24XX_PA_DMA, S3C24XX_SZ_DMA),
+	[1] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA0),
+	[2] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA1),
+	[3] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA2),
+	[4] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA3),
+	[5] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA4),
+	[6] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA5),
+};
+
+static int s3c2443_dma_reqsel[S3C24XX_DMACH_MAX] = {
+	[S3C24XX_DMACH_XD0] = 17,
+	[S3C24XX_DMACH_XD1] = 18,
+	[S3C24XX_DMACH_SDI] = 10,
+	[S3C24XX_DMACH_SPI0_RX] = 1,
+	[S3C24XX_DMACH_SPI0_TX] = 0,
+	[S3C24XX_DMACH_SPI1_RX] = 3,
+	[S3C24XX_DMACH_SPI1_TX] = 2,
+	[S3C24XX_DMACH_UART0] = 19,
+	[S3C24XX_DMACH_UART1] = 21,
+	[S3C24XX_DMACH_UART2] = 23,
+	[S3C24XX_DMACH_UART3] = 25,
+	[S3C24XX_DMACH_UART0_SRC2] = 20,
+	[S3C24XX_DMACH_UART1_SRC2] = 22,
+	[S3C24XX_DMACH_UART2_SRC2] = 24,
+	[S3C24XX_DMACH_UART3_SRC2] = 26,
+	[S3C24XX_DMACH_TIMER] = 9,
+	[S3C24XX_DMACH_I2S_RX] = 5,
+	[S3C24XX_DMACH_I2S_TX] = 4,
+	[S3C24XX_DMACH_PCM_IN] = 28,
+	[S3C24XX_DMACH_PCM_OUT] = 27,
+	[S3C24XX_DMACH_MIC_IN] = 29,
+};
+
+static struct s3c24xx_dma_platdata s3c2443_dma_platdata = {
+	.num_phy_channels = 6,
+	.reqsel_map = s3c2443_dma_reqsel,
+};
+
+struct platform_device s3c2443_device_dma = {
+	.name		= "s3c2443-dma",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(s3c2443_dma_resource),
+	.resource	= s3c2443_dma_resource,
+	.dev	= {
+		.platform_data	= &s3c2443_dma_platdata,
+	},
+};
+#endif
diff --git a/arch/arm/mach-s3c24xx/common.h b/arch/arm/mach-s3c24xx/common.h
index 307c371..7e134d9 100644
--- a/arch/arm/mach-s3c24xx/common.h
+++ b/arch/arm/mach-s3c24xx/common.h
@@ -107,4 +107,7 @@ extern void s3c2443_init_irq(void);
 
 extern struct syscore_ops s3c24xx_irq_syscore_ops;
 
+extern struct platform_device s3c2412_device_dma;
+extern struct platform_device s3c2443_device_dma;
+
 #endif /* __ARCH_ARM_MACH_S3C24XX_COMMON_H */
-- 
1.7.2.3

