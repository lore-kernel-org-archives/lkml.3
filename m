Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaEIF4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 01:56:21 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53801 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaEIF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 01:56:19 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, pantelis.antoniou@gmail.com,
        matt.porter@linaro.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH] ARM: dts: am335x-bone-common: Add i2c2 definition
Date: Thu,  8 May 2014 22:56:23 -0700
Message-Id: <1399614983-552-1-git-send-email-mranostay@gmail.com>
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
index 2e7d932..2aedfee 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -84,6 +84,13 @@
 		>;
 	};
 
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			0x178 (PIN_INPUT_PULLUP | MUX_MODE3)	/* i2c2_sda.uart1_ctsn */
+			0x17c (PIN_INPUT_PULLUP | MUX_MODE3)	/* i2c2_scl.uart1_rtsn */
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
+	clock-frequency = <400000>;
+};
+
 /include/ "tps65217.dtsi"
 
 &tps {
-- 
1.8.3.2

