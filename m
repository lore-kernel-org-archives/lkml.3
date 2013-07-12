Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014Ab3GLNoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:44:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964876Ab3GLNoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:44:06 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 2/8] DMA: shdma: add r8a7740 DMAC data to the device ID table
Date: Fri, 12 Jul 2013 15:43:52 +0200
Message-Id: <1373636638-18496-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:3cSsUIbH9h2Orcr1lM6Ka0Hdfdj7bVc8mwwWujnpU7F
 qcBQCKMSj7mLv1FCsn78ss72x57NQ2MwQ1ENRG+BIJDddWwA5G
 Q63jUEH4j8jC66GoK+djGf6JBMm/UUEXFurF4oF+LFeKflEOBk
 S9oDvkoUs6FkeeTX9r2csbaZb9sUntQFUq4nwDqXH9kZkuaxNp
 vog9Vg1cOhDxabxC+kN0XXhZu/GBARSTObug1G0j4k/NNRoOUN
 6ekzE8suRMO3hPoWxe2AIaFlZkZcNk3vdhjcSY5dlswU+yTm/p
 CnMVgWfH2ipMUMfrLkN226KOv4HUcc8ravB5QTf76m0pjL8mAj
 vQfxO4LvqMIdZbVoMx602erCdyiJsA2BM16yCvo95VpVqdN7vp
 PX8V3LyD7JEPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This configuration data will be re-used, when DMAC DT support is added to
r8a7740, DMAC platform data in setup-r8a7740.c will be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/Kconfig         |    4 ++
 drivers/dma/sh/Makefile        |    1 +
 drivers/dma/sh/shdma-r8a7740.c |   95 ++++++++++++++++++++++++++++++++++++++++
 drivers/dma/sh/shdma.h         |    7 +++
 drivers/dma/sh/shdmac.c        |    1 +
 5 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/sh/shdma-r8a7740.c

diff --git a/drivers/dma/sh/Kconfig b/drivers/dma/sh/Kconfig
index 5c1dee2..0ac3e94 100644
--- a/drivers/dma/sh/Kconfig
+++ b/drivers/dma/sh/Kconfig
@@ -22,3 +22,7 @@ config SUDMAC
 	depends on SH_DMAE_BASE
 	help
 	  Enable support for the Renesas SUDMAC controllers.
+
+config SHDMA_R8A7740
+	def_bool y
+	depends on ARCH_R8A7740 && SH_DMAE != n
diff --git a/drivers/dma/sh/Makefile b/drivers/dma/sh/Makefile
index 893ee09..acdd3cb 100644
--- a/drivers/dma/sh/Makefile
+++ b/drivers/dma/sh/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_SH_DMAE_BASE) += shdma-base.o shdma-of.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
 shdma-y := shdmac.o
+shdma-$(CONFIG_SHDMA_R8A7740) += shdma-r8a7740.o
 shdma-objs := $(shdma-y)
 obj-$(CONFIG_SUDMAC) += sudmac.o
diff --git a/drivers/dma/sh/shdma-r8a7740.c b/drivers/dma/sh/shdma-r8a7740.c
new file mode 100644
index 0000000..2597e2c
--- /dev/null
+++ b/drivers/dma/sh/shdma-r8a7740.c
@@ -0,0 +1,95 @@
+#include <linux/sh_dma.h>
+
+#include <mach/dma-register.h>
+#include <mach/r8a7740.h>
+
+static const struct sh_dmae_slave_config r8a7740_dmae_slaves[] = {
+	{
+		.slave_id	= SHDMA_SLAVE_SDHI0_TX,
+		.addr		= 0xe6850030,
+		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc1,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI0_RX,
+		.addr		= 0xe6850030,
+		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc2,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI1_TX,
+		.addr		= 0xe6860030,
+		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc9,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI1_RX,
+		.addr		= 0xe6860030,
+		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
+		.mid_rid	= 0xca,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI2_TX,
+		.addr		= 0xe6870030,
+		.chcr		= CHCR_TX(XMIT_SZ_16BIT),
+		.mid_rid	= 0xcd,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI2_RX,
+		.addr		= 0xe6870030,
+		.chcr		= CHCR_RX(XMIT_SZ_16BIT),
+		.mid_rid	= 0xce,
+	}, {
+		.slave_id	= SHDMA_SLAVE_FSIA_TX,
+		.addr		= 0xfe1f0024,
+		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xb1,
+	}, {
+		.slave_id	= SHDMA_SLAVE_FSIA_RX,
+		.addr		= 0xfe1f0020,
+		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xb2,
+	}, {
+		.slave_id	= SHDMA_SLAVE_FSIB_TX,
+		.addr		= 0xfe1f0064,
+		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xb5,
+	}, {
+		.slave_id	= SHDMA_SLAVE_MMCIF_TX,
+		.addr		= 0xe6bd0034,
+		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xd1,
+	}, {
+		.slave_id	= SHDMA_SLAVE_MMCIF_RX,
+		.addr		= 0xe6bd0034,
+		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xd2,
+	},
+};
+
+#define DMA_CHANNEL(a, b, c)			\
+{						\
+	.offset		= a,			\
+	.dmars		= b,			\
+	.dmars_bit	= c,			\
+	.chclr_offset	= (0x220 - 0x20) + a	\
+}
+
+static const struct sh_dmae_channel r8a7740_dmae_channels[] = {
+	DMA_CHANNEL(0x00, 0, 0),
+	DMA_CHANNEL(0x10, 0, 8),
+	DMA_CHANNEL(0x20, 4, 0),
+	DMA_CHANNEL(0x30, 4, 8),
+	DMA_CHANNEL(0x50, 8, 0),
+	DMA_CHANNEL(0x60, 8, 8),
+};
+
+struct sh_dmae_pdata r8a7740_dma_pdata = {
+	.slave		= r8a7740_dmae_slaves,
+	.slave_num	= ARRAY_SIZE(r8a7740_dmae_slaves),
+	.channel	= r8a7740_dmae_channels,
+	.channel_num	= ARRAY_SIZE(r8a7740_dmae_channels),
+	.ts_low_shift	= TS_LOW_SHIFT,
+	.ts_low_mask	= TS_LOW_BIT << TS_LOW_SHIFT,
+	.ts_high_shift	= TS_HI_SHIFT,
+	.ts_high_mask	= TS_HI_BIT << TS_HI_SHIFT,
+	.ts_shift	= dma_ts_shift,
+	.ts_shift_num	= ARRAY_SIZE(dma_ts_shift),
+	.dmaor_init	= DMAOR_DME,
+	.chclr_present	= 1,
+};
diff --git a/drivers/dma/sh/shdma.h b/drivers/dma/sh/shdma.h
index 06aae6e..b5fe545 100644
--- a/drivers/dma/sh/shdma.h
+++ b/drivers/dma/sh/shdma.h
@@ -61,4 +61,11 @@ struct sh_dmae_desc {
 #define to_sh_dev(chan) container_of(chan->shdma_chan.dma_chan.device,\
 				     struct sh_dmae_device, shdma_dev.dma_dev)
 
+#ifdef CONFIG_SHDMA_R8A7740
+extern struct sh_dmae_pdata r8a7740_dma_pdata;
+#define r8a7740_shdma_devid &r8a7740_dma_pdata
+#else
+#define r8a7740_shdma_devid NULL
+#endif
+
 #endif	/* __DMA_SHDMA_H */
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 3c5634e..9e724ae 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -923,6 +923,7 @@ MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
 
 const struct platform_device_id sh_dmae_id_table[] = {
 	{.name = SH_DMAE_DRV_NAME,},
+	{.name = "shdma-r8a7740", .driver_data = (kernel_ulong_t)r8a7740_shdma_devid,},
 	{}
 };
 MODULE_DEVICE_TABLE(platform, sh_dmae_id_table);
-- 
1.7.2.5

