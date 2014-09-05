Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaIEWtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:49:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43545 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaIEWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:45 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 15/15] ARM: dts: qcom: Add necessary DT data for Krait cpufreq
Date: Fri,  5 Sep 2014 15:47:36 -0700
Message-Id: <1409957256-23729-18-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary DT nodes and data so we can probe the cpufreq
driver on MSM devices with Krait CPUs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

We can go faster than this, but I've limited it to the safe frequencies
until we have regulator support where we would need to increase the
voltages from whatever the bootloader picks before going faster.

 arch/arm/boot/dts/qcom-apq8064.dtsi | 230 ++++++++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8960.dtsi |  49 ++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi | 311 +++++++++++++++++++++++++++++++++++-
 3 files changed, 586 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 92bf793622c3..f01296bdb8f4 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -21,6 +21,9 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc0>;
 			qcom,saw = <&saw0>;
+			clocks = <&kraitcc 0>;
+			clock-names = "cpu";
+			clock-latency = <100000>;
 		};
 
 		cpu@1 {
@@ -31,6 +34,9 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc1>;
 			qcom,saw = <&saw1>;
+			clocks = <&kraitcc 1>;
+			clock-names = "cpu";
+			clock-latency = <100000>;
 		};
 
 		cpu@2 {
@@ -41,6 +47,9 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc2>;
 			qcom,saw = <&saw2>;
+			clocks = <&kraitcc 2>;
+			clock-names = "cpu";
+			clock-latency = <100000>;
 		};
 
 		cpu@3 {
@@ -51,6 +60,9 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc3>;
 			qcom,saw = <&saw3>;
+			clocks = <&kraitcc 3>;
+			clock-names = "cpu";
+			clock-latency = <100000>;
 		};
 
 		L2: l2-cache {
@@ -64,6 +76,214 @@
 		interrupts = <1 10 0x304>;
 	};
 
+	qcom,pvs {
+		qcom,pvs-format-a;
+		qcom,speed0-pvs0-bin-v0 =
+			< 384000000 950000  >,
+			< 486000000 975000  >,
+			< 594000000 1000000  >,
+			< 702000000 1025000  >,
+			< 810000000 1075000  >,
+			< 918000000 1100000  >;
+
+		qcom,speed0-pvs1-bin-v0 =
+			< 384000000 900000  >,
+			< 486000000 925000  >,
+			< 594000000 950000  >,
+			< 702000000 975000  >,
+			< 810000000 1025000  >,
+			< 918000000 1050000  >;
+
+		qcom,speed0-pvs3-bin-v0 =
+			< 384000000 850000  >,
+			< 486000000 875000  >,
+			< 594000000 900000  >,
+			< 702000000 925000  >,
+			< 810000000 975000  >,
+			< 918000000 1000000  >;
+
+		qcom,speed0-pvs4-bin-v0 =
+			< 384000000 850000  >,
+			< 486000000 875000  >,
+			< 594000000 900000  >,
+			< 702000000 925000  >,
+			< 810000000 962500  >,
+			< 918000000 975000  >;
+
+		qcom,speed1-pvs0-bin-v0 =
+			< 384000000 950000  >,
+			< 486000000 950000  >,
+			< 594000000 950000  >,
+			< 702000000 962500  >,
+			< 810000000 1000000  >,
+			< 918000000 1025000  >;
+
+		qcom,speed1-pvs1-bin-v0 =
+			< 384000000 950000  >,
+			< 486000000 950000  >,
+			< 594000000 950000  >,
+			< 702000000 962500  >,
+			< 810000000 975000  >,
+			< 918000000 1000000  >;
+
+		qcom,speed1-pvs2-bin-v0 =
+			< 384000000 925000  >,
+			< 486000000 925000  >,
+			< 594000000 925000  >,
+			< 702000000 925000  >,
+			< 810000000 937500  >,
+			< 918000000 950000  >;
+
+		qcom,speed1-pvs3-bin-v0 =
+			< 384000000 900000  >,
+			< 486000000 900000  >,
+			< 594000000 900000  >,
+			< 702000000 900000  >,
+			< 810000000 900000  >,
+			< 918000000 925000  >;
+
+		qcom,speed1-pvs4-bin-v0 =
+			< 384000000 875000  >,
+			< 486000000 875000  >,
+			< 594000000 875000  >,
+			< 702000000 875000  >,
+			< 810000000 887500  >,
+			< 918000000 900000  >;
+
+		qcom,speed1-pvs5-bin-v0 =
+			< 384000000 875000  >,
+			< 486000000 875000  >,
+			< 594000000 875000  >,
+			< 702000000 875000  >,
+			< 810000000 887500  >,
+			< 918000000 900000  >;
+
+		qcom,speed1-pvs6-bin-v0 =
+			< 384000000 875000  >,
+			< 486000000 875000  >,
+			< 594000000 875000  >,
+			< 702000000 875000  >,
+			< 810000000 887500  >,
+			< 918000000 900000  >;
+
+		qcom,speed2-pvs0-bin-v0 =
+			< 384000000 950000  >,
+			< 486000000 950000  >,
+			< 594000000 950000  >,
+			< 702000000 950000  >,
+			< 810000000 962500  >,
+			< 918000000 975000  >;
+
+		qcom,speed2-pvs1-bin-v0 =
+			< 384000000 925000  >,
+			< 486000000 925000  >,
+			< 594000000 925000  >,
+			< 702000000 925000  >,
+			< 810000000 937500  >,
+			< 918000000 950000  >;
+
+		qcom,speed2-pvs2-bin-v0 =
+			< 384000000 900000  >,
+			< 486000000 900000  >,
+			< 594000000 900000  >,
+			< 702000000 900000  >,
+			< 810000000 912500  >,
+			< 918000000 925000  >;
+
+		qcom,speed2-pvs3-bin-v0 =
+			< 384000000 900000  >,
+			< 486000000 900000  >,
+			< 594000000 900000  >,
+			< 702000000 900000  >,
+			< 810000000 900000  >,
+			< 918000000 912500  >;
+
+		qcom,speed2-pvs4-bin-v0 =
+			< 384000000 875000  >,
+			< 486000000 875000  >,
+			< 594000000 875000  >,
+			< 702000000 875000  >,
+			< 810000000 887500  >,
+			< 918000000 900000  >;
+
+		qcom,speed2-pvs5-bin-v0 =
+			< 384000000 875000  >,
+			< 486000000 875000  >,
+			< 594000000 875000  >,
+			< 702000000 875000  >,
+			< 810000000 887500  >,
+			< 918000000 900000  >;
+
+		qcom,speed2-pvs6-bin-v0 =
+			< 384000000 875000  >,
+			< 486000000 875000  >,
+			< 594000000 875000  >,
+			< 702000000 875000  >,
+			< 810000000 887500  >,
+			< 918000000 900000  >;
+
+		qcom,speed14-pvs0-bin-v0 =
+			< 384000000 950000 >,
+			< 486000000 950000 >,
+			< 594000000 950000 >,
+			< 702000000 962500 >,
+			< 810000000 1000000 >,
+			< 918000000 1025000 >;
+
+		qcom,speed14-pvs1-bin-v0 =
+			< 384000000 950000 >,
+			< 486000000 950000 >,
+			< 594000000 950000 >,
+			< 702000000 962500 >,
+			< 810000000 975000 >,
+			< 918000000 1000000 >;
+
+		qcom,speed14-pvs2-bin-v0 =
+			< 384000000 925000 >,
+			< 486000000 925000 >,
+			< 594000000 925000 >,
+			< 702000000 925000 >,
+			< 810000000 937500 >,
+			< 918000000 950000 >;
+
+		qcom,speed14-pvs3-bin-v0 =
+			< 384000000 900000 >,
+			< 486000000 900000 >,
+			< 594000000 900000 >,
+			< 702000000 900000 >,
+			< 810000000 900000 >,
+			< 918000000 925000 >;
+
+		qcom,speed14-pvs4-bin-v0 =
+			< 384000000 875000 >,
+			< 486000000 875000 >,
+			< 594000000 875000 >,
+			< 702000000 875000 >,
+			< 810000000 887500 >,
+			< 918000000 900000 >;
+
+		qcom,speed14-pvs5-bin-v0 =
+			< 384000000 875000 >,
+			< 486000000 875000 >,
+			< 594000000 875000 >,
+			< 702000000 875000 >,
+			< 810000000 887500 >,
+			< 918000000 900000 >;
+
+		qcom,speed14-pvs6-bin-v0 =
+			< 384000000 875000 >,
+			< 486000000 875000 >,
+			< 594000000 875000 >,
+			< 702000000 875000 >,
+			< 810000000 887500 >,
+			< 918000000 900000 >;
+	};
+
+	kraitcc: clock-controller {
+		compatible = "qcom,krait-cc-v1";
+		#clock-cells = <1>;
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -92,21 +312,31 @@
 		acc0: clock-controller@2088000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
+			clock-output-names = "acpu0_aux";
 		};
 
 		acc1: clock-controller@2098000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x02098000 0x1000>, <0x02008000 0x1000>;
+			clock-output-names = "acpu1_aux";
 		};
 
 		acc2: clock-controller@20a8000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x020a8000 0x1000>, <0x02008000 0x1000>;
+			clock-output-names = "acpu2_aux";
 		};
 
 		acc3: clock-controller@20b8000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x020b8000 0x1000>, <0x02008000 0x1000>;
+			clock-output-names = "acpu3_aux";
+		};
+
+		l2cc: clock-controller@2011000 {
+			compatible = "qcom,kpss-gcc";
+			reg = <0x2011000 0x1000>;
+			clock-output-names = "acpu_l2_aux";
 		};
 
 		saw0: regulator@2089000 {
diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index 5303e53e34dc..c034e3df2679 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -23,6 +23,10 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc0>;
 			qcom,saw = <&saw0>;
+			clocks = <&kraitcc 0>;
+			clock-names = "cpu";
+			clock-latency = <100000>;
+
 		};
 
 		cpu@1 {
@@ -33,6 +37,10 @@
 			next-level-cache = <&L2>;
 			qcom,acc = <&acc1>;
 			qcom,saw = <&saw1>;
+			clocks = <&kraitcc 1>;
+			clock-names = "cpu";
+			clock-latency = <100000>;
+
 		};
 
 		L2: l2-cache {
@@ -47,6 +55,39 @@
 		qcom,no-pc-write;
 	};
 
+	qcom,pvs {
+		qcom,pvs-format-a;
+			/* Hz		uV */
+		qcom,speed0-pvs0-bin-v0 =
+			<  384000000  950000 >,
+			<  486000000  975000 >,
+			<  594000000 1000000 >,
+			<  702000000 1025000 >,
+			<  810000000 1075000 >,
+			<  918000000 1100000 >;
+
+		qcom,speed0-pvs1-bin-v0 =
+			<  384000000  900000 >,
+			<  486000000  925000 >,
+			<  594000000  950000 >,
+			<  702000000  975000 >,
+			<  810000000 1025000 >,
+			<  918000000 1050000 >;
+
+		qcom,speed0-pvs3-bin-v0 =
+			<  384000000  850000 >,
+			<  486000000  875000 >,
+			<  594000000  900000 >,
+			<  702000000  925000 >,
+			<  810000000  975000 >,
+			<  918000000 1000000 >;
+	};
+
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
index 69dca2aca25a..567a40186136 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -14,40 +14,52 @@
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
+			clock-latency = <100000>;
 		};
 
 		L2: l2-cache {
@@ -71,6 +83,267 @@
 		clock-frequency = <19200000>;
 	};
 
+	qcom,pvs {
+		qcom,pvs-format-b;
+			/* Hz		uV	ua */
+		qcom,speed0-pvs0-bin-v0 =
+			<  300000000  815000  73 >,
+			<  345600000  825000  85 >,
+			<  422400000  835000 104 >,
+			<  499200000  845000 124 >,
+			<  576000000  855000 144 >,
+			<  652800000  865000 165 >,
+			<  729600000  875000 186 >,
+			<  806400000  890000 208 >,
+			<  883200000  900000 229 >,
+			<  960000000  915000 252 >;
+
+		qcom,speed0-pvs1-bin-v0 =
+			<  300000000  800000  73 >,
+			<  345600000  810000  85 >,
+			<  422400000  820000 104 >,
+			<  499200000  830000 124 >,
+			<  576000000  840000 144 >,
+			<  652800000  850000 165 >,
+			<  729600000  860000 186 >,
+			<  806400000  875000 208 >,
+			<  883200000  885000 229 >,
+			<  960000000  895000 252 >;
+
+		qcom,speed0-pvs2-bin-v0 =
+			<  300000000  785000  73 >,
+			<  345600000  795000  85 >,
+			<  422400000  805000 104 >,
+			<  499200000  815000 124 >,
+			<  576000000  825000 144 >,
+			<  652800000  835000 165 >,
+			<  729600000  845000 186 >,
+			<  806400000  855000 208 >,
+			<  883200000  865000 229 >,
+			<  960000000  875000 252 >;
+
+		qcom,speed0-pvs3-bin-v0 =
+			<  300000000  775000  73 >,
+			<  345600000  780000  85 >,
+			<  422400000  790000 104 >,
+			<  499200000  800000 124 >,
+			<  576000000  810000 144 >,
+			<  652800000  820000 165 >,
+			<  729600000  830000 186 >,
+			<  806400000  840000 208 >,
+			<  883200000  850000 229 >,
+			<  960000000  860000 252 >;
+
+		qcom,speed0-pvs4-bin-v0 =
+			<  300000000  775000  73 >,
+			<  345600000  775000  85 >,
+			<  422400000  780000 104 >,
+			<  499200000  790000 124 >,
+			<  576000000  800000 144 >,
+			<  652800000  810000 165 >,
+			<  729600000  820000 186 >,
+			<  806400000  830000 208 >,
+			<  883200000  840000 229 >,
+			<  960000000  850000 252 >;
+
+		qcom,speed0-pvs5-bin-v0 =
+			<  300000000  750000  73 >,
+			<  345600000  760000  85 >,
+			<  422400000  770000 104 >,
+			<  499200000  780000 124 >,
+			<  576000000  790000 144 >,
+			<  652800000  800000 165 >,
+			<  729600000  810000 186 >,
+			<  806400000  820000 208 >,
+			<  883200000  830000 229 >,
+			<  960000000  840000 252 >;
+
+		qcom,speed0-pvs6-bin-v0 =
+			<  300000000  750000  73 >,
+			<  345600000  750000  85 >,
+			<  422400000  760000 104 >,
+			<  499200000  770000 124 >,
+			<  576000000  780000 144 >,
+			<  652800000  790000 165 >,
+			<  729600000  800000 186 >,
+			<  806400000  810000 208 >,
+			<  883200000  820000 229 >,
+			<  960000000  830000 252 >;
+
+		qcom,speed2-pvs0-bin-v0 =
+			<  300000000  800000  72 >,
+			<  345600000  800000  83 >,
+			<  422400000  805000 102 >,
+			<  499200000  815000 121 >,
+			<  576000000  825000 141 >,
+			<  652800000  835000 161 >,
+			<  729600000  845000 181 >,
+			<  806400000  855000 202 >,
+			<  883200000  865000 223 >,
+			<  960000000  875000 245 >;
+
+		qcom,speed2-pvs1-bin-v0 =
+			<  300000000  800000  72 >,
+			<  345600000  800000  83 >,
+			<  422400000  800000 102 >,
+			<  499200000  800000 121 >,
+			<  576000000  810000 141 >,
+			<  652800000  820000 161 >,
+			<  729600000  830000 181 >,
+			<  806400000  840000 202 >,
+			<  883200000  850000 223 >,
+			<  960000000  860000 245 >;
+
+		qcom,speed2-pvs2-bin-v0 =
+			<  300000000  775000  72 >,
+			<  345600000  775000  83 >,
+			<  422400000  775000 102 >,
+			<  499200000  785000 121 >,
+			<  576000000  795000 141 >,
+			<  652800000  805000 161 >,
+			<  729600000  815000 181 >,
+			<  806400000  825000 202 >,
+			<  883200000  835000 223 >,
+			<  960000000  845000 245 >;
+
+		qcom,speed2-pvs3-bin-v0 =
+			<  300000000  775000  72 >,
+			<  345600000  775000  83 >,
+			<  422400000  775000 102 >,
+			<  499200000  775000 121 >,
+			<  576000000  780000 141 >,
+			<  652800000  790000 161 >,
+			<  729600000  800000 181 >,
+			<  806400000  810000 202 >,
+			<  883200000  820000 223 >,
+			<  960000000  830000 245 >;
+
+		qcom,speed2-pvs4-bin-v0 =
+			<  300000000  775000  72 >,
+			<  345600000  775000  83 >,
+			<  422400000  775000 102 >,
+			<  499200000  775000 121 >,
+			<  576000000  775000 141 >,
+			<  652800000  780000 161 >,
+			<  729600000  790000 181 >,
+			<  806400000  800000 202 >,
+			<  883200000  810000 223 >,
+			<  960000000  820000 245 >;
+
+		qcom,speed2-pvs5-bin-v0 =
+			<  300000000  750000  72 >,
+			<  345600000  750000  83 >,
+			<  422400000  750000 102 >,
+			<  499200000  750000 121 >,
+			<  576000000  760000 141 >,
+			<  652800000  770000 161 >,
+			<  729600000  780000 181 >,
+			<  806400000  790000 202 >,
+			<  883200000  800000 223 >,
+			<  960000000  810000 245 >;
+
+		qcom,speed2-pvs6-bin-v0 =
+			<  300000000  750000  72 >,
+			<  345600000  750000  83 >,
+			<  422400000  750000 102 >,
+			<  499200000  750000 121 >,
+			<  576000000  750000 141 >,
+			<  652800000  760000 161 >,
+			<  729600000  770000 181 >,
+			<  806400000  780000 202 >,
+			<  883200000  790000 223 >,
+			<  960000000  800000 245 >;
+
+		qcom,speed1-pvs0-bin-v0 =
+			<  300000000  775000  72 >,
+			<  345600000  775000  83 >,
+			<  422400000  775000 101 >,
+			<  499200000  780000 120 >,
+			<  576000000  790000 139 >,
+			<  652800000  800000 159 >,
+			<  729600000  810000 180 >,
+			<  806400000  820000 200 >,
+			<  883200000  830000 221 >,
+			<  960000000  840000 242 >;
+
+		qcom,speed1-pvs1-bin-v0 =
+			<  300000000  775000  72 >,
+			<  345600000  775000  83 >,
+			<  422400000  775000 101 >,
+			<  499200000  775000 120 >,
+			<  576000000  775000 139 >,
+			<  652800000  785000 159 >,
+			<  729600000  795000 180 >,
+			<  806400000  805000 200 >,
+			<  883200000  815000 221 >,
+			<  960000000  825000 242 >;
+
+		qcom,speed1-pvs2-bin-v0 =
+			<  300000000  750000  72 >,
+			<  345600000  750000  83 >,
+			<  422400000  750000 101 >,
+			<  499200000  750000 120 >,
+			<  576000000  760000 139 >,
+			<  652800000  770000 159 >,
+			<  729600000  780000 180 >,
+			<  806400000  790000 200 >,
+			<  883200000  800000 221 >,
+			<  960000000  810000 242 >;
+
+		qcom,speed1-pvs3-bin-v0 =
+			<  300000000  750000  72 >,
+			<  345600000  750000  83 >,
+			<  422400000  750000 101 >,
+			<  499200000  750000 120 >,
+			<  576000000  750000 139 >,
+			<  652800000  755000 159 >,
+			<  729600000  765000 180 >,
+			<  806400000  775000 200 >,
+			<  883200000  785000 221 >,
+			<  960000000  795000 242 >;
+
+		qcom,speed1-pvs4-bin-v0 =
+			<  300000000  750000  72 >,
+			<  345600000  750000  83 >,
+			<  422400000  750000 101 >,
+			<  499200000  750000 120 >,
+			<  576000000  750000 139 >,
+			<  652800000  750000 159 >,
+			<  729600000  755000 180 >,
+			<  806400000  765000 200 >,
+			<  883200000  775000 221 >,
+			<  960000000  785000 242 >;
+
+		qcom,speed1-pvs5-bin-v0 =
+			<  300000000  725000  72 >,
+			<  345600000  725000  83 >,
+			<  422400000  725000 101 >,
+			<  499200000  725000 120 >,
+			<  576000000  725000 139 >,
+			<  652800000  735000 159 >,
+			<  729600000  745000 180 >,
+			<  806400000  755000 200 >,
+			<  883200000  765000 221 >,
+			<  960000000  775000 242 >;
+
+		qcom,speed1-pvs6-bin-v0 =
+			<  300000000  725000  72 >,
+			<  345600000  725000  83 >,
+			<  422400000  725000 101 >,
+			<  499200000  725000 120 >,
+			<  576000000  725000 139 >,
+			<  652800000  725000 159 >,
+			<  729600000  735000 180 >,
+			<  806400000  745000 200 >,
+			<  883200000  755000 221 >,
+			<  960000000  765000 242 >;
+	};
+
+	kraitcc: clock-controller {
+		compatible = "qcom,krait-cc-v2";
+		#clock-cells = <1>;
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -144,6 +417,36 @@
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

