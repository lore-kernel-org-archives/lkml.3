Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964Ab3GLNpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:45:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab3GLNoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:44:04 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 3/8] DMA: shdma: add r8a73a4 DMAC data to the device ID table
Date: Fri, 12 Jul 2013 15:43:53 +0200
Message-Id: <1373636638-18496-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:dEc5CXb/LGPhknEQNtJG1wEuNHAB+TLHfK5K8Mv2p26
 CsVIi3jdwjTulsIGAWm6Qb3GPSq9bT6U6zotRfPzPc1YpwB2ic
 nwnshBgj0EHg8rCL0rMML4SwraxRN74fcp5aGMCOYIpReJQ+ub
 ofQl54rQ6rIDOXBxRVEviNJm8JRmshrJJ3qQ2+nOFVUldTJjti
 nOoc+Fjh/JFABAHPFXu6/7ExMpR8IaXQFCEUb6LunDFqH9clX4
 8VOqcj/pNKmBqKe/JRHwrxIJ1wypVAT91nLpBpvBKlYeCFUWXD
 +lbOkj1spfxEsH+huM1jiMo1foZnxSGOaD7q/sKOTEC7v1xgIX
 J+JbbkSelyNKPbT0424pjVBb8bvBRHDF8YoZvx4qGbYB5BpiVg
 8BzU3mXAy32og==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This configuration data will be re-used, when DMAC DT support is added to
r8a73a4.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/Kconfig         |    4 ++
 drivers/dma/sh/Makefile        |    1 +
 drivers/dma/sh/shdma-r8a73a4.c |   75 ++++++++++++++++++++++++++++++++++++++++
 drivers/dma/sh/shdma.h         |    7 ++++
 drivers/dma/sh/shdmac.c        |    1 +
 5 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/sh/shdma-r8a73a4.c

diff --git a/drivers/dma/sh/Kconfig b/drivers/dma/sh/Kconfig
index 0ac3e94..6921ba2 100644
--- a/drivers/dma/sh/Kconfig
+++ b/drivers/dma/sh/Kconfig
@@ -23,6 +23,10 @@ config SUDMAC
 	help
 	  Enable support for the Renesas SUDMAC controllers.
 
+config SHDMA_R8A73A4
+	def_bool y
+	depends on ARCH_R8A73A4 && SH_DMAE != n
+
 config SHDMA_R8A7740
 	def_bool y
 	depends on ARCH_R8A7740 && SH_DMAE != n
diff --git a/drivers/dma/sh/Makefile b/drivers/dma/sh/Makefile
index acdd3cb..e08489c 100644
--- a/drivers/dma/sh/Makefile
+++ b/drivers/dma/sh/Makefile
@@ -2,5 +2,6 @@ obj-$(CONFIG_SH_DMAE_BASE) += shdma-base.o shdma-of.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
 shdma-y := shdmac.o
 shdma-$(CONFIG_SHDMA_R8A7740) += shdma-r8a7740.o
+shdma-$(CONFIG_SHDMA_R8A73A4) += shdma-r8a73a4.o
 shdma-objs := $(shdma-y)
 obj-$(CONFIG_SUDMAC) += sudmac.o
diff --git a/drivers/dma/sh/shdma-r8a73a4.c b/drivers/dma/sh/shdma-r8a73a4.c
new file mode 100644
index 0000000..d3b759d
--- /dev/null
+++ b/drivers/dma/sh/shdma-r8a73a4.c
@@ -0,0 +1,75 @@
+#include <linux/sh_dma.h>
+
+#include <mach/dma-register.h>
+#include <mach/r8a73a4.h>
+
+static const struct sh_dmae_slave_config dma_slaves[] = {
+	{
+		.slave_id	= SHDMA_SLAVE_MMCIF0_TX,
+		.addr		= 0xee200034,
+		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xd1,
+	}, {
+		.slave_id	= SHDMA_SLAVE_MMCIF0_RX,
+		.addr		= 0xee200034,
+		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xd2,
+	}, {
+		.slave_id	= SHDMA_SLAVE_MMCIF1_TX,
+		.addr		= 0xee220034,
+		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xe1,
+	}, {
+		.slave_id	= SHDMA_SLAVE_MMCIF1_RX,
+		.addr		= 0xee220034,
+		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
+		.mid_rid	= 0xe2,
+	},
+};
+
+#define DMAE_CHANNEL(a, b)				\
+	{						\
+		.offset         = (a) - 0x20,		\
+		.dmars          = (a) - 0x20 + 0x40,	\
+		.chclr_bit	= (b),			\
+		.chclr_offset	= 0x80 - 0x20,		\
+	}
+
+static const struct sh_dmae_channel dma_channels[] = {
+	DMAE_CHANNEL(0x8000, 0),
+	DMAE_CHANNEL(0x8080, 1),
+	DMAE_CHANNEL(0x8100, 2),
+	DMAE_CHANNEL(0x8180, 3),
+	DMAE_CHANNEL(0x8200, 4),
+	DMAE_CHANNEL(0x8280, 5),
+	DMAE_CHANNEL(0x8300, 6),
+	DMAE_CHANNEL(0x8380, 7),
+	DMAE_CHANNEL(0x8400, 8),
+	DMAE_CHANNEL(0x8480, 9),
+	DMAE_CHANNEL(0x8500, 10),
+	DMAE_CHANNEL(0x8580, 11),
+	DMAE_CHANNEL(0x8600, 12),
+	DMAE_CHANNEL(0x8680, 13),
+	DMAE_CHANNEL(0x8700, 14),
+	DMAE_CHANNEL(0x8780, 15),
+	DMAE_CHANNEL(0x8800, 16),
+	DMAE_CHANNEL(0x8880, 17),
+	DMAE_CHANNEL(0x8900, 18),
+	DMAE_CHANNEL(0x8980, 19),
+};
+
+struct sh_dmae_pdata r8a73a4_dma_pdata = {
+	.slave		= dma_slaves,
+	.slave_num	= ARRAY_SIZE(dma_slaves),
+	.channel	= dma_channels,
+	.channel_num	= ARRAY_SIZE(dma_channels),
+	.ts_low_shift	= TS_LOW_SHIFT,
+	.ts_low_mask	= TS_LOW_BIT << TS_LOW_SHIFT,
+	.ts_high_shift	= TS_HI_SHIFT,
+	.ts_high_mask	= TS_HI_BIT << TS_HI_SHIFT,
+	.ts_shift	= dma_ts_shift,
+	.ts_shift_num	= ARRAY_SIZE(dma_ts_shift),
+	.dmaor_init     = DMAOR_DME,
+	.chclr_present	= 1,
+	.chclr_bitwise	= 1,
+};
diff --git a/drivers/dma/sh/shdma.h b/drivers/dma/sh/shdma.h
index b5fe545..82a83f8 100644
--- a/drivers/dma/sh/shdma.h
+++ b/drivers/dma/sh/shdma.h
@@ -61,6 +61,13 @@ struct sh_dmae_desc {
 #define to_sh_dev(chan) container_of(chan->shdma_chan.dma_chan.device,\
 				     struct sh_dmae_device, shdma_dev.dma_dev)
 
+#ifdef CONFIG_SHDMA_R8A73A4
+extern struct sh_dmae_pdata r8a73a4_dma_pdata;
+#define r8a73a4_shdma_devid &r8a73a4_dma_pdata
+#else
+#define r8a73a4_shdma_devid NULL
+#endif
+
 #ifdef CONFIG_SHDMA_R8A7740
 extern struct sh_dmae_pdata r8a7740_dma_pdata;
 #define r8a7740_shdma_devid &r8a7740_dma_pdata
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 9e724ae..a6d53fa 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -923,6 +923,7 @@ MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
 
 const struct platform_device_id sh_dmae_id_table[] = {
 	{.name = SH_DMAE_DRV_NAME,},
+	{.name = "shdma-r8a73a4", .driver_data = (kernel_ulong_t)r8a73a4_shdma_devid,},
 	{.name = "shdma-r8a7740", .driver_data = (kernel_ulong_t)r8a7740_shdma_devid,},
 	{}
 };
-- 
1.7.2.5

