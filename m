Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3IIQFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:05:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3IIQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:04:00 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 2/4] ARM: shmobile: r8a7790: add I2C support in Device Tree mode
Date: Mon,  9 Sep 2013 18:03:54 +0200
Message-Id: <1378742636-11215-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:4RkZ5yzZGkaacuVrYXCq7mFOkXIgaNPfauoymAQ9cMW
 0y2nSxr1Kf7XKfKShMnRegsa0yqkpbGlOBII7XUihBIr0+xMjt
 peYLkcnTmF7Jx6D67HbxrHdnb2iPgmoFhqOCHaH2JPYbfUk2iq
 R15wAnCED8Om0cdPeVOqKz5mdb9dS6ryTIW33l0Le2u17f3x66
 gpJN3thnkf2l62EE2W/nOw0gphRoIfpE9Ff0PXz0K2KG3V1CWU
 zx5xLAswOcPjt5t6WM8yW6OW+TZteO4O0gwhgojZXLdWXoubmf
 F36zDxN6z5X5B3NjJX68Rqp7GQfXqBe2JHgq1jOoY/cPllQa45
 tUpHx1uVGpMEoTXrhXyEAfzgo8F1uZdD242n0LNiLXhfDwXov9
 nxyeZIzq5OQKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds clocks and clock lookup entries for the four I2C
controllers on r8a7790 and respective Device Tree nodes.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7790.dtsi         |   36 ++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/clock-r8a7790.c |   10 ++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index 885f9f4..a5021112 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -127,6 +127,42 @@
 		interrupts = <0 0 4>, <0 1 4>, <0 2 4>,	<0 3 4>;
 	};
 
+	i2c0: i2c@e6508000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "renesas,i2c-rcar-h2";
+		reg = <0 0xe6508000 0 0x40>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 287 0x4>;
+	};
+
+	i2c1: i2c@e6518000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "renesas,i2c-rcar-h2";
+		reg = <0 0xe6518000 0 0x40>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 288 0x4>;
+	};
+
+	i2c2: i2c@e6530000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "renesas,i2c-rcar-h2";
+		reg = <0 0xe6530000 0 0x40>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 286 0x4>;
+	};
+
+	i2c3: i2c@e6540000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "renesas,i2c-rcar-h2";
+		reg = <0 0xe6540000 0 0x40>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 290 0x4>;
+	};
+
 	mmcif0: mmcif@ee200000 {
 		compatible = "renesas,sh-mmcif";
 		reg = <0 0xee200000 0 0x80>;
diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
index fc36d3d..8e5e90b 100644
--- a/arch/arm/mach-shmobile/clock-r8a7790.c
+++ b/arch/arm/mach-shmobile/clock-r8a7790.c
@@ -52,6 +52,7 @@
 #define SMSTPCR5 0xe6150144
 #define SMSTPCR7 0xe615014c
 #define SMSTPCR8 0xe6150990
+#define SMSTPCR9 0xe6150994
 
 #define SDCKCR		0xE6150074
 #define SD2CKCR		0xE6150078
@@ -181,6 +182,7 @@ static struct clk div6_clks[DIV6_NR] = {
 
 /* MSTP */
 enum {
+	MSTP931, MSTP930, MSTP929, MSTP928,
 	MSTP813,
 	MSTP721, MSTP720,
 	MSTP717, MSTP716,
@@ -192,6 +194,10 @@ enum {
 };
 
 static struct clk mstp_clks[MSTP_NR] = {
+	[MSTP931] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 31, 0), /* I2C0 */
+	[MSTP930] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 30, 0), /* I2C1 */
+	[MSTP929] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 29, 0), /* I2C2 */
+	[MSTP928] = SH_CLK_MSTP32(&hp_clk, SMSTPCR9, 28, 0), /* I2C3 */
 	[MSTP813] = SH_CLK_MSTP32(&p_clk, SMSTPCR8, 13, 0), /* Ether */
 	[MSTP721] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 21, 0), /* SCIF0 */
 	[MSTP720] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 20, 0), /* SCIF1 */
@@ -261,6 +267,10 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-sci.7", &mstp_clks[MSTP720]),
 	CLKDEV_DEV_ID("sh-sci.8", &mstp_clks[MSTP717]),
 	CLKDEV_DEV_ID("sh-sci.9", &mstp_clks[MSTP716]),
+	CLKDEV_DEV_ID("e6508000.i2c", &mstp_clks[MSTP931]),
+	CLKDEV_DEV_ID("e6518000.i2c", &mstp_clks[MSTP930]),
+	CLKDEV_DEV_ID("e6530000.i2c", &mstp_clks[MSTP929]),
+	CLKDEV_DEV_ID("e6540000.i2c", &mstp_clks[MSTP928]),
 	CLKDEV_DEV_ID("r8a7790-ether", &mstp_clks[MSTP813]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("ee200000.mmcif", &mstp_clks[MSTP315]),
-- 
1.7.2.5

