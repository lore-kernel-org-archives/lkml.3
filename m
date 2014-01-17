Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaAQBZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:25:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43111 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaAQBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:25:13 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 1/2] ARM: dts: msm: Add clock controller nodes and hook into uart
Date: Thu, 16 Jan 2014 17:25:03 -0800
Message-Id: <1389921904-3777-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org>
References: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary DT nodes to probe the clock controllers on MSM
devices as well as hook up the uart nodes to the clock
controllers. This should allow us to boot to a serial console on
all DT enabled MSM platforms.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8660-surf.dts | 11 +++++++++++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts  | 18 ++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi     | 24 ++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
index 1187185cf25b..68a72f5507b9 100644
--- a/arch/arm/boot/dts/qcom-msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom-msm8660-surf.dts
@@ -2,6 +2,8 @@
 
 /include/ "skeleton.dtsi"
 
+#include <dt-bindings/clock/qcom,gcc-msm8660.h>
+
 / {
 	model = "Qualcomm MSM8660 SURF";
 	compatible = "qcom,msm8660-surf", "qcom,msm8660";
@@ -37,11 +39,20 @@
 		#interrupt-cells = <2>;
 	};
 
+	gcc: clock-controller@900000 {
+		compatible = "qcom,gcc-msm8660";
+		#clock-cells = <1>;
+		#reset-cells = <1>;
+		reg = <0x900000 0x4000>;
+	};
+
 	serial@19c40000 {
 		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 		reg = <0x19c40000 0x1000>,
 		      <0x19c00000 0x1000>;
 		interrupts = <0 195 0x0>;
+		clocks = <&gcc GSBI12_UART_CLK>, <&gcc GSBI12_H_CLK>;
+		clock-names = "core", "iface";
 	};
 
 	qcom,ssbi@500000 {
diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index 6ccbac77931e..7c30de4fa302 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -2,6 +2,8 @@
 
 /include/ "skeleton.dtsi"
 
+#include <dt-bindings/clock/qcom,gcc-msm8960.h>
+
 / {
 	model = "Qualcomm MSM8960 CDP";
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
@@ -37,11 +39,27 @@
 		reg = <0x800000 0x4000>;
 	};
 
+	gcc: clock-controller@900000 {
+		compatible = "qcom,gcc-msm8960";
+		#clock-cells = <1>;
+		#reset-cells = <1>;
+		reg = <0x900000 0x4000>;
+	};
+
+	clock-controller@4000000 {
+		compatible = "qcom,mmcc-msm8960";
+		reg = <0x4000000 0x1000>;
+		#clock-cells = <1>;
+		#reset-cells = <1>;
+	};
+
 	serial@16440000 {
 		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 		reg = <0x16440000 0x1000>,
 		      <0x16400000 0x1000>;
 		interrupts = <0 154 0x0>;
+		clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
+		clock-names = "core", "iface";
 	};
 
 	qcom,ssbi@500000 {
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 6ac94967d2d3..9e5dadb101eb 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -2,6 +2,8 @@
 
 #include "skeleton.dtsi"
 
+#include <dt-bindings/clock/qcom,gcc-msm8974.h>
+
 / {
 	model = "Qualcomm MSM8974";
 	compatible = "qcom,msm8974";
@@ -93,5 +95,27 @@
 			compatible = "qcom,pshold";
 			reg = <0xfc4ab000 0x4>;
 		};
+
+		gcc: clock-controller@fc400000 {
+			compatible = "qcom,gcc-msm8974";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			reg = <0xfc400000 0x4000>;
+		};
+
+		mmcc: clock-controller@fd8c0000 {
+			compatible = "qcom,mmcc-msm8974";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			reg = <0xfd8c0000 0x6000>;
+		};
+
+		serial@f991e000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf991e000 0x1000>;
+			interrupts = <0 108 0x0>;
+			clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
+			clock-names = "core", "iface";
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

