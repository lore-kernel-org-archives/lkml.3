Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3KAWJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:09:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48607 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3KAWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 10/11] ARM: dts: msm: Add nodes necessary for SMP boot
Date: Fri,  1 Nov 2013 15:08:58 -0700
Message-Id: <1383343739-23080-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Add the necessary nodes to support SMP on MSM8960 and
MSM8974/APQ8074. While we're here also add in the error
interrupts for the krait cache error detection.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
[sboyd: Split into separate patch, add error interrupts]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8960-cdp.dts | 32 ++++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi    | 49 ++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
index 91efaec..0621037c 100644
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@ -9,6 +9,32 @@
 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <1 14 0x304>;
+		compatible = "qcom,krait";
+		enable-method = "qcom,mmio";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2>;
+		};
+
+		L2: l2-cache {
+			compatible = "cache";
+			cache-level = <2>;
+			interrupts = <0 2 0x4>;
+		};
+	};
+
 	intc: interrupt-controller@2000000 {
 		compatible = "qcom,msm-qgic2";
 		interrupt-controller;
@@ -53,6 +79,12 @@
 		#reset-cells = <1>;
 	};
 
+	clock-controller@2008000 {
+		compatible = "qcom,kpss-acc-v1";
+		reg = <0x02008000 0x1000>;
+		cpu-offset = <0x80000>;
+	};
+
 	serial@16440000 {
 		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 		reg = <0x16440000 0x1000>,
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 152879d..0eac2ea 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -9,6 +9,44 @@
 	compatible = "qcom,msm8974";
 	interrupt-parent = <&intc>;
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <1 9 0xf04>;
+		compatible = "qcom,krait";
+		enable-method = "qcom,mmio";
+
+		cpu@0 {
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@1 {
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@2 {
+			device_type = "cpu";
+			reg = <2>;
+			next-level-cache = <&L2>;
+		};
+
+		cpu@3 {
+			device_type = "cpu";
+			reg = <3>;
+			next-level-cache = <&L2>;
+		};
+
+		L2: l2-cache {
+			compatible = "cache";
+			cache-level = <2>;
+			interrupts = <0 2 0x4>;
+		};
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -91,6 +129,17 @@
 			};
 		};
 
+		regulator@f9012000 {
+			compatible = "qcom,l2-saw2", "qcom,saw2";
+			reg = <0xf9012000 0x1000>;
+		};
+
+		clock-controller@f9008000 {
+			compatible = "qcom,kpss-acc-v2";
+			reg = <0xf9008000 0x1000>;
+			cpu-offset = <0x80000>;
+		};
+
 		restart@fc4ab000 {
 			compatible = "qcom,pshold";
 			reg = <0xfc4ab000 0x4>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

