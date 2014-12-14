Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaLNWK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:10:26 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:50186 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaLNWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:10:09 -0500
From: Stefan Agner <stefan@agner.ch>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com
Cc: u.kleine-koenig@pengutronix.de, shawn.guo@linaro.org,
        kernel@pengutronix.de, arnd@arndb.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v2 3/3] ARM: dts: vf610: add Miscellaneous System Control Module (MSCM)
Date: Sun, 14 Dec 2014 23:09:58 +0100
Message-Id: <1418594998-2361-4-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418594998-2361-1-git-send-email-stefan@agner.ch>
References: <1418594998-2361-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Miscellaneous System Control Module (MSCM) to the base
device tree for Vybrid SoCs. This module contains the peripheral
interrupt router, which is handling the routing of the interrupts
between the two cores.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf500.dtsi | 9 +++++++--
 arch/arm/boot/dts/vfxxx.dtsi | 7 +++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
index de67005..090b67e 100644
--- a/arch/arm/boot/dts/vf500.dtsi
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -24,14 +24,13 @@
 	};
 
 	soc {
-		interrupt-parent = <&intc>;
-
 		aips-bus@40000000 {
 
 			intc: interrupt-controller@40002000 {
 				compatible = "arm,cortex-a9-gic";
 				#interrupt-cells = <3>;
 				interrupt-controller;
+				interrupt-parent = <&intc>;
 				reg = <0x40003000 0x1000>,
 				      <0x40002100 0x100>;
 			};
@@ -40,6 +39,7 @@
 				compatible = "arm,cortex-a9-global-timer";
 				reg = <0x40002200 0x20>;
 				interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-parent = <&intc>;
 				clocks = <&clks VF610_CLK_PLATFORM_BUS>;
 			};
 		};
@@ -118,6 +118,11 @@
 	interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
 };
 
+&mscm {
+	interrupt-parent = <&intc>;
+	#interrupt-cells = <3>;
+};
+
 &pit {
 	interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 };
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 505969a..42ed1e9 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -47,6 +47,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "simple-bus";
+		interrupt-parent = <&mscm>;
 		ranges;
 
 		aips0: aips-bus@40000000 {
@@ -55,6 +56,12 @@
 			#size-cells = <1>;
 			ranges;
 
+			mscm: mscm@40001000 {
+				compatible = "fsl,vf610-mscm";
+				interrupt-controller;
+				reg = <0x40001000 0x1000>;
+			};
+
 			edma0: dma-controller@40018000 {
 				#dma-cells = <2>;
 				compatible = "fsl,vf610-edma";
-- 
2.1.3

