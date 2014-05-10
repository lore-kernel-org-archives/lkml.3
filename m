Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaEJBnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 21:43:05 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54250 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEJBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 21:43:03 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pantelis.antoniou@gmail.com,
        matt.porter@linaro.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
Date: Fri,  9 May 2014 18:43:04 -0700
Message-Id: <1399686184-1594-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing i2c2 bus define to access various cape and
prototype/breakout board devices.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 2e7d932..5fdae2e 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -84,6 +84,13 @@
 		>;
 	};
 
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			0x178 (PIN_INPUT_PULLUP | MUX_MODE3)	/* uart1_ctsn.i2c2_sda */
+			0x17c (PIN_INPUT_PULLUP | MUX_MODE3)	/* uart1_rtsn.i2c2_scl */
+		>;
+	};
+
 	uart0_pins: pinmux_uart0_pins {
 		pinctrl-single,pins = <
 			0x170 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart0_rxd.uart0_rxd */
@@ -222,6 +229,15 @@
 
 };
 
+
+&i2c2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c2_pins>;
+
+	status = "okay";
+	clock-frequency = <100000>;
+};
+
 /include/ "tps65217.dtsi"
 
 &tps {
-- 
1.8.3.2

