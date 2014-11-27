Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaK0QWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:22:01 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:44379 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750864AbaK0QV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:21:59 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Olof Johansson <olof@lixom.net>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Rob Herring <robherring2@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Will Deacon <will.deacon@arm.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] arm64: ARM: Fix the Generic Timers interrupt active level description
Date: Thu, 27 Nov 2014 16:21:23 +0000
Message-Id: <1417105283-19575-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Cortex-A5x TRM states in paragraph "9.2 Generic Timer functional
description" that generic timers provide a level not edge interrupt
output. Fix the device trees to correctly describe this.

While doing this update the CPU mask to match the number of described
CPUs as well as the DT bindings documentation for Generic Timers.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---

Arnd, Olof: This is on top of linux-next/master as it patches Juno's
as well as all the other ARM DTs.

--

 Documentation/devicetree/bindings/arm/arch_timer.txt | 8 ++++----
 arch/arm64/boot/dts/arm/foundation-v8.dts            | 8 ++++----
 arch/arm64/boot/dts/arm/juno.dts                     | 8 ++++----
 arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts           | 8 ++++----
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
index 37b2caf..6d2aa87 100644
--- a/Documentation/devicetree/bindings/arm/arch_timer.txt
+++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
@@ -27,10 +27,10 @@ Example:
 	timer {
 		compatible = "arm,cortex-a15-timer",
 			     "arm,armv7-timer";
-		interrupts = <1 13 0xf08>,
-			     <1 14 0xf08>,
-			     <1 11 0xf08>,
-			     <1 10 0xf08>;
+		interrupts = <1 13 0xf04>,
+			     <1 14 0xf04>,
+			     <1 11 0xf04>,
+			     <1 10 0xf04>;
 		clock-frequency = <100000000>;
 	};
 
diff --git a/arch/arm64/boot/dts/arm/foundation-v8.dts b/arch/arm64/boot/dts/arm/foundation-v8.dts
index 4a06090..8c0214e 100644
--- a/arch/arm64/boot/dts/arm/foundation-v8.dts
+++ b/arch/arm64/boot/dts/arm/foundation-v8.dts
@@ -78,10 +78,10 @@
 
 	timer {
 		compatible = "arm,armv8-timer";
-		interrupts = <1 13 0xff01>,
-			     <1 14 0xff01>,
-			     <1 11 0xff01>,
-			     <1 10 0xff01>;
+		interrupts = <1 13 0xf04>,
+			     <1 14 0xf04>,
+			     <1 11 0xf04>,
+			     <1 10 0xf04>;
 		clock-frequency = <100000000>;
 	};
 
diff --git a/arch/arm64/boot/dts/arm/juno.dts b/arch/arm64/boot/dts/arm/juno.dts
index 097ecc4..551a688 100644
--- a/arch/arm64/boot/dts/arm/juno.dts
+++ b/arch/arm64/boot/dts/arm/juno.dts
@@ -98,10 +98,10 @@
 
 	timer {
 		compatible = "arm,armv8-timer";
-		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
-			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
-			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
-			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>;
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>;
 	};
 
 	pmu {
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
index 572005e..49d1b19 100644
--- a/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
@@ -81,10 +81,10 @@
 
 	timer {
 		compatible = "arm,armv8-timer";
-		interrupts = <1 13 0xff01>,
-			     <1 14 0xff01>,
-			     <1 11 0xff01>,
-			     <1 10 0xff01>;
+		interrupts = <1 13 0xf04>,
+			     <1 14 0xf04>,
+			     <1 11 0xf04>,
+			     <1 10 0xf04>;
 		clock-frequency = <100000000>;
 	};
 
-- 
2.1.3

