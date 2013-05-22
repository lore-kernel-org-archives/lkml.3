Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3EVHLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:11:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45745 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab3EVHLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:11:16 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 06/11] ARM: davinci: da8xx: gpio device creation
Date: Wed, 22 May 2013 12:40:29 +0530
Message-ID: <1369206634-6778-7-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create davinci gpio device and remove references in davinci_soc_info
structure. Also rearrange header file inclusion in group basis.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-davinci/board-da830-evm.c     |   19 +++++++++++++++----
 arch/arm/mach-davinci/board-da850-evm.c     |   11 +++++++++++
 arch/arm/mach-davinci/board-omapl138-hawk.c |    2 ++
 arch/arm/mach-davinci/da830.c               |    4 ----
 arch/arm/mach-davinci/da850.c               |    4 ----
 5 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 1332de8..4e8bcc1 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -22,17 +22,19 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/spi-davinci.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/cp_intc.h>
 #include <mach/mux.h>
-#include <linux/platform_data/mtd-davinci.h>
+#include <mach/common.h>
 #include <mach/da8xx.h>
-#include <linux/platform_data/usb-davinci.h>
-#include <linux/platform_data/mtd-davinci-aemif.h>
-#include <linux/platform_data/spi-davinci.h>
 
 #define DA830_EVM_PHY_ID		""
 /*
@@ -590,11 +592,20 @@ static struct spi_board_info da830evm_spi_info[] = {
 	},
 };
 
+static struct davinci_gpio_platform_data da830_gpio_platform_data = {
+	.ngpio = 128,
+	.intc_irq_num = DA830_N_CP_INTC_IRQ,
+};
+
 static __init void da830_evm_init(void)
 {
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 	int ret;
 
+	ret = da8xx_register_gpio(&da830_gpio_platform_data);
+	if (ret)
+		pr_warn("da830_evm_init: GPIO init failed: %d\n", ret);
+
 	ret = da830_register_edma(da830_edma_rsv);
 	if (ret)
 		pr_warning("da830_evm_init: edma registration failed: %d\n",
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 8a24b6c..d5dd010 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -28,6 +28,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/gpio-davinci.h>
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
 #include <linux/platform_data/spi-davinci.h>
@@ -42,6 +43,7 @@
 #include <mach/da8xx.h>
 #include <mach/mux.h>
 #include <mach/sram.h>
+#include <mach/common.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -1138,6 +1140,11 @@ static struct edma_rsv_info *da850_edma_rsv[2] = {
 	&da850_edma_cc1_rsv,
 };
 
+static struct davinci_gpio_platform_data da850_gpio_platform_data = {
+	.ngpio = 144,
+	.intc_irq_num = DA850_N_CP_INTC_IRQ,
+};
+
 #ifdef CONFIG_CPU_FREQ
 static __init int da850_evm_init_cpufreq(void)
 {
@@ -1444,6 +1451,10 @@ static __init void da850_evm_init(void)
 {
 	int ret;
 
+	ret = da8xx_register_gpio(&da850_gpio_platform_data);
+	if (ret)
+		pr_warn("da850_evm_init: GPIO init failed: %d\n", ret);
+
 	ret = pmic_tps65070_init();
 	if (ret)
 		pr_warn("%s: TPS65070 PMIC init failed: %d\n", __func__, ret);
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index b8c20de..1f44a1b 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/gpio.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -20,6 +21,7 @@
 #include <mach/cp_intc.h>
 #include <mach/da8xx.h>
 #include <mach/mux.h>
+#include <mach/common.h>
 
 #define HAWKBOARD_PHY_ID		"davinci_mdio-0:07"
 #define DA850_HAWK_MMCSD_CD_PIN		GPIO_TO_PIN(3, 12)
diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index abbaf02..e7b79ee 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -1195,10 +1195,6 @@ static struct davinci_soc_info davinci_soc_info_da830 = {
 	.intc_irq_prios		= da830_default_priorities,
 	.intc_irq_num		= DA830_N_CP_INTC_IRQ,
 	.timer_info		= &da830_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DA8XX_GPIO_BASE,
-	.gpio_num		= 128,
-	.gpio_irq		= IRQ_DA8XX_GPIO0,
 	.serial_dev		= &da8xx_serial_device,
 	.emac_pdata		= &da8xx_emac_pdata,
 };
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 4d69338..5f7cfa4 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -1297,10 +1297,6 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
 	.intc_irq_prios		= da850_default_priorities,
 	.intc_irq_num		= DA850_N_CP_INTC_IRQ,
 	.timer_info		= &da850_timer_info,
-	.gpio_type		= GPIO_TYPE_DAVINCI,
-	.gpio_base		= DA8XX_GPIO_BASE,
-	.gpio_num		= 144,
-	.gpio_irq		= IRQ_DA8XX_GPIO0,
 	.serial_dev		= &da8xx_serial_device,
 	.emac_pdata		= &da8xx_emac_pdata,
 	.sram_dma		= DA8XX_SHARED_RAM_BASE,
-- 
1.7.9.5

