Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaDYUBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:01:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49621 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752761AbaDYUBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:01:31 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [RFC 4/5] ARM: berlin/dt: add support for the clock group to BG2D
Date: Fri, 25 Apr 2014 22:00:23 +0200
Message-Id: <1398456024-27876-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly added marvell,berlin2-clkgrp driver, add real support for cfgclk
and add the cpu0, perif and nfcecc clocks.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2cd.dtsi | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index b05d32bf70e0..fe5a332908c9 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -36,12 +36,6 @@
 		clock-frequency = <25000000>;
 	};
 
-	cfgclk: cfg-clock {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <75000000>;
-	};
-
 	twdclk: twdclk {
 		compatible = "fixed-factor-clock";
 		#clock-cells = <0>;
@@ -183,6 +177,36 @@
 			reg = <0xea003c 0x8>;
 		};
 
+		grpclk: grpclk@ea0154 {
+			compatible = "marvell,berlin2-clkgrp";
+			clocks = <&syspll>;
+			reg = <0xea0164 0x8>, <0xea0154 0x8>;
+
+			cpu0clk: cpu0clk {
+				#clock-cells = <0>;
+				marvell,clk-switch-offset = <6>;
+				marvell,clk-select-offset = <6>;
+			};
+
+			cfgclk: cfgclk {
+				#clock-cells = <0>;
+				marvell,clk-switch-offset = <15>;
+				marvell,clk-select-offset = <23>;
+			};
+
+			perifclk: perifclk {
+				#clock-cells = <0>;
+				marvell,clk-switch-offset = <24>;
+				marvell,clk-select-offset = <41>;
+			};
+
+			nfceccclk: nfceccclk {
+				#clock-cells = <0>;
+				marvell,clk-switch-offset = <33>;
+				marvell,clk-select-offset = <61>;
+			};
+		};
+
 		sdio0xinclk: sdio0xinclk@ea023c {
 			compatible = "marvell,berlin-clk";
 			clocks = <&syspll>;
-- 
1.9.1

