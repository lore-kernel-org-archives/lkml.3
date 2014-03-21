Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbaCULoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:44:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55805 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760138AbaCULnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:43:55 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/5] ARM: berlin/dt: add cpupll and syspll support to BG2CD
Date: Fri, 21 Mar 2014 12:43:39 +0100
Message-Id: <1395402220-23503-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also moves the clocks from the clocks container node to the root.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2cd.dtsi | 56 ++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index 094968c27533..c84013c1597c 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -30,24 +30,46 @@
 		};
 	};
 
-	clocks {
-		smclk: sysmgr-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <25000000>;
-		};
+	smclk: sysmgr-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
+	};
 
-		cfgclk: cfg-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <75000000>;
-		};
+	cfgclk: cfg-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <75000000>;
+	};
 
-		sysclk: system-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <300000000>;
-		};
+	syspll: syspll {
+		compatible = "marvell,berlin2-pll";
+		clocks = <&smclk>;
+		#clock-cells = <0>;
+		reg = <0xf7ea0014 8>;
+	};
+
+	cpupll: cpupll {
+		compatible = "marvell,berlin2-pll";
+		clocks = <&smclk>;
+		#clock-cells = <0>;
+		reg = <0xf7ea003c 8>;
+	};
+
+	cpuclk: cpu-clock {
+		compatible = "fixed-factor-clock";
+		clocks = <&cpupll>;
+		#clock-cells = <0>;
+		clock-div = <1>;
+		clock-mult = <1>;
+	};
+
+	twdclk: twdclk {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&cpuclk>;
+		clock-mult = <1>;
+		clock-div = <3>;
 	};
 
 	soc {
@@ -76,7 +98,7 @@
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
 			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&sysclk>;
+			clocks = <&twdclk>;
 		};
 
 		apb@e80000 {
-- 
1.8.3.2

