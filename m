Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422916Ab3FTVIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:08:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57221 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422862Ab3FTVIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:08:09 -0400
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
Subject: [PATCH v12 04/11] dmaengine: edma: enable build for AM33XX
Date: Thu, 20 Jun 2013 16:06:40 -0500
Message-ID: <1371762407-24544-5-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Enable TI EDMA option on OMAP and TI_PRIV_EDMA

Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 arch/arm/mach-omap2/Kconfig |    1 +
 drivers/dma/Kconfig         |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index f49cd51..f91b07f 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -17,6 +17,7 @@ config ARCH_OMAP2PLUS
 	select PROC_DEVICETREE if PROC_FS
 	select SOC_BUS
 	select SPARSE_IRQ
+	select TI_PRIV_EDMA
 	select USE_OF
 	help
 	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index e992489..3215a3c 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -213,7 +213,7 @@ config SIRF_DMA
 
 config TI_EDMA
 	tristate "TI EDMA support"
-	depends on ARCH_DAVINCI
+	depends on ARCH_DAVINCI || ARCH_OMAP
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	default n
-- 
1.7.9.5

