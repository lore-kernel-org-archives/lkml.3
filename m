Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3BOSV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:21:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3BOSVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:21:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/4] Revert "ARM: SPEAr13xx: Pass DW DMAC platform data from DT"
Date: Fri, 15 Feb 2013 19:21:49 +0100
Message-Id: <1360952512-971558-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360952512-971558-1-git-send-email-arnd@arndb.de>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:JrrpUG1+FAigVat+DKpbnFRE5+qft1IGe/WENl3SFyO
 54TTQKWOxZAJVoBAngUPOmc0rThGHAmQTuZdPYDEhQUB/xK/Yj
 btfCwi5Df7vgZ6Mmq/G23LBH4AOiOA2qe+oQ5tJrqhUtmEwrH0
 9hSPT1JtkWfsem7ONazal/uIfX+AlIOWmqFAklCG13zIXLs1eZ
 w6kHparzai31YnIYMyQQ6zQ+vpMLDxf2bN/de7KSkG8RsZgIGM
 C6v3fsdVxaSHY4ttoSw+yQnwmFMP9bMNEONpCnta3GxK0K+amn
 elXTAriVyVaCBWMx1DYU7ueOtVJksOUbxFzkKxYTLku3J7tAkH
 5zg0lsYdneHiBerjznODAhFsHqyFMmoK7Lbx7oA9V
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f9965aa20706860077cfa093d04a6351c0c1e940.
---
 arch/arm/boot/dts/spear1340.dtsi             | 19 ----------
 arch/arm/boot/dts/spear13xx.dtsi             | 38 -------------------
 arch/arm/mach-spear13xx/include/mach/spear.h |  2 +
 arch/arm/mach-spear13xx/spear1310.c          |  5 ++-
 arch/arm/mach-spear13xx/spear1340.c          | 33 ++++++++++++-----
 arch/arm/mach-spear13xx/spear13xx.c          | 55 ++++++++++++++++++++++++++--
 6 files changed, 80 insertions(+), 72 deletions(-)

diff --git a/arch/arm/boot/dts/spear1340.dtsi b/arch/arm/boot/dts/spear1340.dtsi
index b2d41b7..34da11a 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -88,25 +88,6 @@
 			status = "disabled";
 		};
 
-		dma@ea800000 {
-			slave_info {
-				uart1_tx {
-					bus_id = "uart1_tx";
-					cfg_hi = <0x6000>;	/* 0xC << 11 */
-					cfg_lo = <0>;
-					src_master = <0>;
-					dst_master = <1>;
-				};
-				uart1_tx {
-					bus_id = "uart1_tx";
-					cfg_hi = <0x680>;	/* 0xD << 7 */
-					cfg_lo = <0>;
-					src_master = <1>;
-					dst_master = <0>;
-				};
-			};
-		};
-
 		spi1: spi@5d400000 {
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x5d400000 0x1000>;
diff --git a/arch/arm/boot/dts/spear13xx.dtsi b/arch/arm/boot/dts/spear13xx.dtsi
index 585f641..b4ca60f 100644
--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@ -105,37 +105,6 @@
 			reg = <0xea800000 0x1000>;
 			interrupts = <0 19 0x4>;
 			status = "disabled";
-
-			nr_channels = <8>;
-			chan_allocation_order = <1>;
-			chan_priority = <1>;
-			block_size = <0xfff>;
-			nr_masters = <2>;
-			data_width = <3 3 0 0>;
-
-			slave_info {
-				ssp0_tx {
-					bus_id = "ssp0_tx";
-					cfg_hi = <0x2000>;	/* 0x4 << 11 */
-					cfg_lo = <0>;
-					src_master = <0>;
-					dst_master = <0>;
-				};
-				ssp0_rx {
-					bus_id = "ssp0_rx";
-					cfg_hi = <0x280>;	/* 0x5 << 7 */
-					cfg_lo = <0>;
-					src_master = <0>;
-					dst_master = <0>;
-				};
-				cf {
-					bus_id = "cf";
-					cfg_hi = <0>;
-					cfg_lo = <0>;
-					src_master = <0>;
-					dst_master = <0>;
-				};
-			};
 		};
 
 		dma@eb000000 {
@@ -143,13 +112,6 @@
 			reg = <0xeb000000 0x1000>;
 			interrupts = <0 59 0x4>;
 			status = "disabled";
-
-			nr_channels = <8>;
-			chan_allocation_order = <1>;
-			chan_priority = <1>;
-			block_size = <0xfff>;
-			nr_masters = <2>;
-			data_width = <3 3 0 0>;
 		};
 
 		fsmc: flash@b0000000 {
diff --git a/arch/arm/mach-spear13xx/include/mach/spear.h b/arch/arm/mach-spear13xx/include/mach/spear.h
index 972a151..7cfa681 100644
--- a/arch/arm/mach-spear13xx/include/mach/spear.h
+++ b/arch/arm/mach-spear13xx/include/mach/spear.h
@@ -43,6 +43,8 @@
 #define VA_L2CC_BASE				IOMEM(UL(0xFB000000))
 
 /* others */
+#define DMAC0_BASE				UL(0xEA800000)
+#define DMAC1_BASE				UL(0xEB000000)
 #define MCIF_CF_BASE				UL(0xB2800000)
 
 /* Debug uart for linux, will be used for debug and uncompress messages */
diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
index ec72c47..02f4724 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -36,7 +36,7 @@
 static struct arasan_cf_pdata cf_pdata = {
 	.cf_if_clk = CF_IF_CLK_166M,
 	.quirk = CF_BROKEN_UDMA,
-	.dma_priv = "cf",
+	.dma_priv = &cf_dma_priv,
 };
 
 /* ssp device registration */
@@ -47,7 +47,10 @@ static struct pl022_ssp_controller ssp1_plat_data = {
 /* Add SPEAr1310 auxdata to pass platform data */
 static struct of_dev_auxdata spear1310_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_pdata),
+	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC0_BASE, NULL, &dmac_plat_data),
+	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC1_BASE, NULL, &dmac_plat_data),
 	OF_DEV_AUXDATA("arm,pl022", SSP_BASE, NULL, &pl022_plat_data),
+
 	OF_DEV_AUXDATA("arm,pl022", SPEAR1310_SSP1_BASE, NULL, &ssp1_plat_data),
 	{}
 };
diff --git a/arch/arm/mach-spear13xx/spear1340.c b/arch/arm/mach-spear13xx/spear1340.c
index 69c8f72..081014f 100644
--- a/arch/arm/mach-spear13xx/spear1340.c
+++ b/arch/arm/mach-spear13xx/spear1340.c
@@ -18,9 +18,9 @@
 #include <linux/delay.h>
 #include <linux/dw_dmac.h>
 #include <linux/of_platform.h>
-#include <linux/pata_arasan_cf_data.h>
 #include <asm/hardware/gic.h>
 #include <asm/mach/arch.h>
+#include <mach/dma.h>
 #include <mach/generic.h>
 #include <mach/spear.h>
 
@@ -78,16 +78,26 @@
 			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
 			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
 
-static struct amba_pl011_data uart1_data = {
-	.dma_filter = dw_dma_generic_filter,
-	.dma_tx_param = "uart1_tx",
-	.dma_rx_param = "uart1_rx",
+static struct dw_dma_slave uart1_dma_param[] = {
+	{
+		/* Tx */
+		.cfg_hi = DWC_CFGH_DST_PER(SPEAR1340_DMA_REQ_UART1_TX),
+		.cfg_lo = 0,
+		.src_master = DMA_MASTER_MEMORY,
+		.dst_master = SPEAR1340_DMA_MASTER_UART1,
+	}, {
+		/* Rx */
+		.cfg_hi = DWC_CFGH_SRC_PER(SPEAR1340_DMA_REQ_UART1_RX),
+		.cfg_lo = 0,
+		.src_master = SPEAR1340_DMA_MASTER_UART1,
+		.dst_master = DMA_MASTER_MEMORY,
+	}
 };
 
-static struct arasan_cf_pdata cf_pdata = {
-	.cf_if_clk = CF_IF_CLK_166M,
-	.quirk = CF_BROKEN_UDMA,
-	.dma_priv = "cf",
+static struct amba_pl011_data uart1_data = {
+	.dma_filter = dw_dma_filter,
+	.dma_tx_param = &uart1_dma_param[0],
+	.dma_rx_param = &uart1_dma_param[1],
 };
 
 /* SATA device registration */
@@ -148,8 +158,11 @@ static struct ahci_platform_data sata_pdata = {
 
 /* Add SPEAr1340 auxdata to pass platform data */
 static struct of_dev_auxdata spear1340_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_pdata),
+	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_dma_priv),
+	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC0_BASE, NULL, &dmac_plat_data),
+	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC1_BASE, NULL, &dmac_plat_data),
 	OF_DEV_AUXDATA("arm,pl022", SSP_BASE, NULL, &pl022_plat_data),
+
 	OF_DEV_AUXDATA("snps,spear-ahci", SPEAR1340_SATA_BASE, NULL,
 			&sata_pdata),
 	OF_DEV_AUXDATA("arm,pl011", SPEAR1340_UART1_BASE, NULL, &uart1_data),
diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index b074db8..c4af775 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -22,16 +22,63 @@
 #include <asm/hardware/gic.h>
 #include <asm/mach/map.h>
 #include <asm/smp_twd.h>
+#include <mach/dma.h>
 #include <mach/generic.h>
 #include <mach/spear.h>
 
+/* common dw_dma filter routine to be used by peripherals */
+bool dw_dma_filter(struct dma_chan *chan, void *slave)
+{
+	struct dw_dma_slave *dws = (struct dw_dma_slave *)slave;
+
+	if (chan->device->dev == dws->dma_dev) {
+		chan->private = slave;
+		return true;
+	} else {
+		return false;
+	}
+}
+
 /* ssp device registration */
+static struct dw_dma_slave ssp_dma_param[] = {
+	{
+		/* Tx */
+		.cfg_hi = DWC_CFGH_DST_PER(DMA_REQ_SSP0_TX),
+		.cfg_lo = 0,
+		.src_master = DMA_MASTER_MEMORY,
+		.dst_master = DMA_MASTER_SSP0,
+	}, {
+		/* Rx */
+		.cfg_hi = DWC_CFGH_SRC_PER(DMA_REQ_SSP0_RX),
+		.cfg_lo = 0,
+		.src_master = DMA_MASTER_SSP0,
+		.dst_master = DMA_MASTER_MEMORY,
+	}
+};
+
 struct pl022_ssp_controller pl022_plat_data = {
 	.enable_dma = 1,
-	.dma_filter = dw_dma_generic_filter,
-	.dma_rx_param = "ssp0_rx",
-	.dma_tx_param = "ssp0_tx",
-	.num_chipselect = 3,
+	.dma_filter = dw_dma_filter,
+	.dma_rx_param = &ssp_dma_param[1],
+	.dma_tx_param = &ssp_dma_param[0],
+};
+
+/* CF device registration */
+struct dw_dma_slave cf_dma_priv = {
+	.cfg_hi = 0,
+	.cfg_lo = 0,
+	.src_master = 0,
+	.dst_master = 0,
+};
+
+/* dmac device registeration */
+struct dw_dma_platform_data dmac_plat_data = {
+	.nr_channels = 8,
+	.chan_allocation_order = CHAN_ALLOCATION_DESCENDING,
+	.chan_priority = CHAN_PRIORITY_DESCENDING,
+	.block_size = 4095U,
+	.nr_masters = 2,
+	.data_width = { 3, 3, 0, 0 },
 };
 
 void __init spear13xx_l2x0_init(void)
-- 
1.8.1.2

