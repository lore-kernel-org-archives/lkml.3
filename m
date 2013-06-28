Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3F1NDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:03:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59971 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3F1NDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:03:05 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 5/8] ARM: mxs: dt: cfa10037: make hogpins grabbed by respective drivers
Date: Fri, 28 Jun 2013 15:02:54 +0200
Message-Id: <1372424577-8279-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10037.dts | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/imx28-cfa10037.dts b/arch/arm/boot/dts/imx28-cfa10037.dts
index c2ef3a3..182b99f 100644
--- a/arch/arm/boot/dts/imx28-cfa10037.dts
+++ b/arch/arm/boot/dts/imx28-cfa10037.dts
@@ -22,13 +22,19 @@
 	apb@80000000 {
 		apbh@80000000 {
 			pinctrl@80018000 {
-				pinctrl-names = "default", "default";
-				pinctrl-1 = <&hog_pins_cfa10037>;
-
-				hog_pins_cfa10037: hog-10037@0 {
+				usb_pins_cfa10037: usb-10037@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
 						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
+				mac0_pins_cfa10037: mac0-10037@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
 						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
 					>;
 					fsl,drive-strength = <0>;
@@ -56,7 +62,8 @@
 		mac0: ethernet@800f0000 {
 			phy-mode = "rmii";
 			pinctrl-names = "default";
-			pinctrl-0 = <&mac0_pins_a>;
+			pinctrl-0 = <&mac0_pins_a
+				&mac0_pins_cfa10037>;
 			phy-reset-gpios = <&gpio2 21 0>;
 			phy-reset-duration = <100>;
 			status = "okay";
@@ -68,6 +75,8 @@
 
 		reg_usb1_vbus: usb1_vbus {
 			compatible = "regulator-fixed";
+			pinctrl-names = "default";
+			pinctrl-0 = <&usb_pins_cfa10037>;
 			regulator-name = "usb1_vbus";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
-- 
1.8.1.2

