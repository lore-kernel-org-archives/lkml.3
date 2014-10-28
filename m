Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaJ1AxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:53:12 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62318 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaJ1AxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:53:09 -0400
From: Matthias Klein <matthias.klein@linux.com>
To: linux-rpi-kernel@lists.infradead.org, swarren@wwwdotorg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: bcm2835: add device tree for Raspberry Pi model B+
Date: Tue, 28 Oct 2014 01:52:46 +0100
Message-Id: <1414457566-31802-1-git-send-email-matthias.klein@linux.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The model B and B+ differ in the GPIO lines for ACT and PWR led.
The PWR led on the B+ model is active low.

Signed-off-by: Matthias Klein <matthias.klein@linux.com>
---
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts | 64 ++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts

diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
new file mode 100644
index 0000000..c01d7cb
--- /dev/null
+++ b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
@@ -0,0 +1,64 @@
+/dts-v1/;
+/include/ "bcm2835.dtsi"
+
+/ {
+	compatible = "raspberrypi,model-b-plus", "brcm,bcm2835";
+	model = "Raspberry Pi Model B+";
+
+	memory {
+		reg = <0 0x10000000>;
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		act {
+			label = "ACT";
+			gpios = <&gpio 47 1>;
+			default-state = "keep";
+			linux,default-trigger = "heartbeat";
+		};
+
+		pwr {
+			label = "PWR";
+			gpios = <&gpio 35 0>;
+			default-state = "keep";
+			linux,default-trigger = "default-on";
+		};
+	};
+};
+
+&gpio {
+	pinctrl-names = "default";
+	pinctrl-0 = <&gpioout &alt0 &alt3>;
+
+	gpioout: gpioout {
+		brcm,pins = <6>;
+		brcm,function = <1>; /* GPIO out */
+	};
+
+	alt0: alt0 {
+		brcm,pins = <0 1 2 3 4 5 7 8 9 10 11 14 15 40 45>;
+		brcm,function = <4>; /* alt0 */
+	};
+
+	alt3: alt3 {
+		brcm,pins = <48 49 50 51 52 53>;
+		brcm,function = <7>; /* alt3 */
+	};
+};
+
+&i2c0 {
+	status = "okay";
+	clock-frequency = <100000>;
+};
+
+&i2c1 {
+	status = "okay";
+	clock-frequency = <100000>;
+};
+
+&mmc {
+	status = "okay";
+	bus-width = <4>;
+};
-- 
2.1.2

