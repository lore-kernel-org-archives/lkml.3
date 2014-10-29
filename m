Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaJ2KIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:08:40 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:58819 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932493AbaJ2KHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:07:45 -0400
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>, <arm@kernel.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srv_heupstream@mediatek.com>,
        <yingjoe.chen@gmail.com>, <hc.yen@mediatek.com>,
        <eddie.huang@mediatek.com>, <nathan.chung@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 5/6] ARM: mediatek: Add sysirq in mt6589/mt8135/mt8127 dtsi
Date: Wed, 29 Oct 2014 18:00:23 +0800
Message-ID: <1414576824-16143-6-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysirq settings for mt6589/mt8135/mt8127
This also correct timer interrupt flag. The old setting works
because boot loader already set polarity for timer interrupt.
Without intpol support, the setting was not changed so gic
can get the irq correctly.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 arch/arm/boot/dts/mt6589.dtsi | 14 ++++++++++++--
 arch/arm/boot/dts/mt8127.dtsi | 14 ++++++++++++--
 arch/arm/boot/dts/mt8135.dtsi | 14 ++++++++++++--
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/mt6589.dtsi b/arch/arm/boot/dts/mt6589.dtsi
index e3c7600..c91b2a9 100644
--- a/arch/arm/boot/dts/mt6589.dtsi
+++ b/arch/arm/boot/dts/mt6589.dtsi
@@ -19,7 +19,7 @@
 
 / {
 	compatible = "mediatek,mt6589";
-	interrupt-parent = <&gic>;
+	interrupt-parent = <&sysirq>;
 
 	cpus {
 		#address-cells = <1>;
@@ -76,15 +76,25 @@
 		timer: timer@10008000 {
 			compatible = "mediatek,mt6577-timer";
 			reg = <0x10008000 0x80>;
-			interrupts = <GIC_SPI 113 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
 			clocks = <&system_clk>, <&rtc_clk>;
 			clock-names = "system-clk", "rtc-clk";
 		};
 
+		sysirq: interrupt-controller@10200100 {
+			compatible = "mediatek,mt6589-sysirq",
+				     "mediatek,mt6577-sysirq";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			interrupt-parent = <&gic>;
+			reg = <0x10200100 0x1c>;
+		};
+
 		gic: interrupt-controller@10211000 {
 			compatible = "arm,cortex-a7-gic";
 			interrupt-controller;
 			#interrupt-cells = <3>;
+			interrupt-parent = <&gic>;
 			reg = <0x10211000 0x1000>,
 			      <0x10212000 0x1000>,
 			      <0x10214000 0x2000>,
diff --git a/arch/arm/boot/dts/mt8127.dtsi b/arch/arm/boot/dts/mt8127.dtsi
index 249c218..59efb07 100644
--- a/arch/arm/boot/dts/mt8127.dtsi
+++ b/arch/arm/boot/dts/mt8127.dtsi
@@ -18,7 +18,7 @@
 
 / {
 	compatible = "mediatek,mt8127";
-	interrupt-parent = <&gic>;
+	interrupt-parent = <&sysirq>;
 
 	cpus {
 		#address-cells = <1>;
@@ -81,15 +81,25 @@
 		timer: timer@10008000 {
 			compatible = "mediatek,mt8127-timer", "mediatek,mt6577-timer";
 			reg = <0 0x10008000 0 0x80>;
-			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_LOW>;
 			clocks = <&system_clk>, <&rtc_clk>;
 			clock-names = "system-clk", "rtc-clk";
 		};
 
+		sysirq: interrupt-controller@10200100 {
+			compatible = "mediatek,mt8127-sysirq",
+				     "mediatek,mt6577-sysirq";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			interrupt-parent = <&gic>;
+			reg = <0 0x10200100 0 0x1c>;
+		};
+
 		gic: interrupt-controller@10211000 {
 			compatible = "arm,cortex-a7-gic";
 			interrupt-controller;
 			#interrupt-cells = <3>;
+			interrupt-parent = <&gic>;
 			reg = <0 0x10211000 0 0x1000>,
 			      <0 0x10212000 0 0x1000>,
 			      <0 0x10214000 0 0x2000>,
diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
index 683b761..2b6d5c8 100644
--- a/arch/arm/boot/dts/mt8135.dtsi
+++ b/arch/arm/boot/dts/mt8135.dtsi
@@ -18,7 +18,7 @@
 
 / {
 	compatible = "mediatek,mt8135";
-	interrupt-parent = <&gic>;
+	interrupt-parent = <&sysirq>;
 
 	cpu-map {
 		cluster0 {
@@ -104,15 +104,25 @@
 		timer: timer@10008000 {
 			compatible = "mediatek,mt8135-timer", "mediatek,mt6577-timer";
 			reg = <0 0x10008000 0 0x80>;
-			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
 			clocks = <&system_clk>, <&rtc_clk>;
 			clock-names = "system-clk", "rtc-clk";
 		};
 
+		sysirq: interrupt-controller@10200030 {
+			compatible = "mediatek,mt8135-sysirq",
+				     "mediatek,mt6577-sysirq";
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			interrupt-parent = <&gic>;
+			reg = <0 0x10200030 0 0x1c>;
+		};
+
 		gic: interrupt-controller@10211000 {
 			compatible = "arm,cortex-a15-gic";
 			interrupt-controller;
 			#interrupt-cells = <3>;
+			interrupt-parent = <&gic>;
 			reg = <0 0x10211000 0 0x1000>,
 			      <0 0x10212000 0 0x1000>,
 			      <0 0x10214000 0 0x2000>,
-- 
1.8.1.1.dirty

