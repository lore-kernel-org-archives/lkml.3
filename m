Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaIPLsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:48:10 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:36118 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbaIPLsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:48:07 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        davidb@codeaurora.org, afaerber@suse.de
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] ARM: dts: qcom: Add I2C dt node for MSM8974 and DB8074 board
Date: Tue, 16 Sep 2014 17:15:38 +0530
Message-Id: <1410867938-6254-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for i2c controller on the DB8074 board.
It also adds necessary DT support for i2c eeprom which is present on
DB8074 board.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |   21 +++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi            |   15 +++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index b4dfb01..4737049 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -22,6 +22,13 @@
 
 
 		pinctrl@fd510000 {
+			i2c11_pins: i2c11 {
+				mux {
+					pins = "gpio83", "gpio84";
+					function = "blsp_i2c11";
+				};
+			};
+
 			spi8_default: spi8_default {
 				mosi {
 					pins = "gpio45";
@@ -41,5 +48,19 @@
 				};
 			};
 		};
+
+		i2c@f9967000 {
+			status = "okay";
+			clock-frequency = <200000>;
+			pinctrl-0 = <&i2c11_pins>;
+			pinctrl-names = "default";
+
+			eeprom: eeprom@52 {
+				compatible = "atmel,24c128";
+				reg = <0x52>;
+				pagesize = <32>;
+				read-only;
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 69dca2a..e265ec1 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1,8 +1,8 @@
 /dts-v1/;
 
-#include "skeleton.dtsi"
-
+#include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/clock/qcom,gcc-msm8974.h>
+#include "skeleton.dtsi"
 
 / {
 	model = "Qualcomm MSM8974";
@@ -236,5 +236,16 @@
 			#interrupt-cells = <2>;
 			interrupts = <0 208 0>;
 		};
+
+		blsp_i2c11: i2c@f9967000 {
+			status = "disable";
+			compatible = "qcom,i2c-qup-v2.1.1";
+			reg = <0xf9967000 0x1000>;
+			interrupts = <0 105 IRQ_TYPE_NONE>;
+			clocks = <&gcc GCC_BLSP2_QUP5_I2C_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
+			clock-names = "core", "iface";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
 	};
 };
-- 
1.7.9.5

