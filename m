Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3FRHpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:45:40 -0400
Received: from mail.abilis.ch ([195.70.19.74]:13746 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3FRHpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:45:38 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Rob Herring <robherring2@gmail.com>, Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH v8] i2c-designware: make SDA hold time configurable
Date: Tue, 18 Jun 2013 09:44:29 +0200
Message-Id: <1371541469-20623-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <51BF77C2.70004@gmail.com>
References: <51BF77C2.70004@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the SDA hold time configurable through device tree.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
---
 .../devicetree/bindings/i2c/i2c-designware.txt     |   14 ++++++++++++++
 arch/arc/boot/dts/abilis_tb100_dvk.dts             |   10 +++++-----
 arch/arc/boot/dts/abilis_tb101_dvk.dts             |   10 +++++-----
 drivers/i2c/busses/i2c-designware-core.c           |    5 +++++
 drivers/i2c/busses/i2c-designware-core.h           |    1 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |   10 ++++++++++
 6 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
index e42a2ee..3266cc7 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
@@ -10,6 +10,9 @@ Recommended properties :
 
  - clock-frequency : desired I2C bus clock frequency in Hz.
 
+Optional properties :
+ - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
+
 Example :
 
 	i2c@f0000 {
@@ -20,3 +23,14 @@ Example :
 		interrupts = <11>;
 		clock-frequency = <400000>;
 	};
+
+	i2c@1120000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "snps,designware-i2c";
+		reg = <0x1120000 0x1000>;
+		interrupt-parent = <&ictl>;
+		interrupts = <12 1>;
+		clock-frequency = <400000>;
+		i2c-sda-hold-time-ns = <300>;
+	};
diff --git a/arch/arc/boot/dts/abilis_tb100_dvk.dts b/arch/arc/boot/dts/abilis_tb100_dvk.dts
index 0fa0d4a..ebc313a 100644
--- a/arch/arc/boot/dts/abilis_tb100_dvk.dts
+++ b/arch/arc/boot/dts/abilis_tb100_dvk.dts
@@ -45,19 +45,19 @@
 		};
 
 		i2c0: i2c@FF120000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c1: i2c@FF121000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c2: i2c@FF122000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c3: i2c@FF123000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c4: i2c@FF124000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 
 		leds {
diff --git a/arch/arc/boot/dts/abilis_tb101_dvk.dts b/arch/arc/boot/dts/abilis_tb101_dvk.dts
index a4d80ce..b204657 100644
--- a/arch/arc/boot/dts/abilis_tb101_dvk.dts
+++ b/arch/arc/boot/dts/abilis_tb101_dvk.dts
@@ -45,19 +45,19 @@
 		};
 
 		i2c0: i2c@FF120000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c1: i2c@FF121000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c2: i2c@FF122000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c3: i2c@FF123000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 		i2c4: i2c@FF124000 {
-			sda-hold-time = <432>;
+			i2c-sda-hold-time-ns = <432>;
 		};
 
 		leds {
diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index c41ca63..6c0e776 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -67,6 +67,7 @@
 #define DW_IC_STATUS		0x70
 #define DW_IC_TXFLR		0x74
 #define DW_IC_RXFLR		0x78
+#define DW_IC_SDA_HOLD		0x7c
 #define DW_IC_TX_ABRT_SOURCE	0x80
 #define DW_IC_ENABLE_STATUS	0x9c
 #define DW_IC_COMP_PARAM_1	0xf4
@@ -332,6 +333,10 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	dw_writel(dev, lcnt, DW_IC_FS_SCL_LCNT);
 	dev_dbg(dev->dev, "Fast-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
 
+	/* Configure SDA Hold Time if required */
+	if (dev->sda_hold_time)
+		dw_writel(dev, dev->sda_hold_time, DW_IC_SDA_HOLD);
+
 	/* Configure Tx/Rx FIFO threshold levels */
 	dw_writel(dev, dev->tx_fifo_depth - 1, DW_IC_TX_TL);
 	dw_writel(dev, 0, DW_IC_RX_TL);
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index e761ad1..912aa22 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -90,6 +90,7 @@ struct dw_i2c_dev {
 	unsigned int		tx_fifo_depth;
 	unsigned int		rx_fifo_depth;
 	int			rx_outstanding;
+	u32			sda_hold_time;
 };
 
 #define ACCESS_SWAP		0x00000001
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 35b70a1..81362e5 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -34,6 +34,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 #include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -121,6 +122,15 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->clk);
 	clk_prepare_enable(dev->clk);
 
+	if (pdev->dev.of_node) {
+		u32 ht;
+		u32 ic_clk = dev->get_clk_rate_khz(dev);
+
+		of_property_read_u32(pdev->dev.of_node,
+					"i2c-sda-hold-time-ns", &ht);
+		dev->sda_hold_time = ((u64)ic_clk * ht + 500000) / 1000000;
+	}
+
 	dev->functionality =
 		I2C_FUNC_I2C |
 		I2C_FUNC_10BIT_ADDR |
-- 
1.7.1

