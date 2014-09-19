Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaISUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:16:57 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:35767 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbaISUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:14:52 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] ARM: mvebu: armada-xp: Use pinctrl node alias
Date: Fri, 19 Sep 2014 22:14:39 +0200
Message-Id: <1411157684-6991-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Armada XP pinctrl node gained an alias, make use of it.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/armada-xp-axpwifiap.dts        |  68 +++++-----
 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts  |  62 ++++-----
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         |   8 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         |   8 +-
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         |   8 +-
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts   | 164 +++++++++++------------
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  14 +-
 7 files changed, 167 insertions(+), 165 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-axpwifiap.dts b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
index 546016148283..cdab007fbaf4 100644
--- a/arch/arm/boot/dts/armada-xp-axpwifiap.dts
+++ b/arch/arm/boot/dts/armada-xp-axpwifiap.dts
@@ -60,40 +60,6 @@
 		};
 
 		internal-regs {
-			pinctrl: pin-ctrl@18000 {
-				pinctrl-0 = <&pmx_phy_int>;
-				pinctrl-names = "default";
-
-				pmx_ge0: pmx-ge0 {
-					marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3",
-						       "mpp4", "mpp5", "mpp6", "mpp7",
-						       "mpp8", "mpp9", "mpp10", "mpp11";
-					marvell,function = "ge0";
-				};
-
-				pmx_ge1: pmx-ge1 {
-					marvell,pins = "mpp12", "mpp13", "mpp14", "mpp15",
-						       "mpp16", "mpp17", "mpp18", "mpp19",
-						       "mpp20", "mpp21", "mpp22", "mpp23";
-					marvell,function = "ge1";
-				};
-
-				pmx_keys: pmx-keys {
-					marvell,pins = "mpp33";
-					marvell,function = "gpio";
-				};
-
-				pmx_spi: pmx-spi {
-					marvell,pins = "mpp36", "mpp37", "mpp38", "mpp39";
-					marvell,function = "spi";
-				};
-
-				pmx_phy_int: pmx-phy-int {
-					marvell,pins = "mpp32";
-					marvell,function = "gpio";
-				};
-			};
-
 			serial@12000 {
 				status = "okay";
 			};
@@ -162,3 +128,37 @@
 		};
 	};
 };
+
+&pinctrl {
+	pinctrl-0 = <&pmx_phy_int>;
+	pinctrl-names = "default";
+
+	pmx_ge0: pmx-ge0 {
+		marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3",
+			       "mpp4", "mpp5", "mpp6", "mpp7",
+			       "mpp8", "mpp9", "mpp10", "mpp11";
+		marvell,function = "ge0";
+	};
+
+	pmx_ge1: pmx-ge1 {
+		marvell,pins = "mpp12", "mpp13", "mpp14", "mpp15",
+			       "mpp16", "mpp17", "mpp18", "mpp19",
+			       "mpp20", "mpp21", "mpp22", "mpp23";
+		marvell,function = "ge1";
+	};
+
+	pmx_keys: pmx-keys {
+		marvell,pins = "mpp33";
+		marvell,function = "gpio";
+	};
+
+	pmx_spi: pmx-spi {
+		marvell,pins = "mpp36", "mpp37", "mpp38", "mpp39";
+		marvell,function = "spi";
+	};
+
+	pmx_phy_int: pmx-phy-int {
+		marvell,pins = "mpp32";
+		marvell,function = "gpio";
+	};
+};
diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
index baa43a004299..492cd8e3f424 100644
--- a/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
+++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
@@ -51,37 +51,6 @@
 		};
 
 		internal-regs {
-			pinctrl: pin-ctrl@18000 {
-				poweroff_pin: poweroff-pin {
-					marvell,pins = "mpp24";
-					marvell,function = "gpio";
-				};
-
-				power_button_pin: power-button-pin {
-					marvell,pins = "mpp44";
-					marvell,function = "gpio";
-				};
-
-				reset_button_pin: reset-button-pin {
-					marvell,pins = "mpp45";
-					marvell,function = "gpio";
-				};
-				select_button_pin: select-button-pin {
-					marvell,pins = "mpp41";
-					marvell,function = "gpio";
-				};
-
-				scroll_button_pin: scroll-button-pin {
-					marvell,pins = "mpp42";
-					marvell,function = "gpio";
-				};
-
-				hdd_led_pin: hdd-led-pin {
-					marvell,pins = "mpp26";
-					marvell,function = "gpio";
-				};
-			};
-
 			serial@12000 {
 				status = "okay";
 			};
@@ -282,3 +251,34 @@
 		gpios = <&gpio0 24 GPIO_ACTIVE_HIGH>;
 	};
 };
+
+&pinctrl {
+	poweroff_pin: poweroff-pin {
+		marvell,pins = "mpp24";
+		marvell,function = "gpio";
+	};
+
+	power_button_pin: power-button-pin {
+		marvell,pins = "mpp44";
+		marvell,function = "gpio";
+	};
+
+	reset_button_pin: reset-button-pin {
+		marvell,pins = "mpp45";
+		marvell,function = "gpio";
+	};
+	select_button_pin: select-button-pin {
+		marvell,pins = "mpp41";
+		marvell,function = "gpio";
+	};
+
+	scroll_button_pin: scroll-button-pin {
+		marvell,pins = "mpp42";
+		marvell,function = "gpio";
+	};
+
+	hdd_led_pin: hdd-led-pin {
+		marvell,pins = "mpp26";
+		marvell,function = "gpio";
+	};
+};
diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index e24ef072b8cb..281ccd24295c 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -167,10 +167,6 @@
 		};
 
 		internal-regs {
-			pinctrl: pin-ctrl@18000 {
-				compatible = "marvell,mv78230-pinctrl";
-			};
-
 			gpio0: gpio@18100 {
 				compatible = "marvell,orion-gpio";
 				reg = <0x18100 0x40>;
@@ -195,3 +191,7 @@
 		};
 	};
 };
+
+&pinctrl {
+	compatible = "marvell,mv78230-pinctrl";
+};
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index 53dfb157b91a..d7a8d0b0f385 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -251,10 +251,6 @@
 		};
 
 		internal-regs {
-			pinctrl: pin-ctrl@18000 {
-				compatible = "marvell,mv78260-pinctrl";
-			};
-
 			gpio0: gpio@18100 {
 				compatible = "marvell,orion-gpio";
 				reg = <0x18100 0x40>;
@@ -298,3 +294,7 @@
 		};
 	};
 };
+
+&pinctrl {
+	compatible = "marvell,mv78260-pinctrl";
+};
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index 8b4ab0a5d620..9c40c130d11a 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -289,10 +289,6 @@
 		};
 
 		internal-regs {
-			pinctrl: pin-ctrl@18000 {
-				compatible = "marvell,mv78460-pinctrl";
-			};
-
 			gpio0: gpio@18100 {
 				compatible = "marvell,orion-gpio";
 				reg = <0x18100 0x40>;
@@ -336,3 +332,7 @@
 		};
 	};
 };
+
+&pinctrl {
+	compatible = "marvell,mv78460-pinctrl";
+};
diff --git a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts b/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
index b3951c39c5da..8c241d08f2a3 100644
--- a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
+++ b/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
@@ -55,88 +55,6 @@
 		};
 
 		internal-regs {
-			pinctrl: pin-ctrl@18000 {
-				poweroff: poweroff {
-					marvell,pins = "mpp42";
-					marvell,function = "gpio";
-				};
-
-				power_button_pin: power-button-pin {
-					marvell,pins = "mpp27";
-					marvell,function = "gpio";
-				};
-
-				reset_button_pin: reset-button-pin {
-					marvell,pins = "mpp41";
-					marvell,function = "gpio";
-				};
-
-				sata1_led_pin: sata1-led-pin {
-					marvell,pins = "mpp31";
-					marvell,function = "gpio";
-				};
-
-				sata2_led_pin: sata2-led-pin {
-					marvell,pins = "mpp40";
-					marvell,function = "gpio";
-				};
-
-				sata3_led_pin: sata3-led-pin {
-					marvell,pins = "mpp44";
-					marvell,function = "gpio";
-				};
-
-				sata4_led_pin: sata4-led-pin {
-					marvell,pins = "mpp47";
-					marvell,function = "gpio";
-				};
-
-				sata1_power_pin: sata1-power-pin {
-					marvell,pins = "mpp24";
-					marvell,function = "gpio";
-				};
-
-				sata2_power_pin: sata2-power-pin {
-					marvell,pins = "mpp25";
-					marvell,function = "gpio";
-				};
-
-				sata3_power_pin: sata3-power-pin {
-					marvell,pins = "mpp26";
-					marvell,function = "gpio";
-				};
-
-				sata4_power_pin: sata4-power-pin {
-					marvell,pins = "mpp28";
-					marvell,function = "gpio";
-				};
-
-				sata1_pres_pin: sata1-pres-pin {
-					marvell,pins = "mpp32";
-					marvell,function = "gpio";
-				};
-
-				sata2_pres_pin: sata2-pres-pin {
-					marvell,pins = "mpp33";
-					marvell,function = "gpio";
-				};
-
-				sata3_pres_pin: sata3-pres-pin {
-					marvell,pins = "mpp34";
-					marvell,function = "gpio";
-				};
-
-				sata4_pres_pin: sata4-pres-pin {
-					marvell,pins = "mpp35";
-					marvell,function = "gpio";
-				};
-
-				err_led_pin: err-led-pin {
-					marvell,pins = "mpp45";
-					marvell,function = "gpio";
-				};
-			};
-
 			serial@12000 {
 				status = "okay";
 			};
@@ -324,3 +242,85 @@
 		gpios = <&gpio1 10 GPIO_ACTIVE_LOW>;
 	};
 };
+
+&pinctrl {
+	poweroff: poweroff {
+		marvell,pins = "mpp42";
+		marvell,function = "gpio";
+	};
+
+	power_button_pin: power-button-pin {
+		marvell,pins = "mpp27";
+		marvell,function = "gpio";
+	};
+
+	reset_button_pin: reset-button-pin {
+		marvell,pins = "mpp41";
+		marvell,function = "gpio";
+	};
+
+	sata1_led_pin: sata1-led-pin {
+		marvell,pins = "mpp31";
+		marvell,function = "gpio";
+	};
+
+	sata2_led_pin: sata2-led-pin {
+		marvell,pins = "mpp40";
+		marvell,function = "gpio";
+	};
+
+	sata3_led_pin: sata3-led-pin {
+		marvell,pins = "mpp44";
+		marvell,function = "gpio";
+	};
+
+	sata4_led_pin: sata4-led-pin {
+		marvell,pins = "mpp47";
+		marvell,function = "gpio";
+	};
+
+	sata1_power_pin: sata1-power-pin {
+		marvell,pins = "mpp24";
+		marvell,function = "gpio";
+	};
+
+	sata2_power_pin: sata2-power-pin {
+		marvell,pins = "mpp25";
+		marvell,function = "gpio";
+	};
+
+	sata3_power_pin: sata3-power-pin {
+		marvell,pins = "mpp26";
+		marvell,function = "gpio";
+	};
+
+	sata4_power_pin: sata4-power-pin {
+		marvell,pins = "mpp28";
+		marvell,function = "gpio";
+	};
+
+	sata1_pres_pin: sata1-pres-pin {
+		marvell,pins = "mpp32";
+		marvell,function = "gpio";
+	};
+
+	sata2_pres_pin: sata2-pres-pin {
+		marvell,pins = "mpp33";
+		marvell,function = "gpio";
+	};
+
+	sata3_pres_pin: sata3-pres-pin {
+		marvell,pins = "mpp34";
+		marvell,function = "gpio";
+	};
+
+	sata4_pres_pin: sata4-pres-pin {
+		marvell,pins = "mpp35";
+		marvell,function = "gpio";
+	};
+
+	err_led_pin: err-led-pin {
+		marvell,pins = "mpp45";
+		marvell,function = "gpio";
+	};
+};
diff --git a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
index 394f085751be..6f6b0916df48 100644
--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -77,12 +77,7 @@
 			serial@12100 {
 				status = "okay";
 			};
-			pinctrl: pin-ctrl@18000 {
-				led_pins: led-pins-0 {
-					marvell,pins = "mpp49", "mpp51", "mpp53";
-					marvell,function = "gpio";
-				};
-			};
+
 			leds {
 				compatible = "gpio-leds";
 				pinctrl-names = "default";
@@ -187,3 +182,10 @@
 		};
 	};
 };
+
+&pinctrl {
+	led_pins: led-pins-0 {
+		marvell,pins = "mpp49", "mpp51", "mpp53";
+		marvell,function = "gpio";
+	};
+};
-- 
2.0.0

