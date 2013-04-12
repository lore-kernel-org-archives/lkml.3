Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3DLO3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:29:39 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40385 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3DLO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:29:35 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v4 4/5] ARM: dts: mvebu: introduce internal-regs node
Date: Fri, 12 Apr 2013 16:29:09 +0200
Message-Id: <1365776950-30094-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365776950-30094-1-git-send-email-gregory.clement@free-electrons.com>
References: <1365776950-30094-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a 'internal-regs' subnode, under which all devices are
moved. This is not really needed for now, but will be for the
mvebu-mbus driver. This generates a lot of code movement since it's
indenting by one more tab all the devices.  So it was a good
opportunity to fix all the bad indentation.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370-db.dts              |  134 +++----
 arch/arm/boot/dts/armada-370-mirabox.dts         |  176 ++++-----
 arch/arm/boot/dts/armada-370-rd.dts              |   96 ++---
 arch/arm/boot/dts/armada-370-xp.dtsi             |  301 +++++++--------
 arch/arm/boot/dts/armada-370.dtsi                |  328 ++++++++---------
 arch/arm/boot/dts/armada-xp-db.dts               |  200 +++++-----
 arch/arm/boot/dts/armada-xp-gp.dts               |  208 +++++------
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         |  252 ++++++-------
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         |  308 ++++++++--------
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         |  428 +++++++++++-----------
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  260 ++++++-------
 arch/arm/boot/dts/armada-xp.dtsi                 |  193 +++++-----
 12 files changed, 1452 insertions(+), 1432 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
index e766f8b..2353b1f 100644
--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -30,85 +30,87 @@
 	};
 
 	soc {
-		serial@12000 {
-			clock-frequency = <200000000>;
-			status = "okay";
-		};
-		sata@a0000 {
-			nr-ports = <2>;
-			status = "okay";
-		};
-
-		mdio {
-			phy0: ethernet-phy@0 {
-				reg = <0>;
+		internal-regs {
+			serial@12000 {
+				clock-frequency = <200000000>;
+				status = "okay";
 			};
-
-			phy1: ethernet-phy@1 {
-				reg = <1>;
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
 			};
-		};
 
-		ethernet@70000 {
-			status = "okay";
-			phy = <&phy0>;
-			phy-mode = "rgmii-id";
-		};
-		ethernet@74000 {
-			status = "okay";
-			phy = <&phy1>;
-			phy-mode = "rgmii-id";
-		};
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
 
-		mvsdio@d4000 {
-			pinctrl-0 = <&sdio_pins1>;
-			pinctrl-names = "default";
-			/*
-			 * This device is disabled by default, because
-			 * using the SD card connector requires
-			 * changing the default CON40 connector
-			 * "DB-88F6710_MPP_2xRGMII_DEVICE_Jumper" to a
-			 * different connector
-			 * "DB-88F6710_MPP_RGMII_SD_Jumper".
-			 */
-			status = "disabled";
-			/* No CD or WP GPIOs */
-		};
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
+			};
 
-		usb@50000 {
-			status = "okay";
-		};
+			ethernet@70000 {
+				status = "okay";
+				phy = <&phy0>;
+				phy-mode = "rgmii-id";
+			};
+			ethernet@74000 {
+				status = "okay";
+				phy = <&phy1>;
+				phy-mode = "rgmii-id";
+			};
 
-		usb@51000 {
-			status = "okay";
-		};
+			mvsdio@d4000 {
+				pinctrl-0 = <&sdio_pins1>;
+				pinctrl-names = "default";
+				/*
+				 * This device is disabled by default, because
+				 * using the SD card connector requires
+				 * changing the default CON40 connector
+				 * "DB-88F6710_MPP_2xRGMII_DEVICE_Jumper" to a
+				 * different connector
+				 * "DB-88F6710_MPP_RGMII_SD_Jumper".
+				 */
+				status = "disabled";
+				/* No CD or WP GPIOs */
+			};
 
-		spi0: spi@10600 {
-			status = "okay";
+			usb@50000 {
+				status = "okay";
+			};
 
-			spi-flash@0 {
-				#address-cells = <1>;
-				#size-cells = <1>;
-				compatible = "mx25l25635e";
-				reg = <0>; /* Chip select 0 */
-				spi-max-frequency = <50000000>;
+			usb@51000 {
+				status = "okay";
 			};
-		};
 
-		pcie-controller {
-			status = "okay";
-			/*
-			 * The two PCIe units are accessible through
-			 * both standard PCIe slots and mini-PCIe
-			 * slots on the board.
-			 */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			spi0: spi@10600 {
 				status = "okay";
+
+				spi-flash@0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "mx25l25635e";
+					reg = <0>; /* Chip select 0 */
+					spi-max-frequency = <50000000>;
+				};
 			};
-			pcie@2,0 {
-				/* Port 1, Lane 0 */
+
+			pcie-controller {
 				status = "okay";
+				/*
+				 * The two PCIe units are accessible through
+				 * both standard PCIe slots and mini-PCIe
+				 * slots on the board.
+				 */
+				pcie@1,0 {
+					/* Port 0, Lane 0 */
+					status = "okay";
+				};
+				pcie@2,0 {
+					/* Port 1, Lane 0 */
+					status = "okay";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-370-mirabox.dts b/arch/arm/boot/dts/armada-370-mirabox.dts
index 6530ae3..14e36e1 100644
--- a/arch/arm/boot/dts/armada-370-mirabox.dts
+++ b/arch/arm/boot/dts/armada-370-mirabox.dts
@@ -25,113 +25,115 @@
 	};
 
 	soc {
-		serial@12000 {
-			clock-frequency = <200000000>;
-			status = "okay";
-		};
-		timer@20300 {
-			clock-frequency = <600000000>;
-			status = "okay";
-		};
-
-		pinctrl {
-			pwr_led_pin: pwr-led-pin {
-				marvell,pins = "mpp63";
-				marvell,function = "gpo";
+		internal-regs {
+			serial@12000 {
+				clock-frequency = <200000000>;
+				status = "okay";
 			};
-
-			stat_led_pins: stat-led-pins {
-				marvell,pins = "mpp64", "mpp65";
-				marvell,function = "gpio";
+			timer@20300 {
+				clock-frequency = <600000000>;
+				status = "okay";
 			};
-		};
 
-		gpio_leds {
-			compatible = "gpio-leds";
-			pinctrl-names = "default";
-			pinctrl-0 = <&pwr_led_pin &stat_led_pins>;
+			pinctrl {
+				pwr_led_pin: pwr-led-pin {
+					marvell,pins = "mpp63";
+					marvell,function = "gpo";
+				};
 
-			green_pwr_led {
-				label = "mirabox:green:pwr";
-				gpios = <&gpio1 31 1>;
-				linux,default-trigger = "heartbeat";
+				stat_led_pins: stat-led-pins {
+					marvell,pins = "mpp64", "mpp65";
+					marvell,function = "gpio";
+				};
 			};
 
-			blue_stat_led {
-				label = "mirabox:blue:stat";
-				gpios = <&gpio2 0 1>;
-				linux,default-trigger = "cpu0";
+			gpio_leds {
+				compatible = "gpio-leds";
+				pinctrl-names = "default";
+				pinctrl-0 = <&pwr_led_pin &stat_led_pins>;
+
+				green_pwr_led {
+					label = "mirabox:green:pwr";
+					gpios = <&gpio1 31 1>;
+					linux,default-trigger = "heartbeat";
+				};
+
+				blue_stat_led {
+					label = "mirabox:blue:stat";
+					gpios = <&gpio2 0 1>;
+					linux,default-trigger = "cpu0";
+				};
+
+				green_stat_led {
+					label = "mirabox:green:stat";
+					gpios = <&gpio2 1 1>;
+					default-state = "off";
+				};
 			};
 
-			green_stat_led {
-				label = "mirabox:green:stat";
-				gpios = <&gpio2 1 1>;
-				default-state = "off";
-			};
-		};
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
 
-		mdio {
-			phy0: ethernet-phy@0 {
-				reg = <0>;
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
 			};
-
-			phy1: ethernet-phy@1 {
-				reg = <1>;
+			ethernet@70000 {
+				status = "okay";
+				phy = <&phy0>;
+				phy-mode = "rgmii-id";
+			};
+			ethernet@74000 {
+				status = "okay";
+				phy = <&phy1>;
+				phy-mode = "rgmii-id";
 			};
-		};
-		ethernet@70000 {
-			status = "okay";
-			phy = <&phy0>;
-			phy-mode = "rgmii-id";
-		};
-		ethernet@74000 {
-			status = "okay";
-			phy = <&phy1>;
-			phy-mode = "rgmii-id";
-		};
-
-		mvsdio@d4000 {
-			pinctrl-0 = <&sdio_pins3>;
-			pinctrl-names = "default";
-			status = "okay";
-			/*
-			 * No CD or WP GPIOs: SDIO interface used for
-			 * Wifi/Bluetooth chip
-			 */
-		};
-
-		usb@50000 {
-			status = "okay";
-		};
 
-		usb@51000 {
-			status = "okay";
-		};
+			mvsdio@d4000 {
+				pinctrl-0 = <&sdio_pins3>;
+				pinctrl-names = "default";
+				status = "okay";
+				/*
+				 * No CD or WP GPIOs: SDIO interface used for
+				 * Wifi/Bluetooth chip
+				 */
+			};
 
-		i2c@11000 {
-			status = "okay";
-			clock-frequency = <100000>;
-			pca9505: pca9505@25 {
-				compatible = "nxp,pca9505";
-				gpio-controller;
-				#gpio-cells = <2>;
-				reg = <0x25>;
+			usb@50000 {
+				status = "okay";
 			};
-		};
 
-		pcie-controller {
-			status = "okay";
+			usb@51000 {
+				status = "okay";
+			};
 
-			/* Internal mini-PCIe connector */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			i2c@11000 {
 				status = "okay";
+				clock-frequency = <100000>;
+				pca9505: pca9505@25 {
+					compatible = "nxp,pca9505";
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <0x25>;
+				};
 			};
 
-			/* Connected on the PCB to a USB 3.0 XHCI controller */
-			pcie@2,0 {
-				/* Port 1, Lane 0 */
+			pcie-controller {
 				status = "okay";
+
+				/* Internal mini-PCIe connector */
+				pcie@1,0 {
+					/* Port 0, Lane 0 */
+					status = "okay";
+				};
+
+				/* Connected on the PCB to a USB 3.0 XHCI controller */
+				pcie@2,0 {
+					/* Port 1, Lane 0 */
+					status = "okay";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index 83d5c04..130f839 100644
--- a/arch/arm/boot/dts/armada-370-rd.dts
+++ b/arch/arm/boot/dts/armada-370-rd.dts
@@ -28,60 +28,62 @@
 	};
 
 	soc {
-		serial@12000 {
-			clock-frequency = <200000000>;
-			status = "okay";
-		};
-		sata@a0000 {
-			nr-ports = <2>;
-			status = "okay";
-		};
-
-		mdio {
-			phy0: ethernet-phy@0 {
-				reg = <0>;
+		internal-regs {
+			serial@12000 {
+				clock-frequency = <200000000>;
+				status = "okay";
 			};
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
+			};
+
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
 
-			phy1: ethernet-phy@1 {
-				reg = <1>;
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
 			};
-		};
 
-		ethernet@70000 {
-			status = "okay";
-			phy = <&phy0>;
-			phy-mode = "sgmii";
-		};
-		ethernet@74000 {
-			status = "okay";
-			phy = <&phy1>;
-			phy-mode = "rgmii-id";
-		};
+			ethernet@70000 {
+				status = "okay";
+				phy = <&phy0>;
+				phy-mode = "sgmii";
+			};
+			ethernet@74000 {
+				status = "okay";
+				phy = <&phy1>;
+				phy-mode = "rgmii-id";
+			};
 
-		mvsdio@d4000 {
-			pinctrl-0 = <&sdio_pins1>;
-			pinctrl-names = "default";
-			status = "okay";
-			/* No CD or WP GPIOs */
-		};
+			mvsdio@d4000 {
+				pinctrl-0 = <&sdio_pins1>;
+				pinctrl-names = "default";
+				status = "okay";
+				/* No CD or WP GPIOs */
+			};
 
-		usb@50000 {
-			status = "okay";
-		};
+			usb@50000 {
+				status = "okay";
+			};
 
-		usb@51000 {
-			status = "okay";
-		};
-	};
+			usb@51000 {
+				status = "okay";
+			};
 
-	gpio-keys {
-		compatible = "gpio-keys";
-		#address-cells = <1>;
-		#size-cells = <0>;
-		button@1 {
-			label = "Software Button";
-			linux,code = <116>;
-			gpios = <&gpio0 6 1>;
+			gpio-keys {
+				compatible = "gpio-keys";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				button@1 {
+					label = "Software Button";
+					linux,code = <116>;
+					gpios = <&gpio0 6 1>;
+				};
+			};
 		};
 	};
-};
+ };
diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index da40ce5..bf8f911 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -28,7 +28,6 @@
 		};
 	};
 
-
 	soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -36,192 +35,196 @@
 		interrupt-parent = <&mpic>;
 		ranges = <0 0xd0000000 0x100000>;
 
-		mpic: interrupt-controller@20000 {
+		internal-regs {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			mpic: interrupt-controller@20000 {
 				compatible = "marvell,mpic";
 				#interrupt-cells = <1>;
 				#size-cells = <1>;
 				interrupt-controller;
-		};
+			};
 
-		coherency-fabric@20200 {
+			coherency-fabric@20200 {
 				compatible = "marvell,coherency-fabric";
-				reg = <0x20200 0xb0>,
-				      <0x21810 0x1c>;
-		};
+				reg = <0x20200 0xb0>, <0x21810 0x1c>;
+			};
 
-		serial@12000 {
+			serial@12000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x12000 0x100>;
 				reg-shift = <2>;
 				interrupts = <41>;
 				reg-io-width = <1>;
 				status = "disabled";
-		};
-		serial@12100 {
+			};
+			serial@12100 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x12100 0x100>;
 				reg-shift = <2>;
 				interrupts = <42>;
 				reg-io-width = <1>;
 				status = "disabled";
-		};
-
-		timer@20300 {
-			       compatible = "marvell,armada-370-xp-timer";
-			       reg = <0x20300 0x30>,
-			       <0x21040 0x30>;
-			       interrupts = <37>, <38>, <39>, <40>, <5>, <6>;
-			       clocks = <&coreclk 2>;
-		};
-
-		sata@a0000 {
-			compatible = "marvell,orion-sata";
-			reg = <0xa0000 0x2400>;
-			interrupts = <55>;
-			clocks = <&gateclk 15>, <&gateclk 30>;
-			clock-names = "0", "1";
-			status = "disabled";
-		};
+			};
+
+			timer@20300 {
+				compatible = "marvell,armada-370-xp-timer";
+				reg = <0x20300 0x30>, <0x21040 0x30>;
+				interrupts = <37>, <38>, <39>, <40>, <5>, <6>;
+				clocks = <&coreclk 2>;
+			};
+
+			sata@a0000 {
+				compatible = "marvell,orion-sata";
+				reg = <0xa0000 0x2400>;
+				interrupts = <55>;
+				clocks = <&gateclk 15>, <&gateclk 30>;
+				clock-names = "0", "1";
+				status = "disabled";
+			};
 
-		mdio {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			compatible = "marvell,orion-mdio";
-			reg = <0x72004 0x4>;
-		};
+			mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "marvell,orion-mdio";
+				reg = <0x72004 0x4>;
+			};
 
-		ethernet@70000 {
+			ethernet@70000 {
 				compatible = "marvell,armada-370-neta";
 				reg = <0x70000 0x2500>;
 				interrupts = <8>;
 				clocks = <&gateclk 4>;
 				status = "disabled";
-		};
+			};
 
-		ethernet@74000 {
+			ethernet@74000 {
 				compatible = "marvell,armada-370-neta";
 				reg = <0x74000 0x2500>;
 				interrupts = <10>;
 				clocks = <&gateclk 3>;
 				status = "disabled";
-		};
-
-		i2c0: i2c@11000 {
-			compatible = "marvell,mv64xxx-i2c";
-			reg = <0x11000 0x20>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			interrupts = <31>;
-			timeout-ms = <1000>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
-
-		i2c1: i2c@11100 {
-			compatible = "marvell,mv64xxx-i2c";
-			reg = <0x11100 0x20>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			interrupts = <32>;
-			timeout-ms = <1000>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
-
-		rtc@10300 {
-			compatible = "marvell,orion-rtc";
-			reg = <0x10300 0x20>;
-			interrupts = <50>;
-		};
-
-		mvsdio@d4000 {
-			compatible = "marvell,orion-sdio";
-			reg = <0xd4000 0x200>;
-			interrupts = <54>;
-			clocks = <&gateclk 17>;
-			status = "disabled";
-		};
-
-		usb@50000 {
-			compatible = "marvell,orion-ehci";
-			reg = <0x50000 0x500>;
-			interrupts = <45>;
-			status = "disabled";
-		};
-
-		usb@51000 {
-			compatible = "marvell,orion-ehci";
-			reg = <0x51000 0x500>;
-			interrupts = <46>;
-			status = "disabled";
-		};
+			};
+
+			i2c0: i2c@11000 {
+				compatible = "marvell,mv64xxx-i2c";
+				reg = <0x11000 0x20>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				interrupts = <31>;
+				timeout-ms = <1000>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
+
+			i2c1: i2c@11100 {
+				compatible = "marvell,mv64xxx-i2c";
+				reg = <0x11100 0x20>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				interrupts = <32>;
+				timeout-ms = <1000>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
+
+			rtc@10300 {
+				compatible = "marvell,orion-rtc";
+				reg = <0x10300 0x20>;
+				interrupts = <50>;
+			};
+
+			mvsdio@d4000 {
+				compatible = "marvell,orion-sdio";
+				reg = <0xd4000 0x200>;
+				interrupts = <54>;
+				clocks = <&gateclk 17>;
+				status = "disabled";
+			};
 
-		spi0: spi@10600 {
-			compatible = "marvell,orion-spi";
-			reg = <0x10600 0x28>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			cell-index = <0>;
-			interrupts = <30>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
+			usb@50000 {
+				compatible = "marvell,orion-ehci";
+				reg = <0x50000 0x500>;
+				interrupts = <45>;
+				status = "disabled";
+			};
 
-		spi1: spi@10680 {
-			compatible = "marvell,orion-spi";
-			reg = <0x10680 0x28>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-			cell-index = <1>;
-			interrupts = <92>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
+			usb@51000 {
+				compatible = "marvell,orion-ehci";
+				reg = <0x51000 0x500>;
+				interrupts = <46>;
+				status = "disabled";
+			};
+
+			spi0: spi@10600 {
+				compatible = "marvell,orion-spi";
+				reg = <0x10600 0x28>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				cell-index = <0>;
+				interrupts = <30>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
+
+			spi1: spi@10680 {
+				compatible = "marvell,orion-spi";
+				reg = <0x10680 0x28>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				cell-index = <1>;
+				interrupts = <92>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
 
-		devbus-bootcs@10400 {
-			compatible = "marvell,mvebu-devbus";
-			reg = <0x10400 0x8>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
+			devbus-bootcs@10400 {
+				compatible = "marvell,mvebu-devbus";
+				reg = <0x10400 0x8>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
 
-		devbus-cs0@10408 {
-			compatible = "marvell,mvebu-devbus";
-			reg = <0x10408 0x8>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
+			devbus-cs0@10408 {
+				compatible = "marvell,mvebu-devbus";
+				reg = <0x10408 0x8>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
 
-		devbus-cs1@10410 {
-			compatible = "marvell,mvebu-devbus";
-			reg = <0x10410 0x8>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
+			devbus-cs1@10410 {
+				compatible = "marvell,mvebu-devbus";
+				reg = <0x10410 0x8>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
 
-		devbus-cs2@10418 {
-			compatible = "marvell,mvebu-devbus";
-			reg = <0x10418 0x8>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
-		};
+			devbus-cs2@10418 {
+				compatible = "marvell,mvebu-devbus";
+				reg = <0x10418 0x8>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
 
-		devbus-cs3@10420 {
-			compatible = "marvell,mvebu-devbus";
-			reg = <0x10420 0x8>;
-			#address-cells = <1>;
-			#size-cells = <1>;
-			clocks = <&coreclk 0>;
-			status = "disabled";
+			devbus-cs3@10420 {
+				compatible = "marvell,mvebu-devbus";
+				reg = <0x10420 0x8>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				clocks = <&coreclk 0>;
+				status = "disabled";
+			};
 		};
 	};
-};
-
+ };
diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 5c4fa65..6ef95dd 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -28,195 +28,195 @@
 	};
 
 	soc {
-
-		mpic: interrupt-controller@20000 {
-			reg = <0x20a00 0x1d0>,
-			      <0x21870 0x58>;
-		};
-
-		system-controller@18200 {
+		internal-regs {
+			system-controller@18200 {
 				compatible = "marvell,armada-370-xp-system-controller";
 				reg = <0x18200 0x100>;
-		};
-
-		L2: l2-cache {
-			compatible = "marvell,aurora-outer-cache";
-			reg = <0xd0008000 0x1000>;
-			cache-id-part = <0x100>;
-			wt-override;
-		};
-
-		pinctrl {
-			compatible = "marvell,mv88f6710-pinctrl";
-			reg = <0x18000 0x38>;
-
-			sdio_pins1: sdio-pins1 {
-			      marvell,pins = "mpp9",  "mpp11", "mpp12",
-					     "mpp13", "mpp14", "mpp15";
-			      marvell,function = "sd0";
 			};
 
-			sdio_pins2: sdio-pins2 {
-			      marvell,pins = "mpp47", "mpp48", "mpp49",
-					     "mpp50", "mpp51", "mpp52";
-			      marvell,function = "sd0";
+			L2: l2-cache {
+				compatible = "marvell,aurora-outer-cache";
+				reg = <0xd0008000 0x1000>;
+				cache-id-part = <0x100>;
+				wt-override;
 			};
 
-			sdio_pins3: sdio-pins3 {
-			      marvell,pins = "mpp48", "mpp49", "mpp50",
-					     "mpp51", "mpp52", "mpp53";
-			      marvell,function = "sd0";
+			mpic: interrupt-controller@20000 {
+				reg = <0x20a00 0x1d0>, <0x21870 0x58>;
 			};
-	        };
-
-		gpio0: gpio@18100 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18100 0x40>;
-			ngpios = <32>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <82>, <83>, <84>, <85>;
-		};
-
-		gpio1: gpio@18140 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18140 0x40>;
-			ngpios = <32>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <87>, <88>, <89>, <90>;
-		};
 
-		gpio2: gpio@18180 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18180 0x40>;
-			ngpios = <2>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <91>;
-		};
-
-		coreclk: mvebu-sar@18230 {
-			compatible = "marvell,armada-370-core-clock";
-			reg = <0x18230 0x08>;
-			#clock-cells = <1>;
-		};
-
-		gateclk: clock-gating-control@18220 {
-			compatible = "marvell,armada-370-gating-clock";
-			reg = <0x18220 0x4>;
-			clocks = <&coreclk 0>;
-			#clock-cells = <1>;
-		};
-
-		xor@60800 {
-			compatible = "marvell,orion-xor";
-			reg = <0x60800 0x100
-			       0x60A00 0x100>;
-			status = "okay";
-
-			xor00 {
-				interrupts = <51>;
-				dmacap,memcpy;
-				dmacap,xor;
-			};
-			xor01 {
-				interrupts = <52>;
-				dmacap,memcpy;
-				dmacap,xor;
-				dmacap,memset;
+			pinctrl {
+				compatible = "marvell,mv88f6710-pinctrl";
+				reg = <0x18000 0x38>;
+
+				sdio_pins1: sdio-pins1 {
+					marvell,pins = "mpp9",  "mpp11", "mpp12",
+							"mpp13", "mpp14", "mpp15";
+					marvell,function = "sd0";
+				};
+
+				sdio_pins2: sdio-pins2 {
+					marvell,pins = "mpp47", "mpp48", "mpp49",
+							"mpp50", "mpp51", "mpp52";
+					marvell,function = "sd0";
+				};
+
+				sdio_pins3: sdio-pins3 {
+					marvell,pins = "mpp48", "mpp49", "mpp50",
+							"mpp51", "mpp52", "mpp53";
+					marvell,function = "sd0";
+				};
 			};
-		};
 
-		xor@60900 {
-			compatible = "marvell,orion-xor";
-			reg = <0x60900 0x100
-			       0x60b00 0x100>;
-			status = "okay";
-
-			xor10 {
-				interrupts = <94>;
-				dmacap,memcpy;
-				dmacap,xor;
-			};
-			xor11 {
-				interrupts = <95>;
-				dmacap,memcpy;
-				dmacap,xor;
-				dmacap,memset;
+			gpio0: gpio@18100 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18100 0x40>;
+				ngpios = <32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <82>, <83>, <84>, <85>;
 			};
-		};
-
-		usb@50000 {
-			clocks = <&coreclk 0>;
-		};
 
-		usb@51000 {
-			clocks = <&coreclk 0>;
-		};
+			gpio1: gpio@18140 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18140 0x40>;
+				ngpios = <32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <87>, <88>, <89>, <90>;
+			};
 
-		thermal@18300 {
-			compatible = "marvell,armada370-thermal";
-			reg = <0x18300 0x4
-			       0x18304 0x4>;
-			status = "okay";
-		};
+			gpio2: gpio@18180 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18180 0x40>;
+				ngpios = <2>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <91>;
+			};
 
-		pcie-controller {
-			compatible = "marvell,armada-370-pcie";
-			status = "disabled";
-			device_type = "pci";
+			coreclk: mvebu-sar@18230 {
+				compatible = "marvell,armada-370-core-clock";
+				reg = <0x18230 0x08>;
+				#clock-cells = <1>;
+			};
 
-			#address-cells = <3>;
-			#size-cells = <2>;
+			gateclk: clock-gating-control@18220 {
+				compatible = "marvell,armada-370-gating-clock";
+				reg = <0x18220 0x4>;
+				clocks = <&coreclk 0>;
+				#clock-cells = <1>;
+			};
 
-			bus-range = <0x00 0xff>;
+			xor@60800 {
+				compatible = "marvell,orion-xor";
+				reg = <0x60800 0x100
+				       0x60A00 0x100>;
+				status = "okay";
+
+				xor00 {
+					interrupts = <51>;
+					dmacap,memcpy;
+					dmacap,xor;
+				};
+				xor01 {
+					interrupts = <52>;
+					dmacap,memcpy;
+					dmacap,xor;
+					dmacap,memset;
+				};
+			};
 
-			reg = <0x40000 0x2000>, <0x80000 0x2000>;
+			xor@60900 {
+				compatible = "marvell,orion-xor";
+				reg = <0x60900 0x100
+				       0x60b00 0x100>;
+				status = "okay";
+
+				xor10 {
+					interrupts = <94>;
+					dmacap,memcpy;
+					dmacap,xor;
+				};
+				xor11 {
+					interrupts = <95>;
+					dmacap,memcpy;
+					dmacap,xor;
+					dmacap,memset;
+				};
+			};
 
-			reg-names = "pcie0.0", "pcie1.0";
+			usb@50000 {
+				clocks = <&coreclk 0>;
+			};
 
-			ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
-				  0x82000000 0 0x80000 0x80000 0 0x00002000   /* Port 1.0 registers */
-				  0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
-			          0x81000000 0 0          0xe8000000 0 0x00100000>; /* downstream I/O */
+			usb@51000 {
+				clocks = <&coreclk 0>;
+			};
 
-			pcie@1,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
-				reg = <0x0800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 58>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 5>;
-				status = "disabled";
+			thermal@18300 {
+				compatible = "marvell,armada370-thermal";
+				reg = <0x18300 0x4
+					0x18304 0x4>;
+				status = "okay";
 			};
 
-			pcie@2,0 {
+			pcie-controller {
+				compatible = "marvell,armada-370-pcie";
+				status = "disabled";
 				device_type = "pci";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
-				reg = <0x1000 0 0 0 0>;
+
 				#address-cells = <3>;
 				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 62>;
-				marvell,pcie-port = <1>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 9>;
-				status = "disabled";
+
+				bus-range = <0x00 0xff>;
+
+				reg = <0x40000 0x2000>, <0x80000 0x2000>;
+
+				reg-names = "pcie0.0", "pcie1.0";
+
+				ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
+					0x82000000 0 0x80000 0x80000 0 0x00002000   /* Port 1.0 registers */
+					0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
+					0x81000000 0 0          0xe8000000 0 0x00100000>; /* downstream I/O */
+
+				pcie@1,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+					reg = <0x0800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 58>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 5>;
+					status = "disabled";
+				};
+
+				pcie@2,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+					reg = <0x1000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 62>;
+					marvell,pcie-port = <1>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 9>;
+					status = "disabled";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index e37863f..6c8b032 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -30,128 +30,130 @@
 	};
 
 	soc {
-		serial@12000 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		serial@12100 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		serial@12200 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		serial@12300 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-
-		sata@a0000 {
-			nr-ports = <2>;
-			status = "okay";
-		};
-
-		mdio {
-			phy0: ethernet-phy@0 {
-				reg = <0>;
+		internal-regs {
+			serial@12000 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-
-			phy1: ethernet-phy@1 {
-				reg = <1>;
+			serial@12100 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-
-			phy2: ethernet-phy@2 {
-				reg = <25>;
+			serial@12200 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-
-			phy3: ethernet-phy@3 {
-				reg = <27>;
+			serial@12300 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-		};
-
-		ethernet@70000 {
-			status = "okay";
-			phy = <&phy0>;
-			phy-mode = "rgmii-id";
-		};
-		ethernet@74000 {
-			status = "okay";
-			phy = <&phy1>;
-			phy-mode = "rgmii-id";
-		};
-		ethernet@30000 {
-			status = "okay";
-			phy = <&phy2>;
-			phy-mode = "sgmii";
-		};
-		ethernet@34000 {
-			status = "okay";
-			phy = <&phy3>;
-			phy-mode = "sgmii";
-		};
-
-		mvsdio@d4000 {
-			pinctrl-0 = <&sdio_pins>;
-			pinctrl-names = "default";
-			status = "okay";
-			/* No CD or WP GPIOs */
-		};
 
-		usb@50000 {
-			status = "okay";
-		};
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
+			};
 
-		usb@51000 {
-			status = "okay";
-		};
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
 
-		usb@52000 {
-			status = "okay";
-		};
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
 
-		spi0: spi@10600 {
-			status = "okay";
+				phy2: ethernet-phy@2 {
+					reg = <25>;
+				};
 
-			spi-flash@0 {
-				#address-cells = <1>;
-				#size-cells = <1>;
-				compatible = "m25p64";
-				reg = <0>; /* Chip select 0 */
-				spi-max-frequency = <20000000>;
+				phy3: ethernet-phy@3 {
+					reg = <27>;
+				};
 			};
-		};
 
-		pcie-controller {
-			status = "okay";
+			ethernet@70000 {
+				status = "okay";
+				phy = <&phy0>;
+				phy-mode = "rgmii-id";
+			};
+			ethernet@74000 {
+				status = "okay";
+				phy = <&phy1>;
+				phy-mode = "rgmii-id";
+			};
+			ethernet@30000 {
+				status = "okay";
+				phy = <&phy2>;
+				phy-mode = "sgmii";
+			};
+			ethernet@34000 {
+				status = "okay";
+				phy = <&phy3>;
+				phy-mode = "sgmii";
+			};
 
-			/*
-			 * All 6 slots are physically present as
-			 * standard PCIe slots on the board.
-			 */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			mvsdio@d4000 {
+				pinctrl-0 = <&sdio_pins>;
+				pinctrl-names = "default";
 				status = "okay";
+				/* No CD or WP GPIOs */
 			};
-			pcie@2,0 {
-				/* Port 0, Lane 1 */
+
+			usb@50000 {
 				status = "okay";
 			};
-			pcie@3,0 {
-				/* Port 0, Lane 2 */
+
+			usb@51000 {
 				status = "okay";
 			};
-			pcie@4,0 {
-				/* Port 0, Lane 3 */
+
+			usb@52000 {
 				status = "okay";
 			};
-			pcie@9,0 {
-				/* Port 2, Lane 0 */
+
+			spi0: spi@10600 {
 				status = "okay";
+
+				spi-flash@0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "m25p64";
+					reg = <0>; /* Chip select 0 */
+					spi-max-frequency = <20000000>;
+				};
 			};
-			pcie@10,0 {
-				/* Port 3, Lane 0 */
+
+			pcie-controller {
 				status = "okay";
+
+				/*
+				 * All 6 slots are physically present as
+				 * standard PCIe slots on the board.
+				 */
+				pcie@1,0 {
+					/* Port 0, Lane 0 */
+					status = "okay";
+				};
+				pcie@2,0 {
+					/* Port 0, Lane 1 */
+					status = "okay";
+				};
+				pcie@3,0 {
+					/* Port 0, Lane 2 */
+					status = "okay";
+				};
+				pcie@4,0 {
+					/* Port 0, Lane 3 */
+					status = "okay";
+				};
+				pcie@9,0 {
+					/* Port 2, Lane 0 */
+					status = "okay";
+				};
+				pcie@10,0 {
+					/* Port 3, Lane 0 */
+					status = "okay";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
index 55bcbff..d9972c9 100644
--- a/arch/arm/boot/dts/armada-xp-gp.dts
+++ b/arch/arm/boot/dts/armada-xp-gp.dts
@@ -37,126 +37,128 @@
 	};
 
 	soc {
-		serial@12000 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		serial@12100 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		serial@12200 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		serial@12300 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-
-		sata@a0000 {
-			nr-ports = <2>;
-			status = "okay";
-		};
-
-		mdio {
-			phy0: ethernet-phy@0 {
-				reg = <16>;
+		internal-regs {
+			serial@12000 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-
-			phy1: ethernet-phy@1 {
-				reg = <17>;
+			serial@12100 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-
-			phy2: ethernet-phy@2 {
-				reg = <18>;
+			serial@12200 {
+				clock-frequency = <250000000>;
+				status = "okay";
+			};
+			serial@12300 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
 
-			phy3: ethernet-phy@3 {
-				reg = <19>;
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
 			};
-		};
 
-		ethernet@70000 {
-			status = "okay";
-			phy = <&phy0>;
-			phy-mode = "rgmii-id";
-		};
-		ethernet@74000 {
-			status = "okay";
-			phy = <&phy1>;
-			phy-mode = "rgmii-id";
-		};
-		ethernet@30000 {
-			status = "okay";
-			phy = <&phy2>;
-			phy-mode = "rgmii-id";
-		};
-		ethernet@34000 {
-			status = "okay";
-			phy = <&phy3>;
-			phy-mode = "rgmii-id";
-		};
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <16>;
+				};
 
-		spi0: spi@10600 {
-			status = "okay";
+				phy1: ethernet-phy@1 {
+					reg = <17>;
+				};
 
-			spi-flash@0 {
-				#address-cells = <1>;
-				#size-cells = <1>;
-				compatible = "n25q128a13";
-				reg = <0>; /* Chip select 0 */
-				spi-max-frequency = <108000000>;
-			};
-		};
+				phy2: ethernet-phy@2 {
+					reg = <18>;
+				};
 
-		devbus-bootcs@10400 {
-			status = "okay";
-			ranges = <0 0xf0000000 0x1000000>; /* @addr 0xf000000, size 0x1000000 */
-
-			/* Device Bus parameters are required */
-
-			/* Read parameters */
-			devbus,bus-width    = <8>;
-			devbus,turn-off-ps  = <60000>;
-			devbus,badr-skew-ps = <0>;
-			devbus,acc-first-ps = <124000>;
-			devbus,acc-next-ps  = <248000>;
-			devbus,rd-setup-ps  = <0>;
-			devbus,rd-hold-ps   = <0>;
-
-			/* Write parameters */
-			devbus,sync-enable = <0>;
-			devbus,wr-high-ps  = <60000>;
-			devbus,wr-low-ps   = <60000>;
-			devbus,ale-wr-ps   = <60000>;
-
-			/* NOR 16 MiB */
-			nor@0 {
-				compatible = "cfi-flash";
-				reg = <0 0x1000000>;
-				bank-width = <2>;
+				phy3: ethernet-phy@3 {
+					reg = <19>;
+				};
 			};
-		};
 
-		pcie-controller {
-			status = "okay";
+			ethernet@70000 {
+				status = "okay";
+				phy = <&phy0>;
+				phy-mode = "rgmii-id";
+			};
+			ethernet@74000 {
+				status = "okay";
+				phy = <&phy1>;
+				phy-mode = "rgmii-id";
+			};
+			ethernet@30000 {
+				status = "okay";
+				phy = <&phy2>;
+				phy-mode = "rgmii-id";
+			};
+			ethernet@34000 {
+				status = "okay";
+				phy = <&phy3>;
+				phy-mode = "rgmii-id";
+			};
 
-			/*
-			 * The 3 slots are physically present as
-			 * standard PCIe slots on the board.
-			 */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			spi0: spi@10600 {
 				status = "okay";
+
+				spi-flash@0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "n25q128a13";
+					reg = <0>; /* Chip select 0 */
+					spi-max-frequency = <108000000>;
+				};
 			};
-			pcie@9,0 {
-				/* Port 2, Lane 0 */
+
+			devbus-bootcs@10400 {
 				status = "okay";
+				ranges = <0 0xf0000000 0x1000000>; /* @addr 0xf000000, size 0x1000000 */
+
+				/* Device Bus parameters are required */
+
+				/* Read parameters */
+				devbus,bus-width    = <8>;
+				devbus,turn-off-ps  = <60000>;
+				devbus,badr-skew-ps = <0>;
+				devbus,acc-first-ps = <124000>;
+				devbus,acc-next-ps  = <248000>;
+				devbus,rd-setup-ps  = <0>;
+				devbus,rd-hold-ps   = <0>;
+
+				/* Write parameters */
+				devbus,sync-enable = <0>;
+				devbus,wr-high-ps  = <60000>;
+				devbus,wr-low-ps   = <60000>;
+				devbus,ale-wr-ps   = <60000>;
+
+				/* NOR 16 MiB */
+				nor@0 {
+					compatible = "cfi-flash";
+					reg = <0 0x1000000>;
+					bank-width = <2>;
+				};
 			};
-			pcie@10,0 {
-				/* Port 3, Lane 0 */
+
+			pcie-controller {
 				status = "okay";
+
+				/*
+				 * The 3 slots are physically present as
+				 * standard PCIe slots on the board.
+				 */
+				pcie@1,0 {
+					/* Port 0, Lane 0 */
+					status = "okay";
+				};
+				pcie@9,0 {
+					/* Port 2, Lane 0 */
+					status = "okay";
+				};
+				pcie@10,0 {
+					/* Port 3, Lane 0 */
+					status = "okay";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index 12905ab..f8eaa38 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -44,140 +44,142 @@
 	};
 
 	soc {
-		pinctrl {
-			compatible = "marvell,mv78230-pinctrl";
-			reg = <0x18000 0x38>;
-
-			sdio_pins: sdio-pins {
-				marvell,pins = "mpp30", "mpp31", "mpp32",
-					       "mpp33", "mpp34", "mpp35";
-				marvell,function = "sd0";
+		internal-regs {
+			pinctrl {
+				compatible = "marvell,mv78230-pinctrl";
+				reg = <0x18000 0x38>;
+
+				sdio_pins: sdio-pins {
+					marvell,pins = "mpp30", "mpp31", "mpp32",
+						       "mpp33", "mpp34", "mpp35";
+					marvell,function = "sd0";
+				};
 			};
-		};
-
-		gpio0: gpio@18100 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18100 0x40>;
-			ngpios = <32>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <82>, <83>, <84>, <85>;
-		};
-
-		gpio1: gpio@18140 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18140 0x40>;
-			ngpios = <17>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <87>, <88>, <89>;
-		};
 
-		/*
-		 * MV78230 has 2 PCIe units Gen2.0: One unit can be
-		 * configured as x4 or quad x1 lanes. One unit is
-		 * x4/x1.
-		 */
-		pcie-controller {
-			compatible = "marvell,armada-xp-pcie";
-			status = "disabled";
-			device_type = "pci";
-
-			#address-cells = <3>;
-			#size-cells = <2>;
-
-			bus-range = <0x00 0xff>;
-
-			ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
-				  0x82000000 0 0x42000 0x42000 0 0x00002000   /* Port 2.0 registers */
-				  0x82000000 0 0x44000 0x44000 0 0x00002000   /* Port 0.1 registers */
-				  0x82000000 0 0x48000 0x48000 0 0x00002000   /* Port 0.2 registers */
-				  0x82000000 0 0x4c000 0x4c000 0 0x00002000   /* Port 0.3 registers */
-				  0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
-				  0x81000000 0 0	  0xe8000000 0 0x00100000>; /* downstream I/O */
-
-			pcie@1,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
-				reg = <0x0800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 58>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 5>;
-				status = "disabled";
+			gpio0: gpio@18100 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18100 0x40>;
+				ngpios = <32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <82>, <83>, <84>, <85>;
 			};
 
-			pcie@2,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
-				reg = <0x1000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 59>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <1>;
-				clocks = <&gateclk 6>;
-				status = "disabled";
+			gpio1: gpio@18140 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18140 0x40>;
+				ngpios = <17>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <87>, <88>, <89>;
 			};
 
-			pcie@3,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
-				reg = <0x1800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 60>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <2>;
-				clocks = <&gateclk 7>;
+			/*
+			 * MV78230 has 2 PCIe units Gen2.0: One unit can be
+			 * configured as x4 or quad x1 lanes. One unit is
+			 * x4/x1.
+			 */
+			pcie-controller {
+				compatible = "marvell,armada-xp-pcie";
 				status = "disabled";
-			};
-
-			pcie@4,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
-				reg = <0x2000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 61>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <3>;
-				clocks = <&gateclk 8>;
-				status = "disabled";
-			};
 
-			pcie@9,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
-				reg = <0x4800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 99>;
-				marvell,pcie-port = <2>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 26>;
-				status = "disabled";
+#address-cells = <3>;
+#size-cells = <2>;
+
+				bus-range = <0x00 0xff>;
+
+				ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
+					0x82000000 0 0x42000 0x42000 0 0x00002000   /* Port 2.0 registers */
+					0x82000000 0 0x44000 0x44000 0 0x00002000   /* Port 0.1 registers */
+					0x82000000 0 0x48000 0x48000 0 0x00002000   /* Port 0.2 registers */
+					0x82000000 0 0x4c000 0x4c000 0 0x00002000   /* Port 0.3 registers */
+					0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
+					0x81000000 0 0	  0xe8000000 0 0x00100000>; /* downstream I/O */
+
+				pcie@1,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+					reg = <0x0800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 58>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 5>;
+					status = "disabled";
+				};
+
+				pcie@2,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+					reg = <0x1000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 59>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <1>;
+					clocks = <&gateclk 6>;
+					status = "disabled";
+				};
+
+				pcie@3,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+					reg = <0x1800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 60>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <2>;
+					clocks = <&gateclk 7>;
+					status = "disabled";
+				};
+
+				pcie@4,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
+					reg = <0x2000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 61>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <3>;
+					clocks = <&gateclk 8>;
+					status = "disabled";
+				};
+
+				pcie@9,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
+					reg = <0x4800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 99>;
+					marvell,pcie-port = <2>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 26>;
+					status = "disabled";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index 1faacd1..f4029f0 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -45,177 +45,179 @@
 	};
 
 	soc {
-		pinctrl {
-			compatible = "marvell,mv78260-pinctrl";
-			reg = <0x18000 0x38>;
-
-			sdio_pins: sdio-pins {
-				marvell,pins = "mpp30", "mpp31", "mpp32",
-					       "mpp33", "mpp34", "mpp35";
-				marvell,function = "sd0";
+		internal-regs {
+			pinctrl {
+				compatible = "marvell,mv78260-pinctrl";
+				reg = <0x18000 0x38>;
+
+				sdio_pins: sdio-pins {
+					marvell,pins = "mpp30", "mpp31", "mpp32",
+						       "mpp33", "mpp34", "mpp35";
+					marvell,function = "sd0";
+				};
 			};
-		};
 
-		gpio0: gpio@18100 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18100 0x40>;
-			ngpios = <32>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <82>, <83>, <84>, <85>;
-		};
+			gpio0: gpio@18100 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18100 0x40>;
+				ngpios = <32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <82>, <83>, <84>, <85>;
+			};
 
-		gpio1: gpio@18140 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18140 0x40>;
-			ngpios = <32>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <87>, <88>, <89>, <90>;
-		};
+			gpio1: gpio@18140 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18140 0x40>;
+				ngpios = <32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <87>, <88>, <89>, <90>;
+			};
 
-		gpio2: gpio@18180 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18180 0x40>;
-			ngpios = <3>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <91>;
-		};
+			gpio2: gpio@18180 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18180 0x40>;
+				ngpios = <3>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <91>;
+			};
 
-		ethernet@34000 {
+			ethernet@34000 {
 				compatible = "marvell,armada-370-neta";
 				reg = <0x34000 0x2500>;
 				interrupts = <14>;
 				clocks = <&gateclk 1>;
 				status = "disabled";
-		};
-
-		/*
-		 * MV78260 has 3 PCIe units Gen2.0: Two units can be
-		 * configured as x4 or quad x1 lanes. One unit is
-		 * x4/x1.
-		 */
-		pcie-controller {
-			compatible = "marvell,armada-xp-pcie";
-			status = "disabled";
-			device_type = "pci";
-
-			#address-cells = <3>;
-			#size-cells = <2>;
-
-			bus-range = <0x00 0xff>;
-
-			ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
-				  0x82000000 0 0x42000 0x42000 0 0x00002000   /* Port 2.0 registers */
-				  0x82000000 0 0x44000 0x44000 0 0x00002000   /* Port 0.1 registers */
-				  0x82000000 0 0x48000 0x48000 0 0x00002000   /* Port 0.2 registers */
-				  0x82000000 0 0x4c000 0x4c000 0 0x00002000   /* Port 0.3 registers */
-				  0x82000000 0 0x80000 0x80000 0 0x00002000   /* Port 1.0 registers */
-				  0x82000000 0 0x82000 0x82000 0 0x00002000   /* Port 3.0 registers */
-				  0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
-				  0x81000000 0 0	  0xe8000000 0 0x00100000>; /* downstream I/O */
-
-			pcie@1,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
-				reg = <0x0800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 58>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 5>;
-				status = "disabled";
 			};
 
-			pcie@2,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
-				reg = <0x1000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 59>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <1>;
-				clocks = <&gateclk 6>;
+			/*
+			 * MV78260 has 3 PCIe units Gen2.0: Two units can be
+			 * configured as x4 or quad x1 lanes. One unit is
+			 * x4/x1.
+			 */
+			pcie-controller {
+				compatible = "marvell,armada-xp-pcie";
 				status = "disabled";
-			};
-
-			pcie@3,0 {
 				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
-				reg = <0x1800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 60>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <2>;
-				clocks = <&gateclk 7>;
-				status = "disabled";
-			};
 
-			pcie@4,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
-				reg = <0x2000 0 0 0 0>;
 				#address-cells = <3>;
 				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 61>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <3>;
-				clocks = <&gateclk 8>;
-				status = "disabled";
-			};
 
-			pcie@9,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
-				reg = <0x4800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 99>;
-				marvell,pcie-port = <2>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 26>;
-				status = "disabled";
-			};
-
-			pcie@10,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x82000 0 0x2000>;
-				reg = <0x5000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 103>;
-				marvell,pcie-port = <3>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 27>;
-				status = "disabled";
+				bus-range = <0x00 0xff>;
+
+				ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
+					0x82000000 0 0x42000 0x42000 0 0x00002000   /* Port 2.0 registers */
+					0x82000000 0 0x44000 0x44000 0 0x00002000   /* Port 0.1 registers */
+					0x82000000 0 0x48000 0x48000 0 0x00002000   /* Port 0.2 registers */
+					0x82000000 0 0x4c000 0x4c000 0 0x00002000   /* Port 0.3 registers */
+					0x82000000 0 0x80000 0x80000 0 0x00002000   /* Port 1.0 registers */
+					0x82000000 0 0x82000 0x82000 0 0x00002000   /* Port 3.0 registers */
+					0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
+					0x81000000 0 0	  0xe8000000 0 0x00100000>; /* downstream I/O */
+
+				pcie@1,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+					reg = <0x0800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 58>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 5>;
+					status = "disabled";
+				};
+
+				pcie@2,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x44000 0 0x2000>;
+					reg = <0x1000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 59>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <1>;
+					clocks = <&gateclk 6>;
+					status = "disabled";
+				};
+
+				pcie@3,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x48000 0 0x2000>;
+					reg = <0x1800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 60>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <2>;
+					clocks = <&gateclk 7>;
+					status = "disabled";
+				};
+
+				pcie@4,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x4c000 0 0x2000>;
+					reg = <0x2000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 61>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <3>;
+					clocks = <&gateclk 8>;
+					status = "disabled";
+				};
+
+				pcie@9,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
+					reg = <0x4800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 99>;
+					marvell,pcie-port = <2>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 26>;
+					status = "disabled";
+				};
+
+				pcie@10,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x82000 0 0x2000>;
+					reg = <0x5000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 103>;
+					marvell,pcie-port = <3>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 27>;
+					status = "disabled";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index ce4f80a..6ab56bd 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -60,243 +60,245 @@
 	};
 
 	soc {
-		pinctrl {
-			compatible = "marvell,mv78460-pinctrl";
-			reg = <0x18000 0x38>;
+		internal-regs {
+			pinctrl {
+				compatible = "marvell,mv78460-pinctrl";
+				reg = <0x18000 0x38>;
 
-			sdio_pins: sdio-pins {
-				marvell,pins = "mpp30", "mpp31", "mpp32",
-					       "mpp33", "mpp34", "mpp35";
-				marvell,function = "sd0";
+				sdio_pins: sdio-pins {
+					marvell,pins = "mpp30", "mpp31", "mpp32",
+						       "mpp33", "mpp34", "mpp35";
+					marvell,function = "sd0";
+				};
 			};
-		};
 
-		gpio0: gpio@18100 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18100 0x40>;
-			ngpios = <32>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <82>, <83>, <84>, <85>;
-		};
+			gpio0: gpio@18100 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18100 0x40>;
+				ngpios = <32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <82>, <83>, <84>, <85>;
+			};
 
-		gpio1: gpio@18140 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18140 0x40>;
-			ngpios = <32>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <87>, <88>, <89>, <90>;
-		};
+			gpio1: gpio@18140 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18140 0x40>;
+				ngpios = <32>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <87>, <88>, <89>, <90>;
+			};
 
-		gpio2: gpio@18180 {
-			compatible = "marvell,orion-gpio";
-			reg = <0x18180 0x40>;
-			ngpios = <3>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <91>;
-		};
+			gpio2: gpio@18180 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18180 0x40>;
+				ngpios = <3>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <91>;
+			};
 
-		ethernet@34000 {
+			ethernet@34000 {
 				compatible = "marvell,armada-370-neta";
 				reg = <0x34000 0x2500>;
 				interrupts = <14>;
 				clocks = <&gateclk 1>;
 				status = "disabled";
-		};
+			};
 
-		/*
-		 * MV78460 has 4 PCIe units Gen2.0: Two units can be
-		 * configured as x4 or quad x1 lanes. Two units are
-		 * x4/x1.
-		 */
-		pcie-controller {
-			compatible = "marvell,armada-xp-pcie";
-			status = "disabled";
-			device_type = "pci";
+			/*
+			 * MV78460 has 4 PCIe units Gen2.0: Two units can be
+			 * configured as x4 or quad x1 lanes. Two units are
+			 * x4/x1.
+			 */
+			pcie-controller {
+				compatible = "marvell,armada-xp-pcie";
+				status = "disabled";
+				device_type = "pci";
 
-			#address-cells = <3>;
-			#size-cells = <2>;
+				#address-cells = <3>;
+				#size-cells = <2>;
 
-			bus-range = <0x00 0xff>;
+				bus-range = <0x00 0xff>;
 
-			ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
-				  0x82000000 0 0x42000 0x42000 0 0x00002000   /* Port 2.0 registers */
-				  0x82000000 0 0x44000 0x44000 0 0x00002000   /* Port 0.1 registers */
-				  0x82000000 0 0x48000 0x48000 0 0x00002000   /* Port 0.2 registers */
-				  0x82000000 0 0x4c000 0x4c000 0 0x00002000   /* Port 0.3 registers */
-				  0x82000000 0 0x80000 0x80000 0 0x00002000   /* Port 1.0 registers */
-				  0x82000000 0 0x82000 0x82000 0 0x00002000   /* Port 3.0 registers */
-				  0x82000000 0 0x84000 0x84000 0 0x00002000   /* Port 1.1 registers */
-				  0x82000000 0 0x88000 0x88000 0 0x00002000   /* Port 1.2 registers */
-				  0x82000000 0 0x8c000 0x8c000 0 0x00002000   /* Port 1.3 registers */
-				  0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
-				  0x81000000 0 0	  0xe8000000 0 0x00100000>; /* downstream I/O */
+				ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
+					0x82000000 0 0x42000 0x42000 0 0x00002000   /* Port 2.0 registers */
+					0x82000000 0 0x44000 0x44000 0 0x00002000   /* Port 0.1 registers */
+					0x82000000 0 0x48000 0x48000 0 0x00002000   /* Port 0.2 registers */
+					0x82000000 0 0x4c000 0x4c000 0 0x00002000   /* Port 0.3 registers */
+					0x82000000 0 0x80000 0x80000 0 0x00002000   /* Port 1.0 registers */
+					0x82000000 0 0x82000 0x82000 0 0x00002000   /* Port 3.0 registers */
+					0x82000000 0 0x84000 0x84000 0 0x00002000   /* Port 1.1 registers */
+					0x82000000 0 0x88000 0x88000 0 0x00002000   /* Port 1.2 registers */
+					0x82000000 0 0x8c000 0x8c000 0 0x00002000   /* Port 1.3 registers */
+					0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
+					0x81000000 0 0	  0xe8000000 0 0x00100000>; /* downstream I/O */
 
-			pcie@1,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
-				reg = <0x0800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 58>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 5>;
-				status = "disabled";
-			};
+				pcie@1,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82000800 0 0x40000 0 0x2000>;
+					reg = <0x0800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 58>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 5>;
+					status = "disabled";
+				};
 
-			pcie@2,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
-				reg = <0x1000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 59>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <1>;
-				clocks = <&gateclk 6>;
-				status = "disabled";
-			};
+				pcie@2,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82001000 0 0x44000 0 0x2000>;
+					reg = <0x1000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 59>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <1>;
+					clocks = <&gateclk 6>;
+					status = "disabled";
+				};
 
-			pcie@3,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
-				reg = <0x1800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 60>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <2>;
-				clocks = <&gateclk 7>;
-				status = "disabled";
-			};
+				pcie@3,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82001800 0 0x48000 0 0x2000>;
+					reg = <0x1800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 60>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <2>;
+					clocks = <&gateclk 7>;
+					status = "disabled";
+				};
 
-			pcie@4,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
-				reg = <0x2000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 61>;
-				marvell,pcie-port = <0>;
-				marvell,pcie-lane = <3>;
-				clocks = <&gateclk 8>;
-				status = "disabled";
-			};
+				pcie@4,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82002000 0 0x4c000 0 0x2000>;
+					reg = <0x2000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 61>;
+					marvell,pcie-port = <0>;
+					marvell,pcie-lane = <3>;
+					clocks = <&gateclk 8>;
+					status = "disabled";
+				};
 
-			pcie@5,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
-				reg = <0x2800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 62>;
-				marvell,pcie-port = <1>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 9>;
-				status = "disabled";
-			};
+				pcie@5,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+					reg = <0x2800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 62>;
+					marvell,pcie-port = <1>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 9>;
+					status = "disabled";
+				};
 
-			pcie@6,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82003000 0 0x84000 0 0x2000>;
-				reg = <0x3000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 63>;
-				marvell,pcie-port = <1>;
-				marvell,pcie-lane = <1>;
-				clocks = <&gateclk 10>;
-				status = "disabled";
-			};
+				pcie@6,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82003000 0 0x84000 0 0x2000>;
+					reg = <0x3000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 63>;
+					marvell,pcie-port = <1>;
+					marvell,pcie-lane = <1>;
+					clocks = <&gateclk 10>;
+					status = "disabled";
+				};
 
-			pcie@7,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82003800 0 0x88000 0 0x2000>;
-				reg = <0x3800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 64>;
-				marvell,pcie-port = <1>;
-				marvell,pcie-lane = <2>;
-				clocks = <&gateclk 11>;
-				status = "disabled";
-			};
+				pcie@7,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82003800 0 0x88000 0 0x2000>;
+					reg = <0x3800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 64>;
+					marvell,pcie-port = <1>;
+					marvell,pcie-lane = <2>;
+					clocks = <&gateclk 11>;
+					status = "disabled";
+				};
 
-			pcie@8,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82004000 0 0x8c000 0 0x2000>;
-				reg = <0x4000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 65>;
-				marvell,pcie-port = <1>;
-				marvell,pcie-lane = <3>;
-				clocks = <&gateclk 12>;
-				status = "disabled";
-			};
-			pcie@9,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82004800 0 0x42000 0 0x2000>;
-				reg = <0x4800 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 99>;
-				marvell,pcie-port = <2>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 26>;
-				status = "disabled";
-			};
+				pcie@8,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82004000 0 0x8c000 0 0x2000>;
+					reg = <0x4000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 65>;
+					marvell,pcie-port = <1>;
+					marvell,pcie-lane = <3>;
+					clocks = <&gateclk 12>;
+					status = "disabled";
+				};
+				pcie@9,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82004800 0 0x42000 0 0x2000>;
+					reg = <0x4800 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 99>;
+					marvell,pcie-port = <2>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 26>;
+					status = "disabled";
+				};
 
-			pcie@10,0 {
-				device_type = "pci";
-				assigned-addresses = <0x82005000 0 0x82000 0 0x2000>;
-				reg = <0x5000 0 0 0 0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				#interrupt-cells = <1>;
-				ranges;
-				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &mpic 103>;
-				marvell,pcie-port = <3>;
-				marvell,pcie-lane = <0>;
-				clocks = <&gateclk 27>;
-				status = "disabled";
+				pcie@10,0 {
+					device_type = "pci";
+					assigned-addresses = <0x82005000 0 0x82000 0 0x2000>;
+					reg = <0x5000 0 0 0 0>;
+					#address-cells = <3>;
+					#size-cells = <2>;
+					#interrupt-cells = <1>;
+					ranges;
+					interrupt-map-mask = <0 0 0 0>;
+					interrupt-map = <0 0 0 0 &mpic 103>;
+					marvell,pcie-port = <3>;
+					marvell,pcie-lane = <0>;
+					clocks = <&gateclk 27>;
+					status = "disabled";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
index e9bc8bf..15a66a8 100644
--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -27,154 +27,156 @@
 	};
 
 	soc {
-		serial@12000 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		serial@12100 {
-			clock-frequency = <250000000>;
-			status = "okay";
-		};
-		pinctrl {
-			led_pins: led-pins-0 {
-				marvell,pins = "mpp49", "mpp51", "mpp53";
-				marvell,function = "gpio";
+		internal-regs {
+			serial@12000 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-		};
-		leds {
-			compatible = "gpio-leds";
-			pinctrl-names = "default";
-			pinctrl-0 = <&led_pins>;
-
-			red_led {
-				label = "red_led";
-				gpios = <&gpio1 17 1>;
-				default-state = "off";
+			serial@12100 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
-
-			yellow_led {
-				label = "yellow_led";
-				gpios = <&gpio1 19 1>;
-				default-state = "off";
+			pinctrl {
+				led_pins: led-pins-0 {
+					marvell,pins = "mpp49", "mpp51", "mpp53";
+					marvell,function = "gpio";
+				};
 			};
-
-			green_led {
-				label = "green_led";
-				gpios = <&gpio1 21 1>;
-				default-state = "off";
-				linux,default-trigger = "heartbeat";
+			leds {
+				compatible = "gpio-leds";
+				pinctrl-names = "default";
+				pinctrl-0 = <&led_pins>;
+
+				red_led {
+					label = "red_led";
+					gpios = <&gpio1 17 1>;
+					default-state = "off";
+				};
+
+				yellow_led {
+					label = "yellow_led";
+					gpios = <&gpio1 19 1>;
+					default-state = "off";
+				};
+
+				green_led {
+					label = "green_led";
+					gpios = <&gpio1 21 1>;
+					default-state = "off";
+					linux,default-trigger = "heartbeat";
+				};
 			};
-		};
 
-		gpio_keys {
-			compatible = "gpio-keys";
-			#address-cells = <1>;
-			#size-cells = <0>;
+			gpio_keys {
+				compatible = "gpio-keys";
+				#address-cells = <1>;
+				#size-cells = <0>;
 
-			button@1 {
-				label = "Init Button";
-				linux,code = <116>;
-				gpios = <&gpio1 28 0>;
+				button@1 {
+					label = "Init Button";
+					linux,code = <116>;
+					gpios = <&gpio1 28 0>;
+				};
 			};
-		};
 
-		mdio {
-			phy0: ethernet-phy@0 {
-				reg = <0>;
-			};
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
 
-			phy1: ethernet-phy@1 {
-				reg = <1>;
-			};
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
 
-			phy2: ethernet-phy@2 {
-				reg = <2>;
-			};
+				phy2: ethernet-phy@2 {
+					reg = <2>;
+				};
 
-			phy3: ethernet-phy@3 {
-				reg = <3>;
+				phy3: ethernet-phy@3 {
+					reg = <3>;
+				};
 			};
-		};
 
-		ethernet@70000 {
-			status = "okay";
-			phy = <&phy0>;
-			phy-mode = "sgmii";
-		};
-		ethernet@74000 {
-			status = "okay";
-			phy = <&phy1>;
-			phy-mode = "sgmii";
-		};
-		ethernet@30000 {
-			status = "okay";
-			phy = <&phy2>;
-			phy-mode = "sgmii";
-		};
-		ethernet@34000 {
-			status = "okay";
-			phy = <&phy3>;
-			phy-mode = "sgmii";
-		};
-		i2c@11000 {
-			status = "okay";
-			clock-frequency = <400000>;
-		};
-		i2c@11100 {
-			status = "okay";
-			clock-frequency = <400000>;
+			ethernet@70000 {
+				status = "okay";
+				phy = <&phy0>;
+				phy-mode = "sgmii";
+			};
+			ethernet@74000 {
+				status = "okay";
+				phy = <&phy1>;
+				phy-mode = "sgmii";
+			};
+			ethernet@30000 {
+				status = "okay";
+				phy = <&phy2>;
+				phy-mode = "sgmii";
+			};
+			ethernet@34000 {
+				status = "okay";
+				phy = <&phy3>;
+				phy-mode = "sgmii";
+			};
+			i2c@11000 {
+				status = "okay";
+				clock-frequency = <400000>;
+			};
+			i2c@11100 {
+				status = "okay";
+				clock-frequency = <400000>;
 
-			s35390a: s35390a@30 {
-				compatible = "s35390a";
-				reg = <0x30>;
+				s35390a: s35390a@30 {
+					compatible = "s35390a";
+					reg = <0x30>;
+				};
+			};
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
+			};
+			usb@50000 {
+				status = "okay";
+			};
+			usb@51000 {
+				status = "okay";
 			};
-		};
-		sata@a0000 {
-			nr-ports = <2>;
-			status = "okay";
-		};
-		usb@50000 {
-			status = "okay";
-		};
-		usb@51000 {
-			status = "okay";
-		};
 
-		devbus-bootcs@10400 {
-			status = "okay";
-			ranges = <0 0xf0000000 0x8000000>; /* @addr 0xf000000, size 0x8000000 */
-
-			/* Device Bus parameters are required */
-
-			/* Read parameters */
-			devbus,bus-width    = <8>;
-			devbus,turn-off-ps  = <60000>;
-			devbus,badr-skew-ps = <0>;
-			devbus,acc-first-ps = <124000>;
-			devbus,acc-next-ps  = <248000>;
-			devbus,rd-setup-ps  = <0>;
-			devbus,rd-hold-ps   = <0>;
-
-			/* Write parameters */
-			devbus,sync-enable = <0>;
-			devbus,wr-high-ps  = <60000>;
-			devbus,wr-low-ps   = <60000>;
-			devbus,ale-wr-ps   = <60000>;
-
-			/* NOR 128 MiB */
-			nor@0 {
-				compatible = "cfi-flash";
-				reg = <0 0x8000000>;
-				bank-width = <2>;
+			devbus-bootcs@10400 {
+				status = "okay";
+				ranges = <0 0xf0000000 0x8000000>; /* @addr 0xf000000, size 0x8000000 */
+
+				/* Device Bus parameters are required */
+
+				/* Read parameters */
+				devbus,bus-width    = <8>;
+				devbus,turn-off-ps  = <60000>;
+				devbus,badr-skew-ps = <0>;
+				devbus,acc-first-ps = <124000>;
+				devbus,acc-next-ps  = <248000>;
+				devbus,rd-setup-ps  = <0>;
+				devbus,rd-hold-ps   = <0>;
+
+				/* Write parameters */
+				devbus,sync-enable = <0>;
+				devbus,wr-high-ps  = <60000>;
+				devbus,wr-low-ps   = <60000>;
+				devbus,ale-wr-ps   = <60000>;
+
+				/* NOR 128 MiB */
+				nor@0 {
+					compatible = "cfi-flash";
+					reg = <0 0x8000000>;
+					bank-width = <2>;
+				};
 			};
-		};
 
-		pcie-controller {
-			status = "okay";
-			/* Internal mini-PCIe connector */
-			pcie@1,0 {
-				/* Port 0, Lane 0 */
+			pcie-controller {
 				status = "okay";
+				/* Internal mini-PCIe connector */
+				pcie@1,0 {
+					/* Port 0, Lane 0 */
+					status = "okay";
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index 465b9fa..bacab11 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -22,141 +22,140 @@
 	model = "Marvell Armada XP family SoC";
 	compatible = "marvell,armadaxp", "marvell,armada-370-xp";
 
-
 	soc {
-		L2: l2-cache {
-			compatible = "marvell,aurora-system-cache";
-			reg = <0x08000 0x1000>;
-			cache-id-part = <0x100>;
-			wt-override;
-		};
+		internal-regs {
+			L2: l2-cache {
+				compatible = "marvell,aurora-system-cache";
+				reg = <0x08000 0x1000>;
+				cache-id-part = <0x100>;
+				wt-override;
+			};
 
-		mpic: interrupt-controller@20000 {
-		      reg = <0x20a00 0x2d0>,
-			    <0x21070 0x58>;
-		};
+			mpic: interrupt-controller@20000 {
+			      reg = <0x20a00 0x2d0>, <0x21070 0x58>;
+			};
 
-		armada-370-xp-pmsu@22000 {
-			compatible = "marvell,armada-370-xp-pmsu";
-			reg = <0x22100 0x430>,
-			      <0x20800 0x20>;
-		};
+			armada-370-xp-pmsu@22000 {
+				compatible = "marvell,armada-370-xp-pmsu";
+				reg = <0x22100 0x430>, <0x20800 0x20>;
+			};
 
-		serial@12200 {
+			serial@12200 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x12200 0x100>;
 				reg-shift = <2>;
 				interrupts = <43>;
 				reg-io-width = <1>;
 				status = "disabled";
-		};
-		serial@12300 {
+			};
+			serial@12300 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x12300 0x100>;
 				reg-shift = <2>;
 				interrupts = <44>;
 				reg-io-width = <1>;
 				status = "disabled";
-		};
+			};
 
-		timer@20300 {
+			timer@20300 {
 				marvell,timer-25Mhz;
-		};
+			};
 
-		coreclk: mvebu-sar@18230 {
-			compatible = "marvell,armada-xp-core-clock";
-			reg = <0x18230 0x08>;
-			#clock-cells = <1>;
-		};
+			coreclk: mvebu-sar@18230 {
+				compatible = "marvell,armada-xp-core-clock";
+				reg = <0x18230 0x08>;
+				#clock-cells = <1>;
+			};
 
-		cpuclk: clock-complex@18700 {
-			#clock-cells = <1>;
-			compatible = "marvell,armada-xp-cpu-clock";
-			reg = <0x18700 0xA0>;
-			clocks = <&coreclk 1>;
-		};
+			cpuclk: clock-complex@18700 {
+				#clock-cells = <1>;
+				compatible = "marvell,armada-xp-cpu-clock";
+				reg = <0x18700 0xA0>;
+				clocks = <&coreclk 1>;
+			};
 
-		gateclk: clock-gating-control@18220 {
-			compatible = "marvell,armada-xp-gating-clock";
-			reg = <0x18220 0x4>;
-			clocks = <&coreclk 0>;
-			#clock-cells = <1>;
-		};
+			gateclk: clock-gating-control@18220 {
+				compatible = "marvell,armada-xp-gating-clock";
+				reg = <0x18220 0x4>;
+				clocks = <&coreclk 0>;
+				#clock-cells = <1>;
+			};
 
-		system-controller@18200 {
+			system-controller@18200 {
 				compatible = "marvell,armada-370-xp-system-controller";
 				reg = <0x18200 0x500>;
-		};
+			};
 
-		ethernet@30000 {
+			ethernet@30000 {
 				compatible = "marvell,armada-370-neta";
 				reg = <0x30000 0x2500>;
 				interrupts = <12>;
 				clocks = <&gateclk 2>;
 				status = "disabled";
-		};
-
-		xor@60900 {
-			compatible = "marvell,orion-xor";
-			reg = <0x60900 0x100
-			       0x60b00 0x100>;
-			clocks = <&gateclk 22>;
-			status = "okay";
-
-			xor10 {
-				interrupts = <51>;
-				dmacap,memcpy;
-				dmacap,xor;
 			};
-			xor11 {
-				interrupts = <52>;
-				dmacap,memcpy;
-				dmacap,xor;
-				dmacap,memset;
-			};
-		};
 
-		xor@f0900 {
-			compatible = "marvell,orion-xor";
-			reg = <0xF0900 0x100
-			       0xF0B00 0x100>;
-			clocks = <&gateclk 28>;
-			status = "okay";
-
-			xor00 {
-				interrupts = <94>;
-				dmacap,memcpy;
-				dmacap,xor;
+			xor@60900 {
+				compatible = "marvell,orion-xor";
+				reg = <0x60900 0x100
+				       0x60b00 0x100>;
+				clocks = <&gateclk 22>;
+				status = "okay";
+
+				xor10 {
+					interrupts = <51>;
+					dmacap,memcpy;
+					dmacap,xor;
+				};
+				xor11 {
+					interrupts = <52>;
+					dmacap,memcpy;
+					dmacap,xor;
+					dmacap,memset;
+				};
 			};
-			xor01 {
-				interrupts = <95>;
-				dmacap,memcpy;
-				dmacap,xor;
-				dmacap,memset;
+
+			xor@f0900 {
+				compatible = "marvell,orion-xor";
+				reg = <0xF0900 0x100
+				       0xF0B00 0x100>;
+				clocks = <&gateclk 28>;
+				status = "okay";
+
+				xor00 {
+					interrupts = <94>;
+					dmacap,memcpy;
+					dmacap,xor;
+				};
+				xor01 {
+					interrupts = <95>;
+					dmacap,memcpy;
+					dmacap,xor;
+					dmacap,memset;
+				};
 			};
-		};
 
-		usb@50000 {
-			clocks = <&gateclk 18>;
-		};
+			usb@50000 {
+				clocks = <&gateclk 18>;
+			};
 
-		usb@51000 {
-			clocks = <&gateclk 19>;
-		};
+			usb@51000 {
+				clocks = <&gateclk 19>;
+			};
 
-		usb@52000 {
-			compatible = "marvell,orion-ehci";
-			reg = <0x52000 0x500>;
-			interrupts = <47>;
-			clocks = <&gateclk 20>;
-			status = "disabled";
-		};
+			usb@52000 {
+				compatible = "marvell,orion-ehci";
+				reg = <0x52000 0x500>;
+				interrupts = <47>;
+				clocks = <&gateclk 20>;
+				status = "disabled";
+			};
 
-		thermal@182b0 {
-			compatible = "marvell,armadaxp-thermal";
-			reg = <0x182b0 0x4
-			       0x184d0 0x4>;
-			status = "okay";
+			thermal@182b0 {
+				compatible = "marvell,armadaxp-thermal";
+				reg = <0x182b0 0x4
+					0x184d0 0x4>;
+				status = "okay";
+			};
 		};
 	};
 };
-- 
1.7.9.5

