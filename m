Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaESRhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:37:37 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40838 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894AbaESRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:36:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/7] dt-binding: ARM: add pinctrl binding docs for Marvell Berlin2 SoCs
Date: Mon, 19 May 2014 19:36:34 +0200
Message-Id: <1400520995-27365-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>

Add pin control binding documentation to the SoC binding documentaion
as pinctrl is part of chip/system control registers. The documentation
also explains how to configure this group based controller.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- move documentation of an exclusive pinctrl node to the Berlin SoC
  binding documentation of chip/system control nodes instead.
- remove "marvell," prefix from pinctrl function/groups property

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: zmxu@marvell.com
Cc: jszhang@marvell.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/arm/marvell,berlin.txt     | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
index 744a7ea569d4..94013a9a8769 100644
--- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -41,6 +41,18 @@ Required properties:
   BG2/BG2CD: chip control register set
   BG2Q: chip control register set and cpu pll registers
 
+* Marvell Berlin2 system control binding
+
+Marvell Berlin SoCs have a system control register set providing several
+individual registers dealing with pinmux, padmux, and reset.
+
+Required properties:
+- compatible: should be one of
+	"marvell,berlin2-system-ctrl" for BG2
+	"marvell,berlin2cd-system-ctrl" for BG2CD
+	"marvell,berlin2q-system-ctrl" for BG2Q
+- reg: address and length of the system control register set
+
 * Clock provider binding
 
 As clock related registers are spread among the chip control registers, the
@@ -61,6 +73,23 @@ Clocks provided by core clocks shall be referenced by a clock specifier
 indexing one of the provided clocks. Refer to dt-bindings/clock/berlin<soc>.h
 for the corresponding index mapping.
 
+* Pin controller binding
+
+Pin control registers are part of both register sets, chip control and system
+control. The pins controlled are organized in groups, so no actual pin
+information is needed.
+
+A pin-controller node should contain subnodes representing the pin group
+configurations, one per function. Each subnode has the group name and the muxing
+function used.
+
+Be aware the Marvell Berlin datasheets use the keyword 'mode' for what is called
+a 'function' in the pin-controller subsystem.
+
+Required subnode-properties:
+- groups: a list of strings describing the group names.
+- function: a string describing the function used to mux the groups.
+
 Example:
 
 chip: chip-control@ea0000 {
@@ -69,4 +98,29 @@ chip: chip-control@ea0000 {
 	reg = <0xea0000 0x400>;
 	clocks = <&refclk>, <&externaldev 0>;
 	clock-names = "refclk", "video_ext0";
+
+	spi1_pmux: spi1-pmux {
+		groups = "G0";
+		function = "spi1";
+	};
+};
+
+sysctrl: system-controller@d000 {
+	compatible = "marvell,berlin2-system-ctrl";
+	reg = <0xd000 0x100>;
+
+	uart0_pmux: uart0-pmux {
+		groups = "GSM4";
+		function = "uart0";
+	};
+
+	uart1_pmux: uart1-pmux {
+		groups = "GSM5";
+		function = "uart1";
+	};
+
+	uart2_pmux: uart2-pmux {
+		groups = "GSM3";
+		function = "uart2";
+	};
 };
-- 
1.9.1

