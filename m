Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbbAHGWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 01:22:41 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54725 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbbAHGWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 01:22:40 -0500
From: Howard Chen <howard.chen@linaro.org>
To: matthias.bgg@gmail.com
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek
	SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] ARM: mediatek: Add sysirq device node to mt6592 dtsi
Date: Thu,  8 Jan 2015 14:23:10 +0800
Message-Id: <1420698191-10878-1-git-send-email-howard.chen@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysirq node to mt6592.dtsi and also correct timer interrupt flag.
The old setting works because boot loader already set it.
With a sysirq device node, the timer interrupt can use a correct value.

Signed-off-by: Howard Chen <howard.chen@linaro.org>
---
 arch/arm/boot/dts/mt6592.dtsi | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/mt6592.dtsi b/arch/arm/boot/dts/mt6592.dtsi
index 31e5a09..67c8174 100644
--- a/arch/arm/boot/dts/mt6592.dtsi
+++ b/arch/arm/boot/dts/mt6592.dtsi
@@ -18,7 +18,7 @@
 
 / {
 	compatible = "mediatek,mt6592";
-	interrupt-parent = <&gic>;
+	interrupt-parent = <&sysirq>;
 
 	cpus {
 		#address-cells = <1>;
@@ -81,18 +81,25 @@
 	timer: timer@10008000 {
 		compatible = "mediatek,mt6577-timer";
 		reg = <0x10008000 0x80>;
-		interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_LOW>;
 		clocks = <&system_clk>, <&rtc_clk>;
 		clock-names = "system-clk", "rtc-clk";
 	};
 
+	sysirq: interrupt-controller@10200220 {
+		compatible = "mediatek,mt6592-sysirq", "mediatek,mt6577-sysirq";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		interrupt-parent = <&gic>;
+		reg = <0x10200220 0x1c>;
+	};
+
 	gic: interrupt-controller@10211000 {
 		compatible = "arm,cortex-a7-gic";
 		interrupt-controller;
 		#interrupt-cells = <3>;
+		interrupt-parent = <&gic>;
 		reg = <0x10211000 0x1000>,
 		      <0x10212000 0x1000>;
 	};
-
 };
-
-- 
1.9.1

