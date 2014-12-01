Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaLAREU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:04:20 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:58740 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaLARD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:03:27 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net,
        arnd@arndb.de, sre@kernel.org, fkan@apm.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v2 2/3] ARM: dts: vf610: add system reset controller and syscon-reboot
Date: Mon,  1 Dec 2014 18:03:08 +0100
Message-Id: <1417453389-1588-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417453389-1588-1-git-send-email-stefan@agner.ch>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the system reset controller (SRC) module and use syscon-reboot
to register a restart handler which restarts the SoC using the
SRC SW_RST bit.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf500.dtsi |  4 ++++
 arch/arm/boot/dts/vfxxx.dtsi | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
index de67005..3f38f49 100644
--- a/arch/arm/boot/dts/vf500.dtsi
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -130,6 +130,10 @@
 	interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 };
 
+&src {
+	interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+};
+
 &uart0 {
 	interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
 };
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 505969a..3e696d7 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -43,6 +43,14 @@
 		clock-frequency = <32768>;
 	};
 
+	reboot: syscon-reboot {
+		compatible = "syscon-reboot";
+		regmap = <&src>;
+		offset = <0x0>;
+		mask = <0x1000>;
+		priority = <192>;
+	};
+
 	soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -318,6 +326,11 @@
 				clocks = <&clks VF610_CLK_USBC0>;
 				status = "disabled";
 			};
+
+			src: src@4006e000 {
+				compatible = "fsl,vf610-src", "syscon";
+				reg = <0x4006e000 0x1000>;
+			};
 		};
 
 		aips1: aips-bus@40080000 {
-- 
2.1.3

