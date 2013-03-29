Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3C2Sr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:47:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43029 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3C2SrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:47:24 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Rpard <maxime.ripard@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: cfa10036: add one wire bitbanging to the cfa10049
Date: Fri, 29 Mar 2013 19:46:41 +0100
Message-Id: <1364582801-15087-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index ded7784..b9dad4e 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -30,7 +30,6 @@
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
-						0x1153 /* MX28_PAD_LCD_D22__GPIO_1_21 */
 						0x1163 /* MX28_PAD_LCD_D22__GPIO_1_22 */
 						0x1173 /* MX28_PAD_LCD_D22__GPIO_1_23 */
 						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
@@ -120,6 +119,16 @@
 					fsl,voltage = <1>;
 					fsl,pull-up = <0>;
 				};
+
+				w1_gpio_pins: w1-gpio@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x1153 /* MX28_PAD_LCD_D21__GPIO_1_21 */
+					>;
+					fsl,drive-strength = <1>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>; /* 0 will enable the keeper */
+				};
 			};
 
 			lcdif@80030000 {
@@ -304,5 +313,14 @@
 		pwms = <&pwm 3 5000000>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+
+	};
+
+	onewire@0 {
+		compatible = "w1-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&w1_gpio_pins>;
+		status = "okay";
+		gpios = <&gpio1 21 0>;
 	};
 };
-- 
1.7.10.4

