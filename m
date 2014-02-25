Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBYKhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:37:36 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:34425 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaBYKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:37:32 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v3 2/3] ARM: shmobile: r8a7778/r8a7779 dtsi: Improve and correct HSPI nodes
Date: Tue, 25 Feb 2014 11:37:20 +0100
Message-Id: <1393324641-3690-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

  - Add "renesas,hspi-r8a7778" resp. "renesas,hspi-r8a7779" compatible
    values,
  - Correct reference to parent interrupt controller
    (use "interrupt-parent" instead of "interrupt-controller"),
  - Add missing "#address-cells" and "#size-cells" properties, which are
    needed when populating the SPI buses.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Tested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> [HSPI/BockW]
---
v3:
  - Split in two patches: bindings and dtsi updates
v2:
  - Add Tested-by
  - List full example compatible properties with soctypes instead of just
    the soctypes, so checkpatch can validate DTSes.

 arch/arm/boot/dts/r8a7778.dtsi |   18 ++++++++++++------
 arch/arm/boot/dts/r8a7779.dtsi |   18 ++++++++++++------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7778.dtsi b/arch/arm/boot/dts/r8a7778.dtsi
index 85c5b3b99f5e..3c6fab5c9702 100644
--- a/arch/arm/boot/dts/r8a7778.dtsi
+++ b/arch/arm/boot/dts/r8a7778.dtsi
@@ -204,26 +204,32 @@
 	};
 
 	hspi0: spi@fffc7000 {
-		compatible = "renesas,hspi";
+		compatible = "renesas,hspi-r8a7778", "renesas,hspi";
 		reg = <0xfffc7000 0x18>;
-		interrupt-controller = <&gic>;
+		interrupt-parent = <&gic>;
 		interrupts = <0 63 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 		status = "disabled";
 	};
 
 	hspi1: spi@fffc8000 {
-		compatible = "renesas,hspi";
+		compatible = "renesas,hspi-r8a7778", "renesas,hspi";
 		reg = <0xfffc8000 0x18>;
-		interrupt-controller = <&gic>;
+		interrupt-parent = <&gic>;
 		interrupts = <0 84 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 		status = "disabled";
 	};
 
 	hspi2: spi@fffc6000 {
-		compatible = "renesas,hspi";
+		compatible = "renesas,hspi-r8a7778", "renesas,hspi";
 		reg = <0xfffc6000 0x18>;
-		interrupt-controller = <&gic>;
+		interrupt-parent = <&gic>;
 		interrupts = <0 85 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 		status = "disabled";
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
index d0561d4c7c46..8b1a336ee401 100644
--- a/arch/arm/boot/dts/r8a7779.dtsi
+++ b/arch/arm/boot/dts/r8a7779.dtsi
@@ -256,26 +256,32 @@
 	};
 
 	hspi0: spi@fffc7000 {
-		compatible = "renesas,hspi";
+		compatible = "renesas,hspi-r8a7779", "renesas,hspi";
 		reg = <0xfffc7000 0x18>;
-		interrupt-controller = <&gic>;
+		interrupt-parent = <&gic>;
 		interrupts = <0 73 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 		status = "disabled";
 	};
 
 	hspi1: spi@fffc8000 {
-		compatible = "renesas,hspi";
+		compatible = "renesas,hspi-r8a7779", "renesas,hspi";
 		reg = <0xfffc8000 0x18>;
-		interrupt-controller = <&gic>;
+		interrupt-parent = <&gic>;
 		interrupts = <0 74 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 		status = "disabled";
 	};
 
 	hspi2: spi@fffc6000 {
-		compatible = "renesas,hspi";
+		compatible = "renesas,hspi-r8a7779", "renesas,hspi";
 		reg = <0xfffc6000 0x18>;
-		interrupt-controller = <&gic>;
+		interrupt-parent = <&gic>;
 		interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 		status = "disabled";
 	};
 };
-- 
1.7.9.5

