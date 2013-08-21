Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3HUJaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:30:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37432 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3HUJaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:30:09 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b1-5214889f6789
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, t.figa@samsung.com, ben-linux@fluff.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sjg@chromium.org, naveenkrishna.ch@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH] i2c: exynos5: add High Speed I2C controller driver
Date: Wed, 21 Aug 2013 14:54:37 +0530
Message-id: <1377077077-20896-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkWnd+h0iQwablBhaT1h1gsvg3+xSb
	xYHZD1ktXp3ZyGbR8fcLo8XlXXPYLGac38dksWjbf2aLb1u2MVqsn/GaxWLf663MDtwesxsu
	snj8XfWC2WPnrLvsHudnLGT0eDnxN5tH/18Dj74tqxg9fr7U8fi8SS6AM4rLJiU1J7MstUjf
	LoEro+3hTOaC57cZK2ZdesHWwDhtI2MXIweHhICJRNup1C5GTiBTTOLCvfVsXYxcHEICSxkl
	Np/9yAyRMJE4sWM+O0RiOqPEx8aXTBBOD5NE+6UzbCBVbAJmEgcXrWYHsUUEEiQ6J51iArGZ
	BW4zSrx4lgNiCws4S/T+nQu2mUVAVWLeSSGQMK+Aq8Sv/7NYIA5SkJgzyQbE5BRwk1h0uRyk
	Qgio4v7fRcwgWyUEbrFLtP/cyAKSYBEQkPg2+RBUq6zEpgNQJ0tKHFxxg2UCo/ACRoZVjKKp
	BckFxUnpRSZ6xYm5xaV56XrJ+bmbGIERc/rfswk7GO8dsD7EmAw0biKzlGhyPjDi8kriDY3N
	jCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWM79gKuxPv+F
	p13t49jYJVnnuY42XmRac/lFi4TUvN42Xe5ZYsUdIhUnf3M7MIgyZbIo7FhndaatZNKaS2UX
	slLPB00P22Z/KNqrqftP9dbni0Xe3f255vKs57uLqraa3hG+snSP0Iqftdfuep7dXpoZd5ft
	6tFzunbHS0IZZsdmbFx7V6xsnxJLcUaioRZzUXEiAGVO35auAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd35HSJBBv/3K1lMWneAyeLf7FNs
	FgdmP2S1eHVmI5tFx98vjBaXd81hs5hxfh+TxaJt/5ktvm3ZxmixfsZrFot9r7cyO3B7zG64
	yOLxd9ULZo+ds+6ye5yfsZDR4+XE32we/X8NPPq2rGL0+PlSx+PzJrkAzqgGRpuM1MSU1CKF
	1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoGuVFMoSc0qBQgGJxcVK
	+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBltD2cyFzy/zVgx69ILtgbGaRsZuxg5OSQETCRO
	7JjPDmGLSVy4t56ti5GLQ0hgOqPEx8aXTBBOD5NE+6UzbCBVbAJmEgcXrQbrEBFIkOicdIoJ
	xGYWuM0o8eJZDogtLOAs0ft3LtAGDg4WAVWJeSeFQMK8Aq4Sv/7PYgEJSwgoSMyZZANicgq4
	SSy6XA5SIQRUcf/vIuYJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH5DOpHYwr
	GywOMQpwMCrx8F5QFgkSYk0sK67MPcQowcGsJMK7qBooxJuSWFmVWpQfX1Sak1p8iDEZ6KSJ
	zFKiyfnAZJFXEm9obGJuamxqaWJhYmZJmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwZ
	0+Pfhm2L1Qz8pV65QPanVdIBxUPy7iGrI8Ke3+afI3xp/fS4nVITlf/31LMWsH4UK+Mz3lXG
	c8yjPLro2/p964Vm8x1c7beSu2d+SrbJnBV9m5e9LPv9n0du3dnofqm8SSri734t/mD7ILAq
	3Guf5Iv3uszpHh8mL1d9Py96+t/Ju4ScecKVWIozEg21mIuKEwENp3SODAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for High Speed I2C driver found in Exynos5 and
later SoCs from Samsung.

Highspeed mode is a minor change in the i2c protocol.
Starts with
1. start condition,
2. 8-bit master ID code (00001xxx)
3. followed by a NACK bit
Once the above conditions are met, the bus is now operates in highspeed mode.
The rest of the I2C protocol applies the same.

Driver only supports Device Tree method.

Changes since v1:
1. Added FIFO functionality
2. Added High speed mode functionality
3. Remove SMBUS_QUICK
4. Remove the debugfs functionality
5. Use devm_* functions where ever possible
6. Driver is free from GPIO configs
7. Use OF data string "clock-frequency" to get the bus operating frequencies
8. Split the clock divisor calculation function
9. Add resets for the failed transacton cases
10. Removed retries as core does retries if -EAGAIN is returned
11. Removed mode from device tree info (use speed to distinguish
    the mode of operation)
12. Use wait_for_completion_timeout as the interruptible case is not tested well
13. few other bug fixes and cosmetic changes
14. Removed the untested runtime_pm code
15. Removed the retries as core does that
16. Use adap.nr instead of alias
17. Added spinlocks around the irq code
18. Use i2c_add_numbered_adapter() instead of using aliases

Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Simon Glass <sjg@google.com>
Tested-by: Andrew Bresticker <abrestic@google.com>
Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Signed-off-by: Andrew Bresticker <abrestic@google.com>
---

Wolfram and Thomas Figa thanks for reviewing the code.

Changes since v10:
1. Remove the incomplete runtime_pm code
2. Correct the error checks as suggested by Thomas
3. Use i2c_add_numbered_adapter() as suggested
4. Modified the irq routine to handle the specific interrupts
5. Added spinlocks around the irq code
6. Remove the "mode" of operation field from device tree node and use the
   clock-frequency to decide the mode.

 .../devicetree/bindings/i2c/i2c-exynos5.txt        |   44 ++
 drivers/i2c/busses/Kconfig                         |    7 +
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-exynos5.c                   |  799 ++++++++++++++++++++
 4 files changed, 851 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
 create mode 100644 drivers/i2c/busses/i2c-exynos5.c

diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
new file mode 100644
index 0000000..805e018
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
@@ -0,0 +1,44 @@
+* Samsung's High Speed I2C controller
+
+The Samsung's High Speed I2C controller is used to interface with I2C devices
+at various speeds ranging from 100khz to 3.4Mhz.
+
+Required properties:
+  - compatible: value should be.
+      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
+  - reg: physical base address of the controller and length of memory mapped
+    region.
+  - interrupts: interrupt number to the cpu.
+  - #address-cells: always 1 (for i2c addresses)
+  - #size-cells: always 0
+
+  - Pinctrl:
+    - pinctrl-0: Pin control group to be used for this controller.
+    - pinctrl-names: Should contain only one value - "default".
+
+Optional properties:
+  - clock-frequency: Desired operating frequency in Hz of the bus.
+    -> If not specified, the default value is 100khz in fast-speed mode and
+       1Mhz in high-speed mode.
+    -> If specified, The bus operates in high-speed mode only if the
+       clock-frequency is >= 1Mhz.
+
+Example:
+
+hsi2c@12ca0000 {
+	compatible = "samsung,exynos5-hsi2c";
+	reg = <0x12ca0000 0x100>;
+	interrupts = <56>;
+	clock-frequency = <100000>;
+
+	pinctrl-0 = <&i2c4_bus>;
+	pinctrl-names = "default";
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	s2mps11_pmic@66 {
+		compatible = "samsung,s2mps11-pmic";
+		reg = <0x66>;
+	};
+};
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index fcdd321..69b1848 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -436,6 +436,13 @@ config I2C_EG20T
 	  ML7213/ML7223/ML7831 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
+config I2C_EXYNOS5
+	tristate "Exynos5 high-speed I2C driver"
+	depends on ARCH_EXYNOS5 && OF
+	help
+	  Say Y here to include support for high-speed I2C controller in the
+	  Exynos5 based Samsung SoCs.
+
 config I2C_GPIO
 	tristate "GPIO-based bitbanging I2C"
 	depends on GPIOLIB
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index d00997f..d1ad371 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -42,6 +42,7 @@ i2c-designware-platform-objs := i2c-designware-platdrv.o
 obj-$(CONFIG_I2C_DESIGNWARE_PCI)	+= i2c-designware-pci.o
 i2c-designware-pci-objs := i2c-designware-pcidrv.o
 obj-$(CONFIG_I2C_EG20T)		+= i2c-eg20t.o
+obj-$(CONFIG_I2C_EXYNOS5)	+= i2c-exynos5.o
 obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
 obj-$(CONFIG_I2C_HIGHLANDER)	+= i2c-highlander.o
 obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
new file mode 100644
index 0000000..5cbe1d4
--- /dev/null
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -0,0 +1,799 @@
+/**
+ * i2c-exynos5.c - Samsung Exynos5 I2C Controller Driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_i2c.h>
+
+/*
+ * HSI2C controller from Samsung supports 2 modes of operation
+ * 1. Auto mode: Where in master automatically controls the whole transaction
+ * 2. Manual mode: Software controls the transaction by issuing commands
+ *    START, READ, WRITE, STOP, RESTART in I2C_MANUAL_CMD register.
+ *
+ * Operation mode can be selected by setting AUTO_MODE bit in I2C_CONF register
+ *
+ * Special bits are available for both modes of operation to set commands
+ * and for checking transfer status
+ */
+
+/* Register Map */
+#define HSI2C_CTL		0x00
+#define HSI2C_FIFO_CTL		0x04
+#define HSI2C_TRAILIG_CTL	0x08
+#define HSI2C_CLK_CTL		0x0C
+#define HSI2C_CLK_SLOT		0x10
+#define HSI2C_INT_ENABLE	0x20
+#define HSI2C_INT_STATUS	0x24
+#define HSI2C_ERR_STATUS	0x2C
+#define HSI2C_FIFO_STATUS	0x30
+#define HSI2C_TX_DATA		0x34
+#define HSI2C_RX_DATA		0x38
+#define HSI2C_CONF		0x40
+#define HSI2C_AUTO_CONF		0x44
+#define HSI2C_TIMEOUT		0x48
+#define HSI2C_MANUAL_CMD	0x4C
+#define HSI2C_TRANS_STATUS	0x50
+#define HSI2C_TIMING_HS1	0x54
+#define HSI2C_TIMING_HS2	0x58
+#define HSI2C_TIMING_HS3	0x5C
+#define HSI2C_TIMING_FS1	0x60
+#define HSI2C_TIMING_FS2	0x64
+#define HSI2C_TIMING_FS3	0x68
+#define HSI2C_TIMING_SLA	0x6C
+#define HSI2C_ADDR		0x70
+
+/* I2C_CTL Register bits */
+#define HSI2C_FUNC_MODE_I2C			(1u << 0)
+#define HSI2C_MASTER				(1u << 3)
+#define HSI2C_RXCHON				(1u << 6)
+#define HSI2C_TXCHON				(1u << 7)
+#define HSI2C_SW_RST				(1u << 31)
+
+/* I2C_FIFO_CTL Register bits */
+#define HSI2C_RXFIFO_EN				(1u << 0)
+#define HSI2C_TXFIFO_EN				(1u << 1)
+#define HSI2C_RXFIFO_TRIGGER_LEVEL(x)		((x) << 4)
+#define HSI2C_TXFIFO_TRIGGER_LEVEL(x)		((x) << 16)
+
+/* As per user manual FIFO max depth is 64bytes */
+#define HSI2C_FIFO_MAX				0x40
+/* default trigger levels for Tx and Rx FIFOs */
+#define HSI2C_DEF_TXFIFO_LVL			(HSI2C_FIFO_MAX - 0x30)
+#define HSI2C_DEF_RXFIFO_LVL			(HSI2C_FIFO_MAX - 0x10)
+
+/* I2C_TRAILING_CTL Register bits */
+#define HSI2C_TRAILING_COUNT			(0xf)
+
+/* I2C_INT_EN Register bits */
+#define HSI2C_INT_TX_ALMOSTEMPTY_EN		(1u << 0)
+#define HSI2C_INT_RX_ALMOSTFULL_EN		(1u << 1)
+#define HSI2C_INT_TRAILING_EN			(1u << 6)
+#define HSI2C_INT_I2C_EN			(1u << 9)
+
+/* I2C_INT_STAT Register bits */
+#define HSI2C_INT_TX_ALMOSTEMPTY		(1u << 0)
+#define HSI2C_INT_RX_ALMOSTFULL			(1u << 1)
+#define HSI2C_INT_TX_UNDERRUN			(1u << 2)
+#define HSI2C_INT_TX_OVERRUN			(1u << 3)
+#define HSI2C_INT_RX_UNDERRUN			(1u << 4)
+#define HSI2C_INT_RX_OVERRUN			(1u << 5)
+#define HSI2C_INT_TRAILING			(1u << 6)
+#define HSI2C_INT_I2C				(1u << 9)
+
+/* I2C_FIFO_STAT Register bits */
+#define HSI2C_RX_FIFO_EMPTY			(1u << 24)
+#define HSI2C_RX_FIFO_FULL			(1u << 23)
+#define HSI2C_RX_FIFO_LVL(x)			((x >> 16) & 0x7f)
+#define HSI2C_TX_FIFO_EMPTY			(1u << 8)
+#define HSI2C_TX_FIFO_FULL			(1u << 7)
+#define HSI2C_TX_FIFO_LVL(x)			((x >> 0) & 0x7f)
+
+/* I2C_CONF Register bits */
+#define HSI2C_AUTO_MODE				(1u << 31)
+#define HSI2C_10BIT_ADDR_MODE			(1u << 30)
+#define HSI2C_HS_MODE				(1u << 29)
+
+/* I2C_AUTO_CONF Register bits */
+#define HSI2C_READ_WRITE			(1u << 16)
+#define HSI2C_STOP_AFTER_TRANS			(1u << 17)
+#define HSI2C_MASTER_RUN			(1u << 31)
+
+/* I2C_TIMEOUT Register bits */
+#define HSI2C_TIMEOUT_EN			(1u << 31)
+
+/* I2C_TRANS_STATUS register bits */
+#define HSI2C_MASTER_BUSY			(1u << 17)
+#define HSI2C_SLAVE_BUSY			(1u << 16)
+#define HSI2C_TIMEOUT_AUTO			(1u << 4)
+#define HSI2C_NO_DEV				(1u << 3)
+#define HSI2C_NO_DEV_ACK			(1u << 2)
+#define HSI2C_TRANS_ABORT			(1u << 1)
+#define HSI2C_TRANS_DONE			(1u << 0)
+
+/* I2C_ADDR register bits */
+#define HSI2C_SLV_ADDR_SLV(x)			((x & 0x3ff) << 0)
+#define HSI2C_SLV_ADDR_MAS(x)			((x & 0x3ff) << 10)
+#define HSI2C_MASTER_ID(x)			((x & 0xff) << 24)
+#define MASTER_ID(x)				((x & 0x7) + 0x08)
+
+/*
+ * Controller operating frequency, timing values for operation
+ * are calculated against this frequency
+ */
+#define HSI2C_HS_TX_CLOCK	1000000
+#define HSI2C_FS_TX_CLOCK	100000
+#define HSI2C_HIGH_SPD		1
+#define HSI2C_FAST_SPD		0
+
+#define EXYNOS5_I2C_TIMEOUT (msecs_to_jiffies(1000))
+
+struct exynos5_i2c {
+	struct i2c_adapter	adap;
+	unsigned int		suspended:1;
+
+	struct i2c_msg		*msg;
+	struct completion	msg_complete;
+	spinlock_t		lock;		/* IRQ synchronization */
+	unsigned int		msg_ptr;
+
+	unsigned int		irq;
+
+	void __iomem		*regs;
+	struct clk		*clk;
+	struct device		*dev;
+	int			state;
+
+	/*
+	 * Since the TRANS_DONE bit is cleared on read, and we may read it
+	 * either during an IRQ or after a transaction, keep track of its
+	 * state here.
+	 */
+	int			trans_done;
+
+	/* Controller operating frequency */
+	unsigned int		fs_clock;
+	unsigned int		hs_clock;
+
+	/*
+	 * HSI2C Controller can operate in
+	 * 1. High speed upto 3.4Mbps
+	 * 2. Fast speed upto 1Mbps
+	 */
+	int			speed_mode;
+};
+
+static const struct of_device_id exynos5_i2c_match[] = {
+	{ .compatible = "samsung,exynos5-hsi2c" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
+
+static void exynos5_i2c_clr_pend_irq(struct exynos5_i2c *i2c)
+{
+	writel(readl(i2c->regs + HSI2C_INT_STATUS),
+				i2c->regs + HSI2C_INT_STATUS);
+}
+
+/*
+ * exynos5_i2c_set_timing: updates the registers with appropriate
+ * timing values calculated
+ *
+ * Returns 0 on success, -EINVAL if the cycle length cannot
+ * be calculated.
+ */
+static int exynos5_i2c_set_timing(struct exynos5_i2c *i2c, int mode)
+{
+	u32 i2c_timing_s1;
+	u32 i2c_timing_s2;
+	u32 i2c_timing_s3;
+	u32 i2c_timing_sla;
+	unsigned int t_start_su, t_start_hd;
+	unsigned int t_stop_su;
+	unsigned int t_data_su, t_data_hd;
+	unsigned int t_scl_l, t_scl_h;
+	unsigned int t_sr_release;
+	unsigned int t_ftl_cycle;
+	unsigned int clkin = clk_get_rate(i2c->clk);
+	unsigned int div, utemp0 = 0, utemp1 = 0, clk_cycle;
+	unsigned int op_clk = (mode == HSI2C_HIGH_SPD) ?
+				i2c->hs_clock : i2c->fs_clock;
+
+	/*
+	 * FPCLK / FI2C =
+	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
+	 * utemp0 = (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
+	 * utemp1 = (TSCLK_L + TSCLK_H + 2)
+	 */
+	t_ftl_cycle = (readl(i2c->regs + HSI2C_CONF) >> 16) & 0x7;
+	utemp0 = (clkin / op_clk) - 8 - 2 * t_ftl_cycle;
+
+	/* CLK_DIV max is 256 */
+	for (div = 0; div < 256; div++) {
+		utemp1 = utemp0 / (div + 1);
+
+		/*
+		 * SCL_L and SCL_H each has max value of 255
+		 * Hence, For the clk_cycle to the have right value
+		 * utemp1 has to be less then 512 and more than 4.
+		 */
+		if ((utemp1 < 512) && (utemp1 > 4)) {
+			clk_cycle = utemp1 - 2;
+			break;
+		} else if (div == 255) {
+			dev_warn(i2c->dev, "Failed to calculate divisor");
+			return -EINVAL;
+		}
+	}
+
+	t_scl_l = clk_cycle / 2;
+	t_scl_h = clk_cycle / 2;
+	t_start_su = t_scl_l;
+	t_start_hd = t_scl_l;
+	t_stop_su = t_scl_l;
+	t_data_su = t_scl_l / 2;
+	t_data_hd = t_scl_l / 2;
+	t_sr_release = clk_cycle;
+
+	i2c_timing_s1 = t_start_su << 24 | t_start_hd << 16 | t_stop_su << 8;
+	i2c_timing_s2 = t_data_su << 24 | t_scl_l << 8 | t_scl_h << 0;
+	i2c_timing_s3 = div << 16 | t_sr_release << 0;
+	i2c_timing_sla = t_data_hd << 0;
+
+	dev_dbg(i2c->dev, "tSTART_SU: %X, tSTART_HD: %X, tSTOP_SU: %X\n",
+		t_start_su, t_start_hd, t_stop_su);
+	dev_dbg(i2c->dev, "tDATA_SU: %X, tSCL_L: %X, tSCL_H: %X\n",
+		t_data_su, t_scl_l, t_scl_h);
+	dev_dbg(i2c->dev, "nClkDiv: %X, tSR_RELEASE: %X\n",
+		div, t_sr_release);
+	dev_dbg(i2c->dev, "tDATA_HD: %X\n", t_data_hd);
+
+	if (mode == HSI2C_HIGH_SPD) {
+		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_HS1);
+		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_HS2);
+		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_HS3);
+	} else {
+		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_FS1);
+		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_FS2);
+		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_FS3);
+	}
+	writel(i2c_timing_sla, i2c->regs + HSI2C_TIMING_SLA);
+
+	return 0;
+}
+
+static int exynos5_hsi2c_clock_setup(struct exynos5_i2c *i2c)
+{
+	/*
+	 * Configure the Fast speed timing values
+	 * Even the High Speed mode initially starts with Fast mode
+	 */
+	if (exynos5_i2c_set_timing(i2c, HSI2C_FAST_SPD)) {
+		dev_err(i2c->dev, "HSI2C FS Clock set up failed\n");
+		return -EINVAL;
+	}
+
+	/* configure the High speed timing values */
+	if (i2c->speed_mode == HSI2C_HIGH_SPD) {
+		if (exynos5_i2c_set_timing(i2c, HSI2C_HIGH_SPD)) {
+			dev_err(i2c->dev, "HSI2C HS Clock set up failed\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * exynos5_i2c_init: configures the controller for I2C functionality
+ * Programs I2C controller for Master mode operation
+ */
+static void exynos5_i2c_init(struct exynos5_i2c *i2c)
+{
+	u32 i2c_conf = readl(i2c->regs + HSI2C_CONF);
+	u32 i2c_timeout = readl(i2c->regs + HSI2C_TIMEOUT);
+
+	/* Disable timeout */
+	i2c_timeout &= ~HSI2C_TIMEOUT_EN;
+	writel(i2c_timeout, i2c->regs + HSI2C_TIMEOUT);
+
+	writel((HSI2C_FUNC_MODE_I2C | HSI2C_MASTER),
+					i2c->regs + HSI2C_CTL);
+	writel(HSI2C_TRAILING_COUNT, i2c->regs + HSI2C_TRAILIG_CTL);
+
+	if (i2c->speed_mode == HSI2C_HIGH_SPD) {
+		writel(HSI2C_MASTER_ID(MASTER_ID(i2c->adap.nr)),
+					i2c->regs + HSI2C_ADDR);
+		i2c_conf |= HSI2C_HS_MODE;
+	}
+
+	writel(i2c_conf | HSI2C_AUTO_MODE, i2c->regs + HSI2C_CONF);
+}
+
+static void exynos5_i2c_reset(struct exynos5_i2c *i2c)
+{
+	u32 i2c_ctl;
+
+	/* Set and clear the bit for reset */
+	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
+	i2c_ctl |= HSI2C_SW_RST;
+	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
+
+	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
+	i2c_ctl &= ~HSI2C_SW_RST;
+	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
+
+	/* We don't expect calculations to fail during the run */
+	exynos5_hsi2c_clock_setup(i2c);
+	/* Initialize the configure registers */
+	exynos5_i2c_init(i2c);
+}
+
+/*
+ * exynos5_i2c_irq: top level IRQ servicing routine
+ *
+ * INT_STATUS registers gives the interrupt details. Further,
+ * FIFO_STATUS or TRANS_STATUS registers are to be check for detailed
+ * state of the bus.
+ */
+static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
+{
+	struct exynos5_i2c *i2c = dev_id;
+	u32 fifo_level, int_status, fifo_status, trans_status;
+	unsigned long flags;
+	u32 len;
+	unsigned char byte;
+
+	spin_lock_irqsave(&i2c->lock, flags);
+	i2c->state = -EINVAL;
+
+	int_status = readl(i2c->regs + HSI2C_INT_STATUS);
+
+	/* handle interrupt related to the transfer status */
+	if (int_status & HSI2C_INT_I2C) {
+		trans_status = readl(i2c->regs + HSI2C_TRANS_STATUS);
+		if (trans_status & HSI2C_NO_DEV_ACK) {
+			dev_dbg(i2c->dev, "No ACK from device\n");
+			i2c->state = -ENXIO;
+			goto stop;
+		} else if (trans_status & HSI2C_NO_DEV) {
+			dev_dbg(i2c->dev, "No device\n");
+			i2c->state = -ENXIO;
+			goto stop;
+		} else if (trans_status & HSI2C_TRANS_ABORT) {
+			dev_dbg(i2c->dev, "Deal with arbitration lose\n");
+			i2c->state = -EAGAIN;
+			goto stop;
+		} else if (trans_status & HSI2C_TIMEOUT_AUTO) {
+			dev_dbg(i2c->dev, "Accessing device timed out\n");
+			i2c->state = -EAGAIN;
+			goto stop;
+		} else if (trans_status & HSI2C_TRANS_DONE) {
+			i2c->trans_done = 1;
+			i2c->state = 0;
+		}
+	}
+
+	if ((i2c->msg->flags & I2C_M_RD) && (int_status &
+			(HSI2C_INT_TRAILING | HSI2C_INT_RX_ALMOSTFULL))) {
+		fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
+		fifo_level = HSI2C_RX_FIFO_LVL(fifo_status);
+		len = min(fifo_level, i2c->msg->len - i2c->msg_ptr);
+
+		while (len > 0) {
+			byte = (unsigned char)
+				readl(i2c->regs + HSI2C_RX_DATA);
+			i2c->msg->buf[i2c->msg_ptr++] = byte;
+			len--;
+		}
+		i2c->state = 0;
+	} else if (int_status & HSI2C_INT_TX_ALMOSTEMPTY) {
+		fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
+		fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
+
+		len = HSI2C_FIFO_MAX - fifo_level;
+		if (len > (i2c->msg->len - i2c->msg_ptr))
+			len = i2c->msg->len - i2c->msg_ptr;
+
+		while (len > 0) {
+			byte = i2c->msg->buf[i2c->msg_ptr++];
+			writel(byte, i2c->regs + HSI2C_TX_DATA);
+			len--;
+		}
+		i2c->state = 0;
+	}
+
+ stop:
+	if ((i2c->msg_ptr == i2c->msg->len) || (i2c->state < 0)) {
+		writel(0, i2c->regs + HSI2C_INT_ENABLE);
+		exynos5_i2c_clr_pend_irq(i2c);
+		complete(&i2c->msg_complete);
+	} else {
+		exynos5_i2c_clr_pend_irq(i2c);
+	}
+
+	spin_unlock_irqrestore(&i2c->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * exynos5_i2c_wait_bus_idle
+ *
+ * Wait for the transaction to complete (indicated by the TRANS_DONE bit
+ * being set), and, if this is the last message in a transfer, wait for the
+ * MASTER_BUSY bit to be cleared.
+ *
+ * Returns -EBUSY if the bus cannot be bought to idle
+ */
+static int exynos5_i2c_wait_bus_idle(struct exynos5_i2c *i2c, int stop)
+{
+	unsigned long stop_time;
+	u32 trans_status;
+
+	/* wait for 100 milli seconds for the bus to be idle */
+	stop_time = jiffies + msecs_to_jiffies(100) + 1;
+	do {
+		trans_status = readl(i2c->regs + HSI2C_TRANS_STATUS);
+		if (trans_status & HSI2C_TRANS_DONE)
+			i2c->trans_done = 1;
+		/*
+		 * Only wait for MASTER_BUSY to be cleared if this is the last
+		 * message.
+		 */
+		if ((!stop || !(trans_status & HSI2C_MASTER_BUSY)) &&
+		    i2c->trans_done)
+			return 0;
+
+		usleep_range(50, 200);
+	} while (time_before(jiffies, stop_time));
+
+	return -EBUSY;
+}
+
+/*
+ * exynos5_i2c_message_start: Configures the bus and starts the xfer
+ * i2c: struct exynos5_i2c pointer for the current bus
+ * stop: Enables stop after transfer if set. Set for last transfer of
+ *       in the list of messages.
+ *
+ * Configures the bus for read/write function
+ * Sets chip address to talk to, message length to be sent.
+ * Enables appropriate interrupts and sends start xfer command.
+ */
+static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
+{
+	u32 i2c_ctl;
+	u32 int_en = HSI2C_INT_I2C_EN;
+	u32 i2c_auto_conf = 0;
+	u32 fifo_ctl;
+
+	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
+	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
+	fifo_ctl = HSI2C_RXFIFO_EN | HSI2C_TXFIFO_EN;
+
+	if (i2c->msg->flags & I2C_M_RD) {
+		i2c_ctl |= HSI2C_RXCHON;
+
+		i2c_auto_conf = HSI2C_READ_WRITE;
+
+		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
+		int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
+			HSI2C_INT_TRAILING_EN);
+	} else {
+		i2c_ctl |= HSI2C_TXCHON;
+
+		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(HSI2C_DEF_RXFIFO_LVL);
+		int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
+	}
+
+	writel(HSI2C_SLV_ADDR_MAS(i2c->msg->addr), i2c->regs + HSI2C_ADDR);
+
+	writel(fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
+	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
+
+	if (stop == 1)
+		i2c_auto_conf |= HSI2C_STOP_AFTER_TRANS;
+	i2c_auto_conf |= i2c->msg->len;
+	i2c_auto_conf |= HSI2C_MASTER_RUN;
+	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONF);
+
+	writel(int_en, i2c->regs + HSI2C_INT_ENABLE);
+}
+
+static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
+			      struct i2c_msg *msgs, int stop)
+{
+	unsigned long timeout;
+	int ret;
+
+	INIT_COMPLETION(i2c->msg_complete);
+
+	spin_lock_irq(&i2c->lock);
+	i2c->msg = msgs;
+	i2c->msg_ptr = 0;
+	i2c->trans_done = 0;
+
+	exynos5_i2c_message_start(i2c, stop);
+
+	spin_unlock_irq(&i2c->lock);
+	timeout = wait_for_completion_timeout(&i2c->msg_complete,
+					      EXYNOS5_I2C_TIMEOUT);
+	if (timeout == 0)
+		ret = -ETIMEDOUT;
+	else
+		ret = i2c->state;
+
+	if (ret < 0) {
+		exynos5_i2c_reset(i2c);
+		if (ret == -ETIMEDOUT) {
+			dev_warn(i2c->dev, "%s timeout\n",
+				 (msgs->flags & I2C_M_RD) ? "rx" : "tx");
+			return ret;
+		} else if (ret == -EAGAIN) {
+			return ret;
+		}
+	}
+
+	/*
+	 * If this is the last message to be transfered (stop == 1)
+	 * Then check if the bus can be brought back to idle.
+	 *
+	 * Return -EBUSY if the bus still busy.
+	 */
+	if (exynos5_i2c_wait_bus_idle(i2c, stop))
+		return -EBUSY;
+
+	/* Return the state as in interrupt routine */
+	return ret;
+}
+
+static int exynos5_i2c_xfer(struct i2c_adapter *adap,
+			struct i2c_msg *msgs, int num)
+{
+	struct exynos5_i2c *i2c = (struct exynos5_i2c *)adap->algo_data;
+	int i = 0, ret = 0, stop = 0;
+
+	if (i2c->suspended) {
+		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
+		return -EIO;
+	}
+
+	clk_prepare_enable(i2c->clk);
+
+	for (i = 0; i < num; i++) {
+		stop = (i == num - 1);
+
+		if (msgs->len == 0) {
+			msgs++;
+			continue;
+		}
+
+		ret = exynos5_i2c_xfer_msg(i2c, msgs, stop);
+		if (!stop)
+			msgs++;
+
+		if (ret < 0)
+			goto out;
+	}
+
+	if (i == num) {
+		ret = num;
+	} else {
+		/* Only one message, cannot access the device */
+		if (i == 1)
+			ret = -EREMOTEIO;
+		else
+			ret = i;
+
+		dev_warn(i2c->dev, "xfer message failed\n");
+	}
+
+ out:
+	clk_disable_unprepare(i2c->clk);
+	return ret;
+}
+
+static u32 exynos5_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
+}
+
+static const struct i2c_algorithm exynos5_i2c_algorithm = {
+	.master_xfer		= exynos5_i2c_xfer,
+	.functionality		= exynos5_i2c_func,
+};
+
+static int exynos5_i2c_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct exynos5_i2c *i2c;
+	struct resource *mem;
+	unsigned int op_clock;
+	int ret;
+
+	if (!np) {
+		dev_err(&pdev->dev, "no device node\n");
+		return -ENOENT;
+	}
+
+	i2c = devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL);
+	if (!i2c) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	if (of_property_read_u32(np, "clock-frequency", &op_clock)) {
+		i2c->speed_mode = HSI2C_FAST_SPD;
+		i2c->fs_clock = HSI2C_FS_TX_CLOCK;
+	} else {
+		if (op_clock >= HSI2C_HS_TX_CLOCK) {
+			i2c->speed_mode = HSI2C_HIGH_SPD;
+			i2c->fs_clock = HSI2C_FS_TX_CLOCK;
+			i2c->hs_clock = op_clock;
+		} else {
+			i2c->speed_mode = HSI2C_FAST_SPD;
+			i2c->fs_clock = op_clock;
+		}
+	}
+
+	strlcpy(i2c->adap.name, "exynos5-i2c", sizeof(i2c->adap.name));
+	i2c->adap.owner   = THIS_MODULE;
+	i2c->adap.algo    = &exynos5_i2c_algorithm;
+
+	i2c->dev = &pdev->dev;
+	i2c->clk = devm_clk_get(&pdev->dev, "hsi2c");
+	if (IS_ERR(i2c->clk)) {
+		dev_err(&pdev->dev, "cannot get clock\n");
+		return -ENOENT;
+	}
+
+	clk_prepare_enable(i2c->clk);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	i2c->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(i2c->regs)) {
+		ret = PTR_ERR(i2c->regs);
+		goto err_clk;
+	}
+
+	i2c->adap.dev.of_node = np;
+	i2c->adap.algo_data = i2c;
+	i2c->adap.dev.parent = &pdev->dev;
+
+	/* Clear pending interrupts from u-boot or misc causes */
+	exynos5_i2c_clr_pend_irq(i2c);
+
+	spin_lock_init(&i2c->lock);
+	init_completion(&i2c->msg_complete);
+
+	i2c->irq = ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
+		dev_err(&pdev->dev, "cannot find HS-I2C IRQ\n");
+		ret = -EINVAL;
+		goto err_clk;
+	}
+
+	ret = devm_request_irq(&pdev->dev, i2c->irq, exynos5_i2c_irq,
+				0, dev_name(&pdev->dev), i2c);
+
+	if (ret != 0) {
+		dev_err(&pdev->dev, "cannot request HS-I2C IRQ %d\n", i2c->irq);
+		goto err_clk;
+	}
+
+	ret = exynos5_hsi2c_clock_setup(i2c);
+	if (ret)
+		goto err_clk;
+
+	exynos5_i2c_init(i2c);
+
+	i2c->adap.nr = -1;
+	ret = i2c_add_numbered_adapter(&i2c->adap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
+		goto err_clk;
+	}
+
+	of_i2c_register_devices(&i2c->adap);
+	platform_set_drvdata(pdev, i2c);
+
+	clk_disable_unprepare(i2c->clk);
+
+	return 0;
+
+ err_clk:
+	clk_disable_unprepare(i2c->clk);
+	return ret;
+}
+
+static int exynos5_i2c_remove(struct platform_device *pdev)
+{
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&i2c->adap);
+	clk_disable_unprepare(i2c->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int exynos5_i2c_suspend_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+
+	i2c->suspended = 1;
+
+	return 0;
+}
+
+static int exynos5_i2c_resume_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+	int ret = 0;
+
+	clk_prepare_enable(i2c->clk);
+
+	ret = exynos5_hsi2c_clock_setup(i2c);
+	if (ret) {
+		clk_disable_unprepare(i2c->clk);
+		return ret;
+	}
+
+	exynos5_i2c_init(i2c);
+	clk_disable_unprepare(i2c->clk);
+	i2c->suspended = 0;
+
+	return 0;
+}
+
+static const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
+	.suspend_noirq = exynos5_i2c_suspend_noirq,
+	.resume_noirq	= exynos5_i2c_resume_noirq,
+};
+
+#define EXYNOS5_DEV_PM_OPS (&exynos5_i2c_dev_pm_ops)
+#else
+#define EXYNOS5_DEV_PM_OPS NULL
+#endif
+
+static struct platform_driver exynos5_i2c_driver = {
+	.probe		= exynos5_i2c_probe,
+	.remove		= exynos5_i2c_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "exynos5-hsi2c",
+		.pm	= EXYNOS5_DEV_PM_OPS,
+		.of_match_table = exynos5_i2c_match,
+	},
+};
+
+module_platform_driver(exynos5_i2c_driver);
+
+MODULE_DESCRIPTION("Exynos5 HS-I2C Bus driver");
+MODULE_AUTHOR("Naveen Krishna Chatradhi, <ch.naveen@samsung.com>");
+MODULE_AUTHOR("Taekgyun Ko, <taeggyun.ko@samsung.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

