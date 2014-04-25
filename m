Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaDYUBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:01:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49626 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754532AbaDYUBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:01:32 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [RFC 5/5] ARM: berlin/dt: add support for the clock group to BG2Q
Date: Fri, 25 Apr 2014 22:00:24 +0200
Message-Id: <1398456024-27876-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly added marvell,berlin2-clkgrp driver, add real support for cfgclk
and add the nfcecc clock.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 559819b89ea1..169c783ef262 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -53,12 +53,6 @@
 		clock-frequency = <25000000>;
 	};
 
-	cfgclk: config-clock {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <100000000>;
-	};
-
 	twdclk: twdclk {
 		compatible = "fixed-factor-clock";
 		#clock-cells = <0>;
@@ -191,6 +185,24 @@
 			reg = <0xea0030 0x8>;
 		};
 
+		grpclk: grpclk@ea00ec {
+			compatible = "marvell,berlin2-clkgrp";
+			clocks = <&syspll>;
+			reg = <0xea00f8 0x4>, <0xea00ec 0xc>;
+
+			cfgclk: cfgclk {
+				#clock-cells = <0>;
+				marvell,clk-switch-offset = <9>;
+				marvell,clk-select-offset = <12>;
+			};
+
+			nfceccclk: nfceccclk {
+				#clock-cells = <0>;
+				marvell,clk-switch-offset = <27>;
+				marvell,clk-select-offset = <50>;
+			};
+		};
+
 		sdio0xinclk: sdio0xinclk@ea0158 {
 			compatible = "marvell,berlin-clk";
 			clocks = <&syspll>;
-- 
1.9.1

