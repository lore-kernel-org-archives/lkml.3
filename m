Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3I3POT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:14:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50858 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab3I3POP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:14:15 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Joel Fernandes <joelf@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP DEVICE TREE..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 8/9] ARM: dts: AM33XX: Add LCDC info into am335x-evm
Date: Mon, 30 Sep 2013 10:13:05 -0500
Message-ID: <1380553986-15910-9-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380553986-15910-1-git-send-email-joelf@ti.com>
References: <1380553986-15910-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

Add LCDC device node in DT for am33xx
Add LCDC and Panel info in DT for am335x-evm

Changes:
- remove redundant/unnecessary SoC specific setting in the board dts
- resolved conflicts on for_3.13/dts

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/boot/dts/am335x-evm.dts | 71 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/am33xx.dtsi    |  9 +++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 86463fa..b73f41f 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -85,6 +85,40 @@
 		brightness-levels = <0 51 53 56 62 75 101 152 255>;
 		default-brightness-level = <8>;
 	};
+
+	panel {
+		compatible = "ti,tilcdc,panel";
+		status = "okay";
+		pinctrl-names = "default";
+		pinctrl-0 = <&lcd_pins_s0>;
+		panel-info {
+			ac-bias           = <255>;
+			ac-bias-intrpt    = <0>;
+			dma-burst-sz      = <16>;
+			bpp               = <32>;
+			fdd               = <0x80>;
+			sync-edge         = <0>;
+			sync-ctrl         = <1>;
+			raster-order      = <0>;
+			fifo-th           = <0>;
+		};
+
+		display-timings {
+			800x480p62 {
+				clock-frequency = <30000000>;
+				hactive = <800>;
+				vactive = <480>;
+				hfront-porch = <39>;
+				hback-porch = <39>;
+				hsync-len = <47>;
+				vback-porch = <29>;
+				vfront-porch = <13>;
+				vsync-len = <2>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
 };
 
 &am33xx_pinmux {
@@ -212,6 +246,39 @@
 			0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
 		>;
 	};
+
+	lcd_pins_s0: lcd_pins_s0 {
+		pinctrl-single,pins = <
+			0x20 0x01	/* gpmc_ad8.lcd_data16, OUTPUT | MODE1 */
+			0x24 0x01	/* gpmc_ad9.lcd_data17, OUTPUT | MODE1 */
+			0x28 0x01	/* gpmc_ad10.lcd_data18, OUTPUT | MODE1 */
+			0x2c 0x01	/* gpmc_ad11.lcd_data19, OUTPUT | MODE1 */
+			0x30 0x01	/* gpmc_ad12.lcd_data20, OUTPUT | MODE1 */
+			0x34 0x01	/* gpmc_ad13.lcd_data21, OUTPUT | MODE1 */
+			0x38 0x01	/* gpmc_ad14.lcd_data22, OUTPUT | MODE1 */
+			0x3c 0x01	/* gpmc_ad15.lcd_data23, OUTPUT | MODE1 */
+			0xa0 0x00	/* lcd_data0.lcd_data0, OUTPUT | MODE0 */
+			0xa4 0x00	/* lcd_data1.lcd_data1, OUTPUT | MODE0 */
+			0xa8 0x00	/* lcd_data2.lcd_data2, OUTPUT | MODE0 */
+			0xac 0x00	/* lcd_data3.lcd_data3, OUTPUT | MODE0 */
+			0xb0 0x00	/* lcd_data4.lcd_data4, OUTPUT | MODE0 */
+			0xb4 0x00	/* lcd_data5.lcd_data5, OUTPUT | MODE0 */
+			0xb8 0x00	/* lcd_data6.lcd_data6, OUTPUT | MODE0 */
+			0xbc 0x00	/* lcd_data7.lcd_data7, OUTPUT | MODE0 */
+			0xc0 0x00	/* lcd_data8.lcd_data8, OUTPUT | MODE0 */
+			0xc4 0x00	/* lcd_data9.lcd_data9, OUTPUT | MODE0 */
+			0xc8 0x00	/* lcd_data10.lcd_data10, OUTPUT | MODE0 */
+			0xcc 0x00	/* lcd_data11.lcd_data11, OUTPUT | MODE0 */
+			0xd0 0x00	/* lcd_data12.lcd_data12, OUTPUT | MODE0 */
+			0xd4 0x00	/* lcd_data13.lcd_data13, OUTPUT | MODE0 */
+			0xd8 0x00	/* lcd_data14.lcd_data14, OUTPUT | MODE0 */
+			0xdc 0x00	/* lcd_data15.lcd_data15, OUTPUT | MODE0 */
+			0xe0 0x00	/* lcd_vsync.lcd_vsync, OUTPUT | MODE0 */
+			0xe4 0x00	/* lcd_hsync.lcd_hsync, OUTPUT | MODE0 */
+			0xe8 0x00	/* lcd_pclk.lcd_pclk, OUTPUT | MODE0 */
+			0xec 0x00	/* lcd_ac_bias_en.lcd_ac_bias_en, OUTPUT | MODE0 */
+		>;
+	};
 };
 
 &uart0 {
@@ -308,6 +375,10 @@
 	};
 };
 
+&lcdc {
+	status = "okay";
+};
+
 &elm {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index d7be90a..f870d0b 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -682,6 +682,15 @@
 			status = "disabled";
 		};
 
+		lcdc: lcdc@4830e000 {
+			compatible = "ti,am33xx-tilcdc";
+			reg = <0x4830e000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <36>;
+			ti,hwmods = "lcdc";
+			status = "disabled";
+		};
+
 		tscadc: tscadc@44e0d000 {
 			compatible = "ti,am3359-tscadc";
 			reg = <0x44e0d000 0x1000>;
-- 
1.8.1.2

