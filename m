Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3GTKRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 06:17:25 -0400
Received: from mail.nanl.de ([217.115.11.12]:41369 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab3GTKQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 06:16:48 -0400
From: Jonas Gorski <jogo@openwrt.org>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Krzysztof Halasa <khc@pm.waw.pl>, Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH 1/2] arm: ixp4xx: set cohorent_dma_mask for ethernet platform devices
Date: Sat, 20 Jul 2013 12:15:38 +0200
Message-Id: <1374315339-31469-2-git-send-email-jogo@openwrt.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374315339-31469-1-git-send-email-jogo@openwrt.org>
References: <1374315339-31469-1-git-send-email-jogo@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM requires the cohorent_dma_mask set, so set it for the platform
devices so that the ethernet driver has access to it.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
 arch/arm/mach-ixp4xx/fsg-setup.c     | 2 ++
 arch/arm/mach-ixp4xx/goramo_mlr.c    | 2 ++
 arch/arm/mach-ixp4xx/ixdp425-setup.c | 3 +++
 arch/arm/mach-ixp4xx/nas100d-setup.c | 1 +
 arch/arm/mach-ixp4xx/nslu2-setup.c   | 1 +
 arch/arm/mach-ixp4xx/omixp-setup.c   | 3 +++
 arch/arm/mach-ixp4xx/vulcan-setup.c  | 2 ++
 7 files changed, 14 insertions(+)

diff --git a/arch/arm/mach-ixp4xx/fsg-setup.c b/arch/arm/mach-ixp4xx/fsg-setup.c
index 429966b7..c120e78 100644
--- a/arch/arm/mach-ixp4xx/fsg-setup.c
+++ b/arch/arm/mach-ixp4xx/fsg-setup.c
@@ -142,12 +142,14 @@ static struct platform_device fsg_eth[] = {
 		.id			= IXP4XX_ETH_NPEB,
 		.dev = {
 			.platform_data	= fsg_plat_eth,
+			.coherent_dma_mask = DMA_BIT_MASK(32),
 		},
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev = {
 			.platform_data	= fsg_plat_eth + 1,
+			.coherent_dma_mask = DMA_BIT_MASK(32),
 		},
 	}
 };
diff --git a/arch/arm/mach-ixp4xx/goramo_mlr.c b/arch/arm/mach-ixp4xx/goramo_mlr.c
index e54ff49..0d1b101 100644
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ b/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -294,10 +294,12 @@ static struct platform_device device_eth_tab[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= eth_plat,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= eth_plat + 1,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/ixdp425-setup.c b/arch/arm/mach-ixp4xx/ixdp425-setup.c
index 22d688b..f608629 100644
--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
+++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -20,6 +20,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <asm/types.h>
 #include <asm/setup.h>
 #include <asm/memory.h>
@@ -195,10 +196,12 @@ static struct platform_device ixdp425_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= ixdp425_plat_eth,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= ixdp425_plat_eth + 1,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/nas100d-setup.c b/arch/arm/mach-ixp4xx/nas100d-setup.c
index ed667ce..59654f3 100644
--- a/arch/arm/mach-ixp4xx/nas100d-setup.c
+++ b/arch/arm/mach-ixp4xx/nas100d-setup.c
@@ -170,6 +170,7 @@ static struct platform_device nas100d_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= nas100d_plat_eth,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/nslu2-setup.c b/arch/arm/mach-ixp4xx/nslu2-setup.c
index 7e55236..ff078d2 100644
--- a/arch/arm/mach-ixp4xx/nslu2-setup.c
+++ b/arch/arm/mach-ixp4xx/nslu2-setup.c
@@ -182,6 +182,7 @@ static struct platform_device nslu2_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= nslu2_plat_eth,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/omixp-setup.c b/arch/arm/mach-ixp4xx/omixp-setup.c
index 75ef03d..b79cd51 100644
--- a/arch/arm/mach-ixp4xx/omixp-setup.c
+++ b/arch/arm/mach-ixp4xx/omixp-setup.c
@@ -17,6 +17,7 @@
 #include <linux/serial_8250.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/dma-mapping.h>
 #ifdef CONFIG_LEDS_CLASS
 #include <linux/leds.h>
 #endif
@@ -190,10 +191,12 @@ static struct platform_device ixdp425_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= ixdp425_plat_eth,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= ixdp425_plat_eth + 1,
+		.dev.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
 
diff --git a/arch/arm/mach-ixp4xx/vulcan-setup.c b/arch/arm/mach-ixp4xx/vulcan-setup.c
index d599e35..162d71f 100644
--- a/arch/arm/mach-ixp4xx/vulcan-setup.c
+++ b/arch/arm/mach-ixp4xx/vulcan-setup.c
@@ -139,6 +139,7 @@ static struct platform_device vulcan_eth[] = {
 		.id			= IXP4XX_ETH_NPEB,
 		.dev = {
 			.platform_data	= &vulcan_plat_eth[0],
+			.coherent_dma_mask = DMA_BIT_MASK(32),
 		},
 	},
 	[1] = {
@@ -146,6 +147,7 @@ static struct platform_device vulcan_eth[] = {
 		.id			= IXP4XX_ETH_NPEC,
 		.dev = {
 			.platform_data	= &vulcan_plat_eth[1],
+			.coherent_dma_mask = DMA_BIT_MASK(32),
 		},
 	},
 };
-- 
1.8.3.2

