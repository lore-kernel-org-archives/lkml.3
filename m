Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3F1NDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:03:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59984 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3F1NDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:03:06 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 7/8] ARM: mxs: dt: cfa10055: make hogpins grabbed by respective drivers
Date: Fri, 28 Jun 2013 15:02:56 +0200
Message-Id: <1372424577-8279-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10055.dts | 38 ++++++++++++------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10055.dts b/arch/arm/boot/dts/imx28-cfa10055.dts
index 1581112..171bcbe 100644
--- a/arch/arm/boot/dts/imx28-cfa10055.dts
+++ b/arch/arm/boot/dts/imx28-cfa10055.dts
@@ -23,36 +23,13 @@
 	apb@80000000 {
 		apbh@80000000 {
 			pinctrl@80018000 {
-				pinctrl-names = "default", "default";
-				pinctrl-1 = <&hog_pins_cfa10055
-					&hog_pins_cfa10055_pullup>;
-
-				hog_pins_cfa10055: hog-10055@0 {
-					reg = <0>;
-					fsl,pinmux-ids = <
-						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
-					>;
-					fsl,drive-strength = <0>;
-					fsl,voltage = <1>;
-					fsl,pull-up = <0>;
-				};
-
-				hog_pins_cfa10055_pullup: hog-10055-pullup@0 {
-					reg = <0>;
-					fsl,pinmux-ids = <
-						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
-					>;
-					fsl,drive-strength = <0>;
-					fsl,voltage = <1>;
-					fsl,pull-up = <1>;
-				};
-
 				spi2_pins_cfa10055: spi2-cfa10055@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x2103 /* MX28_PAD_SSP2_SCK__GPIO_2_16 */
 						0x2113 /* MX28_PAD_SSP2_CMD__GPIO_2_17 */
 						0x2123 /* MX28_PAD_SSP2_D0__GPIO_2_18 */
+						0x3053 /* MX28_PAD_AUART1_TX__GPIO_3_5 */
 					>;
 					fsl,drive-strength = <1>;
 					fsl,voltage = <1>;
@@ -98,12 +75,23 @@
 					fsl,voltage = <1>;
 					fsl,pull-up = <0>;
 				};
+
+				lcdif_pins_cfa10055_pullup: lcdif-10055-pullup@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
 			};
 
 			lcdif@80030000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&lcdif_18bit_pins_cfa10055
-					     &lcdif_pins_cfa10055>;
+					     &lcdif_pins_cfa10055
+					     &lcdif_pins_cfa10055_pullup>;
 				display = <&display>;
 				status = "okay";
 
-- 
1.8.1.2

