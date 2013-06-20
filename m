Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422862Ab3FTVJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:09:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37414 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422740Ab3FTVH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:07:59 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Date: Thu, 20 Jun 2013 16:06:41 -0500
Message-ID: <1371762407-24544-6-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel A Fernandes <agnel.joel@gmail.com>

Build TI_EDMA by default for ARCH_DAVINCI and ARCH_OMAP2PLUS

Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 arch/arm/Kconfig            |    1 +
 arch/arm/mach-omap2/Kconfig |    1 +
 drivers/dma/Kconfig         |    2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b1c66a4..7d58cd9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -841,6 +841,7 @@ config ARCH_DAVINCI
 	select HAVE_IDE
 	select NEED_MACH_GPIO_H
 	select TI_PRIV_EDMA
+	select DMADEVICES
 	select USE_OF
 	select ZONE_DMA
 	help
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index f91b07f..c02f083 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -17,6 +17,7 @@ config ARCH_OMAP2PLUS
 	select PROC_DEVICETREE if PROC_FS
 	select SOC_BUS
 	select SPARSE_IRQ
+	select DMADEVICES
 	select TI_PRIV_EDMA
 	select USE_OF
 	help
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 3215a3c..b2d6f15 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -216,7 +216,7 @@ config TI_EDMA
 	depends on ARCH_DAVINCI || ARCH_OMAP
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
-	default n
+	default y
 	help
 	  Enable support for the TI EDMA controller. This DMA
 	  engine is found on TI DaVinci and AM33xx parts.
-- 
1.7.9.5

