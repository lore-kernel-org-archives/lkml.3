Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaKTKxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:53:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:53507 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaKTKxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:53:14 -0500
From: Lee Jones <lee@kernel.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arm@kernel.org, Matthias Klein <matthias.klein@linux.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] ARM: bcm2835: Add device tree for Raspberry Pi model B+
Date: Thu, 20 Nov 2014 10:52:45 +0000
Message-Id: <1416480765-13449-1-git-send-email-lee@kernel.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Klein <matthias.klein@linux.com>

The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
I2S interface.

Signed-off-by: Matthias Klein <matthias.klein@linux.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---

As requested by Arnd.

 arch/arm/boot/dts/Makefile               |  1 +
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts | 30 +++++++++++++++++++
 arch/arm/boot/dts/bcm2835-rpi-b.dts      | 46 ++--------------------------
 arch/arm/boot/dts/bcm2835-rpi.dtsi       | 51 ++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+), 43 deletions(-)
 create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
 create mode 100644 arch/arm/boot/dts/bcm2835-rpi.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 38c89ca..cbf7db6 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -54,6 +54,7 @@ dtb-$(CONFIG_ARCH_AT91)	+= at91-sama5d4ek.dtb
 dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
 dtb-$(CONFIG_ARCH_AXXIA) += axm5516-amarillo.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
+dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b-plus.dtb
 dtb-$(CONFIG_ARCH_BCM_5301X) += bcm4708-netgear-r6250.dtb
 dtb-$(CONFIG_ARCH_BCM_63XX) += bcm963138dvt.dtb
 dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm28155-ap.dtb \
diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
new file mode 100644
index 0000000..e479515
--- /dev/null
+++ b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
@@ -0,0 +1,30 @@
+/dts-v1/;
+/include/ "bcm2835-rpi.dtsi"
+
+/ {
+	compatible = "raspberrypi,model-b-plus", "brcm,bcm2835";
+	model = "Raspberry Pi Model B+";
+
+	leds {
+		act {
+			gpios = <&gpio 47 0>;
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
+	pinctrl-0 = <&gpioout &alt0 &i2s_alt0 &alt3>;
+
+	/* I2S interface */
+	i2s_alt0: i2s_alt0 {
+		brcm,pins = <18 19 20 21>;
+		brcm,function = <4>; /* alt0 */
+	};
+};
diff --git a/arch/arm/boot/dts/bcm2835-rpi-b.dts b/arch/arm/boot/dts/bcm2835-rpi-b.dts
index 58a0d60..bafa46f 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b.dts
@@ -1,63 +1,23 @@
 /dts-v1/;
-/include/ "bcm2835.dtsi"
+/include/ "bcm2835-rpi.dtsi"
 
 / {
 	compatible = "raspberrypi,model-b", "brcm,bcm2835";
 	model = "Raspberry Pi Model B";
 
-	memory {
-		reg = <0 0x10000000>;
-	};
-
 	leds {
-		compatible = "gpio-leds";
-
 		act {
-			label = "ACT";
 			gpios = <&gpio 16 1>;
-			default-state = "keep";
-			linux,default-trigger = "heartbeat";
 		};
 	};
 };
 
 &gpio {
-	pinctrl-names = "default";
-	pinctrl-0 = <&gpioout &alt0 &alt2 &alt3>;
-
-	gpioout: gpioout {
-		brcm,pins = <6>;
-		brcm,function = <1>; /* GPIO out */
-	};
-
-	alt0: alt0 {
-		brcm,pins = <0 1 2 3 4 5 7 8 9 10 11 14 15 40 45>;
-		brcm,function = <4>; /* alt0 */
-	};
-
-	alt3: alt3 {
-		brcm,pins = <48 49 50 51 52 53>;
-		brcm,function = <7>; /* alt3 */
-	};
+	pinctrl-0 = <&gpioout &alt0 &i2s_alt2 &alt3>;
 
 	/* I2S interface */
-	alt2: alt2 {
+	i2s_alt2: i2s_alt2 {
 		brcm,pins = <28 29 30 31>;
 		brcm,function = <6>; /* alt2 */
 	};
 };
-
-&i2c0 {
-	status = "okay";
-	clock-frequency = <100000>;
-};
-
-&i2c1 {
-	status = "okay";
-	clock-frequency = <100000>;
-};
-
-&sdhci {
-	status = "okay";
-	bus-width = <4>;
-};
diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm2835-rpi.dtsi
new file mode 100644
index 0000000..c706448
--- /dev/null
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -0,0 +1,51 @@
+/include/ "bcm2835.dtsi"
+
+/ {
+	memory {
+		reg = <0 0x10000000>;
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		act {
+			label = "ACT";
+			default-state = "keep";
+			linux,default-trigger = "heartbeat";
+		};
+	};
+};
+
+&gpio {
+	pinctrl-names = "default";
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
+&sdhci {
+	status = "okay";
+	bus-width = <4>;
+};
-- 
1.9.1

