Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3EFHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:25:29 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56544 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3EFHZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:25:25 -0400
From: Jassi Brar <jassisinghbrar@gmail.com>
To: s-anna@ti.com, loic.pallardy@st.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv2 4/4] mailbox: omap2: Introduce common API driver
Date: Mon,  6 May 2013 12:54:40 +0530
Message-Id: <1367825080-6297-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new driver conforming to the common API.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 arch/arm/mach-omap2/omap_hwmod_2420_data.c |   12 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |   11 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   11 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   13 +
 drivers/mailbox/Kconfig                    |    9 +
 drivers/mailbox/Makefile                   |    1 +
 drivers/mailbox/omap2.c                    |  420 ++++++++++++++++++++++++++++
 include/linux/platform_data/mailbox-omap.h |   64 +++++
 8 files changed, 541 insertions(+)
 create mode 100644 drivers/mailbox/omap2.c
 create mode 100644 include/linux/platform_data/mailbox-omap.h

diff --git a/arch/arm/mach-omap2/omap_hwmod_2420_data.c b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
index 5137cc8..dbcb928 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2420_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
@@ -16,6 +16,7 @@
 #include <linux/i2c-omap.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/omap-dma.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod.h"
@@ -166,6 +167,16 @@ static struct omap_hwmod omap2420_dma_system_hwmod = {
 };
 
 /* mailbox */
+static struct omap_mbox_dev_info omap2420_mailbox_info[] = {
+	{ .name = "dsp", .tx_id = 0, .rx_id = 1, .irq_id = 0, .usr_id = 0 },
+	{ .name = "iva", .tx_id = 2, .rx_id = 3, .irq_id = 1, .usr_id = 3 },
+};
+
+static struct omap_mbox_pdata omap2420_mailbox_attrs = {
+	.info_cnt	= ARRAY_SIZE(omap2420_mailbox_info),
+	.info		= omap2420_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap2420_mailbox_irqs[] = {
 	{ .name = "dsp", .irq = 26 + OMAP_INTC_START, },
 	{ .name = "iva", .irq = 34 + OMAP_INTC_START, },
@@ -186,6 +197,7 @@ static struct omap_hwmod omap2420_mailbox_hwmod = {
 			.idlest_idle_bit = OMAP24XX_ST_MAILBOXES_SHIFT,
 		},
 	},
+	.dev_attr	= &omap2420_mailbox_attrs,
 };
 
 /*
diff --git a/arch/arm/mach-omap2/omap_hwmod_2430_data.c b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
index 4ce999e..df2f874 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2430_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
@@ -17,6 +17,7 @@
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/omap-dma.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod.h"
@@ -170,6 +171,15 @@ static struct omap_hwmod omap2430_dma_system_hwmod = {
 };
 
 /* mailbox */
+static struct omap_mbox_dev_info omap2430_mailbox_info[] = {
+	{ .name = "dsp", .tx_id = 0, .rx_id = 1 },
+};
+
+static struct omap_mbox_pdata omap2430_mailbox_attrs = {
+	.info_cnt	= ARRAY_SIZE(omap2430_mailbox_info),
+	.info		= omap2430_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap2430_mailbox_irqs[] = {
 	{ .irq = 26 + OMAP_INTC_START, },
 	{ .irq = -1 },
@@ -189,6 +199,7 @@ static struct omap_hwmod omap2430_mailbox_hwmod = {
 			.idlest_idle_bit = OMAP24XX_ST_MAILBOXES_SHIFT,
 		},
 	},
+	.dev_attr	= &omap2430_mailbox_attrs,
 };
 
 /* mcspi3 */
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 4083606..3833e96 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -25,6 +25,7 @@
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "am35xx.h"
@@ -1501,6 +1502,15 @@ static struct omap_hwmod_class omap3xxx_mailbox_hwmod_class = {
 	.sysc = &omap3xxx_mailbox_sysc,
 };
 
+static struct omap_mbox_dev_info omap3xxx_mailbox_info[] = {
+	{ .name = "dsp", .tx_id = 0, .rx_id = 1 },
+};
+
+static struct omap_mbox_pdata omap3xxx_mailbox_attrs = {
+	.info_cnt	= ARRAY_SIZE(omap3xxx_mailbox_info),
+	.info		= omap3xxx_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap3xxx_mailbox_irqs[] = {
 	{ .irq = 26 + OMAP_INTC_START, },
 	{ .irq = -1 },
@@ -1520,6 +1530,7 @@ static struct omap_hwmod omap3xxx_mailbox_hwmod = {
 			.idlest_idle_bit = OMAP3430_ST_MAILBOXES_SHIFT,
 		},
 	},
+	.dev_attr	= &omap3xxx_mailbox_attrs,
 };
 
 /*
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index eaba9dc..44d99b6 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -29,6 +29,7 @@
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/iommu-omap.h>
+#include <linux/platform_data/mailbox-omap.h>
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod.h"
@@ -1861,6 +1862,17 @@ static struct omap_hwmod_class omap44xx_mailbox_hwmod_class = {
 };
 
 /* mailbox */
+static struct omap_mbox_dev_info omap44xx_mailbox_info[] = {
+	{ .name = "mbox-ipu", .tx_id = 0, .rx_id = 1 },
+	{ .name = "mbox-dsp", .tx_id = 3, .rx_id = 2 },
+};
+
+static struct omap_mbox_pdata omap44xx_mailbox_attrs = {
+	.intr_type	= MBOX_INTR_CFG_TYPE2,
+	.info_cnt	= ARRAY_SIZE(omap44xx_mailbox_info),
+	.info		= omap44xx_mailbox_info,
+};
+
 static struct omap_hwmod_irq_info omap44xx_mailbox_irqs[] = {
 	{ .irq = 26 + OMAP44XX_IRQ_GIC_START },
 	{ .irq = -1 }
@@ -1877,6 +1889,7 @@ static struct omap_hwmod omap44xx_mailbox_hwmod = {
 			.context_offs = OMAP4_RM_L4CFG_MAILBOX_CONTEXT_OFFSET,
 		},
 	},
+	.dev_attr	= &omap44xx_mailbox_attrs,
 };
 
 /*
diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index 9545c9f..897b1c7 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -16,4 +16,13 @@ config PL320_MBOX
 	  Management Engine, primarily for cpufreq. Say Y here if you want
 	  to use the PL320 IPCM support.
 
+config OMAP2PLUS_MBOX
+	tristate "OMAP2+ Mailbox framework support"
+	depends on ARCH_OMAP2PLUS
+	help
+	  Mailbox implementation for OMAP family chips with hardware for
+	  interprocessor communication involving DSP, IVA1.0 and IVA2 in
+	  OMAP2/3; or IPU, IVA HD and DSP in OMAP4. Say Y here if you want
+	  to use OMAP2+ Mailbox framework support.
+
 endif
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index 7b897f3..b1c9b14 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -3,3 +3,4 @@
 obj-$(CONFIG_MAILBOX)		+= mailbox.o
 
 obj-$(CONFIG_PL320_MBOX)	+= pl320.o
+obj-$(CONFIG_OMAP2PLUS_MBOX)	+= omap2.o
diff --git a/drivers/mailbox/omap2.c b/drivers/mailbox/omap2.c
new file mode 100644
index 0000000..c22a82a
--- /dev/null
+++ b/drivers/mailbox/omap2.c
@@ -0,0 +1,420 @@
+/*
+ * Mailbox driver for OMAP4
+ *
+ * Copyright (C) 2013 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/mailbox-omap.h>
+
+#define MAILBOX_REVISION		0x000
+#define MAILBOX_MESSAGE(m)		(0x040 + 4 * (m))
+#define MAILBOX_FIFOSTATUS(m)		(0x080 + 4 * (m))
+#define MAILBOX_MSGSTATUS(m)		(0x0c0 + 4 * (m))
+#define MAILBOX_IRQSTATUS(u)		(0x100 + 8 * (u))
+#define MAILBOX_IRQENABLE(u)		(0x104 + 8 * (u))
+
+#define OMAP4_MAILBOX_IRQSTATUS(u)	(0x104 + 0x10 * (u))
+#define OMAP4_MAILBOX_IRQENABLE(u)	(0x108 + 0x10 * (u))
+#define OMAP4_MAILBOX_IRQENABLE_CLR(u)	(0x10c + 0x10 * (u))
+
+#define MAILBOX_IRQ_NEWMSG(m)		(1 << (2 * (m)))
+#define MAILBOX_IRQ_NOTFULL(m)		(1 << (2 * (m) + 1))
+
+#define RX_IRQ	0
+#define TX_IRQ	1
+
+/* We assume peak RX activity won't be more than 32 packets together */
+#define RXBUF_LEN	32
+
+/*
+ * Logical link is a pair of independent physical TX+RX mailboxes.
+ * IDEALLY, a client should acquire RX and TX separately as 2 links, so
+ * that (for example) when it can't take in anymore packets it could
+ * release the RX link and re-acquire only when it has appetite once again.
+ */
+struct omap2_mbox_link {
+	int irq;
+	bool active;
+	unsigned usr_id;
+	unsigned mb_rx, mb_tx;
+	u32 rxbuf[RXBUF_LEN];
+	struct ipc_link link;
+	struct omap2_mbox_con *omc;
+};
+
+struct omap2_mbox_con {
+	struct device *dev;
+	unsigned intr_type;
+	void __iomem *mbox_base;
+	struct omap2_mbox_link oml[4];
+	struct ipc_controller ipc_con;
+	struct mutex lock;
+};
+
+static inline struct omap2_mbox_link *to_oml(struct ipc_link *l)
+{
+	if (!l)
+		return NULL;
+
+	return container_of(l, struct omap2_mbox_link, link);
+}
+
+static inline void omap_mb_write(struct omap2_mbox_con *omc, u32 val, u32 off)
+{
+	__raw_writel(val, omc->mbox_base + off);
+}
+
+static inline u32 omap_mb_read(struct omap2_mbox_con *omc, u32 off)
+{
+	return __raw_readl(omc->mbox_base + off);
+}
+
+static void omc_enable_irq(struct omap2_mbox_link *oml, int tx)
+{
+	struct omap2_mbox_con *omc = oml->omc;
+	u32 val, off;
+
+	if (omc->intr_type)
+		off = OMAP4_MAILBOX_IRQENABLE(oml->usr_id);
+	else
+		off = MAILBOX_IRQENABLE(oml->usr_id);
+
+	val = omap_mb_read(omc, off);
+	if (tx)
+		val |= MAILBOX_IRQ_NOTFULL(oml->mb_tx);
+	else
+		val |= MAILBOX_IRQ_NEWMSG(oml->mb_rx);
+
+	omap_mb_write(omc, val, off);
+}
+
+static void omc_disable_irq(struct omap2_mbox_link *oml, int tx)
+{
+	struct omap2_mbox_con *omc = oml->omc;
+	u32 val, off;
+
+	if (tx)
+		val = MAILBOX_IRQ_NOTFULL(oml->mb_tx);
+	else
+		val = MAILBOX_IRQ_NEWMSG(oml->mb_rx);
+
+	if (omc->intr_type) {
+		off = OMAP4_MAILBOX_IRQENABLE_CLR(oml->usr_id);
+	} else {
+		off = MAILBOX_IRQENABLE(oml->usr_id);
+		val = omap_mb_read(omc, off) & ~val;
+	}
+
+	omap_mb_write(omc, val, off);
+}
+
+static void omc_ack_irq(struct omap2_mbox_link *oml, int tx)
+{
+	struct omap2_mbox_con *omc = oml->omc;
+	u32 val, off;
+
+	if (tx)
+		val = MAILBOX_IRQ_NOTFULL(oml->mb_tx);
+	else
+		val = MAILBOX_IRQ_NEWMSG(oml->mb_rx);
+
+	if (omc->intr_type)
+		off = OMAP4_MAILBOX_IRQSTATUS(oml->usr_id);
+	else
+		off = MAILBOX_IRQSTATUS(oml->usr_id);
+
+	omap_mb_write(omc, val, off);
+	/* Flush posted write for irq status to avoid spurious interrupts */
+	omap_mb_read(omc, off);
+}
+
+static int omc_is_irq(struct omap2_mbox_link *oml, int tx)
+{
+	struct omap2_mbox_con *omc = oml->omc;
+	u32 val, off;
+
+	if (tx)
+		val = MAILBOX_IRQ_NOTFULL(oml->mb_tx);
+	else
+		val = MAILBOX_IRQ_NEWMSG(oml->mb_rx);
+
+	if (omc->intr_type)
+		off = OMAP4_MAILBOX_IRQSTATUS(oml->usr_id);
+	else
+		off = MAILBOX_IRQSTATUS(oml->usr_id);
+
+	return omap_mb_read(omc, off) & val;
+}
+
+static void omc_tx_irq(struct omap2_mbox_link *oml)
+{
+	omc_disable_irq(oml, TX_IRQ);
+	ipc_link_txdone(&oml->link, XFER_OK);
+}
+
+static void omc_rx_irq(struct omap2_mbox_link *oml)
+{
+	struct omap2_mbox_con *omc = oml->omc;
+	int i, j, count = omap_mb_read(omc, MAILBOX_MSGSTATUS(oml->mb_rx));
+	struct omap2_mbox_rxdata pkt;
+
+	j = 0;
+	while (count && j < RXBUF_LEN) {
+
+		for (i = 0; i < count; i++)
+			oml->rxbuf[j++] = omap_mb_read(omc,
+						MAILBOX_MESSAGE(oml->mb_rx));
+
+		count = omap_mb_read(omc, MAILBOX_MSGSTATUS(oml->mb_rx));
+	}
+	pkt.len = j;
+	pkt.buf = oml->rxbuf;
+	ipc_link_received_data(&oml->link, (void *)&pkt)
+}
+
+static irqreturn_t ipc_handler(int irq, void *p)
+{
+	struct omap2_mbox_link *oml = p;
+	struct omap2_mbox_con *omc = oml->omc;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		struct omap2_mbox_link *l = &omc->oml[i];
+
+		if (!l->active)
+			continue;
+
+		if (omc_is_irq(l, TX_IRQ)) {
+			omc_tx_irq(l);
+			omc_ack_irq(l, TX_IRQ);
+		}
+
+		if (omc_is_irq(l, RX_IRQ)) {
+			omc_rx_irq(l);
+			omc_ack_irq(l, RX_IRQ);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int mhu_send_data(struct ipc_link *link, void *data)
+{
+	struct omap2_mbox_link *oml = to_oml(link);
+	struct omap2_mbox_con *omc = oml->omc;
+
+	/* If FIFO is already full */
+	if (omap_mb_read(omc, MAILBOX_FIFOSTATUS(oml->mb_tx)) & 0x1) {
+		/* Enable IRQ and return busy */
+		omc_enable_irq(oml, TX_IRQ);
+		return -EBUSY;
+	}
+
+	omap_mb_write(omc, (u32)data, MAILBOX_MESSAGE(oml->mb_tx));
+	ipc_link_txdone(link, XFER_OK);
+
+	return 0;
+}
+
+static int mhu_startup(struct ipc_link *link, void *ignored)
+{
+	struct omap2_mbox_link *oml = to_oml(link);
+	struct omap2_mbox_con *omc = oml->omc;
+	int i, irq_taken, err = 0;
+
+	pm_runtime_enable(omc->dev);
+	pm_runtime_get_sync(omc->dev);
+
+	mutex_lock(&omc->lock);
+
+	irq_taken = 0;
+	for (i = 0; i < 4; i++) {
+		struct omap2_mbox_link *l = &omc->oml[i];
+		if (l->irq == oml->irq && l->active)
+			irq_taken = 1;
+	}
+	oml->active = true;
+	if (!irq_taken) {
+		err = request_irq(oml->irq, ipc_handler,
+			0, omc->oml[i].link.link_name, oml);
+		if (err)
+			oml->active = false;
+	}
+
+	mutex_unlock(&omc->lock);
+
+	if (err) {
+		pm_runtime_put_sync(omc->dev);
+		pm_runtime_disable(omc->dev);
+	} else {
+		omc_disable_irq(oml, TX_IRQ);
+		/* Start accepting messages */
+		omc_enable_irq(oml, RX_IRQ);
+	}
+
+	return err;
+}
+
+static void mhu_shutdown(struct ipc_link *link)
+{
+	struct omap2_mbox_link *oml = to_oml(link);
+	struct omap2_mbox_con *omc = oml->omc;
+	int irq_taken;
+
+	/* Stop accepting messages */
+	omc_disable_irq(oml, RX_IRQ);
+	/* Flush the TX FIFO */
+	omc_disable_irq(oml, TX_IRQ);
+	omap_mb_read(omc, MAILBOX_MESSAGE(oml->mb_tx));
+	omap_mb_read(omc, MAILBOX_MESSAGE(oml->mb_tx));
+	omap_mb_read(omc, MAILBOX_MESSAGE(oml->mb_tx));
+	omap_mb_read(omc, MAILBOX_MESSAGE(oml->mb_tx));
+
+	mutex_lock(&omc->lock);
+
+	irq_taken = 0;
+	oml->active = false;
+	for (i = 0; i < 4; i++) {
+		struct omap2_mbox_link *l = &omc->oml[i];
+		if (l->irq == oml->irq && l->active)
+			irq_taken = 1;
+	}
+	if (!irq_taken)
+		free_irq(oml->irq, omc);
+
+	mutex_unlock(&omc->lock);
+
+	pm_runtime_put_sync(omc->dev);
+	pm_runtime_disable(omc->dev);
+}
+
+static struct ipc_link_ops omap2_mbox_ops = {
+	.startup = omap2_mbox_startup,
+	.send_data = omap2_mbox_send_data,
+	.shutdown = omap2_mbox_shutdown,
+};
+
+static int omap2_mbox_probe(struct platform_device *pdev)
+{
+	struct omap_mbox_pdata *pdata = pdev->dev.platform_data;
+	struct omap_mbox_dev_info *info;
+	struct omap2_mbox_con *omc;
+	void __iomem *base;
+	struct ipc_link *l[5];
+	struct resource *mem;
+	int i, ret;
+
+	if (!pdata || !pdata->info_cnt || !pdata->info) {
+		pr_err("%s: platform not supported\n", __func__);
+		return -ENODEV;
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		pr_err("%s: No mem resource\n", __func__);
+		return -ENOMEM;
+	}
+
+	base = ioremap(mem->start, resource_size(mem));
+	if (!base) {
+		pr_err("%s: Ioremap failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	omc = kzalloc(sizeof(*omc), GFP_KERNEL);
+	if (!omc) {
+		pr_err("%s: Unable to alloc omap2_mbox_con\n", __func__);
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	info = pdata->info;
+	for (i = 0; i < pdata->info_cnt; i++, info++, priv++) {
+		omc->oml[i].irq = platform_get_irq(pdev, info->irq_id);
+		omc->oml[i].active = false;
+		omc->oml[i].usr_id = info->usr_id;
+		omc->oml[i].mb_rx = info->rx_id;
+		omc->oml[i].mb_tx = info->tx_id;
+		omc->oml[i].omc = omc;
+		snprintf(omc->oml[i].link.link_name, 16, "%s", info->name);
+		l[i] = &omc->oml[i].link;
+		omc->intr_type = pdata->intr_type;
+	}
+	l[i] = NULL;
+	omc->ipc_con.links = l;
+	omc->mbox_base = base;
+	omc->dev = &pdev->dev;
+	/*
+	 * OMAP has "TX-FIFO Not Full" IRQ, not the "TX-Done" IRQ
+	 * So we simply put data in FIFO and assume we are done.
+	 */
+	omc->ipc_con.txdone_irq = true;
+	omc->ipc_con.ops = &omap2_mbox_ops;
+	snprintf(ipcu->ipc_con.controller_name, 16, "omap2");
+	mutex_init(&omc->lock);
+
+	ret = ipc_links_register(&omc->ipc_con);
+	if (ret) {
+		pr_err("%s: IPC register failed\n", __func__);
+		ret = -EINVAL;
+		goto err_reg;
+	}
+
+	platform_set_drvdata(pdev, omc);
+
+	return ret;
+
+err_alloc:
+	iounmap(base);
+err_reg:
+	kfree(omc);
+	return ret;
+}
+
+static int omap2_mbox_remove(struct platform_device *pdev)
+{
+	struct omap2_mbox_con *omc = platform_set_drvdata(pdev);
+
+	ipc_links_unregister(&omc->ipc_con);
+	iounmap(omc->mbox_base);
+	kfree(omc);
+
+	return 0;
+}
+
+static struct platform_driver omap2_mbox_driver = {
+	.probe	= omap2_mbox_probe,
+	.remove	= omap2_mbox_remove,
+	.driver	= {
+		.name = "omap-mailbox",
+	},
+};
+
+static int __init omap2_mbox_init(void)
+{
+	return platform_driver_register(&omap2_mbox_driver);
+}
+module_init(omap2_mbox_init);
+
+static void __exit omap2_mbox_exit(void)
+{
+	platform_driver_unregister(&omap2_mbox_driver);
+}
+module_exit(omap2_mbox_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("omap mailbox: omap2/3/4 architecture specific functions");
+MODULE_AUTHOR("Jaswinder Singh <jaswinder.singh@linaro.org>");
+MODULE_AUTHOR("Suman Anna <s-anna@ti.com>");
+MODULE_ALIAS("platform:omap2-mailbox");
diff --git a/include/linux/platform_data/mailbox-omap.h b/include/linux/platform_data/mailbox-omap.h
new file mode 100644
index 0000000..b35eaee
--- /dev/null
+++ b/include/linux/platform_data/mailbox-omap.h
@@ -0,0 +1,64 @@
+/*
+ * mailbox-omap.h
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _PLAT_MAILBOX_H
+#define _PLAT_MAILBOX_H
+
+/* Interrupt register configuration types */
+#define MBOX_INTR_CFG_TYPE1	(0)
+#define MBOX_INTR_CFG_TYPE2	(1)
+
+/**
+ * struct omap_mbox_dev_info - OMAP mailbox device attribute info
+ * @name:	name of the mailbox device
+ * @tx_id:	mailbox queue id used for transmitting messages
+ * @rx_id:	mailbox queue id on which messages are received
+ * @irq_id:	irq identifier number to use from the hwmod data
+ * @usr_id:	mailbox user id for identifying the interrupt into
+ *			the MPU interrupt controller.
+ */
+struct omap_mbox_dev_info {
+	const char *name;
+	u32 tx_id;
+	u32 rx_id;
+	u32 irq_id;
+	u32 usr_id;
+};
+
+/**
+ * struct omap_mbox_pdata - OMAP mailbox platform data
+ * @intr_type:	type of interrupt configuration registers used
+			while programming mailbox queue interrupts
+ * @info_cnt:	number of mailbox devices for the platform
+ * @info:	array of mailbox device attributes
+ */
+struct omap_mbox_pdata {
+	u32 intr_type;
+	u32 info_cnt;
+	struct omap_mbox_dev_info *info;
+};
+
+/**
+ * struct omap2_mbox_rxdata - RX Packet handed over to a client by controller.
+ *  For TX, clients simply provide a (void *)u32 packet at a time.
+ * @len: Number of words received
+ * @buf: Array of received words
+ */
+struct omap2_mbox_rxdata {
+	int len;
+	u32 *buf;
+};
+
+#endif /* _PLAT_MAILBOX_H */
-- 
1.7.10.4

