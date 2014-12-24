Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaLXXMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 18:12:03 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:37011 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaLXXMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 18:12:00 -0500
From: Walter Lozano <walter@vanguardiasur.com.ar>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        s.trumtrar@pengutronix.de
Cc: Walter Lozano <walter@vanguardiasur.com.ar>
Subject: [PATCH v2] ARM: socfpga: dts: Add adxl34x
Date: Wed, 24 Dec 2014 20:11:52 -0300
Message-Id: <1419462712-14151-1-git-send-email-walter@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DTS bindings for the adxl34x digital
accelerometer.

Signed-off-by: Walter Lozano <walter@vanguardiasur.com.ar>
---
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
index 16ea6f5..d343e03 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
@@ -60,6 +60,22 @@
 	rxc-skew-ps = <2000>;
 };
 
+&gpio2 {
+	status = "okay";
+};
+
+&i2c1 {
+	status = "okay";
+
+	accel1: accelerometer@53 {
+		compatible = "adxl34x";
+		reg = <0x53>;
+
+		interrupt-parent = <&portc>;
+		interrupts = <3 2>;
+	};
+};
+
 &mmc0 {
 	vmmc-supply = <&regulator_3_3v>;
 	vqmmc-supply = <&regulator_3_3v>;
-- 
1.7.10.4

