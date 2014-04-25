Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaDYUB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:01:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49608 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752761AbaDYUB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:01:27 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree@vger.kernel.org
Subject: [RFC 2/5] clk: berlin: add berlin clock groups DT bindings documentation
Date: Fri, 25 Apr 2014 22:00:21 +0200
Message-Id: <1398456024-27876-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398456024-27876-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the device tree for the clocks sharing a common set of registers

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
Cc: devicetree@vger.kernel.org
 .../devicetree/bindings/clock/berlin-clock.txt     | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/Documentation/devicetree/bindings/clock/berlin-clock.txt
index 49bc229827a0..6d374066d6b9 100644
--- a/Documentation/devicetree/bindings/clock/berlin-clock.txt
+++ b/Documentation/devicetree/bindings/clock/berlin-clock.txt
@@ -11,10 +11,18 @@ Required properties:
 		CPU PLL and System PLL
 	"marvell,berlin2-clk":
 		simple clocks
+	"marvell,berlin2-clkgrp":
+		clocks sharing a common set of registers
 - reg: Address and length of the clock register set.
 - #clock-cells: from common clock binding; shall be set to 0.
 - clocks: from common clock binding
 
+For the clock groups:
+- marvell,clk-switch-offset: offset in bits to the first bit related to the
+  clock in the switch registers
+- marvell,clk-select-offset: offset in bits to the first bit related to the
+  clock in the selection registers.
+
 smclk: sysmgr-clock {
 	compatible = "fixed-clock";
 	#clock-cells = <0>;
@@ -34,3 +42,24 @@ sdio0xinclk: sdio0xinclk@ea023c {
 	#clock-cells = <0>;
 	reg = <0xea023c 0x4>;
 };
+
+
+grpclk: grpclk@ea00ec {
+	compatible = "marvell,berlin-clkgrp";
+	clocks = <&syspll>;
+	reg = <0xea00f8 0x4>, <0xea00ec 0xc>;
+
+	cfgclk: cfgclk {
+		#clock-cells = <0>;
+		marvell,clk-switch-offset = <9>;
+		marvell,clk-select-offset = <12>;
+	};
+
+	nfcecccclk: nfcecccclk {
+		#clock-cells = <0>;
+		marvell,clk-switch-offset = <27>;
+		marvell,clk-select-offset = <50>;
+	};
+};
+
+
-- 
1.9.1

