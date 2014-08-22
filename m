Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaHVOGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:06:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34158 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbaHVOG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:06:29 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 5/6] ARM: dts: OMAP5/DRA7: switch over to interrupts-extended property for UART
Date: Fri, 22 Aug 2014 09:03:54 -0500
Message-ID: <1408716235-26164-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716235-26164-1-git-send-email-nm@ti.com>
References: <1408716235-26164-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had deeper idle states working on omaps for few years now,
but only in the legacy mode. When booted with device tree, the
wake-up events did not have a chance to work until commit
3e6cee1786a1 ("pinctrl: single: Add support for wake-up interrupts")
that recently got merged. In addition to that we also needed
commit 79d9701559a9 ("of/irq: create interrupts-extended property")
that's now also merged.

Note that there's no longer need to specify the wake-up bit in
the pinctrl settings, the request_irq on the wake-up pin takes
care of that.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi  |   20 ++++++++++----------
 arch/arm/boot/dts/omap5.dtsi |   12 ++++++------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 4e4ce96..45cb91f 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -331,7 +331,7 @@
 		uart1: serial@4806a000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806a000 0x100>;
-			interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart1";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -340,7 +340,7 @@
 		uart2: serial@4806c000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806c000 0x100>;
-			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart2";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -349,7 +349,7 @@
 		uart3: serial@48020000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48020000 0x100>;
-			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart3";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -358,7 +358,7 @@
 		uart4: serial@4806e000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806e000 0x100>;
-			interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
                         status = "disabled";
@@ -367,7 +367,7 @@
 		uart5: serial@48066000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48066000 0x100>;
-			interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart5";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -376,7 +376,7 @@
 		uart6: serial@48068000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48068000 0x100>;
-			interrupts = <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -385,7 +385,7 @@
 		uart7: serial@48420000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48420000 0x100>;
-			interrupts = <GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart7";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -394,7 +394,7 @@
 		uart8: serial@48422000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48422000 0x100>;
-			interrupts = <GIC_SPI 219 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 219 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart8";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -403,7 +403,7 @@
 		uart9: serial@48424000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48424000 0x100>;
-			interrupts = <GIC_SPI 220 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 220 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart9";
 			clock-frequency = <48000000>;
 			status = "disabled";
@@ -412,7 +412,7 @@
 		uart10: serial@4ae2b000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4ae2b000 0x100>;
-			interrupts = <GIC_SPI 221 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 221 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart10";
 			clock-frequency = <48000000>;
 			status = "disabled";
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 04acda6..fe2effd 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -452,7 +452,7 @@
 		uart1: serial@4806a000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806a000 0x100>;
-			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart1";
 			clock-frequency = <48000000>;
 		};
@@ -460,7 +460,7 @@
 		uart2: serial@4806c000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806c000 0x100>;
-			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart2";
 			clock-frequency = <48000000>;
 		};
@@ -468,7 +468,7 @@
 		uart3: serial@48020000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48020000 0x100>;
-			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart3";
 			clock-frequency = <48000000>;
 		};
@@ -476,7 +476,7 @@
 		uart4: serial@4806e000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x4806e000 0x100>;
-			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
 		};
@@ -484,7 +484,7 @@
 		uart5: serial@48066000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48066000 0x100>;
-			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart5";
 			clock-frequency = <48000000>;
 		};
@@ -492,7 +492,7 @@
 		uart6: serial@48068000 {
 			compatible = "ti,omap4-uart";
 			reg = <0x48068000 0x100>;
-			interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&gic GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
 		};
-- 
1.7.9.5

