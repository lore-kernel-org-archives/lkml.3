Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaAQJoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:44:01 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:45002 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaAQJnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:43:53 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: chris@printf.net
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, mark.rutland@arm.com,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v6] mmc: sdhci-moxart: Add MOXA ART SDHCI driver
Date: Fri, 17 Jan 2014 10:43:45 +0100
Message-Id: <1389951825-14884-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1386763426-10158-1-git-send-email-jonas.jensen@gmail.com>
References: <1386763426-10158-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SDHCI driver for MOXA ART SoCs.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes in v6 fixes a kernel panic in moxart_dma_complete().
    
    Panic only happens with CONFIG_SLAB or CONFIG_SLOB, the same code
    works for CONFIG_SLUB, and happens because a cookie belonging
    to the channel is passed to dmaengine_tx_status(), e.g.
    "host->tx_desc->chan->cookie".
    
    Panic log:
    [    4.130000] mmc0: new SD card at address e624
    [    4.170000] nf_conntrack version 0.5.0 (357 buckets, 1428 max)
    [    4.190000] ip_tables: (C) 2000-2006 Netfilter Core Team
    [    4.190000] TCP: cubic registered
    [    4.200000] NET: Registered protocol family 10
    [    4.240000] sit: IPv6 over IPv4 tunneling driver
    [    4.270000] mmcblk0: mmc0:e624 SD02G 1.84 GiB
    [    4.320000]  mmcblk0: p1
    [    4.370000] NET: Registered protocol family 17
    [    4.440000] console [netcon0] enabled
    [    4.440000] netconsole: network logging started
    [    4.450000] moxart-rtc rtc.0: setting system clock to 2014-01-16 13:39:54 UTC (1389879594)
    [    4.550000] kjournald starting.  Commit interval 5 seconds
    [    4.550000] EXT3-fs (mmcblk0p1): warning: maximal mount count reached, running e2fsck is recommended
    [    4.570000] EXT3-fs (mmcblk0p1): using internal journal
    [    4.580000] EXT3-fs (mmcblk0p1): mounted filesystem with ordered data mode
    [    4.590000] VFS: Mounted root (ext3 filesystem) on device 179:1.
    [    4.610000] devtmpfs: mounted
    [    4.630000] Freeing unused kernel memory: 156K (c0339000 - c0360000)
    [    4.640000] Unable to handle kernel paging request at virtual address aaaaaaaa
    [    4.640000] pgd = c0004000
    [    4.640000] [aaaaaaaa] *pgd=00000000
    [    4.640000] Internal error: Oops: 1 [#1] ARM
    [    4.640000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-rc8-next-20140115+ #1577
    [    4.640000] task: c03676a8 ti: c0362000 task.ti: c0362000
    [    4.640000] PC is at moxart_dma_complete+0x14/0x68
    [    4.640000] LR is at vchan_complete+0xcc/0xf4
    [    4.640000] pc : [<c01a6724>]    lr : [<c0154a28>]    psr: a0000013
    [    4.640000] sp : c0363e98  ip : c037ffcc  fp : c0380f00
    [    4.640000] r10: c1a867e0  r9 : c0380f38  r8 : c0363eb0
    [    4.640000] r7 : 00100100  r6 : 00200200  r5 : c01a6710  r4 : c1a867e0
    [    4.640000] r3 : c1ac0030  r2 : c0363e9c  r1 : c03676a8  r0 : aaaaaaaa
    [    4.640000] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
    [    4.640000] Control: 0000397f  Table: 00004000  DAC: 00000017
    [    4.640000] Process swapper (pid: 0, stack limit = 0xc03621c0)
    [    4.640000] Stack: (0xc0363e98 to 0xc0364000)
    [    4.640000] 3e80:                                                       c1a867e0 c03676a8
    [    4.640000] 3ea0: 00000000 c03676a8 c1871158 c0154a28 c0363eb0 c0363eb0 60000013 c1871184
    [    4.640000] 3ec0: c03694d4 00000000 00000000 00000006 00000100 c0018fc4 c036bc60 00000007
    [    4.640000] 3ee0: 00000040 c0362000 c0380f20 c0018950 c185b894 c185b894 c185b840 00000006
    [    4.640000] 3f00: 0000000a 00200000 00000001 ffff8ca1 00000000 00000011 00000000 c0934d40
    [    4.640000] 3f20: 00000001 c0363f68 66015261 c0352624 00000000 c0018d38 00000011 c0009a14
    [    4.640000] 3f40: c18020e4 01000000 00000018 c0008538 c0009b94 20000013 ffffffff c0363f9c
    [    4.640000] 3f60: c0998200 c000bfb8 00000001 c03676a8 00000000 20000013 c0362000 c0364020
    [    4.640000] 3f80: c0364110 ffffffff c0998200 66015261 c0352624 00000000 f6aa4ecf c0363fb0
    [    4.640000] 3fa0: c003da20 c0009b94 20000013 ffffffff c03676a8 c0047548 c03676a8 c0339988
    [    4.640000] 3fc0: ffffffff ffffffff c03394d4 00000000 00000000 c0352624 00000000 0000397d
    [    4.640000] 3fe0: c03640a4 c0352620 c03689ec 00004000 003517b4 00008040 00000000 00000000
    [    4.640000] [<c01a6724>] (moxart_dma_complete) from [<c0154a28>] (vchan_complete+0xcc/0xf4)
    [    4.640000] [<c0154a28>] (vchan_complete) from [<c0018fc4>] (tasklet_action+0x84/0xd4)
    [    4.640000] [<c0018fc4>] (tasklet_action) from [<c0018950>] (__do_softirq+0x170/0x2a4)
    [    4.640000] [<c0018950>] (__do_softirq) from [<c0018d38>] (irq_exit+0x80/0x100)
    [    4.640000] [<c0018d38>] (irq_exit) from [<c0009a14>] (handle_IRQ+0x60/0x80)
    [    4.640000] [<c0009a14>] (handle_IRQ) from [<c0008538>] (handle_irq+0x88/0x9c)
    [    4.640000] [<c0008538>] (handle_irq) from [<c000bfb8>] (__irq_svc+0x38/0x48)
    [    4.640000] Exception stack(0xc0363f68 to 0xc0363fb0)
    [    4.640000] 3f60:                   00000001 c03676a8 00000000 20000013 c0362000 c0364020
    [    4.640000] 3f80: c0364110 ffffffff c0998200 66015261 c0352624 00000000 f6aa4ecf c0363fb0
    [    4.640000] 3fa0: c003da20 c0009b94 20000013 ffffffff
    [    4.640000] [<c000bfb8>] (__irq_svc) from [<c0009b94>] (arch_cpu_idle+0x3c/0x48)
    [    4.640000] [<c0009b94>] (arch_cpu_idle) from [<c0047548>] (cpu_startup_entry+0x80/0xf0)
    [    4.640000] [<c0047548>] (cpu_startup_entry) from [<c0339988>] (start_kernel+0x298/0x2e0)
    [    4.640000] Code: e5903030 e1a04000 e593000c e28d2004 (e5903000)
    [    4.950000] ---[ end trace e911ec2d43c1d3c3 ]---
    [    4.960000] Kernel panic - not syncing: Fatal exception in interrupt
    
    Changes since v5:
    
    1. add local dma_cookie_t to host struct
    2. store dmaengine_submit() return value to [1]
    3. use [1] when calling dmaengine_tx_status()
    
    Applies to next-20140117

 .../devicetree/bindings/mmc/moxa,moxart-sdhci.txt  |  28 +
 drivers/mmc/host/Kconfig                           |   9 +
 drivers/mmc/host/Makefile                          |   1 +
 drivers/mmc/host/sdhci-moxart.c                    | 931 +++++++++++++++++++++
 4 files changed, 969 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt
 create mode 100644 drivers/mmc/host/sdhci-moxart.c

diff --git a/Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt b/Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt
new file mode 100644
index 0000000..020b13e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/moxa,moxart-sdhci.txt
@@ -0,0 +1,28 @@
+MOXA ART SD Host Controller Interface
+
+Required properties:
+
+- compatible :	Must be "moxa,moxart-sdhci"
+- reg :		Should contain registers location and length
+- interrupts :	Should contain the interrupt number
+- clocks :	Should contain phandle for the clock feeding the SDHCI controller
+
+Optional properties:
+
+These are optional but required to enable DMA transfer mode:
+
+- dmas :	Should contain two DMA channels, line request number must be 5 for
+		both channels
+- dma-names :	Must be "tx", "rx"
+
+Example:
+
+	sdhci: sdhci@98e00000 {
+		compatible = "moxa,moxart-sdhci";
+		reg = <0x98e00000 0x5C>;
+		interrupts = <5 0>;
+		clocks = <&coreclk>;
+		dmas =  <&dma 0 5>,
+			<&dma 1 5>;
+		dma-names = "tx", "rx";
+	};
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 1384f67..e972190 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -283,6 +283,15 @@ config MMC_SDHCI_BCM2835
 
 	  If unsure, say N.
 
+config MMC_SDHCI_MOXART
+	tristate "MOXART SD Host Controller Interface support"
+	depends on ARCH_MOXART && MMC
+	help
+	  This selects the MOXART SD Host Controller Interface.
+	  MOXA provides one multi-functional card reader which can
+	  be found on some embedded hardware such as UC-7112-LX.
+	  If you have a controller with this interface, say Y here.
+
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
 	depends on ARCH_OMAP
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 3483b6b..39e2554 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
 obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
 obj-$(CONFIG_MMC_SDHCI_BCM_KONA)	+= sdhci-bcm-kona.o
 obj-$(CONFIG_MMC_SDHCI_BCM2835)		+= sdhci-bcm2835.o
+obj-$(CONFIG_MMC_SDHCI_MOXART)		+= sdhci-moxart.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff --git a/drivers/mmc/host/sdhci-moxart.c b/drivers/mmc/host/sdhci-moxart.c
new file mode 100644
index 0000000..f0bf3e0
--- /dev/null
+++ b/drivers/mmc/host/sdhci-moxart.c
@@ -0,0 +1,931 @@
+/*
+ * MOXA ART MMC host driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * Based on code from
+ * Moxa Technologies Co., Ltd. <www.moxa.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/mmc.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/sizes.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk.h>
+#include <linux/bitops.h>
+#include <linux/of_dma.h>
+
+#include <asm/dma.h>
+#include <asm/irq.h>
+
+#define MSD_CMD_REG		0
+#define MSD_ARG_REG		4
+#define MSD_RESP0_REG		8
+#define MSD_RESP1_REG		0x0c
+#define MSD_RESP2_REG		0x10
+#define MSD_RESP3_REG		0x14
+#define MSD_RESP_CMD_REG	0x18
+#define MSD_DATA_CTRL_REG	0x1c
+#define MSD_DATA_TIMER_REG	0x20
+#define MSD_DATA_LEN_REG	0x24
+#define MSD_STATUS_REG		0x28
+#define MSD_CLEAR_REG		0x2c
+#define MSD_INT_MASK_REG	0x30
+#define MSD_POWER_CTRL_REG	0x34
+#define MSD_CLOCK_CTRL_REG	0x38
+#define MSD_BUS_WIDTH_REG	0x3c
+#define MSD_DATA_WIN_REG	0x40
+#define MSD_FEATURE_REG		0x44
+#define MSD_REVISION_REG	0x48
+
+#define MMC_RSP_SHORT		1
+#define MMC_RSP_LONG		2
+#define MMC_RSP_MASK		3
+#define MMC_ERR_NONE		0
+#define MMC_ERR_TIMEOUT		1
+#define MMC_MODE_MMC		0
+#define MMC_MODE_SD		1
+#define MMC_ERR_BADCRC		2
+#define MMC_VDD_360		23
+
+#define MSD_RETRY_COUNT		10
+
+#define REG_COMMAND		0
+#define REG_ARGUMENT		4
+#define REG_RESPONSE0		8
+#define REG_RESPONSE1		12
+#define REG_RESPONSE2		16
+#define REG_RESPONSE3		20
+#define REG_RESPONSE_COMMAND	24
+#define REG_DATA_CONTROL	28
+#define REG_DATA_TIMER		32
+#define REG_DATA_LENGTH		36
+#define REG_STATUS		40
+#define REG_CLEAR		44
+#define REG_INTERRUPT_MASK	48
+#define REG_POWER_CONTROL	52
+#define REG_CLOCK_CONTROL	56
+#define REG_BUS_WIDTH		60
+#define REG_DATA_WINDOW		64
+#define REG_FEATURE		68
+#define REG_REVISION		72
+
+/* REG_COMMAND */
+#define MSD_SDC_RST		BIT(10)
+#define MSD_CMD_EN		BIT(9)
+#define MSD_APP_CMD		BIT(8)
+#define MSD_LONG_RSP		BIT(7)
+#define MSD_NEED_RSP		BIT(6)
+#define MSD_CMD_IDX_MASK	0x3f
+
+/* REG_RESPONSE_COMMAND */
+#define MSD_RSP_CMD_APP		BIT(6)
+#define MSD_RSP_CMD_IDX_MASK	0x3f
+
+/* REG_DATA_CONTROL */
+#define MSD_DATA_EN		BIT(6)
+#define MSD_DMA_EN		BIT(5)
+#define MSD_DATA_WRITE		BIT(4)
+#define MSD_BLK_SIZE_MASK	0x0f
+
+/* REG_DATA_LENGTH */
+#define MSD_DATA_LEN_MASK	0xffffff
+
+/* REG_STATUS */
+#define MSD_WRITE_PROT		BIT(12)
+#define MSD_CARD_DETECT		BIT(11)
+/* 1-10 below can be sent to interrupt or clear register */
+#define MSD_CARD_CHANGE		BIT(10)
+#define MSD_FIFO_ORUN		BIT(9)
+#define MSD_FIFO_URUN		BIT(8)
+#define MSD_DATA_END		BIT(7)
+#define MSD_CMD_SENT		BIT(6)
+#define MSD_DATA_CRC_OK		BIT(5)
+#define MSD_RSP_CRC_OK		BIT(4)
+#define MSD_DATA_TIMEOUT	BIT(3)
+#define MSD_RSP_TIMEOUT		BIT(2)
+#define MSD_DATA_CRC_FAIL	BIT(1)
+#define MSD_RSP_CRC_FAIL	BIT(0)
+
+/* REG_POWER_CONTROL */
+#define MSD_SD_POWER_ON		BIT(4)
+#define MSD_SD_POWER_MASK	0x0f
+
+/* REG_CLOCK_CONTROL */
+#define MSD_CLK_DIS		BIT(8)
+#define MSD_CLK_SD		BIT(7)
+#define MSD_CLK_DIV_MASK	0x7f
+
+/* REG_BUS_WIDTH */
+#define MSD_WIDE_BUS_SUPPORT	BIT(3)
+#define MSD_WIDE_BUS		BIT(2)	/* bus width is 4 bytes */
+#define MSD_SINGLE_BUS		BIT(0)	/* bus width is 1 byte */
+
+/* REG_FEATURE */
+#define MSD_CPRM_FUNCTION	BIT(8)
+
+struct moxart_host {
+	spinlock_t			lock;
+	void __iomem			*base;
+	phys_addr_t			reg_phys;
+
+	struct dma_chan			*dma_chan_rx;
+	struct dma_chan			*dma_chan_tx;
+	struct dma_async_tx_descriptor	*tx_desc;
+	dma_cookie_t			cur_dma_cookie;
+	unsigned int			dma_direction;
+	bool				have_dma;
+	struct completion		dma_complete;
+	struct completion		pio_complete;
+
+	struct mmc_host			*mmc;
+	struct mmc_request		*mrq;
+
+	struct scatterlist		*cur_sg;
+	unsigned int			num_sg;
+	unsigned int			remain;
+	int				size;
+
+	unsigned int			timeout;
+	long				sysclk;
+	bool				removed;
+};
+
+#define MSD_FIFO_LENW	4	/* 4 words, total 4 * 4 = 16 bytes */
+#define MSD_FIFO_LENB	16	/* 16 bytes */
+
+#define DMA_FIFO_LEN_FORCE		0
+#define MIN_POWER (MMC_VDD_360 - MSD_SD_POWER_MASK)
+
+static inline void moxart_init_sg(struct moxart_host *host,
+				  struct mmc_data *data)
+{
+	host->cur_sg = data->sg;
+	host->num_sg = data->sg_len;
+	host->remain = host->cur_sg->length;
+
+	if (host->remain > host->size)
+		host->remain = host->size;
+
+	data->error = MMC_ERR_NONE;
+}
+
+static inline int moxart_next_sg(struct moxart_host *host)
+{
+	int remain;
+	struct mmc_data *data = host->mrq->cmd->data;
+
+	host->cur_sg++;
+	host->num_sg--;
+
+	if (host->num_sg > 0) {
+		host->remain = host->cur_sg->length;
+		remain = host->size - data->bytes_xfered;
+		if (remain > 0 && remain < host->remain)
+			host->remain = remain;
+	}
+
+	return host->num_sg;
+}
+
+static void moxart_send_command(struct moxart_host *host,
+	struct mmc_command *cmd)
+{
+	unsigned int status, cmdctrl;
+	int retry = 0;
+
+	dev_dbg(mmc_dev(host->mmc), "%s: cmd->opcode=%d\n",
+		__func__, cmd->opcode);
+
+	cmd->error = MMC_ERR_TIMEOUT;
+
+	writel(MSD_RSP_TIMEOUT | MSD_RSP_CRC_OK |
+	       MSD_RSP_CRC_FAIL | MSD_CMD_SENT, host->base + REG_CLEAR);
+	writel(cmd->arg, host->base + REG_ARGUMENT);
+
+	cmdctrl = cmd->opcode & MSD_CMD_IDX_MASK;
+	if (cmdctrl == SD_APP_SET_BUS_WIDTH || cmdctrl == SD_APP_OP_COND ||
+	    cmdctrl == SD_APP_SEND_SCR || cmdctrl == SD_APP_SD_STATUS ||
+	    cmdctrl == SD_APP_SEND_NUM_WR_BLKS)
+		cmdctrl |= MSD_APP_CMD;
+
+	if (cmd->flags & MMC_RSP_136)
+		cmdctrl |= (MSD_LONG_RSP | MSD_NEED_RSP);
+	else
+		cmdctrl |= MSD_NEED_RSP;
+
+	writel(cmdctrl | MSD_CMD_EN, host->base + REG_COMMAND);
+
+	while (retry++ < MSD_RETRY_COUNT) {
+		udelay(10);
+		status = readl(host->base + REG_STATUS);
+		if (status & MSD_CARD_DETECT) {
+			dev_dbg(mmc_dev(host->mmc), "%s: MSD_CARD_DETECT\n",
+				__func__);
+			cmd->error = MMC_ERR_TIMEOUT;
+			break;
+		}
+		if (cmdctrl & MSD_NEED_RSP) {
+			dev_dbg(mmc_dev(host->mmc), "%s: MSD_NEED_RSP\n",
+				__func__);
+			if (status & MSD_RSP_TIMEOUT) {
+				dev_dbg(mmc_dev(host->mmc), "%s: MSD_RSP_TIMEOUT\n",
+					__func__);
+				writel(MSD_RSP_TIMEOUT, host->base + REG_CLEAR);
+				cmd->error = MMC_ERR_TIMEOUT;
+				break;
+			}
+			if ((cmd->flags & MMC_RSP_CRC) &&
+				(status & MSD_RSP_CRC_FAIL)) {
+				dev_dbg(mmc_dev(host->mmc), "%s: MSD_RSP_CRC_FAIL\n",
+					__func__);
+				writel(MSD_RSP_CRC_FAIL, host->base +
+				       REG_CLEAR);
+				cmd->error = MMC_ERR_BADCRC;
+				break;
+			}
+			if (status & MSD_RSP_CRC_OK) {
+				dev_dbg(mmc_dev(host->mmc), "%s: MSD_RSP_CRC_OK\n",
+					__func__);
+				writel(MSD_RSP_CRC_OK, host->base + REG_CLEAR);
+
+				if (cmd->flags & MMC_RSP_136) {
+					cmd->resp[3] =
+						readl(host->base +
+						      REG_RESPONSE0);
+					cmd->resp[2] =
+						readl(host->base +
+						      REG_RESPONSE1);
+					cmd->resp[1] =
+						readl(host->base +
+						      REG_RESPONSE2);
+					cmd->resp[0] =
+						readl(host->base +
+						      REG_RESPONSE3);
+				} else {
+					cmd->resp[0] =
+						readl(host->base +
+						      REG_RESPONSE0);
+				}
+
+				cmd->error = MMC_ERR_NONE;
+				break;
+			}
+		} else {
+			dev_dbg(mmc_dev(host->mmc), "%s: !(cmdctrl & MSD_NEED_RSP)\n",
+				__func__);
+			if (status & MSD_CMD_SENT) {
+				writel(MSD_CMD_SENT, host->base + REG_CLEAR);
+				cmd->error = MMC_ERR_NONE;
+				break;
+			}
+		}
+	}
+
+	if (retry >= (MSD_RETRY_COUNT - 1)) {
+		/*
+		 * this seems to happen a lot on or after CMD25
+		 * (MMC_WRITE_MULTIPLE_BLOCK) with more than 4 blocks
+		 * (>4096), possibly because the transfer is too big
+		 * or takes too long to complete.
+		 * when this happens the controller is usually rendered
+		 * unresponsive and can only be recovered with reboot.
+		 */
+		dev_dbg(mmc_dev(host->mmc), "%s: WARNING! no valid status found!\n",
+			__func__);
+	}
+}
+
+static void moxart_dma_complete(void *param)
+{
+	struct moxart_host		*host = param;
+	struct dma_chan			*chan = host->tx_desc->chan;
+	struct dma_tx_state		txs;
+
+	if (dmaengine_tx_status(chan, host->cur_dma_cookie, &txs) == DMA_ERROR)
+		dev_err_ratelimited(mmc_dev(host->mmc), "%s: DMA error\n",
+				    __func__);
+
+	dev_dbg(mmc_dev(host->mmc), "%s: host=%p\n", __func__, host);
+
+	complete(&host->dma_complete);
+}
+
+static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
+{
+	unsigned int len, direction_dev;
+	struct dma_async_tx_descriptor *desc = NULL;
+	struct dma_chan *dma_chan_cur;
+
+	if (host->size == data->bytes_xfered)
+		return;
+
+	if (data->flags & MMC_DATA_WRITE) {
+		direction_dev = DMA_MEM_TO_DEV;
+		dma_chan_cur = host->dma_chan_tx;
+	} else {
+		direction_dev = DMA_DEV_TO_MEM;
+		dma_chan_cur = host->dma_chan_rx;
+	}
+
+	/*
+	 * because dma_map_sg takes both sg and sg_len as arguments
+	 * (and maps the entire list of buffers) data->sg does not
+	 * have to be incremented between calls (as is required
+	 * in moxart_transfer_pio)
+	 */
+	len = dma_map_sg(dma_chan_cur->device->dev, data->sg,
+			 data->sg_len, host->dma_direction);
+
+	if (len > 0) {
+		desc = dmaengine_prep_slave_sg(dma_chan_cur, data->sg,
+					       len, direction_dev,
+					       DMA_PREP_INTERRUPT |
+					       DMA_CTRL_ACK);
+	} else {
+		dev_err(mmc_dev(host->mmc),
+			"%s: dma_map_sg returned zero length\n",
+			__func__);
+	}
+
+	if (desc) {
+		host->tx_desc = desc;
+		desc->callback = moxart_dma_complete;
+		desc->callback_param = host;
+		host->cur_dma_cookie = dmaengine_submit(desc);
+		dma_async_issue_pending(dma_chan_cur);
+	}
+
+	data->bytes_xfered += host->remain;
+}
+
+/* when DMA is available this is used only for SD_APP_SEND_SCR */
+static void moxart_transfer_pio(struct moxart_host *host)
+{
+	unsigned char *buffer;
+	unsigned int wcnt, i;
+	struct mmc_data *data = host->mrq->cmd->data;
+
+	if (host->size == data->bytes_xfered)
+		goto transfer_complete;
+
+	buffer = sg_virt(host->cur_sg);
+	wcnt = host->remain >> 2;
+
+	if (data->flags & MMC_DATA_WRITE) {
+		for (i = 0; i < wcnt; i++, buffer += 4) {
+			writel(*(unsigned int *)buffer,
+			       host->base + REG_DATA_WINDOW);
+			udelay(10);
+		}
+	} else {
+		for (i = 0; i < wcnt; i++, buffer += 4) {
+			/* byte order reversed only when reading SCR */
+			if (data->mrq->cmd->opcode == SD_APP_SEND_SCR) {
+				*(unsigned int *)buffer = ioread32be(
+					host->base + REG_DATA_WINDOW);
+			} else {
+				*(unsigned int *)buffer =
+					readl(host->base + REG_DATA_WINDOW);
+			}
+			udelay(10);
+		}
+	}
+	wcnt <<= 2;
+	host->remain -= wcnt;
+	data->bytes_xfered += wcnt;
+
+	if (host->size != data->bytes_xfered) {
+		moxart_next_sg(host);
+		/*
+		 * used to goto "transfer_start" label here,
+		 * there is no need, this function will be
+		 * called again from interrupt.
+		 *
+		 * compare with DMA where sg increment is
+		 * redundant thanks to dma_map_sg
+		 */
+	} else {
+		complete(&host->pio_complete);
+	}
+
+transfer_complete:
+	dev_dbg(mmc_dev(host->mmc), "%s: host->size=%d host->remain=%u\n",
+		__func__, host->size, host->remain);
+}
+
+static void moxart_prepare_data(struct moxart_host *host)
+{
+	struct mmc_data *data = host->mrq->cmd->data;
+	unsigned int timeout, datactrl;
+	int blksz_bits;
+
+	dev_dbg(mmc_dev(host->mmc), "%s\n", __func__);
+
+	if (!data)
+		return;
+
+	host->size = data->blocks * data->blksz;
+	blksz_bits = ffs(data->blksz) - 1;
+	BUG_ON(1 << blksz_bits != data->blksz);
+
+	moxart_init_sg(host, data);
+
+	timeout = (host->mmc->f_max / 1000) * (data->timeout_ns / 1000);
+	timeout *= 2;
+
+	datactrl = (blksz_bits & MSD_BLK_SIZE_MASK) | MSD_DATA_EN;
+
+	if (data->flags & MMC_DATA_WRITE)
+		datactrl |= MSD_DATA_WRITE;
+
+	if (((host->size > MSD_FIFO_LENB) || DMA_FIFO_LEN_FORCE)
+	    && host->have_dma) {
+		datactrl |= MSD_DMA_EN;
+	}
+
+	dev_dbg(mmc_dev(host->mmc), "%s: blocks=%d blksz=%d datactrl=0x%08x\n",
+		__func__, data->blocks,	data->blksz, datactrl);
+	dev_dbg(mmc_dev(host->mmc), "%s: timeout=%u timeout_ns=%u\n",
+		__func__, timeout, data->timeout_ns);
+
+	writel(timeout, host->base + REG_DATA_TIMER);
+	writel(host->size, host->base + REG_DATA_LENGTH);
+	writel(datactrl, host->base + REG_DATA_CONTROL);
+}
+
+static void moxart_transfer_check(struct mmc_data *data,
+				  struct moxart_host *host)
+{
+	unsigned int status, count = 0;
+
+	dev_dbg(mmc_dev(host->mmc), "%s\n", __func__);
+
+	while (1) {
+		udelay(10);
+		status = readl(host->base + REG_STATUS);
+		if (status & (MSD_DATA_CRC_OK | MSD_DATA_CRC_FAIL
+			| MSD_DATA_END)	|| count > 10)
+			break;
+		dev_dbg(mmc_dev(host->mmc), "%s: waiting for status=%08x ..\n",
+			__func__, status);
+		count++;
+	}
+	if (status & MSD_DATA_CRC_OK) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_CRC_OK\n", __func__);
+		writel(MSD_DATA_CRC_OK, host->base + REG_CLEAR);
+	}
+	if (status & MSD_DATA_CRC_FAIL) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_CRC_FAIL\n",
+			__func__);
+		writel(MSD_DATA_CRC_FAIL, host->base + REG_CLEAR);
+		data->error = MMC_ERR_TIMEOUT;
+	}
+	if (status & MSD_DATA_END) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_END\n",
+			__func__);
+		writel(MSD_DATA_END, host->base + REG_CLEAR);
+	}
+	if (status & MSD_DATA_TIMEOUT) {
+		dev_dbg(mmc_dev(host->mmc), "%s: MSD_DATA_TIMEOUT\n",
+			__func__);
+		writel(MSD_DATA_TIMEOUT, host->base + REG_CLEAR);
+	}
+}
+
+static void moxart_card_change(struct moxart_host *host)
+{
+	int delay;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (readl(host->base + REG_STATUS) & MSD_CARD_DETECT) {
+		dev_dbg(mmc_dev(host->mmc), "%s: card removed\n", __func__);
+		if (host->have_dma && host->size > MSD_FIFO_LENB) {
+			dev_dbg(mmc_dev(host->mmc), "%s: call dmaengine_terminate_all\n",
+				__func__);
+			dmaengine_terminate_all(host->dma_chan_rx);
+			dmaengine_terminate_all(host->dma_chan_tx);
+		}
+		host->removed = true;
+		delay = 0;
+	} else {
+		dev_dbg(mmc_dev(host->mmc), "%s: card inserted\n", __func__);
+		host->removed = false;
+		delay = 500;
+	}
+
+	/*
+	 * clearing FIFO interrupts here does not stop a follow up
+	 * MSD_FIFO_*RUN after MSD_CARD_CHANGE. instead, check
+	 * host->mrq != NULL in moxart_irq to avoid unnecessary calls
+	 * to moxart_transfer_pio
+	 * if this happens during transfer the mmc_request in
+	 * moxart_request should still be valid
+	 * (which is why host->mrq can be set NULL here)
+	 */
+	host->mrq = NULL;
+	writel(MSD_CARD_CHANGE | MSD_FIFO_ORUN | MSD_FIFO_URUN,
+	       host->base + REG_CLEAR);
+	writel(MSD_CARD_CHANGE, host->base + REG_INTERRUPT_MASK);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+	dev_dbg(mmc_dev(host->mmc), "%s: call mmc_detect_change\n", __func__);
+	mmc_detect_change(host->mmc, msecs_to_jiffies(delay));
+}
+
+static void moxart_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct moxart_host *host = mmc_priv(mmc);
+	unsigned long dma_time, pio_time, flags;
+	unsigned int status;
+
+	dev_dbg(mmc_dev(host->mmc), "%s\n", __func__);
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	init_completion(&host->dma_complete);
+	init_completion(&host->pio_complete);
+
+	host->mrq = mrq;
+
+	if (readl(host->base + REG_STATUS) & MSD_CARD_DETECT) {
+		mrq->cmd->error = MMC_ERR_TIMEOUT;
+		goto request_done;
+	}
+
+	moxart_prepare_data(host);
+	moxart_send_command(host, host->mrq->cmd);
+
+	if (mrq->cmd->data) {
+		/* only use DMA/PIO (and wait) when there is data */
+		if (((host->size > MSD_FIFO_LENB) || DMA_FIFO_LEN_FORCE)
+			&& host->have_dma) {
+
+			writel(MSD_CARD_CHANGE, host->base +
+			       REG_INTERRUPT_MASK);
+
+			spin_unlock_irqrestore(&host->lock, flags);
+
+			host->dma_direction = (mrq->cmd->data->flags
+					      & MMC_DATA_WRITE) ?
+					      DMA_TO_DEVICE : DMA_FROM_DEVICE;
+			moxart_transfer_dma(mrq->cmd->data, host);
+
+			dma_time = wait_for_completion_interruptible_timeout(
+				   &host->dma_complete, host->timeout);
+			dev_dbg(mmc_dev(host->mmc), "%s: dma_time=%lu (DMA wait time)\n",
+				__func__, dma_time);
+
+			dma_unmap_sg(host->dma_chan_tx->device->dev,
+				     mrq->cmd->data->sg, mrq->cmd->data->sg_len,
+				     host->dma_direction);
+
+			spin_lock_irqsave(&host->lock, flags);
+		} else {
+
+			writel(MSD_FIFO_URUN | MSD_FIFO_ORUN | MSD_CARD_CHANGE,
+			       host->base + REG_INTERRUPT_MASK);
+
+			status = readl(host->base + REG_STATUS);
+			dev_dbg(mmc_dev(host->mmc), "%s: status=%08x\n",
+				__func__, status);
+
+			spin_unlock_irqrestore(&host->lock, flags);
+
+			/* PIO transfer started from interrupt */
+			pio_time = wait_for_completion_interruptible_timeout(
+				   &host->pio_complete, host->timeout);
+			dev_dbg(mmc_dev(host->mmc), "%s: pio_time=%lu (PIO wait time)\n",
+				__func__, pio_time);
+
+			spin_lock_irqsave(&host->lock, flags);
+		}
+
+		/* removed during transfer? (interrupts were just enabled..) */
+		if (host->removed) {
+			dev_dbg(mmc_dev(host->mmc), "%s: host removed during transfer!\n",
+				__func__);
+			mrq->cmd->error = MMC_ERR_TIMEOUT;
+		}
+
+		moxart_transfer_check(mrq->cmd->data, host);
+
+		if (mrq->cmd->data->stop)
+			moxart_send_command(host, mrq->cmd->data->stop);
+	}
+
+request_done:
+	spin_unlock_irqrestore(&host->lock, flags);
+	mmc_request_done(host->mmc, mrq);
+}
+
+static irqreturn_t moxart_irq(int irq, void *devid)
+{
+	struct moxart_host *host = (struct moxart_host *)devid;
+	unsigned int status;
+	unsigned long flags;
+
+	status = readl(host->base + REG_STATUS);
+
+	dev_dbg(mmc_dev(host->mmc), "%s: host=%p status=%08x\n",
+		__func__, host, status);
+
+	if (status & MSD_CARD_CHANGE) {
+		dev_dbg(mmc_dev(host->mmc), "%s: call moxart_card_change\n",
+			__func__);
+		moxart_card_change(host);
+	}
+	if (status & (MSD_FIFO_ORUN | MSD_FIFO_URUN) && host->mrq) {
+		writel(status & (MSD_FIFO_ORUN | MSD_FIFO_URUN),
+		       host->base + REG_CLEAR);
+		dev_dbg(mmc_dev(host->mmc), "%s: call moxart_transfer_pio\n",
+			__func__);
+		spin_lock_irqsave(&host->lock, flags);
+		moxart_transfer_pio(host);
+		spin_unlock_irqrestore(&host->lock, flags);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void moxart_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct moxart_host *host = mmc_priv(mmc);
+	unsigned long flags;
+	unsigned short power;
+	int div;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (ios->clock) {
+		div = (host->sysclk / (host->mmc->f_max * 2)) - 1;
+
+		if (div > MSD_CLK_DIV_MASK)
+			div = MSD_CLK_DIV_MASK;
+		else if (div < 0)
+			div = 0;
+
+		div |= MSD_CLK_SD;
+		writel(div, host->base + REG_CLOCK_CONTROL);
+	} else if (!(readl(host->base + REG_CLOCK_CONTROL) & MSD_CLK_DIS)) {
+		writel(readl(host->base + REG_CLOCK_CONTROL) | MSD_CLK_DIS,
+		       host->base + REG_CLOCK_CONTROL);
+	}
+
+	if (ios->power_mode == MMC_POWER_OFF) {
+		writel(readl(host->base + REG_POWER_CONTROL) & ~MSD_SD_POWER_ON,
+		       host->base + REG_POWER_CONTROL);
+	} else {
+		if (ios->vdd < MIN_POWER)
+			power = 0;
+		else
+			power = ios->vdd - MIN_POWER;
+
+		writel(MSD_SD_POWER_ON | (unsigned int) power,
+		       host->base + REG_POWER_CONTROL);
+	}
+
+	if (ios->bus_width == MMC_BUS_WIDTH_1)
+		writel(MSD_SINGLE_BUS, host->base + REG_BUS_WIDTH);
+	else
+		writel(MSD_WIDE_BUS, host->base + REG_BUS_WIDTH);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+
+static int moxart_get_ro(struct mmc_host *mmc)
+{
+	struct moxart_host *host = mmc_priv(mmc);
+
+	return !!(readl(host->base + REG_STATUS) & MSD_WRITE_PROT);
+}
+
+static struct mmc_host_ops moxart_ops = {
+	.request = moxart_request,
+	.set_ios = moxart_set_ios,
+	.get_ro = moxart_get_ro,
+};
+
+static int moxart_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct resource res_mmc;
+	struct mmc_host *mmc;
+	struct moxart_host *host = NULL;
+	void __iomem *reg_mmc;
+	dma_cap_mask_t mask;
+	int ret;
+	struct dma_slave_config cfg;
+	unsigned int irq;
+	struct clk *clk;
+
+	mmc = mmc_alloc_host(sizeof(struct moxart_host), dev);
+	if (!mmc) {
+		dev_err(dev, "%s: mmc_alloc_host failed\n", __func__);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = of_address_to_resource(node, 0, &res_mmc);
+	if (ret) {
+		dev_err(dev, "%s: could not get MMC base resource\n", __func__);
+		goto out;
+	}
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0) {
+		dev_err(dev, "irq_of_parse_and_map failed\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	reg_mmc = devm_ioremap_resource(dev, &res_mmc);
+	if (IS_ERR(reg_mmc))
+		return PTR_ERR(reg_mmc);
+
+	mmc->ops = &moxart_ops;
+
+	/*
+	 * hardware does not support MMC_CAP_SD_HIGHSPEED
+	 * CMD6 will timeout and make things not work
+	 */
+	mmc->caps = MMC_CAP_4_BIT_DATA;
+
+	mmc->f_min = 400000;
+	mmc->f_max = 25000000;
+	mmc->ocr_avail = 0xffff00;	/* support 2.0v - 3.6v power */
+	mmc->max_segs = 32;
+	mmc->max_blk_size = 512;
+	mmc->max_blk_count = mmc->max_req_size / mmc->max_blk_size;
+	mmc->max_seg_size = mmc->max_req_size;
+
+	host = mmc_priv(mmc);
+	host->mmc = mmc;
+	host->base = reg_mmc;
+	host->reg_phys = res_mmc.start;
+	host->timeout = msecs_to_jiffies(1000);
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk)) {
+		dev_err(dev, "%s: of_clk_get failed\n", __func__);
+		return PTR_ERR(clk);
+	}
+	host->sysclk = clk_get_rate(clk);
+
+	spin_lock_init(&host->lock);
+
+	/* disable all interrupt */
+	writel(0, host->base + REG_INTERRUPT_MASK);
+
+	/* reset chip */
+	writel(MSD_SDC_RST, host->base + REG_COMMAND);
+
+	/* wait for reset finished */
+	while (readl(host->base + REG_COMMAND) & MSD_SDC_RST)
+		udelay(10);
+
+	host->dma_chan_tx = of_dma_request_slave_channel(node, "tx");
+	host->dma_chan_rx = of_dma_request_slave_channel(node, "rx");
+
+	if (!host->dma_chan_rx || !host->dma_chan_tx) {
+		dev_dbg(dev, "%s: using PIO mode transfer\n", __func__);
+
+		host->have_dma = false;
+		mmc->max_blk_count = 1;
+	} else {
+		dev_dbg(dev, "%s: using 2 DMA channels rx=%p tx=%p\n",
+			__func__, host->dma_chan_rx, host->dma_chan_tx);
+
+		cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+
+		cfg.direction = DMA_MEM_TO_DEV;
+		cfg.src_addr = 0;
+		cfg.dst_addr = (unsigned int)host->reg_phys + MSD_DATA_WIN_REG;
+		dmaengine_slave_config(host->dma_chan_tx, &cfg);
+
+		cfg.direction = DMA_DEV_TO_MEM;
+		cfg.src_addr = (unsigned int)host->reg_phys + MSD_DATA_WIN_REG;
+		cfg.dst_addr = 0;
+		dmaengine_slave_config(host->dma_chan_rx, &cfg);
+
+		host->have_dma = true;
+
+		/*
+		 * there seems to be a max size on transfers so
+		 * set max_blk_count low for both DMA and PIO
+		 *
+		 * sending large chunks result either in timeout
+		 * or render the MMC controller unresponsive
+		 * (status register 0 on consecutive read retries,
+		 * also see comments in moxart_send_command)
+		 *
+		 * obviously, DMA is quicker and can handle
+		 * larger chunks but setting it higher than 16
+		 * can still bug the controller
+		 */
+		mmc->max_blk_count = 16;
+	}
+
+	ret = devm_request_irq(dev, irq, moxart_irq, 0, "moxart-mmc", host);
+
+	if (ret)
+		goto out;
+
+	dev_set_drvdata(dev, mmc);
+	mmc_add_host(mmc);
+
+	dev_dbg(dev, "%s: IRQ=%d\n", __func__, irq);
+
+	return 0;
+
+out:
+	if (mmc)
+		mmc_free_host(mmc);
+	return ret;
+}
+
+static void moxart_release_dma(struct moxart_host *host)
+{
+	if (host->dma_chan_tx) {
+		struct dma_chan *chan = host->dma_chan_tx;
+		host->dma_chan_tx = NULL;
+		dma_release_channel(chan);
+	}
+	if (host->dma_chan_rx) {
+		struct dma_chan *chan = host->dma_chan_rx;
+		host->dma_chan_rx = NULL;
+		dma_release_channel(chan);
+	}
+}
+
+static int moxart_remove(struct platform_device *pdev)
+{
+	struct mmc_host *mmc = dev_get_drvdata(&pdev->dev);
+	struct moxart_host *host = mmc_priv(mmc);
+
+	dev_set_drvdata(&pdev->dev, NULL);
+
+	if (mmc) {
+		moxart_release_dma(host);
+		mmc_remove_host(mmc);
+		mmc_free_host(mmc);
+
+		writel(0, host->base + REG_INTERRUPT_MASK);
+		writel(0, host->base + REG_POWER_CONTROL);
+		writel(readl(host->base + REG_CLOCK_CONTROL) | MSD_CLK_DIS,
+		       host->base + REG_CLOCK_CONTROL);
+	}
+
+	kfree(host);
+
+	return 0;
+}
+
+static const struct of_device_id moxart_sdhci_match[] = {
+	{ .compatible = "moxa,moxart-sdhci" },
+	{ }
+};
+
+static struct platform_driver moxart_sdhci_driver = {
+	.probe      = moxart_probe,
+	.remove     = moxart_remove,
+	.driver     = {
+		.name		= "sdhci-moxart",
+		.owner		= THIS_MODULE,
+		.of_match_table	= moxart_sdhci_match,
+	},
+};
+module_platform_driver(moxart_sdhci_driver);
+
+MODULE_ALIAS("platform:sdhci-moxart");
+MODULE_DESCRIPTION("MOXART SDHCI driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
-- 
1.8.2.1

