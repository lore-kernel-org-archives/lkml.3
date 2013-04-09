Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936838Ab3DIJZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:25:32 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:35127 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936809Ab3DIJZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:25:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: <Yuantian.Tang@freescale.com>
To: <mturquette@linaro.org>
CC: <linus.walleij@linaro.org>, <viresh.kumar@linaro.org>,
        <shawn.guo@linaro.org>, <ulf.hansson@linaro.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        Tang Yuantian <Yuantian.Tang@freescale.com>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH] powerpc/mpc85xx: Update the clock device tree nodes
Date: Tue, 9 Apr 2013 16:46:27 +0800
Message-ID: <1365497187-8305-2-git-send-email-Yuantian.Tang@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1365497187-8305-1-git-send-email-Yuantian.Tang@freescale.com>
References: <1365497187-8305-1-git-send-email-Yuantian.Tang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Yuantian <yuantian.tang@freescale.com>

The following SoCs will be affected: p2041, p3041, p4080,
p5020, p5040

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
* resend for review

 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi |  62 ++++++++++++++++-
 arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi  |   4 ++
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi |  62 ++++++++++++++++-
 arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi  |   4 ++
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi | 100 +++++++++++++++++++++++++++-
 arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi  |   8 +++
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi |  42 +++++++++++-
 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi  |   2 +
 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi |  54 ++++++++++++++-
 arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi  |   4 ++
 10 files changed, 337 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi b/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
index 69ac1ac..d83de62 100644
--- a/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
@@ -305,9 +305,69 @@
 	};
 
 	clockgen: global-utilities@e1000 {
-		compatible = "fsl,p2041-clockgen", "fsl,qoriq-clockgen-1.0";
+		compatible = "fsl,p2041-clockgen", "fsl,qoriq-clockgen-1.0",
+				   "fixed-clock";
 		reg = <0xe1000 0x1000>;
 		clock-frequency = <0>;
+		clock-output-names = "sysclk";
+		#clock-cells = <0>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pll0: pll0@800 {
+			#clock-cells = <1>;
+			reg = <0x800>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll0", "pll0-div2", "pll0-div4";
+		};
+		pll1: pll1@820 {
+			#clock-cells = <1>;
+			reg = <0x820>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll1", "pll1-div2", "pll1-div4";
+		};
+		mux0: mux0@0 {
+			#clock-cells = <0>;
+			reg = <0x0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				   <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux0";
+		};
+		mux1: mux1@20 {
+			#clock-cells = <0>;
+			reg = <0x20>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				   <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux1";
+		};
+		mux2: mux2@40 {
+			#clock-cells = <0>;
+			reg = <0x40>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				   <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux2";
+		};
+		mux3: mux3@60 {
+			#clock-cells = <0>;
+			reg = <0x60>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				   <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux3";
+		};
 	};
 
 	rcpm: global-utilities@e2000 {
diff --git a/arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi b/arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi
index 7a2697d..22f3b14 100644
--- a/arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi
@@ -81,6 +81,7 @@
 		cpu0: PowerPC,e500mc@0 {
 			device_type = "cpu";
 			reg = <0>;
+			clocks = <&mux0>;
 			next-level-cache = <&L2_0>;
 			L2_0: l2-cache {
 				next-level-cache = <&cpc>;
@@ -89,6 +90,7 @@
 		cpu1: PowerPC,e500mc@1 {
 			device_type = "cpu";
 			reg = <1>;
+			clocks = <&mux1>;
 			next-level-cache = <&L2_1>;
 			L2_1: l2-cache {
 				next-level-cache = <&cpc>;
@@ -97,6 +99,7 @@
 		cpu2: PowerPC,e500mc@2 {
 			device_type = "cpu";
 			reg = <2>;
+			clocks = <&mux2>;
 			next-level-cache = <&L2_2>;
 			L2_2: l2-cache {
 				next-level-cache = <&cpc>;
@@ -105,6 +108,7 @@
 		cpu3: PowerPC,e500mc@3 {
 			device_type = "cpu";
 			reg = <3>;
+			clocks = <&mux3>;
 			next-level-cache = <&L2_3>;
 			L2_3: l2-cache {
 				next-level-cache = <&cpc>;
diff --git a/arch/powerpc/boot/dts/fsl/p3041si-post.dtsi b/arch/powerpc/boot/dts/fsl/p3041si-post.dtsi
index 9b5a81a..25b19cc 100644
--- a/arch/powerpc/boot/dts/fsl/p3041si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p3041si-post.dtsi
@@ -332,9 +332,69 @@
 	};
 
 	clockgen: global-utilities@e1000 {
-		compatible = "fsl,p3041-clockgen", "fsl,qoriq-clockgen-1.0";
+		compatible = "fsl,p3041-clockgen", "fsl,qoriq-clockgen-1.0",
+				   "fixed-clock";
 		reg = <0xe1000 0x1000>;
 		clock-frequency = <0>;
+		clock-output-names = "sysclk";
+		#clock-cells = <0>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pll0: pll1@800 {
+			#clock-cells = <1>;
+			reg = <0x800>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll0", "pll0-div2", "pll0-div4";
+		};
+		pll1: pll1@820 {
+			#clock-cells = <1>;
+			reg = <0x820>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll1", "pll1-div2", "pll1-div4";
+		};
+		mux0: mux0@0 {
+			#clock-cells = <0>;
+			reg = <0x0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				 <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux0";
+		};
+		mux1: mux1@20 {
+			#clock-cells = <0>;
+			reg = <0x20>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				 <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux1";
+		};
+		mux2: mux2@40 {
+			#clock-cells = <0>;
+			reg = <0x40>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				 <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux2";
+		};
+		mux3: mux3@60 {
+			#clock-cells = <0>;
+			reg = <0x60>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				 <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux3";
+		};
 	};
 
 	rcpm: global-utilities@e2000 {
diff --git a/arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi b/arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi
index c9ca2c3..468e8be 100644
--- a/arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi
@@ -82,6 +82,7 @@
 		cpu0: PowerPC,e500mc@0 {
 			device_type = "cpu";
 			reg = <0>;
+			clocks = <&mux0>;
 			next-level-cache = <&L2_0>;
 			L2_0: l2-cache {
 				next-level-cache = <&cpc>;
@@ -90,6 +91,7 @@
 		cpu1: PowerPC,e500mc@1 {
 			device_type = "cpu";
 			reg = <1>;
+			clocks = <&mux1>;
 			next-level-cache = <&L2_1>;
 			L2_1: l2-cache {
 				next-level-cache = <&cpc>;
@@ -98,6 +100,7 @@
 		cpu2: PowerPC,e500mc@2 {
 			device_type = "cpu";
 			reg = <2>;
+			clocks = <&mux2>;
 			next-level-cache = <&L2_2>;
 			L2_2: l2-cache {
 				next-level-cache = <&cpc>;
@@ -106,6 +109,7 @@
 		cpu3: PowerPC,e500mc@3 {
 			device_type = "cpu";
 			reg = <3>;
+			clocks = <&mux3>;
 			next-level-cache = <&L2_3>;
 			L2_3: l2-cache {
 				next-level-cache = <&cpc>;
diff --git a/arch/powerpc/boot/dts/fsl/p4080si-post.dtsi b/arch/powerpc/boot/dts/fsl/p4080si-post.dtsi
index 19859ad..3596f05 100644
--- a/arch/powerpc/boot/dts/fsl/p4080si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p4080si-post.dtsi
@@ -352,9 +352,107 @@
 	};
 
 	clockgen: global-utilities@e1000 {
-		compatible = "fsl,p4080-clockgen", "fsl,qoriq-clockgen-1.0";
+		compatible = "fsl,p4080-clockgen", "fsl,qoriq-clockgen-1.0",
+				   "fixed-clock";
 		reg = <0xe1000 0x1000>;
 		clock-frequency = <0>;
+		clock-output-names = "sysclk";
+		#clock-cells = <0>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pll0: pll0@800 {
+			#clock-cells = <1>;
+			reg = <0x800>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll0", "pll0-div2";
+		};
+		pll1: pll1@820 {
+			#clock-cells = <1>;
+			reg = <0x820>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll1", "pll1-div2";
+		};
+		pll2: pll2@840 {
+			#clock-cells = <1>;
+			reg = <0x840>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll2", "pll2-div2";
+		};
+		pll3: pll2@860 {
+			#clock-cells = <1>;
+			reg = <0x860>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll3", "pll3-div2";
+		};
+		mux0: mux0@0 {
+			#clock-cells = <0>;
+			reg = <0x0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux0";
+		};
+		mux1: mux1@20 {
+			#clock-cells = <0>;
+			reg = <0x20>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux1";
+		};
+		mux2: mux2@40 {
+			#clock-cells = <0>;
+			reg = <0x40>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux2";
+		};
+		mux3: mux3@60 {
+			#clock-cells = <0>;
+			reg = <0x60>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux3";
+		};
+		mux4: mux4@80 {
+			#clock-cells = <0>;
+			reg = <0x80>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll2 0>, <&pll2 1>, <&pll3 0>, <&pll3 1>;
+			clock-names = "pll2_0", "pll2_1", "pll3_0", "pll3_1";
+			clock-output-names = "cmux4";
+		};
+		mux5: mux5@a0 {
+			#clock-cells = <0>;
+			reg = <0xa0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll2 0>, <&pll2 1>, <&pll3 0>, <&pll3 1>;
+			clock-names = "pll2_0", "pll2_1", "pll3_0", "pll3_1";
+			clock-output-names = "cmux5";
+		};
+		mux6: mux6@c0 {
+			#clock-cells = <0>;
+			reg = <0xc0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll2 0>, <&pll2 1>, <&pll3 0>, <&pll3 1>;
+			clock-names = "pll2_0", "pll2_1", "pll3_0", "pll3_1";
+			clock-output-names = "cmux6";
+		};
+		mux7: mux7@e0 {
+			#clock-cells = <0>;
+			reg = <0xe0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll2 0>, <&pll2 1>, <&pll3 0>, <&pll3 1>;
+			clock-names = "pll2_0", "pll2_1", "pll3_0", "pll3_1";
+			clock-output-names = "cmux7";
+		};
 	};
 
 	rcpm: global-utilities@e2000 {
diff --git a/arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi b/arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi
index 493d9a0..0040b5a 100644
--- a/arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi
@@ -81,6 +81,7 @@
 		cpu0: PowerPC,e500mc@0 {
 			device_type = "cpu";
 			reg = <0>;
+			clocks = <&mux0>;
 			next-level-cache = <&L2_0>;
 			L2_0: l2-cache {
 				next-level-cache = <&cpc>;
@@ -89,6 +90,7 @@
 		cpu1: PowerPC,e500mc@1 {
 			device_type = "cpu";
 			reg = <1>;
+			clocks = <&mux1>;
 			next-level-cache = <&L2_1>;
 			L2_1: l2-cache {
 				next-level-cache = <&cpc>;
@@ -97,6 +99,7 @@
 		cpu2: PowerPC,e500mc@2 {
 			device_type = "cpu";
 			reg = <2>;
+			clocks = <&mux2>;
 			next-level-cache = <&L2_2>;
 			L2_2: l2-cache {
 				next-level-cache = <&cpc>;
@@ -105,6 +108,7 @@
 		cpu3: PowerPC,e500mc@3 {
 			device_type = "cpu";
 			reg = <3>;
+			clocks = <&mux3>;
 			next-level-cache = <&L2_3>;
 			L2_3: l2-cache {
 				next-level-cache = <&cpc>;
@@ -113,6 +117,7 @@
 		cpu4: PowerPC,e500mc@4 {
 			device_type = "cpu";
 			reg = <4>;
+			clocks = <&mux4>;
 			next-level-cache = <&L2_4>;
 			L2_4: l2-cache {
 				next-level-cache = <&cpc>;
@@ -121,6 +126,7 @@
 		cpu5: PowerPC,e500mc@5 {
 			device_type = "cpu";
 			reg = <5>;
+			clocks = <&mux5>;
 			next-level-cache = <&L2_5>;
 			L2_5: l2-cache {
 				next-level-cache = <&cpc>;
@@ -129,6 +135,7 @@
 		cpu6: PowerPC,e500mc@6 {
 			device_type = "cpu";
 			reg = <6>;
+			clocks = <&mux6>;
 			next-level-cache = <&L2_6>;
 			L2_6: l2-cache {
 				next-level-cache = <&cpc>;
@@ -137,6 +144,7 @@
 		cpu7: PowerPC,e500mc@7 {
 			device_type = "cpu";
 			reg = <7>;
+			clocks = <&mux7>;
 			next-level-cache = <&L2_7>;
 			L2_7: l2-cache {
 				next-level-cache = <&cpc>;
diff --git a/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi b/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi
index 9ea77c3..3c662bd 100644
--- a/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p5020si-post.dtsi
@@ -337,9 +337,49 @@
 	};
 
 	clockgen: global-utilities@e1000 {
-		compatible = "fsl,p5020-clockgen", "fsl,qoriq-clockgen-1.0";
+		compatible = "fsl,p5020-clockgen", "fsl,qoriq-clockgen-1.0",
+				   "fixed-clock";
 		reg = <0xe1000 0x1000>;
 		clock-frequency = <0>;
+		clock-output-names = "sysclk";
+		#clock-cells = <0>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pll0: pll0@800 {
+			#clock-cells = <1>;
+			reg = <0x800>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll0", "pll0-div2", "pll0-div4";
+		};
+		pll1: pll1@820 {
+			#clock-cells = <1>;
+			reg = <0x820>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll1", "pll1-div2", "pll1-div4";
+		};
+		mux0: mux0@0 {
+			#clock-cells = <0>;
+			reg = <0x0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				 <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux0";
+		};
+		mux1: mux1@20 {
+			#clock-cells = <0>;
+			reg = <0x20>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll0 2>,
+				 <&pll1 0>, <&pll1 1>, <&pll1 2>;
+			clock-names = "pll0_0", "pll0_1", "pll0_2",
+				"pll1_0", "pll1_1", "pll1_2";
+			clock-output-names = "cmux1";
+		};
 	};
 
 	rcpm: global-utilities@e2000 {
diff --git a/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi b/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi
index 8df47fc..fe1a2e6 100644
--- a/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi
@@ -88,6 +88,7 @@
 		cpu0: PowerPC,e5500@0 {
 			device_type = "cpu";
 			reg = <0>;
+			clocks = <&mux0>;
 			next-level-cache = <&L2_0>;
 			L2_0: l2-cache {
 				next-level-cache = <&cpc>;
@@ -96,6 +97,7 @@
 		cpu1: PowerPC,e5500@1 {
 			device_type = "cpu";
 			reg = <1>;
+			clocks = <&mux1>;
 			next-level-cache = <&L2_1>;
 			L2_1: l2-cache {
 				next-level-cache = <&cpc>;
diff --git a/arch/powerpc/boot/dts/fsl/p5040si-post.dtsi b/arch/powerpc/boot/dts/fsl/p5040si-post.dtsi
index 97f8c26..3870b22 100644
--- a/arch/powerpc/boot/dts/fsl/p5040si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p5040si-post.dtsi
@@ -297,9 +297,61 @@
 	};
 
 	clockgen: global-utilities@e1000 {
-		compatible = "fsl,p5040-clockgen", "fsl,qoriq-clockgen-1.0";
+		compatible = "fsl,p5040-clockgen", "fsl,qoriq-clockgen-1.0",
+				   "fixed-clock";
 		reg = <0xe1000 0x1000>;
 		clock-frequency = <0>;
+		clock-output-names = "sysclk";
+		#clock-cells = <0>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pll0: pll0@800 {
+			#clock-cells = <1>;
+			reg = <0x800>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll0", "pll0-div2";
+		};
+		pll1: pll1@820 {
+			#clock-cells = <1>;
+			reg = <0x820>;
+			compatible = "fsl,core-pll-clock";
+			clocks = <&clockgen>;
+			clock-output-names = "pll1", "pll1-div2";
+		};
+		mux0: mux0@0 {
+			#clock-cells = <0>;
+			reg = <0x0>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux0";
+		};
+		mux1: mux1@20 {
+			#clock-cells = <0>;
+			reg = <0x20>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux1";
+		};
+		mux2: mux2@40 {
+			#clock-cells = <0>;
+			reg = <0x40>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux2";
+		};
+		mux3: mux3@60 {
+			#clock-cells = <0>;
+			reg = <0x60>;
+			compatible = "fsl,core-mux-clock";
+			clocks = <&pll0 0>, <&pll0 1>, <&pll1 0>, <&pll1 1>;
+			clock-names = "pll0_0", "pll0_1", "pll1_0", "pll1_1";
+			clock-output-names = "cmux3";
+		};
 	};
 
 	rcpm: global-utilities@e2000 {
diff --git a/arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi b/arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi
index 40ca943..3674686 100644
--- a/arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi
@@ -81,6 +81,7 @@
 		cpu0: PowerPC,e5500@0 {
 			device_type = "cpu";
 			reg = <0>;
+			clocks = <&mux0>;
 			next-level-cache = <&L2_0>;
 			L2_0: l2-cache {
 				next-level-cache = <&cpc>;
@@ -89,6 +90,7 @@
 		cpu1: PowerPC,e5500@1 {
 			device_type = "cpu";
 			reg = <1>;
+			clocks = <&mux1>;
 			next-level-cache = <&L2_1>;
 			L2_1: l2-cache {
 				next-level-cache = <&cpc>;
@@ -97,6 +99,7 @@
 		cpu2: PowerPC,e5500@2 {
 			device_type = "cpu";
 			reg = <2>;
+			clocks = <&mux2>;
 			next-level-cache = <&L2_2>;
 			L2_2: l2-cache {
 				next-level-cache = <&cpc>;
@@ -105,6 +108,7 @@
 		cpu3: PowerPC,e5500@3 {
 			device_type = "cpu";
 			reg = <3>;
+			clocks = <&mux3>;
 			next-level-cache = <&L2_3>;
 			L2_3: l2-cache {
 				next-level-cache = <&cpc>;
-- 
1.8.0


