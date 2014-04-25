Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaDYUBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:01:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49615 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754516AbaDYUB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:01:29 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [RFC 3/5] ARM: berlin/dt: add support for the clock group to BG2
Date: Fri, 25 Apr 2014 22:00:22 +0200
Message-Id: <1398456024-27876-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly added marvell,berlin2-clkgrp driver, add real support for cfgclk
and add the cpu0 and perif clocks.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2.dtsi | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 2604c8692b77..589a71472e2e 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -43,12 +43,6 @@
 		clock-frequency = <25000000>;
 	};
 
-	cfgclk: cfg-clock {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <100000000>;
-	};
-
 	twdclk: twdclk {
 		compatible = "fixed-factor-clock";
 		#clock-cells = <0>;
@@ -190,6 +184,30 @@
 			reg = <0xea003c 0x8>;
 		};
 
+		grpclk: grpclk@ea0154 {
+			compatible = "marvell,berlin2-clkgrp";
+			clocks = <&syspll>;
+			reg = <0xea00f8 0x4>, <0xea00ec 0xc>;
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
+		};
+
 		sdio0xinclk: sdio0xinclk@ea023c {
 			compatible = "marvell,berlin-clk";
 			clocks = <&syspll>;
-- 
1.9.1

