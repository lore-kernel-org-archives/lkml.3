Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaIQKdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:33:13 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:35075 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbaIQKdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:33:11 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: galak@codeaurora.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        davidb@codeaurora.org, afaerber@suse.de
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH v4] ARM: DT: apq8064: Add i2c device nodes
Date: Wed, 17 Sep 2014 16:00:25 +0530
Message-Id: <1410949825-7631-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds i2c pinctrl DT node for IFC6410 board.
It also adds necessary DT support for i2c eeprom which is present on
IFC6410.

Tested on IFC6410 board.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
Changes since v3:
 - Removed pinctrl DT node.

Changes since v2:
 - Renamed pinmux i2c subnode "i2c1_pinmux" to "i2c1".
 - Removed labes of node.
 - Used canonical value as "okay" instead of "ok".
 - Used macros.

Changes since v1:
 - Renamed pinmux phandle "qcom_pinmux" to "tlmm_pinmux".
 - Updated pinmux interrupt.

 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |   27 ++++++++++++++++++
 arch/arm/boot/dts/qcom-apq8064.dtsi        |   42 ++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
index 90db8af..3573cd7 100644
--- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
+++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
@@ -5,6 +5,33 @@
 	compatible = "qcom,apq8064-ifc6410", "qcom,apq8064";
 
 	soc {
+		pinctrl@800000 {
+			i2c1_pins: i2c1 {
+				mux {
+					pins = "gpio20", "gpio21";
+					function = "gsbi1";
+				};
+			};
+		};
+
+		gsbi@12440000 {
+			status = "okay";
+			qcom,mode = <GSBI_PROT_I2C>;
+
+			i2c@12460000 {
+				status = "okay";
+				clock-frequency = <200000>;
+				pinctrl-0 = <&i2c1_pins>;
+				pinctrl-names = "default";
+
+				eeprom: eeprom@52 {
+					compatible = "atmel,24c128";
+					reg = <0x52>;
+					pagesize = <32>;
+				};
+			};
+		};
+
 		gsbi@16600000 {
 			status = "ok";
 			qcom,mode = <GSBI_PROT_I2C_UART>;
diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index b1e476a..fddaeb7 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -156,6 +156,48 @@
 			regulator;
 		};
 
+		gsbi1: gsbi@12440000 {
+			status = "disabled";
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x12440000 0x100>;
+			clocks = <&gcc GSBI1_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			i2c1: i2c@12460000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x12460000 0x1000>;
+				interrupts = <0 194 IRQ_TYPE_NONE>;
+				clocks = <&gcc GSBI1_QUP_CLK>, <&gcc GSBI1_H_CLK>;
+				clock-names = "core", "iface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
+		gsbi2: gsbi@12480000 {
+			status = "disabled";
+			compatible = "qcom,gsbi-v1.0.0";
+			reg = <0x12480000 0x100>;
+			clocks = <&gcc GSBI2_H_CLK>;
+			clock-names = "iface";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			i2c2: i2c@124a0000 {
+				compatible = "qcom,i2c-qup-v1.1.1";
+				reg = <0x124a0000 0x1000>;
+				interrupts = <0 196 IRQ_TYPE_NONE>;
+				clocks = <&gcc GSBI2_QUP_CLK>, <&gcc GSBI2_H_CLK>;
+				clock-names = "core", "iface";
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
+
 		gsbi7: gsbi@16600000 {
 			status = "disabled";
 			compatible = "qcom,gsbi-v1.0.0";
-- 
1.7.9.5

