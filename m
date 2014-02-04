Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaBDPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:25:56 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:43885 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaBDPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:24:14 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v5 05/11] ARM: shmobile: r7s72100 dtsi: Add RSPI nodes
Date: Tue,  4 Feb 2014 16:23:59 +0100
Message-Id: <1391527445-14881-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
References: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
v5:
  - Rebased on top of renesas-devel-v3.14-rc1-20140204
v4:
  - Switch to named IRQs
v3:
  - No changes
v2:
  - No changes

 arch/arm/boot/dts/r7s72100-genmai-reference.dts |    2 +-
 arch/arm/boot/dts/r7s72100.dtsi                 |   75 +++++++++++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/r7s72100-genmai-reference.dts b/arch/arm/boot/dts/r7s72100-genmai-reference.dts
index da19c70ed82b..0849017e9d2f 100644
--- a/arch/arm/boot/dts/r7s72100-genmai-reference.dts
+++ b/arch/arm/boot/dts/r7s72100-genmai-reference.dts
@@ -9,7 +9,7 @@
  */
 
 /dts-v1/;
-/include/ "r7s72100.dtsi"
+#include "r7s72100.dtsi"
 
 / {
 	model = "Genmai";
diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
index 46b82aa7dc4e..9be67a16fc6f 100644
--- a/arch/arm/boot/dts/r7s72100.dtsi
+++ b/arch/arm/boot/dts/r7s72100.dtsi
@@ -8,12 +8,22 @@
  * kind, whether express or implied.
  */
 
+#include <dt-bindings/interrupt-controller/irq.h>
+
 / {
 	compatible = "renesas,r7s72100";
 	interrupt-parent = <&gic>;
 	#address-cells = <1>;
 	#size-cells = <1>;
 
+	aliases {
+		spi0 = &spi0;
+		spi1 = &spi1;
+		spi2 = &spi2;
+		spi3 = &spi3;
+		spi4 = &spi4;
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -33,4 +43,69 @@
 		reg = <0xe8201000 0x1000>,
 			<0xe8202000 0x1000>;
 	};
+
+	spi0: spi@e800c800 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800c800 0x24>;
+		interrupts = <0 238 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 239 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 240 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi1: spi@e800d000 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800d000 0x24>;
+		interrupts = <0 241 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 242 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 243 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi2: spi@e800d800 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800d800 0x24>;
+		interrupts = <0 244 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 245 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 246 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi3: spi@e800e000 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800e000 0x24>;
+		interrupts = <0 247 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 248 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 249 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	spi4: spi@e800e800 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800e800 0x24>;
+		interrupts = <0 250 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 251 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 252 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
 };
-- 
1.7.9.5

