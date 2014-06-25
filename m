Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaFYAIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:08:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaFYAGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:06:31 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC/PATCH 12/12] ARM: dts: qcom: Add necessary DT data for Krait cpufreq
Date: Tue, 24 Jun 2014 17:06:23 -0700
Message-Id: <1403654783-7176-13-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary DT nodes and data so we can probe the cpufreq
driver on MSM devices with Krait CPUs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8960.dtsi |  49 +++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi | 106 ++++++++++++++++++++++++++++++++++--
 2 files changed, 151 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index 5303e53e34dc..94eeca22986f 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -23,6 +23,24 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc0>;
 			qcom,saw = <&saw0>;
+			clocks = <&kraitcc 0>;
+			clock-names = "cpu";
+			operating-points = <
+				/* kHz    ignored */
+				 918000 1000000
+				 864000 1000000
+				 810000 1000000
+				 756000 1000000
+				 702000 1000000
+				 648000 1000000
+				 594000 1000000
+				 540000 1000000
+				 486000 1000000
+				 432000 1000000
+				 384000 1000000
+			>;
+			clock-latency = <100000>;
+
 		};
 
 		cpu@1 {
@@ -33,6 +51,24 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc1>;
 			qcom,saw = <&saw1>;
+			clocks = <&kraitcc 1>;
+			clock-names = "cpu";
+			operating-points = <
+				/* kHz    ignored */
+				 918000 1000000
+				 864000 1000000
+				 810000 1000000
+				 756000 1000000
+				 702000 1000000
+				 648000 1000000
+				 594000 1000000
+				 540000 1000000
+				 486000 1000000
+				 432000 1000000
+				 384000 1000000
+			>;
+			clock-latency = <100000>;
+
 		};
 
 		L2: l2-cache {
@@ -47,6 +83,11 @@
 		qcom,no-pc-write;
 	};
 
+	kraitcc: clock-controller {
+		compatible = "qcom,krait-cc-v1";
+		#clock-cells = <1>;
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -100,11 +141,19 @@
 		acc0: clock-controller@2088000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
+			clock-output-names = "acpu0_aux";
 		};
 
 		acc1: clock-controller@2098000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x02098000 0x1000>, <0x02008000 0x1000>;
+			clock-output-names = "acpu1_aux";
+		};
+
+		l2cc: clock-controller@2011000 {
+			compatible = "qcom,kpss-gcc";
+			reg = <0x2011000 0x1000>;
+			clock-output-names = "acpu_l2_aux";
 		};
 
 		saw0: regulator@2089000 {
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 69dca2aca25a..e607063b527a 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -14,40 +14,104 @@
 		#size-cells = <0>;
 		interrupts = <1 9 0xf04>;
 
-		cpu@0 {
+		cpu0: cpu@0 {
 			compatible = "qcom,krait";
 			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <0>;
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc0>;
+			clocks = <&kraitcc 0>;
+			clock-names = "cpu";
+			operating-points = <
+				/* kHz    ignored */
+				 960000 1000000
+				 883200 1000000
+				 806400 1000000
+				 729600 1000000
+				 652800 1000000
+				 576000 1000000
+				 499200 1000000
+				 422400 1000000
+				 345600 1000000
+				 300000 1000000
+			>;
+			clock-latency = <100000>;
 		};
 
-		cpu@1 {
+		cpu1: cpu@1 {
 			compatible = "qcom,krait";
 			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <1>;
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc1>;
+			clocks = <&kraitcc 1>;
+			clock-names = "cpu";
+			operating-points = <
+				/* kHz    ignored */
+				 960000 1000000
+				 883200 1000000
+				 806400 1000000
+				 729600 1000000
+				 652800 1000000
+				 576000 1000000
+				 499200 1000000
+				 422400 1000000
+				 345600 1000000
+				 300000 1000000
+			>;
+			clock-latency = <100000>;
 		};
 
-		cpu@2 {
+		cpu2: cpu@2 {
 			compatible = "qcom,krait";
 			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <2>;
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc2>;
+			clocks = <&kraitcc 2>;
+			clock-names = "cpu";
+			operating-points = <
+				/* kHz    ignored */
+				 960000 1000000
+				 883200 1000000
+				 806400 1000000
+				 729600 1000000
+				 652800 1000000
+				 576000 1000000
+				 499200 1000000
+				 422400 1000000
+				 345600 1000000
+				 300000 1000000
+			>;
+			clock-latency = <100000>;
 		};
 
-		cpu@3 {
+		cpu3: cpu@3 {
 			compatible = "qcom,krait";
 			enable-method = "qcom,kpss-acc-v2";
 			device_type = "cpu";
 			reg = <3>;
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc3>;
+			clocks = <&kraitcc 3>;
+			clock-names = "cpu";
+			operating-points = <
+				/* kHz    ignored */
+				 960000 1000000
+				 883200 1000000
+				 806400 1000000
+				 729600 1000000
+				 652800 1000000
+				 576000 1000000
+				 499200 1000000
+				 422400 1000000
+				 345600 1000000
+				 300000 1000000
+			>;
+			clock-latency = <100000>;
 		};
 
 		L2: l2-cache {
@@ -71,6 +135,10 @@
 		clock-frequency = <19200000>;
 	};
 
+	kraitcc: clock-controller {
+		compatible = "qcom,krait-cc-v2";
+		#clock-cells = <1>;
+	};
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -144,6 +212,36 @@
 			};
 		};
 
+		clock-controller@f9016000 {
+			compatible = "qcom,hfpll";
+			reg = <0xf9016000 0x30>;
+			clock-output-names = "hfpll_l2";
+		};
+
+		clock-controller@f908a000 {
+			compatible = "qcom,hfpll";
+			reg = <0xf908a000 0x30>, <0xf900a000 0x30>;
+			clock-output-names = "hfpll0";
+		};
+
+		clock-controller@f909a000 {
+			compatible = "qcom,hfpll";
+			reg = <0xf909a000 0x30>, <0xf900a000 0x30>;
+			clock-output-names = "hfpll1";
+		};
+
+		clock-controller@f90aa000 {
+			compatible = "qcom,hfpll";
+			reg = <0xf90aa000 0x30>, <0xf900a000 0x30>;
+			clock-output-names = "hfpll2";
+		};
+
+		clock-controller@f90ba000 {
+			compatible = "qcom,hfpll";
+			reg = <0xf90ba000 0x30>, <0xf900a000 0x30>;
+			clock-output-names = "hfpll3";
+		};
+
 		saw_l2: regulator@f9012000 {
 			compatible = "qcom,saw2";
 			reg = <0xf9012000 0x1000>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

