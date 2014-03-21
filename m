Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaCUUJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:09:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58690 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751800AbaCUUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:09:00 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 3/5] ARM: berlin/dt: add cpupll and syspll support to BG2Q
Date: Fri, 21 Mar 2014 21:08:39 +0100
Message-Id: <1395432521-11055-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Berlin BG2Q has two supported PLLs: CPU PLL and System PLL, add those to the
SoC device tree.

Note that support for the AVPLL is not yet available.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 07452a7483fa..5925e6a16749 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -59,16 +59,10 @@
 		clock-frequency = <100000000>;
 	};
 
-	cpuclk: cpu-clock {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <1200000000>;
-	};
-
 	twdclk: twdclk {
 		compatible = "fixed-factor-clock";
 		#clock-cells = <0>;
-		clocks = <&cpuclk>;
+		clocks = <&cpupll>;
 		clock-mult = <1>;
 		clock-div = <3>;
 	};
@@ -101,6 +95,20 @@
 			#interrupt-cells = <3>;
 		};
 
+		cpupll: cpupll@dd0170 {
+			compatible = "marvell,berlin2q-pll";
+			clocks = <&smclk>;
+			#clock-cells = <0>;
+			reg = <0xdd0170 0x8>;
+		};
+
+		syspll: syspll@ea0030 {
+			compatible = "marvell,berlin2q-pll";
+			clocks = <&smclk>;
+			#clock-cells = <0>;
+			reg = <0xea0030 0x8>;
+		};
+
 		apb@e80000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.8.3.2

