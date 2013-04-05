Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162837Ab3DEUYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:24:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:40694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162796Ab3DEUYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:24:31 -0400
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
Subject: [PATCH v2 7/9] arm: dts: mvebu: introduce internal-regs node
Date: Fri,  5 Apr 2013 22:24:02 +0200
Message-Id: <1365193444-13441-8-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370-db.dts              |  108 +++++-----
 arch/arm/boot/dts/armada-370-mirabox.dts         |   78 ++++----
 arch/arm/boot/dts/armada-370-rd.dts              |    2 +
 arch/arm/boot/dts/armada-370-xp.dtsi             |  228 +++++++++++-----------
 arch/arm/boot/dts/armada-370.dtsi                |  211 ++++++++++----------
 arch/arm/boot/dts/armada-xp-db.dts               |  154 +++++++--------
 arch/arm/boot/dts/armada-xp-gp.dts               |  124 ++++++------
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         |   56 +++---
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         |   80 ++++----
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         |   80 ++++----
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  196 ++++++++++---------
 arch/arm/boot/dts/armada-xp.dtsi                 |  182 +++++++++--------
 12 files changed, 759 insertions(+), 740 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
index 183901c..6c30a9f 100644
--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -30,68 +30,70 @@
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
+			};
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
 			};
 
-			phy1: ethernet-phy@1 {
-				reg = <1>;
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
+
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
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
 
-		usb@50000 {
-			status = "okay";
-		};
+			usb@50000 {
+				status = "okay";
+			};
 
-		usb@51000 {
-			status = "okay";
-		};
+			usb@51000 {
+				status = "okay";
+			};
 
-		spi0: spi@10600 {
-			status = "okay";
+			spi0: spi@10600 {
+				status = "okay";
 
-			spi-flash@0 {
-				#address-cells = <1>;
-				#size-cells = <1>;
-				compatible = "mx25l25635e";
-				reg = <0>; /* Chip select 0 */
-				spi-max-frequency = <50000000>;
+				spi-flash@0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "mx25l25635e";
+					reg = <0>; /* Chip select 0 */
+					spi-max-frequency = <50000000>;
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-370-mirabox.dts b/arch/arm/boot/dts/armada-370-mirabox.dts
index 2773eee..5a06e87 100644
--- a/arch/arm/boot/dts/armada-370-mirabox.dts
+++ b/arch/arm/boot/dts/armada-370-mirabox.dts
@@ -25,50 +25,52 @@
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
-		mdio {
-			phy0: ethernet-phy@0 {
-				reg = <0>;
+		internal-regs {
+			serial@12000 {
+				clock-frequency = <200000000>;
+				status = "okay";
 			};
+			timer@20300 {
+				clock-frequency = <600000000>;
+				status = "okay";
+			};
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
 
-			phy1: ethernet-phy@1 {
-				reg = <1>;
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
+			};
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
 
-		mvsdio@d4000 {
-			pinctrl-0 = <&sdio_pins2>;
-			pinctrl-names = "default";
-			status = "okay";
-			/*
-			 * No CD or WP GPIOs: SDIO interface used for
-			 * Wifi/Bluetooth chip
-			 */
-		};
+			mvsdio@d4000 {
+				pinctrl-0 = <&sdio_pins2>;
+				pinctrl-names = "default";
+				status = "okay";
+				/*
+				 * No CD or WP GPIOs: SDIO interface used for
+				 * Wifi/Bluetooth chip
+				 */
+			};
 
-		usb@50000 {
-			status = "okay";
-		};
+			usb@50000 {
+				status = "okay";
+			};
 
-		usb@51000 {
-			status = "okay";
+			usb@51000 {
+				status = "okay";
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index be209020..437dcd2 100644
--- a/arch/arm/boot/dts/armada-370-rd.dts
+++ b/arch/arm/boot/dts/armada-370-rd.dts
@@ -28,6 +28,7 @@
 	};
 
 	soc {
+		internal-regs {
 		serial@12000 {
 			clock-frequency = <200000000>;
 			status = "okay";
@@ -72,5 +73,6 @@
 		usb@51000 {
 			status = "okay";
 		};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 1874655..8b9adc6 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -28,7 +28,6 @@
 		};
 	};
 
-
 	soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -36,151 +35,156 @@
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
-		addr-decoding@20000 {
-			compatible = "marvell,armada-addr-decoding-controller";
-			reg = <0x20000 0x258>;
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
+			addr-decoding@20000 {
+				compatible = "marvell,armada-addr-decoding-controller";
+				reg = <0x20000 0x258>;
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
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 661bdcb..296097d 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -28,132 +28,131 @@
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
+			};
 
-			sdio_pins1: sdio-pins1 {
-			      marvell,pins = "mpp9",  "mpp11", "mpp12",
-					     "mpp13", "mpp14", "mpp15";
-			      marvell,function = "sd0";
+			L2: l2-cache {
+				compatible = "marvell,aurora-outer-cache";
+				reg = <0xd0008000 0x1000>;
+				cache-id-part = <0x100>;
+				wt-override;
 			};
 
-			sdio_pins2: sdio-pins2 {
-			      marvell,pins = "mpp47", "mpp48", "mpp49",
-					     "mpp50", "mpp51", "mpp52";
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
+			pinctrl {
+				compatible = "marvell,mv88f6710-pinctrl";
+				reg = <0x18000 0x38>;
 
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
+			sdio_pins1: sdio-pins1 {
+					marvell,pins = "mpp9",  "mpp11", "mpp12",
+						"mpp13", "mpp14", "mpp15";
+					marvell,function = "sd0";
+				};
 
-		coreclk: mvebu-sar@18230 {
-			compatible = "marvell,armada-370-core-clock";
-			reg = <0x18230 0x08>;
-			#clock-cells = <1>;
-		};
+			sdio_pins2: sdio-pins2 {
+					marvell,pins = "mpp47", "mpp48", "mpp49",
+						"mpp50", "mpp51", "mpp52";
+					marvell,function = "sd0";
+				};
+			};
 
-		gateclk: clock-gating-control@18220 {
-			compatible = "marvell,armada-370-gating-clock";
-			reg = <0x18220 0x4>;
-			clocks = <&coreclk 0>;
-			#clock-cells = <1>;
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
 
-		xor@60800 {
-			compatible = "marvell,orion-xor";
-			reg = <0x60800 0x100
-			       0x60A00 0x100>;
-			status = "okay";
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
 
-			xor00 {
-				interrupts = <51>;
-				dmacap,memcpy;
-				dmacap,xor;
+			gpio2: gpio@18180 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18180 0x40>;
+				ngpios = <2>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <91>;
 			};
-			xor01 {
-				interrupts = <52>;
-				dmacap,memcpy;
-				dmacap,xor;
-				dmacap,memset;
+
+			coreclk: mvebu-sar@18230 {
+				compatible = "marvell,armada-370-core-clock";
+				reg = <0x18230 0x08>;
+				#clock-cells = <1>;
 			};
-		};
 
-		xor@60900 {
-			compatible = "marvell,orion-xor";
-			reg = <0x60900 0x100
-			       0x60b00 0x100>;
-			status = "okay";
+			gateclk: clock-gating-control@18220 {
+				compatible = "marvell,armada-370-gating-clock";
+				reg = <0x18220 0x4>;
+				clocks = <&coreclk 0>;
+				#clock-cells = <1>;
+			};
 
-			xor10 {
-				interrupts = <94>;
-				dmacap,memcpy;
-				dmacap,xor;
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
 			};
-			xor11 {
-				interrupts = <95>;
-				dmacap,memcpy;
-				dmacap,xor;
-				dmacap,memset;
+
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
 			};
-		};
 
-		usb@50000 {
-			clocks = <&coreclk 0>;
-		};
+			usb@50000 {
+				clocks = <&coreclk 0>;
+			};
 
-		usb@51000 {
-			clocks = <&coreclk 0>;
+			usb@51000 {
+				clocks = <&coreclk 0>;
+			};
 		};
-
 	};
 };
diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index 5e2b595..fbd0f04 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -30,95 +30,97 @@
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
+			};
+			serial@12200 {
+				clock-frequency = <250000000>;
+				status = "okay";
+			};
+			serial@12300 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
 
-			phy2: ethernet-phy@2 {
-				reg = <25>;
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
 			};
 
-			phy3: ethernet-phy@3 {
-				reg = <27>;
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <0>;
+				};
+
+				phy1: ethernet-phy@1 {
+					reg = <1>;
+				};
+
+				phy2: ethernet-phy@2 {
+					reg = <25>;
+				};
+
+				phy3: ethernet-phy@3 {
+					reg = <27>;
+				};
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
-			phy-mode = "sgmii";
-		};
-		ethernet@34000 {
-			status = "okay";
-			phy = <&phy3>;
-			phy-mode = "sgmii";
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
 
-		mvsdio@d4000 {
-			pinctrl-0 = <&sdio_pins>;
-			pinctrl-names = "default";
-			status = "okay";
-			/* No CD or WP GPIOs */
-		};
+			mvsdio@d4000 {
+				pinctrl-0 = <&sdio_pins>;
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
+			usb@51000 {
+				status = "okay";
+			};
 
-		usb@52000 {
-			status = "okay";
-		};
+			usb@52000 {
+				status = "okay";
+			};
 
-		spi0: spi@10600 {
-			status = "okay";
+			spi0: spi@10600 {
+				status = "okay";
 
-			spi-flash@0 {
-				#address-cells = <1>;
-				#size-cells = <1>;
-				compatible = "m25p64";
-				reg = <0>; /* Chip select 0 */
-				spi-max-frequency = <20000000>;
+				spi-flash@0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "m25p64";
+					reg = <0>; /* Chip select 0 */
+					spi-max-frequency = <20000000>;
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
index 12b98d3..b0298d7 100644
--- a/arch/arm/boot/dts/armada-xp-gp.dts
+++ b/arch/arm/boot/dts/armada-xp-gp.dts
@@ -37,76 +37,78 @@
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
+			};
+			serial@12200 {
+				clock-frequency = <250000000>;
+				status = "okay";
+			};
+			serial@12300 {
+				clock-frequency = <250000000>;
+				status = "okay";
 			};
 
-			phy2: ethernet-phy@2 {
-				reg = <18>;
+			sata@a0000 {
+				nr-ports = <2>;
+				status = "okay";
 			};
 
-			phy3: ethernet-phy@3 {
-				reg = <19>;
+			mdio {
+				phy0: ethernet-phy@0 {
+					reg = <16>;
+				};
+
+				phy1: ethernet-phy@1 {
+					reg = <17>;
+				};
+
+				phy2: ethernet-phy@2 {
+					reg = <18>;
+				};
+
+				phy3: ethernet-phy@3 {
+					reg = <19>;
+				};
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
 
-		spi0: spi@10600 {
-			status = "okay";
+			spi0: spi@10600 {
+				status = "okay";
 
-			spi-flash@0 {
-				#address-cells = <1>;
-				#size-cells = <1>;
-				compatible = "n25q128a13";
-				reg = <0>; /* Chip select 0 */
-				spi-max-frequency = <108000000>;
+				spi-flash@0 {
+					#address-cells = <1>;
+					#size-cells = <1>;
+					compatible = "n25q128a13";
+					reg = <0>; /* Chip select 0 */
+					spi-max-frequency = <108000000>;
+				};
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/armada-xp-mv78230.dtsi b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
index 40fa72e..f0d38fb 100644
--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -44,37 +44,39 @@
 	};
 
 	soc {
-		pinctrl {
-			compatible = "marvell,mv78230-pinctrl";
-			reg = <0x18000 0x38>;
+		internal-regs {
+			pinctrl {
+				compatible = "marvell,mv78230-pinctrl";
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
-			ngpios = <17>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupts-cells = <2>;
-			interrupts = <87>, <88>, <89>;
+			gpio1: gpio@18140 {
+				compatible = "marvell,orion-gpio";
+				reg = <0x18140 0x40>;
+				ngpios = <17>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupt-controller;
+				#interrupts-cells = <2>;
+				interrupts = <87>, <88>, <89>;
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-xp-mv78260.dtsi b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
index 7578c21..2621bda 100644
--- a/arch/arm/boot/dts/armada-xp-mv78260.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78260.dtsi
@@ -45,56 +45,58 @@
 	};
 
 	soc {
-		pinctrl {
-			compatible = "marvell,mv78260-pinctrl";
-			reg = <0x18000 0x38>;
+		internal-regs {
+			pinctrl {
+				compatible = "marvell,mv78260-pinctrl";
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
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-xp-mv78460.dtsi b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
index 5280a4d..ccb95ff 100644
--- a/arch/arm/boot/dts/armada-xp-mv78460.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78460.dtsi
@@ -60,56 +60,58 @@
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
+			};
 		};
 	};
  };
diff --git a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
index a7bade4..e2eaf4f 100644
--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -27,117 +27,119 @@
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
-
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
 
-			s35390a: s35390a@30 {
-				compatible = "s35390a";
-				reg = <0x30>;
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
+
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
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index 6ca6b7a..2b39dde 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -22,135 +22,133 @@
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
-			};
-			xor11 {
-				interrupts = <52>;
-				dmacap,memcpy;
-				dmacap,xor;
-				dmacap,memset;
 			};
-		};
-
-		xor@f0900 {
-			compatible = "marvell,orion-xor";
-			reg = <0xF0900 0x100
-			       0xF0B00 0x100>;
-			clocks = <&gateclk 28>;
-			status = "okay";
 
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
+			usb@52000 {
+				compatible = "marvell,orion-ehci";
+				reg = <0x52000 0x500>;
+				interrupts = <47>;
+				clocks = <&gateclk 20>;
+				status = "disabled";
+			};
 		};
-
 	};
 };
-- 
1.7.9.5

