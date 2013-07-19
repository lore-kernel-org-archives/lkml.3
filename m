Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901Ab3GSQa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:30:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3GSQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:46 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 02/15] DMA: shdma: add r8a7740 DMAC data to the device ID table
Date: Fri, 19 Jul 2013 18:29:27 +0200
Message-Id: <1374251374-30186-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:+nkR06595ANd7LhywXWj0HDArdgbYK6aBhwZpxb9yRn
 D4qAlEzl96EHPYQTlJh6Ngag0o1ZR4fDATd1KI81isoskyuOFn
 zR04UwtHgJofgtPFDA9EDecmKenJgm8JzU8femvVYXGKIJE/OB
 qdWwe3+tBjtG5CjK7oWCx0YLd7D3X3CmZZG2WfhGf/kK84PLGi
 RD2cdgoVyhqEnZc8LlHS5D2ZT3uSAmgMc4N4LRubXLNIWrHSb4
 u9zJ05oTXp7wy8pJmYckhjtK5LnB3SfTuVu54Y676QpnokIGem
 8LjzTYaEx1BrmjqYPcPaWn2lc2w8xrwnA7uYt9GPqcu26WbTRp
 BWJefnWfKLiSKyp3hSpPEgNKDT6KlFMxUVC6BBed1OYaMNBb+H
 65dhEX0lBRK6w==
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
index 751a4e3..fe54cda 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -907,6 +907,7 @@ MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
 
 const struct platform_device_id sh_dmae_id_table[] = {
 	{.name = SH_DMAE_DRV_NAME,},
+	{.name = "shdma-r8a7740", .driver_data = (kernel_ulong_t)r8a7740_shdma_devid,},
 	{}
 };
 MODULE_DEVICE_TABLE(platform, sh_dmae_id_table);
-- 
1.7.2.5

