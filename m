Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaE1SdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:33:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52141 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaE1Sc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:32:59 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] ARM: dts: qcom: Update msm8974/apq8074 device trees
Date: Wed, 28 May 2014 13:32:56 -0500
Message-Id: <1401301976-22506-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move SoC peripherals into an SoC container node
* Move serial enabling into board file (qcom-apq8074-dragonboard.dts)
* Move spi pinctrl into board file
* Cleanup cpu node to match binding spec, enable-method and compatible
  should be per cpu, not part of the container
* Drop interrupts property from l2-cache node as its not part of the
  binding spec
* Move timer node out of SoC container

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
v2:
* Move timer node out of SoC container

 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts | 28 ++++++++++++++-
 arch/arm/boot/dts/qcom-msm8974.dtsi            | 49 ++++++++++----------------
 2 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index 92320c4..b4dfb01 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -4,7 +4,11 @@
 	model = "Qualcomm APQ8074 Dragonboard";
 	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
 
-	soc: soc {
+	soc {
+		serial@f991e000 {
+			status = "ok";
+		};
+
 		sdhci@f9824900 {
 			bus-width = <8>;
 			non-removable;
@@ -15,5 +19,27 @@
 			cd-gpios = <&msmgpio 62 0x1>;
 			bus-width = <4>;
 		};
+
+
+		pinctrl@fd510000 {
+			spi8_default: spi8_default {
+				mosi {
+					pins = "gpio45";
+					function = "blsp_spi8";
+				};
+				miso {
+					pins = "gpio46";
+					function = "blsp_spi8";
+				};
+				cs {
+					pins = "gpio47";
+					function = "blsp_spi8";
+				};
+				clk {
+					pins = "gpio48";
+					function = "blsp_spi8";
+				};
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index c530a33..69dca2a 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -13,10 +13,10 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		interrupts = <1 9 0xf04>;
-		compatible = "qcom,krait";
-		enable-method = "qcom,kpss-acc-v2";
 
 		cpu@0 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <0>;
 			next-level-cache = <&L2>;
@@ -24,6 +24,8 @@
 		};
 
 		cpu@1 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <1>;
 			next-level-cache = <&L2>;
@@ -31,6 +33,8 @@
 		};
 
 		cpu@2 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <2>;
 			next-level-cache = <&L2>;
@@ -38,6 +42,8 @@
 		};
 
 		cpu@3 {
+			compatible = "qcom,krait";
+			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <3>;
 			next-level-cache = <&L2>;
@@ -47,7 +53,6 @@
 		L2: l2-cache {
 			compatible = "cache";
 			cache-level = <2>;
-			interrupts = <0 2 0x4>;
 			qcom,saw = <&saw_l2>;
 		};
 	};
@@ -57,6 +62,15 @@
 		interrupts = <1 7 0xf04>;
 	};
 
+	timer {
+		compatible = "arm,armv7-timer";
+		interrupts = <1 2 0xf08>,
+			     <1 3 0xf08>,
+			     <1 4 0xf08>,
+			     <1 1 0xf08>;
+		clock-frequency = <19200000>;
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -71,15 +85,6 @@
 			      <0xf9002000 0x1000>;
 		};
 
-		timer {
-			compatible = "arm,armv7-timer";
-			interrupts = <1 2 0xf08>,
-				     <1 3 0xf08>,
-				     <1 4 0xf08>,
-				     <1 1 0xf08>;
-			clock-frequency = <19200000>;
-		};
-
 		timer@f9020000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
@@ -190,6 +195,7 @@
 			interrupts = <0 108 0x0>;
 			clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
 			clock-names = "core", "iface";
+			status = "disabled";
 		};
 
 		sdhci@f9824900 {
@@ -229,25 +235,6 @@
 			interrupt-controller;
 			#interrupt-cells = <2>;
 			interrupts = <0 208 0>;
-
-			spi8_default: spi8_default {
-				mosi {
-					pins = "gpio45";
-					function = "blsp_spi8";
-				};
-				miso {
-					pins = "gpio46";
-					function = "blsp_spi8";
-				};
-				cs {
-					pins = "gpio47";
-					function = "blsp_spi8";
-				};
-				clk {
-					pins = "gpio48";
-					function = "blsp_spi8";
-				};
-			};
 		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

