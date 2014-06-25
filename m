Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaFYKiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:38:07 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:19731 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756288AbaFYKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:38:04 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH] arm/arm64: DT: Fix GICv2 CPU interface size
Date: Wed, 25 Jun 2014 11:37:54 +0100
Message-Id: <1403692675-26503-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the Cortex-{A7,A15} implementations are using a GICv2. Same for
the current arm64 platforms.

Turns out that most of these platforms have described their GIC CPU
interface size as being 4kB. while it is actually 8kB (the GICC_DIR
register lives at offset 0x1000).

This was found when converting the GIC driver to use EOImode==1 on
GICv2-based systems. It uses the GICC_DIR register, and the result
is a very early firework...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/boot/dts/axm55xx.dtsi              | 2 +-
 arch/arm/boot/dts/dra7.dtsi                 | 2 +-
 arch/arm/boot/dts/ecx-2000.dts              | 2 +-
 arch/arm/boot/dts/exynos3250.dtsi           | 2 +-
 arch/arm/boot/dts/exynos5.dtsi              | 2 +-
 arch/arm/boot/dts/exynos5260.dtsi           | 2 +-
 arch/arm/boot/dts/exynos5410.dtsi           | 2 +-
 arch/arm/boot/dts/exynos5440.dtsi           | 2 +-
 arch/arm/boot/dts/omap5.dtsi                | 2 +-
 arch/arm/boot/dts/r8a73a4.dtsi              | 2 +-
 arch/arm/boot/dts/r8a7790.dtsi              | 2 +-
 arch/arm/boot/dts/r8a7791.dtsi              | 2 +-
 arch/arm/boot/dts/sun6i-a31.dtsi            | 2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi            | 2 +-
 arch/arm/boot/dts/tegra114.dtsi             | 2 +-
 arch/arm/boot/dts/tegra124.dtsi             | 2 +-
 arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts | 2 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts  | 2 +-
 arch/arm64/boot/dts/apm-storm.dtsi          | 2 +-
 arch/arm64/boot/dts/foundation-v8.dts       | 2 +-
 arch/arm64/boot/dts/rtsm_ve-aemv8a.dts      | 2 +-
 21 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/axm55xx.dtsi b/arch/arm/boot/dts/axm55xx.dtsi
index ea288f0..40aacc9 100644
--- a/arch/arm/boot/dts/axm55xx.dtsi
+++ b/arch/arm/boot/dts/axm55xx.dtsi
@@ -62,7 +62,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0x20 0x01001000 0 0x1000>,
-		      <0x20 0x01002000 0 0x1000>,
+		      <0x20 0x01002000 0 0x2000>,
 		      <0x20 0x01004000 0 0x2000>,
 		      <0x20 0x01006000 0 0x2000>;
 		interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) |
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index c29945e..65329ff 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -46,7 +46,7 @@
 		interrupt-controller;
 		#interrupt-cells = <3>;
 		reg = <0x48211000 0x1000>,
-		      <0x48212000 0x1000>,
+		      <0x48212000 0x2000>,
 		      <0x48214000 0x2000>,
 		      <0x48216000 0x2000>;
 		interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_HIGH)>;
diff --git a/arch/arm/boot/dts/ecx-2000.dts b/arch/arm/boot/dts/ecx-2000.dts
index 2ccbb57f..c15e7e0 100644
--- a/arch/arm/boot/dts/ecx-2000.dts
+++ b/arch/arm/boot/dts/ecx-2000.dts
@@ -99,7 +99,7 @@
 			interrupt-controller;
 			interrupts = <1 9 0xf04>;
 			reg = <0xfff11000 0x1000>,
-			      <0xfff12000 0x1000>,
+			      <0xfff12000 0x2000>,
 			      <0xfff14000 0x2000>,
 			      <0xfff16000 0x2000>;
 		};
diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3e678fa..bbd177a 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -173,7 +173,7 @@
 			#interrupt-cells = <3>;
 			interrupt-controller;
 			reg = <0x10481000 0x1000>,
-			      <0x10482000 0x1000>,
+			      <0x10482000 0x2000>,
 			      <0x10484000 0x2000>,
 			      <0x10486000 0x2000>;
 			interrupts = <1 9 0xf04>;
diff --git a/arch/arm/boot/dts/exynos5.dtsi b/arch/arm/boot/dts/exynos5.dtsi
index 79d0608..15fdc3b 100644
--- a/arch/arm/boot/dts/exynos5.dtsi
+++ b/arch/arm/boot/dts/exynos5.dtsi
@@ -44,7 +44,7 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg =	<0x10481000 0x1000>,
-			<0x10482000 0x1000>,
+			<0x10482000 0x2000>,
 			<0x10484000 0x2000>,
 			<0x10486000 0x2000>;
 		interrupts = <1 9 0xf04>;
diff --git a/arch/arm/boot/dts/exynos5260.dtsi b/arch/arm/boot/dts/exynos5260.dtsi
index 5398a60..c0e2341 100644
--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -161,7 +161,7 @@
 			#size-cells = <0>;
 			interrupt-controller;
 			reg = <0x10481000 0x1000>,
-				<0x10482000 0x1000>,
+				<0x10482000 0x2000>,
 				<0x10484000 0x2000>,
 				<0x10486000 0x2000>;
 			interrupts = <1 9 0xf04>;
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
index 3839c26..aa76aa5 100644
--- a/arch/arm/boot/dts/exynos5410.dtsi
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -76,7 +76,7 @@
 			#interrupt-cells = <3>;
 			interrupt-controller;
 			reg =	<0x10481000 0x1000>,
-				<0x10482000 0x1000>,
+				<0x10482000 0x2000>,
 				<0x10484000 0x2000>,
 				<0x10486000 0x2000>;
 			interrupts = <1 9 0xf04>;
diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index ae3a17c..fa9180e 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -35,7 +35,7 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg =	<0x2E1000 0x1000>,
-			<0x2E2000 0x1000>,
+			<0x2E2000 0x2000>,
 			<0x2E4000 0x2000>,
 			<0x2E6000 0x2000>;
 		interrupts = <1 9 0xf04>;
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 3bfda16c..8915faf 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -93,7 +93,7 @@
 		interrupt-controller;
 		#interrupt-cells = <3>;
 		reg = <0x48211000 0x1000>,
-		      <0x48212000 0x1000>,
+		      <0x48212000 0x2000>,
 		      <0x48214000 0x2000>,
 		      <0x48216000 0x2000>;
 	};
diff --git a/arch/arm/boot/dts/r8a73a4.dtsi b/arch/arm/boot/dts/r8a73a4.dtsi
index 82c5ac8..65c0bd4 100644
--- a/arch/arm/boot/dts/r8a73a4.dtsi
+++ b/arch/arm/boot/dts/r8a73a4.dtsi
@@ -36,7 +36,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0 0xf1001000 0 0x1000>,
-			<0 0xf1002000 0 0x1000>,
+			<0 0xf1002000 0 0x2000>,
 			<0 0xf1004000 0 0x2000>,
 			<0 0xf1006000 0 0x2000>;
 		interrupts = <1 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index 7ff2960..b1ada72 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -102,7 +102,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0 0xf1001000 0 0x1000>,
-			<0 0xf1002000 0 0x1000>,
+			<0 0xf1002000 0 0x2000>,
 			<0 0xf1004000 0 0x2000>,
 			<0 0xf1006000 0 0x2000>;
 		interrupts = <1 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 8d7ffae..c0f2a35 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -61,7 +61,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0 0xf1001000 0 0x1000>,
-			<0 0xf1002000 0 0x1000>,
+			<0 0xf1002000 0 0x2000>,
 			<0 0xf1004000 0 0x2000>,
 			<0 0xf1006000 0 0x2000>;
 		interrupts = <1 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index a9dfa12..c8428326 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -683,7 +683,7 @@
 		gic: interrupt-controller@01c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
-			      <0x01c82000 0x1000>,
+			      <0x01c82000 0x2000>,
 			      <0x01c84000 0x2000>,
 			      <0x01c86000 0x2000>;
 			interrupt-controller;
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 01e9466..175c547 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -945,7 +945,7 @@
 		gic: interrupt-controller@01c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
-			      <0x01c82000 0x1000>,
+			      <0x01c82000 0x2000>,
 			      <0x01c84000 0x2000>,
 			      <0x01c86000 0x2000>;
 			interrupt-controller;
diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index fdc559a..9cc8baa 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -131,7 +131,7 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x50041000 0x1000>,
-		      <0x50042000 0x1000>,
+		      <0x50042000 0x2000>,
 		      <0x50044000 0x2000>,
 		      <0x50046000 0x2000>;
 		interrupts = <GIC_PPI 9
diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 6e6bc4e..6f988ee 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -95,7 +95,7 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x0 0x50041000 0x0 0x1000>,
-		      <0x0 0x50042000 0x0 0x1000>,
+		      <0x0 0x50042000 0x0 0x2000>,
 		      <0x0 0x50044000 0x0 0x2000>,
 		      <0x0 0x50046000 0x0 0x2000>;
 		interrupts = <GIC_PPI 9
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts b/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts
index 9420053..f0ec2be 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts
@@ -81,7 +81,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0 0x2c001000 0 0x1000>,
-		      <0 0x2c002000 0 0x1000>,
+		      <0 0x2c002000 0 0x2000>,
 		      <0 0x2c004000 0 0x2000>,
 		      <0 0x2c006000 0 0x2000>;
 		interrupts = <1 9 0xf04>;
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index a25c262..65dfa2a 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -103,7 +103,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0 0x2c001000 0 0x1000>,
-		      <0 0x2c002000 0 0x1000>,
+		      <0 0x2c002000 0 0x2000>,
 		      <0 0x2c004000 0 0x2000>,
 		      <0 0x2c006000 0 0x2000>;
 		interrupts = <1 9 0xf04>;
diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 40aa96c..b1009b0 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -82,7 +82,7 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x0 0x78010000 0x0 0x1000>,	/* GIC Dist */
-		      <0x0 0x78020000 0x0 0x1000>,	/* GIC CPU */
+		      <0x0 0x78020000 0x0 0x2000>,	/* GIC CPU */
 		      <0x0 0x78040000 0x0 0x2000>,	/* GIC VCPU Control */
 		      <0x0 0x78060000 0x0 0x2000>;	/* GIC VCPU */
 		interrupts = <1 9 0xf04>;	/* GIC Maintenence IRQ */
diff --git a/arch/arm64/boot/dts/foundation-v8.dts b/arch/arm64/boot/dts/foundation-v8.dts
index 4a06090..16f8233 100644
--- a/arch/arm64/boot/dts/foundation-v8.dts
+++ b/arch/arm64/boot/dts/foundation-v8.dts
@@ -70,7 +70,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0x0 0x2c001000 0 0x1000>,
-		      <0x0 0x2c002000 0 0x1000>,
+		      <0x0 0x2c002000 0 0x2000>,
 		      <0x0 0x2c004000 0 0x2000>,
 		      <0x0 0x2c006000 0 0x2000>;
 		interrupts = <1 9 0xf04>;
diff --git a/arch/arm64/boot/dts/rtsm_ve-aemv8a.dts b/arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
index 572005e..0d271ce 100644
--- a/arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
+++ b/arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
@@ -73,7 +73,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0x0 0x2c001000 0 0x1000>,
-		      <0x0 0x2c002000 0 0x1000>,
+		      <0x0 0x2c002000 0 0x2000>,
 		      <0x0 0x2c004000 0 0x2000>,
 		      <0x0 0x2c006000 0 0x2000>;
 		interrupts = <1 9 0xf04>;
-- 
1.8.3.4

