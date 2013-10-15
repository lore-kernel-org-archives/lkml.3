Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3JOFLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:11:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45807 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3JOFLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:11:34 -0400
X-AuditID: cbfee690-b7fa36d00000744b-23-525cce84dc15
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, hs@denx.de
Cc: khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        sjg@chromium.org, naveenkrishna.ch@gmail.com, d.mueller@elsoft.ch,
        trini@ti.com, mk7.kang@samsung.com, cpgs@samsung.com
Subject: [PATCH 3/3 v6] i2c: s3c24xx: add hsi2c controller support
Date: Tue, 15 Oct 2013 10:43:35 +0530
Message-id: <1381814015-16088-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1380799488-14589-1-git-send-email-ch.naveen@samsung.com>
References: <1380799488-14589-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkVrflXEyQwY1JPBaT1h1gsnh5SNNi
	weFmZotXZzayWey4c5/ZovFvpEXH3y+MFpd3zWGzmHF+H5NFx5EWRotF2/4zW3zbso3RYvLi
	+cwOvB6zGy6yeMybdYLFo2nrI2aPv6teMHvsnHWX3eNKw0k2j74tqxg9fr7U8Th+YzuTx+dN
	cgFcUVw2Kak5mWWpRfp2CVwZj1/OYy7o3slYsezLCqYGxqsTGbsYOTkkBEwkrn5eC2WLSVy4
	t56ti5GLQ0hgKaPElkOz2WGKTrzdyQ6RmM4oMefbQRYIp4dJ4sWEm8wgVWwCZhIHF60G6xAR
	yJF4dXoVK0gRs8BhRonXXc+A5nJwCAs4Sbx+lwBSwyKgKrFn4kKwel4BV4mHby8zQWxTlOh+
	NoENxOYUcJP4+AAiLgRUc+v4B7ArJATesku829vLBjFIQOLb5EMsIPMlBGQlNh1ghpgjKXFw
	xQ2WCYzCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIERtXpf88m7GC8d8D6EGMy0LiJ
	zFKiyfnAqMwriTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUAyPvXjsFvVOrHMsPs5cu3Gy39ve/1J3rO8u/XNx1WK06rtf3+YVF2m4u99Jf3Yt+XfTs
	qP+FEvOr3wKn3G599/lvbnBnuL5zaY6+tFfOGkG/G39ens1vZTr6MymxqvykTPixpjr5tuI5
	jyI5vNWXMMoYnD+R/sT7pqp6Uvay8wW3VoebWy57EKPEUpyRaKjFXFScCAByMtMUwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoG7zuZggg2v3rS0mrTvAZPHykKbF
	gsPNzBavzmxks9hx5z6zRePfSIuOv18YLS7vmsNmMeP8PiaLjiMtjBaLtv1ntvi2ZRujxeTF
	85kdeD1mN1xk8Zg36wSLR9PWR8wef1e9YPbYOesuu8eVhpNsHn1bVjF6/Hyp43H8xnYmj8+b
	5AK4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	bldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZjx+OY+5oHsnY8WyLyuY
	GhivTmTsYuTkkBAwkTjxdic7hC0mceHeerYuRi4OIYHpjBJzvh1kgXB6mCReTLjJDFLFJmAm
	cXDRarAOEYEciVenV7GCFDELHGaUeN31DKidg0NYwEni9bsEkBoWAVWJPRMXgtXzCrhKPHx7
	mQlim6JE97MJbCA2p4CbxMcHEHEhoJpbxz+wT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjOGafSe9gXNVgcYhRgINRiYf3B29MkBBrYllxZe4hRgkOZiUR3pxqoBBvSmJlVWpR
	fnxRaU5q8SHGZKCrJjJLiSbnA9NJXkm8obGJuamxqaWJhYmZJWnCSuK8B1utA4UE0hNLUrNT
	UwtSi2C2MHFwSjUwth76Nv2dqKlOyF2uqZa3lxZL8F6acYX9phLPLWFHT+9zddKHpTc3ndxe
	G2oQeadDN3LbnHlugV+31EdUaj3XTz5wX7XLV+6Aa/aMjlflRktPG1VczlXM3hl3cWZ73seJ
	viukQ3W+1pwxlvHtDn8da9Xw9mjtylPGBq7mBSzCNROXCPGy7jZWYinOSDTUYi4qTgQA3FPK
	fB0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for hsi2c controller available on exynos5420.

Note: driver currently supports only fast speed mode 100kbps

Change-Id: I02555b1dc8f4ac21c50aa5158179768563c92f43
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: R. Chandrasekar <rc.sekar@samsung.com>
---
Changes since v5:
Fix compilation errors (undeclared CONFIG_MAX_I2C_NUM) for VCMA9 boards

 drivers/i2c/s3c24x0_i2c.c |  623 +++++++++++++++++++++++++++++++++++++++++----
 drivers/i2c/s3c24x0_i2c.h |   37 +++
 2 files changed, 610 insertions(+), 50 deletions(-)

diff --git a/drivers/i2c/s3c24x0_i2c.c b/drivers/i2c/s3c24x0_i2c.c
index 0e6f241..71f3637 100644
--- a/drivers/i2c/s3c24x0_i2c.c
+++ b/drivers/i2c/s3c24x0_i2c.c
@@ -34,6 +34,76 @@
 #define I2C_NOK_LA	3	/* Lost arbitration */
 #define I2C_NOK_TOUT	4	/* time out */
 
+/* HSI2C specific register description */
+
+/* I2C_CTL Register bits */
+#define HSI2C_FUNC_MODE_I2C		(1u << 0)
+#define HSI2C_MASTER			(1u << 3)
+#define HSI2C_RXCHON			(1u << 6)	/* Write/Send */
+#define HSI2C_TXCHON			(1u << 7)	/* Read/Receive */
+#define HSI2C_SW_RST			(1u << 31)
+
+/* I2C_FIFO_CTL Register bits */
+#define HSI2C_RXFIFO_EN			(1u << 0)
+#define HSI2C_TXFIFO_EN			(1u << 1)
+#define HSI2C_TXFIFO_TRIGGER_LEVEL	(0x20 << 16)
+#define HSI2C_RXFIFO_TRIGGER_LEVEL	(0x20 << 4)
+
+/* I2C_TRAILING_CTL Register bits */
+#define HSI2C_TRAILING_COUNT		(0xff)
+
+/* I2C_INT_EN Register bits */
+#define HSI2C_TX_UNDERRUN_EN		(1u << 2)
+#define HSI2C_TX_OVERRUN_EN		(1u << 3)
+#define HSI2C_RX_UNDERRUN_EN		(1u << 4)
+#define HSI2C_RX_OVERRUN_EN		(1u << 5)
+#define HSI2C_INT_TRAILING_EN		(1u << 6)
+#define HSI2C_INT_I2C_EN		(1u << 9)
+
+#define HSI2C_INT_ERROR_MASK	(HSI2C_TX_UNDERRUN_EN |\
+				 HSI2C_TX_OVERRUN_EN  |\
+				 HSI2C_RX_UNDERRUN_EN |\
+				 HSI2C_RX_OVERRUN_EN  |\
+				 HSI2C_INT_TRAILING_EN)
+
+/* I2C_CONF Register bits */
+#define HSI2C_AUTO_MODE			(1u << 31)
+#define HSI2C_10BIT_ADDR_MODE		(1u << 30)
+#define HSI2C_HS_MODE			(1u << 29)
+
+/* I2C_AUTO_CONF Register bits */
+#define HSI2C_READ_WRITE		(1u << 16)
+#define HSI2C_STOP_AFTER_TRANS		(1u << 17)
+#define HSI2C_MASTER_RUN		(1u << 31)
+
+/* I2C_TIMEOUT Register bits */
+#define HSI2C_TIMEOUT_EN		(1u << 31)
+
+/* I2C_TRANS_STATUS register bits */
+#define HSI2C_MASTER_BUSY		(1u << 17)
+#define HSI2C_SLAVE_BUSY		(1u << 16)
+#define HSI2C_TIMEOUT_AUTO		(1u << 4)
+#define HSI2C_NO_DEV			(1u << 3)
+#define HSI2C_NO_DEV_ACK		(1u << 2)
+#define HSI2C_TRANS_ABORT		(1u << 1)
+#define HSI2C_TRANS_SUCCESS		(1u << 0)
+#define HSI2C_TRANS_ERROR_MASK	(HSI2C_TIMEOUT_AUTO |\
+				 HSI2C_NO_DEV | HSI2C_NO_DEV_ACK |\
+				 HSI2C_TRANS_ABORT)
+#define HSI2C_TRANS_FINISHED_MASK (HSI2C_TRANS_ERROR_MASK | HSI2C_TRANS_SUCCESS)
+
+
+/* I2C_FIFO_STAT Register bits */
+#define HSI2C_RX_FIFO_EMPTY		(1u << 24)
+#define HSI2C_RX_FIFO_FULL		(1u << 23)
+#define HSI2C_TX_FIFO_EMPTY		(1u << 8)
+#define HSI2C_TX_FIFO_FULL		(1u << 7)
+#define HSI2C_RX_FIFO_LEVEL(x)		(((x) >> 16) & 0x7f)
+#define HSI2C_TX_FIFO_LEVEL(x)		((x) & 0x7f)
+
+#define HSI2C_SLV_ADDR_MAS(x)		((x & 0x3ff) << 10)
+
+/* S3C I2C Controller bits */
 #define I2CSTAT_BSY	0x20	/* Busy bit */
 #define I2CSTAT_NACK	0x01	/* Nack bit */
 #define I2CCON_ACKGEN	0x80	/* Acknowledge generation */
@@ -45,16 +115,41 @@
 
 #define I2C_TIMEOUT_MS 1000		/* 1 second */
 
+#define	HSI2C_TIMEOUT_US 100000 /* 100 ms, finer granularity */
+
+
+/* To support VCMA9 boards and other who dont define max_i2c_num */
+#ifndef CONFIG_MAX_I2C_NUM
+#define CONFIG_MAX_I2C_NUM 1
+#endif
 
 /*
  * For SPL boot some boards need i2c before SDRAM is initialised so force
  * variables to live in SRAM
  */
 static unsigned int g_current_bus __attribute__((section(".data")));
-#ifdef CONFIG_OF_CONTROL
 static struct s3c24x0_i2c_bus i2c_bus[CONFIG_MAX_I2C_NUM]
 			__attribute__((section(".data")));
-#endif
+
+/**
+ * Get a pointer to the given bus index
+ *
+ * @bus_idx: Bus index to look up
+ * @return pointer to bus, or NULL if invalid or not available
+ */
+static struct s3c24x0_i2c_bus *get_bus(unsigned int bus_idx)
+{
+	if (bus_idx < ARRAY_SIZE(i2c_bus)) {
+		struct s3c24x0_i2c_bus *bus;
+
+		bus = &i2c_bus[bus_idx];
+		if (bus->active)
+			return bus;
+	}
+
+	debug("Undefined bus: %d\n", bus_idx);
+	return NULL;
+}
 
 #if !(defined CONFIG_EXYNOS4 || defined CONFIG_EXYNOS5)
 static int GetI2CSDA(void)
@@ -105,6 +200,55 @@ static int WaitForXfer(struct s3c24x0_i2c *i2c)
 	return I2C_NOK_TOUT;
 }
 
+/*
+ * Wait for transfer completion.
+ *
+ * This function reads the interrupt status register waiting for the INT_I2C
+ * bit to be set, which indicates copletion of a transaction.
+ *
+ * @param i2c: pointer to the appropriate register bank
+ *
+ * @return: I2C_OK in case of successful completion, I2C_NOK_TIMEOUT in case
+ *          the status bits do not get set in time, or an approrpiate error
+ *          value in case of transfer errors.
+ */
+static int hsi2c_wait_for_trx(struct exynos5_hsi2c *i2c)
+{
+	int i = HSI2C_TIMEOUT_US;
+
+	while (i-- > 0) {
+		u32 int_status = readl(&i2c->usi_int_stat);
+
+		if (int_status & HSI2C_INT_I2C_EN) {
+			u32 trans_status = readl(&i2c->usi_trans_status);
+
+			/* Deassert pending interrupt. */
+			writel(int_status, &i2c->usi_int_stat);
+
+			if (trans_status & HSI2C_NO_DEV_ACK) {
+				debug("%s: no ACK from device\n", __func__);
+				return I2C_NACK;
+			}
+			if (trans_status & HSI2C_NO_DEV) {
+				debug("%s: no device\n", __func__);
+				return I2C_NOK;
+			}
+			if (trans_status & HSI2C_TRANS_ABORT) {
+				debug("%s: arbitration lost\n", __func__);
+				return I2C_NOK_LA;
+			}
+			if (trans_status & HSI2C_TIMEOUT_AUTO) {
+				debug("%s: device timed out\n", __func__);
+				return I2C_NOK_TOUT;
+			}
+			return I2C_OK;
+		}
+		udelay(1);
+	}
+	debug("%s: transaction timeout!\n", __func__);
+	return I2C_NOK_TOUT;
+}
+
 static void ReadWriteByte(struct s3c24x0_i2c *i2c)
 {
 	writel(readl(&i2c->iiccon) & ~I2CCON_IRPND, &i2c->iiccon);
@@ -154,6 +298,107 @@ static void i2c_ch_init(struct s3c24x0_i2c *i2c, int speed, int slaveadd)
 	writel(I2C_MODE_MT | I2C_TXRX_ENA, &i2c->iicstat);
 }
 
+static int hsi2c_get_clk_details(struct s3c24x0_i2c_bus *i2c_bus)
+{
+	struct exynos5_hsi2c *hsregs = i2c_bus->hsregs;
+	ulong clkin;
+	unsigned int op_clk = i2c_bus->clock_frequency;
+	unsigned int i = 0, utemp0 = 0, utemp1 = 0;
+	unsigned int t_ftl_cycle;
+
+#if defined CONFIG_EXYNOS5
+	clkin = get_i2c_clk();
+#endif
+	/* FPCLK / FI2C =
+	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
+	 * uTemp0 = (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
+	 * uTemp1 = (TSCLK_L + TSCLK_H + 2)
+	 * uTemp2 = TSCLK_L + TSCLK_H
+	 */
+	t_ftl_cycle = (readl(&hsregs->usi_conf) >> 16) & 0x7;
+	utemp0 = (clkin / op_clk) - 8 - 2 * t_ftl_cycle;
+
+	/* CLK_DIV max is 256 */
+	for (i = 0; i < 256; i++) {
+		utemp1 = utemp0 / (i + 1);
+		if ((utemp1 < 512) && (utemp1 > 4)) {
+			i2c_bus->clk_cycle = utemp1 - 2;
+			i2c_bus->clk_div = i;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+static void hsi2c_ch_init(struct s3c24x0_i2c_bus *i2c_bus)
+{
+	struct exynos5_hsi2c *hsregs = i2c_bus->hsregs;
+	unsigned int t_sr_release;
+	unsigned int n_clkdiv;
+	unsigned int t_start_su, t_start_hd;
+	unsigned int t_stop_su;
+	unsigned int t_data_su, t_data_hd;
+	unsigned int t_scl_l, t_scl_h;
+	u32 i2c_timing_s1;
+	u32 i2c_timing_s2;
+	u32 i2c_timing_s3;
+	u32 i2c_timing_sla;
+
+	n_clkdiv = i2c_bus->clk_div;
+	t_scl_l = i2c_bus->clk_cycle / 2;
+	t_scl_h = i2c_bus->clk_cycle / 2;
+	t_start_su = t_scl_l;
+	t_start_hd = t_scl_l;
+	t_stop_su = t_scl_l;
+	t_data_su = t_scl_l / 2;
+	t_data_hd = t_scl_l / 2;
+	t_sr_release = i2c_bus->clk_cycle;
+
+	i2c_timing_s1 = t_start_su << 24 | t_start_hd << 16 | t_stop_su << 8;
+	i2c_timing_s2 = t_data_su << 24 | t_scl_l << 8 | t_scl_h << 0;
+	i2c_timing_s3 = n_clkdiv << 16 | t_sr_release << 0;
+	i2c_timing_sla = t_data_hd << 0;
+
+	writel(HSI2C_TRAILING_COUNT, &hsregs->usi_trailing_ctl);
+
+	/* Clear to enable Timeout */
+	clrsetbits_le32(&hsregs->usi_timeout, HSI2C_TIMEOUT_EN, 0);
+
+	/* set AUTO mode */
+	writel(readl(&hsregs->usi_conf) | HSI2C_AUTO_MODE, &hsregs->usi_conf);
+
+	/* Enable completion conditions' reporting. */
+	writel(HSI2C_INT_I2C_EN, &hsregs->usi_int_en);
+
+	/* Enable FIFOs */
+	writel(HSI2C_RXFIFO_EN | HSI2C_TXFIFO_EN, &hsregs->usi_fifo_ctl);
+
+	/* Currently operating in Fast speed mode. */
+	writel(i2c_timing_s1, &hsregs->usi_timing_fs1);
+	writel(i2c_timing_s2, &hsregs->usi_timing_fs2);
+	writel(i2c_timing_s3, &hsregs->usi_timing_fs3);
+	writel(i2c_timing_sla, &hsregs->usi_timing_sla);
+}
+
+/* SW reset for the high speed bus */
+static void exynos5_i2c_reset(struct s3c24x0_i2c_bus *i2c_bus)
+{
+	struct exynos5_hsi2c *i2c = i2c_bus->hsregs;
+	u32 i2c_ctl;
+
+	/* Set and clear the bit for reset */
+	i2c_ctl = readl(&i2c->usi_ctl);
+	i2c_ctl |= HSI2C_SW_RST;
+	writel(i2c_ctl, &i2c->usi_ctl);
+
+	i2c_ctl = readl(&i2c->usi_ctl);
+	i2c_ctl &= ~HSI2C_SW_RST;
+	writel(i2c_ctl, &i2c->usi_ctl);
+
+	/* Initialize the configure registers */
+	hsi2c_ch_init(i2c_bus);
+}
+
 /*
  * MULTI BUS I2C support
  */
@@ -161,16 +406,21 @@ static void i2c_ch_init(struct s3c24x0_i2c *i2c, int speed, int slaveadd)
 #ifdef CONFIG_I2C_MULTI_BUS
 int i2c_set_bus_num(unsigned int bus)
 {
-	struct s3c24x0_i2c *i2c;
+	struct s3c24x0_i2c_bus *i2c_bus;
 
 	i2c_bus = get_bus(bus);
 	if (!i2c_bus)
 		return -1;
-	}
-
 	g_current_bus = bus;
-	i2c = get_base_i2c();
-	i2c_ch_init(i2c, CONFIG_SYS_I2C_SPEED, CONFIG_SYS_I2C_SLAVE);
+
+	if (i2c_bus->is_highspeed) {
+		if (hsi2c_get_clk_details(i2c_bus))
+			return -1;
+		hsi2c_ch_init(i2c_bus);
+	} else {
+		i2c_ch_init(i2c_bus->regs, i2c_bus->clock_frequency,
+						CONFIG_SYS_I2C_SLAVE);
+	}
 
 	return 0;
 }
@@ -255,6 +505,227 @@ void i2c_init(int speed, int slaveadd)
 }
 
 /*
+ * Poll the appropriate bit of the fifo status register until the interface is
+ * ready to process the next byte or timeout expires.
+ *
+ * In addition to the FIFO status register this function also polls the
+ * interrupt status register to be able to detect unexpected transaction
+ * completion.
+ *
+ * When FIFO is ready to process the next byte, this function returns I2C_OK.
+ * If in course of polling the INT_I2C assertion is detected, the function
+ * returns I2C_NOK. If timeout happens before any of the above conditions is
+ * met - the function returns I2C_NOK_TOUT;
+
+ * @param i2c: pointer to the appropriate i2c register bank.
+ * @param rx_transfer: set to True if the receive transaction is in progress.
+ * @return: as described above.
+ */
+static unsigned hsi2c_poll_fifo(struct exynos5_hsi2c *i2c, bool rx_transfer)
+{
+	u32 fifo_bit = rx_transfer ? HSI2C_RX_FIFO_EMPTY : HSI2C_TX_FIFO_FULL;
+	int i = HSI2C_TIMEOUT_US;
+
+	while (readl(&i2c->usi_fifo_stat) & fifo_bit) {
+		if (readl(&i2c->usi_int_stat) & HSI2C_INT_I2C_EN) {
+			/*
+			 * There is a chance that assertion of
+			 * HSI2C_INT_I2C_EN and deassertion of
+			 * HSI2C_RX_FIFO_EMPTY happen simultaneously. Let's
+			 * give FIFO status priority and check it one more
+			 * time before reporting interrupt. The interrupt will
+			 * be reported next time this function is called.
+			 */
+			if (rx_transfer &&
+			    !(readl(&i2c->usi_fifo_stat) & fifo_bit))
+				break;
+			return I2C_NOK;
+		}
+		if (!i--) {
+			debug("%s: FIFO polling timeout!\n", __func__);
+			return I2C_NOK_TOUT;
+		}
+		udelay(1);
+	}
+	return I2C_OK;
+}
+
+/*
+ * Preapre hsi2c transaction, either read or write.
+ *
+ * Set up transfer as described in section 27.5.1.2 'I2C Channel Auto Mode' of
+ * the 5420 UM.
+ *
+ * @param i2c: pointer to the appropriate i2c register bank.
+ * @param chip: slave address on the i2c bus (with read/write bit exlcuded)
+ * @param len: number of bytes expected to be sent or received
+ * @param rx_transfer: set to true for receive transactions
+ * @param: issue_stop: set to true if i2c stop condition should be generated
+ *         after this transaction.
+ * @return: I2C_NOK_TOUT in case the bus remained busy for HSI2C_TIMEOUT_US,
+ *          I2C_OK otherwise.
+ */
+static int hsi2c_prepare_transaction(struct exynos5_hsi2c *i2c,
+				     u8 chip,
+				     u16 len,
+				     bool rx_transfer,
+				     bool issue_stop)
+{
+	u32 conf;
+
+	conf = len | HSI2C_MASTER_RUN;
+
+	if (issue_stop)
+		conf |= HSI2C_STOP_AFTER_TRANS;
+
+	/* Clear to enable Timeout */
+	writel(readl(&i2c->usi_timeout) & ~HSI2C_TIMEOUT_EN, &i2c->usi_timeout);
+
+	/* Set slave address */
+	writel(HSI2C_SLV_ADDR_MAS(chip), &i2c->i2c_addr);
+
+	if (rx_transfer) {
+		/* i2c master, read transaction */
+		writel((HSI2C_RXCHON | HSI2C_FUNC_MODE_I2C | HSI2C_MASTER),
+		       &i2c->usi_ctl);
+
+		/* read up to len bytes, stop after transaction is finished */
+		writel(conf | HSI2C_READ_WRITE, &i2c->usi_auto_conf);
+	} else {
+		/* i2c master, write transaction */
+		writel((HSI2C_TXCHON | HSI2C_FUNC_MODE_I2C | HSI2C_MASTER),
+		       &i2c->usi_ctl);
+
+		/* write up to len bytes, stop after transaction is finished */
+		writel(conf, &i2c->usi_auto_conf);
+	}
+
+	/* Reset all pending interrupt status bits we care about, if any */
+	writel(HSI2C_INT_I2C_EN, &i2c->usi_int_stat);
+
+	return I2C_OK;
+}
+
+/*
+ * Wait while i2c bus is settling down (mostly stop gets completed).
+ */
+static int hsi2c_wait_while_busy(struct exynos5_hsi2c *i2c)
+{
+	int i = HSI2C_TIMEOUT_US;
+
+	while (readl(&i2c->usi_trans_status) & HSI2C_MASTER_BUSY) {
+		if (!i--) {
+			debug("%s: bus busy\n", __func__);
+			return I2C_NOK_TOUT;
+		}
+		udelay(1);
+	}
+	return I2C_OK;
+}
+
+static int hsi2c_write(struct exynos5_hsi2c *i2c,
+		       unsigned char chip,
+		       unsigned char addr[],
+		       unsigned char alen,
+		       unsigned char data[],
+		       unsigned short len,
+		       bool issue_stop)
+{
+	int i, rv = 0;
+
+	if (!(len + alen)) {
+		/* Writes of zero length not supported in auto mode. */
+		debug("%s: zero length writes not supported\n", __func__);
+		return I2C_NOK;
+	}
+
+	rv = hsi2c_prepare_transaction
+		(i2c, chip, len + alen, false, issue_stop);
+	if (rv != I2C_OK)
+		return rv;
+
+	/* Move address, if any, and the data, if any, into the FIFO. */
+	for (i = 0; i < alen; i++) {
+		rv = hsi2c_poll_fifo(i2c, false);
+		if (rv != I2C_OK) {
+			debug("%s: address write failed\n", __func__);
+			goto write_error;
+		}
+		writel(addr[i], &i2c->usi_txdata);
+	}
+
+	for (i = 0; i < len; i++) {
+		rv = hsi2c_poll_fifo(i2c, false);
+		if (rv != I2C_OK) {
+			debug("%s: data write failed\n", __func__);
+			goto write_error;
+		}
+		writel(data[i], &i2c->usi_txdata);
+	}
+
+	rv = hsi2c_wait_for_trx(i2c);
+
+ write_error:
+	if (issue_stop) {
+		int tmp_ret = hsi2c_wait_while_busy(i2c);
+		if (rv == I2C_OK)
+			rv = tmp_ret;
+	}
+
+	writel(HSI2C_FUNC_MODE_I2C, &i2c->usi_ctl); /* done */
+	return rv;
+}
+
+static int hsi2c_read(struct exynos5_hsi2c *i2c,
+		      unsigned char chip,
+		      unsigned char addr[],
+		      unsigned char alen,
+		      unsigned char data[],
+		      unsigned short len)
+{
+	int i, rv, tmp_ret;
+	bool drop_data = false;
+
+	if (!len) {
+		/* Reads of zero length not supported in auto mode. */
+		debug("%s: zero length read adjusted\n", __func__);
+		drop_data = true;
+		len = 1;
+	}
+
+	if (alen) {
+		/* Internal register adress needs to be written first. */
+		rv = hsi2c_write(i2c, chip, addr, alen, NULL, 0, false);
+		if (rv != I2C_OK)
+			return rv;
+	}
+
+	rv = hsi2c_prepare_transaction(i2c, chip, len, true, true);
+
+	if (rv != I2C_OK)
+		return rv;
+
+	for (i = 0; i < len; i++) {
+		rv = hsi2c_poll_fifo(i2c, true);
+		if (rv != I2C_OK)
+			goto read_err;
+		if (drop_data)
+			continue;
+		data[i] = readl(&i2c->usi_rxdata);
+	}
+
+	rv = hsi2c_wait_for_trx(i2c);
+
+ read_err:
+	tmp_ret = hsi2c_wait_while_busy(i2c);
+	if (rv == I2C_OK)
+		rv = tmp_ret;
+
+	writel(HSI2C_FUNC_MODE_I2C, &i2c->usi_ctl); /* done */
+	return rv;
+}
+
+/*
  * cmd_type is 0 for write, 1 for read.
  *
  * addr_len can take any value from 0-255, it is only limited
@@ -368,10 +839,13 @@ bailout:
 
 int i2c_probe(uchar chip)
 {
-	struct s3c24x0_i2c *i2c;
+	struct s3c24x0_i2c_bus *i2c_bus;
 	uchar buf[1];
+	int ret;
 
-	i2c = get_base_i2c();
+	i2c_bus = get_bus(g_current_bus);
+	if (!i2c_bus)
+		return -1;
 	buf[0] = 0;
 
 	/*
@@ -379,12 +853,21 @@ int i2c_probe(uchar chip)
 	 * address was <ACK>ed (i.e. there was a chip at that address which
 	 * drove the data line low).
 	 */
-	return i2c_transfer(i2c, I2C_READ, chip << 1, 0, 0, buf, 1) != I2C_OK;
+	if (i2c_bus->is_highspeed) {
+		ret = hsi2c_read(i2c_bus->hsregs,
+				chip, 0, 0, buf, 1);
+	} else {
+		ret = i2c_transfer(i2c_bus->regs,
+				I2C_READ, chip << 1, 0, 0, buf, 1);
+	}
+
+
+	return ret != I2C_OK;
 }
 
 int i2c_read(uchar chip, uint addr, int alen, uchar *buffer, int len)
 {
-	struct s3c24x0_i2c *i2c;
+	struct s3c24x0_i2c_bus *i2c_bus;
 	uchar xaddr[4];
 	int ret;
 
@@ -416,11 +899,21 @@ int i2c_read(uchar chip, uint addr, int alen, uchar *buffer, int len)
 		chip |= ((addr >> (alen * 8)) &
 			 CONFIG_SYS_I2C_EEPROM_ADDR_OVERFLOW);
 #endif
-	i2c = get_base_i2c();
-	ret = i2c_transfer(i2c, I2C_READ, chip << 1, &xaddr[4 - alen], alen,
-			buffer, len);
-	if (ret != 0) {
-		debug("I2c read: failed %d\n", ret);
+	i2c_bus = get_bus(g_current_bus);
+	if (!i2c_bus)
+		return -1;
+
+	if (i2c_bus->is_highspeed)
+		ret = hsi2c_read(i2c_bus->hsregs, chip, &xaddr[4 - alen],
+				 alen, buffer, len);
+	else
+		ret = i2c_transfer(i2c_bus->regs, I2C_READ, chip << 1,
+				&xaddr[4 - alen], alen, buffer, len);
+
+	if (ret) {
+		if (i2c_bus->is_highspeed)
+			exynos5_i2c_reset(i2c_bus);
+		debug("I2c read failed %d\n", ret);
 		return 1;
 	}
 	return 0;
@@ -428,8 +921,9 @@ int i2c_read(uchar chip, uint addr, int alen, uchar *buffer, int len)
 
 int i2c_write(uchar chip, uint addr, int alen, uchar *buffer, int len)
 {
-	struct s3c24x0_i2c *i2c;
+	struct s3c24x0_i2c_bus *i2c_bus;
 	uchar xaddr[4];
+	int ret;
 
 	if (alen > 4) {
 		debug("I2C write: addr len %d not supported\n", alen);
@@ -458,58 +952,80 @@ int i2c_write(uchar chip, uint addr, int alen, uchar *buffer, int len)
 		chip |= ((addr >> (alen * 8)) &
 			 CONFIG_SYS_I2C_EEPROM_ADDR_OVERFLOW);
 #endif
-	i2c = get_base_i2c();
-	return (i2c_transfer
-		(i2c, I2C_WRITE, chip << 1, &xaddr[4 - alen], alen, buffer,
-		 len) != 0);
+	i2c_bus = get_bus(g_current_bus);
+	if (!i2c_bus)
+		return -1;
+
+	if (i2c_bus->is_highspeed)
+		ret = hsi2c_write(i2c_bus->hsregs, chip, &xaddr[4 - alen],
+				  alen, buffer, len, true);
+	else
+		ret = i2c_transfer(i2c_bus->regs, I2C_WRITE, chip << 1,
+				&xaddr[4 - alen], alen, buffer, len);
+
+	if (ret != 0) {
+		if (i2c_bus->is_highspeed)
+			exynos5_i2c_reset(i2c_bus);
+		return 1;
+	} else {
+		return 0;
+	}
 }
 
 #ifdef CONFIG_OF_CONTROL
-void board_i2c_init(const void *blob)
+static void process_nodes(const void *blob, int node_list[], int count,
+			 int is_highspeed)
 {
+	struct s3c24x0_i2c_bus *bus;
 	int i;
-	int node_list[CONFIG_MAX_I2C_NUM];
-	int count;
-
-	count = fdtdec_find_aliases_for_id(blob, "i2c",
-		COMPAT_SAMSUNG_S3C2440_I2C, node_list,
-		CONFIG_MAX_I2C_NUM);
 
 	for (i = 0; i < count; i++) {
-		struct s3c24x0_i2c_bus *bus;
 		int node = node_list[i];
 
 		if (node <= 0)
 			continue;
+
 		bus = &i2c_bus[i];
 		bus->active = true;
-		bus->regs = (struct s3c24x0_i2c *)
-			fdtdec_get_addr(blob, node, "reg");
+		bus->is_highspeed = is_highspeed;
+
+		if (is_highspeed)
+			bus->hsregs = (struct exynos5_hsi2c *)
+					fdtdec_get_addr(blob, node, "reg");
+		else
+			bus->regs = (struct s3c24x0_i2c *)
+					fdtdec_get_addr(blob, node, "reg");
+
 		bus->id = pinmux_decode_periph_id(blob, node);
+		bus->clock_frequency = fdtdec_get_int(blob, node,
+						      "clock-frequency",
+						      CONFIG_SYS_I2C_SPEED);
 		bus->node = node;
 		bus->bus_num = i;
 		exynos_pinmux_config(bus->id, 0);
+
+		/* Mark position as used */
+		node_list[i] = -1;
 	}
 }
 
-/**
- * Get a pointer to the given bus index
- *
- * @bus_idx: Bus index to look up
- * @return pointer to bus, or NULL if invalid or not available
- */
-static struct s3c24x0_i2c_bus *get_bus(unsigned int bus_idx)
+void board_i2c_init(const void *blob)
 {
-	if (bus_idx < ARRAY_SIZE(i2c_bus)) {
-		struct s3c24x0_i2c_bus *bus;
+	int node_list[CONFIG_MAX_I2C_NUM];
+	int count;
 
-		bus = &i2c_bus[bus_idx];
-		if (bus->active)
-			return bus;
-	}
+	/* First get the normal i2c ports */
+	count = fdtdec_find_aliases_for_id(blob, "i2c",
+		COMPAT_SAMSUNG_S3C2440_I2C, node_list,
+		CONFIG_MAX_I2C_NUM);
+	process_nodes(blob, node_list, count, 0);
+
+	/* Now look for high speed i2c ports */
+	count = fdtdec_find_aliases_for_id(blob, "i2c",
+		COMPAT_SAMSUNG_EXYNOS5_I2C, node_list,
+		CONFIG_MAX_I2C_NUM);
+	process_nodes(blob, node_list, count, 1);
 
-	debug("Undefined bus: %d\n", bus_idx);
-	return NULL;
 }
 
 int i2c_get_bus_num_fdt(int node)
@@ -527,7 +1043,7 @@ int i2c_get_bus_num_fdt(int node)
 
 int i2c_reset_port_fdt(const void *blob, int node)
 {
-	struct s3c24x0_i2c_bus *i2c;
+	struct s3c24x0_i2c_bus *i2c_bus;
 	int bus;
 
 	bus = i2c_get_bus_num_fdt(node);
@@ -536,13 +1052,20 @@ int i2c_reset_port_fdt(const void *blob, int node)
 		return -1;
 	}
 
-	i2c = get_bus(bus);
-	if (!i2c) {
+	i2c_bus = get_bus(bus);
+	if (!i2c_bus) {
 		debug("get_bus() failed for node node %d\n", node);
 		return -1;
 	}
 
-	i2c_ch_init(i2c->regs, CONFIG_SYS_I2C_SPEED, CONFIG_SYS_I2C_SLAVE);
+	if (i2c_bus->is_highspeed) {
+		if (hsi2c_get_clk_details(i2c_bus))
+			return -1;
+		hsi2c_ch_init(i2c_bus);
+	} else {
+		i2c_ch_init(i2c_bus->regs, i2c_bus->clock_frequency,
+						CONFIG_SYS_I2C_SLAVE);
+	}
 
 	return 0;
 }
diff --git a/drivers/i2c/s3c24x0_i2c.h b/drivers/i2c/s3c24x0_i2c.h
index 882af62..1ae73d2 100644
--- a/drivers/i2c/s3c24x0_i2c.h
+++ b/drivers/i2c/s3c24x0_i2c.h
@@ -15,11 +15,48 @@ struct s3c24x0_i2c {
 	u32	iiclc;
 };
 
+struct exynos5_hsi2c {
+	u32	usi_ctl;
+	u32	usi_fifo_ctl;
+	u32	usi_trailing_ctl;
+	u32	usi_clk_ctl;
+	u32	usi_clk_slot;
+	u32	spi_ctl;
+	u32	uart_ctl;
+	u32	res1;
+	u32	usi_int_en;
+	u32	usi_int_stat;
+	u32	usi_modem_stat;
+	u32	usi_error_stat;
+	u32	usi_fifo_stat;
+	u32	usi_txdata;
+	u32	usi_rxdata;
+	u32	res2;
+	u32	usi_conf;
+	u32	usi_auto_conf;
+	u32	usi_timeout;
+	u32	usi_manual_cmd;
+	u32	usi_trans_status;
+	u32	usi_timing_hs1;
+	u32	usi_timing_hs2;
+	u32	usi_timing_hs3;
+	u32	usi_timing_fs1;
+	u32	usi_timing_fs2;
+	u32	usi_timing_fs3;
+	u32	usi_timing_sla;
+	u32	i2c_addr;
+};
+
 struct s3c24x0_i2c_bus {
 	bool active;	/* port is active and available */
 	int node;	/* device tree node */
 	int bus_num;	/* i2c bus number */
 	struct s3c24x0_i2c *regs;
+	struct exynos5_hsi2c *hsregs;
+	int is_highspeed;	/* High speed type, rather than I2C */
+	unsigned clock_frequency;
 	int id;
+	unsigned clk_cycle;
+	unsigned clk_div;
 };
 #endif /* _S3C24X0_I2C_H */
-- 
1.7.10.4

