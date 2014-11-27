Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaK0Xfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:35:52 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:54878 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaK0Xfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:35:51 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH] ARM: dts: vf610: enable watchdog for Cortex-A5 dt's
Date: Fri, 28 Nov 2014 00:35:36 +0100
Message-Id: <1417131336-3136-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During restructuring of the device tree files the watchdog was
changed to be disabled by default. However, since the watchdog
instance is dedicated to the Cortex-A5, enable the peripheral
by default in the base device tree vf500.dtsi.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf500.dtsi | 5 +++++
 arch/arm/boot/dts/vfxxx.dtsi | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
index de67005..ea0f74f 100644
--- a/arch/arm/boot/dts/vf500.dtsi
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -169,3 +169,8 @@
 &usbphy1 {
 	interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
 };
+
+&wdoga5 {
+	interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 505969a..7126468 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -184,7 +184,7 @@
 				status = "disabled";
 			};
 
-			wdog@4003e000 {
+			wdoga5: wdog@4003e000 {
 				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
 				reg = <0x4003e000 0x1000>;
 				clocks = <&clks VF610_CLK_WDT>;
-- 
2.1.3

