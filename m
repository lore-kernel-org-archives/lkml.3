Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaIOQRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:17:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39526 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753999AbaIOQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:16:14 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCHv3 5/7] ARM: at91: dt: add device tree file for SAMA5D4ek board
Date: Mon, 15 Sep 2014 18:15:57 +0200
Message-Id: <1410797759-18675-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Add reference SAMA5D4-EK platform DT file.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/Makefile           |   2 +
 arch/arm/boot/dts/at91-sama5d4ek.dts | 308 +++++++++++++++++++++++++++++++++++
 2 files changed, 310 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91-sama5d4ek.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 75c7b7425c79..a7df6aeb5a1a 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -48,6 +48,8 @@ dtb-$(CONFIG_ARCH_AT91)	+= sama5d33ek.dtb
 dtb-$(CONFIG_ARCH_AT91)	+= sama5d34ek.dtb
 dtb-$(CONFIG_ARCH_AT91)	+= sama5d35ek.dtb
 dtb-$(CONFIG_ARCH_AT91)	+= sama5d36ek.dtb
+# sama5d4
+dtb-$(CONFIG_ARCH_AT91)	+= at91-sama5d4ek.dtb
 
 dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
 dtb-$(CONFIG_ARCH_AXXIA) += axm5516-amarillo.dtb
diff --git a/arch/arm/boot/dts/at91-sama5d4ek.dts b/arch/arm/boot/dts/at91-sama5d4ek.dts
new file mode 100644
index 000000000000..aa01c2610c6d
--- /dev/null
+++ b/arch/arm/boot/dts/at91-sama5d4ek.dts
@@ -0,0 +1,308 @@
+/*
+ * sama5d4ek.dts - Device Tree file for SAMA5D4 Evaluation Kit
+ *
+ *  Copyright (C) 2014 Atmel,
+ *                2014 Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+/dts-v1/;
+#include "sama5d4.dtsi"
+
+/ {
+	model = "Atmel SAMA5D4-EK";
+	compatible = "atmel,sama5d4ek", "atmel,sama5d4", "atmel,sama5";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		reg = <0x20000000 0x20000000>;
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		main_clock: clock@0 {
+			compatible = "atmel,osc", "fixed-clock";
+			clock-frequency = <12000000>;
+		};
+
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+
+		main_xtal {
+			clock-frequency = <12000000>;
+		};
+	};
+
+	ahb {
+		apb {
+			lcd_bus@f0000000 {
+				status = "okay";
+
+				lcd@f0000000 {
+					status = "okay";
+				};
+
+				lcdovl1@f0000140 {
+					status = "okay";
+				};
+
+				lcdovl2@f0000240 {
+					status = "okay";
+				};
+
+				lcdheo1@f0000340 {
+					status = "okay";
+				};
+			};
+
+			adc0: adc@fc034000 {
+				/* The vref depends on JP22 of EK. If connect 1-2 then use 3.3V. connect 2-3 use 3.0V */
+				atmel,adc-vref = <3300>;
+				/*atmel,adc-ts-wires = <4>;*/	/* Set up ADC touch screen */
+				status = "okay";		/* Enable ADC IIO support */
+			};
+
+			mmc0: mmc@f8000000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_mmc0_clk_cmd_dat0 &pinctrl_mmc0_dat1_3 &pinctrl_mmc0_cd>;
+				slot@1 {
+					reg = <1>;
+					bus-width = <4>;
+					cd-gpios = <&pioE 5 0>;
+				};
+			};
+
+			spi0: spi@f8010000 {
+				cs-gpios = <&pioC 3 0>, <0>, <0>, <0>;
+				status = "okay";
+				m25p80@0 {
+					compatible = "atmel,at25df321a";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
+
+			i2c0: i2c@f8014000 {
+				status = "okay";
+				pmic: act8865@5b {
+					compatible = "active-semi,act8865";
+					reg = <0x5b>;
+					status = "okay";
+
+					regulators {
+						vcc_1v8_reg: DCDC_REG1 {
+							regulator-name = "VCC_1V8";
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <1800000>;
+							regulator-always-on;
+						};
+
+						vcc_1v2_reg: DCDC_REG2 {
+							regulator-name = "1V2_HDMI";
+							regulator-min-microvolt = <1200000>;
+							regulator-max-microvolt = <1200000>;
+							regulator-always-on;
+						};
+
+						vcc_3v3_reg: DCDC_REG3 {
+							regulator-name = "VCC_3V3";
+							regulator-min-microvolt = <3300000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+
+						vdd_2v5_reg: LDO_REG1 {
+							regulator-name = "FUSE_2V5";
+							regulator-min-microvolt = <2500000>;
+							regulator-max-microvolt = <2500000>;
+						};
+
+						vdd_3v3_reg: LDO_REG2 {
+							regulator-name = "VDDANA";
+							regulator-min-microvolt = <3300000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+
+						vdd_1v8_reg: LDO_REG3 {
+							regulator-name = "1V8_AUDIO";
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <1800000>;
+							regulator-always-on;
+						};
+					};
+				};
+			};
+
+			macb0: ethernet@f8020000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+
+			mmc1: mmc@fc000000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_mmc1_clk_cmd_dat0 &pinctrl_mmc1_dat1_3 &pinctrl_mmc1_cd>;
+				status = "okay";
+				slot@0 {
+					reg = <0>;
+					bus-width = <4>;
+					cd-gpios = <&pioE 6 0>;
+				};
+			};
+
+			usart2: serial@fc008000 {
+				status = "okay";
+			};
+
+			usart3: serial@fc00c000 {
+				status = "okay";
+			};
+
+			usart4: serial@fc010000 {
+				status = "okay";
+			};
+
+			watchdog@fc068640 {
+				status = "okay";
+			};
+
+			pinctrl@fc06a000 {
+				board {
+					pinctrl_mmc0_cd: mmc0_cd {
+						atmel,pins =
+							<AT91_PIOE 5 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
+					};
+					pinctrl_mmc1_cd: mmc1_cd {
+						atmel,pins =
+							<AT91_PIOE 6 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
+					};
+					pinctrl_usba_vbus: usba_vbus {
+						atmel,pins =
+							<AT91_PIOE 31 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;
+					};
+					pinctrl_key_gpio: key_gpio_0 {
+						atmel,pins =
+							<AT91_PIOE 13 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>; /* PE13 gpio */
+					};
+				};
+			};
+		};
+
+		usb0: gadget@00400000 {
+			atmel,vbus-gpio = <&pioE 31 GPIO_ACTIVE_HIGH>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usba_vbus>;
+			status = "okay";
+		};
+
+		usb1: ohci@00500000 {
+			num-ports = <3>;
+			atmel,vbus-gpio = <0 /* &pioE 10 GPIO_ACTIVE_LOW */
+					   &pioE 11 GPIO_ACTIVE_LOW
+					   &pioE 12 GPIO_ACTIVE_LOW
+					  >;
+			status = "okay";
+		};
+
+		usb2: ehci@00600000 {
+			status = "okay";
+		};
+
+		nand0: nand@80000000 {
+			nand-bus-width = <8>;
+			nand-ecc-mode = "hw";
+			nand-on-flash-bbt;
+			atmel,has-pmecc;
+			status = "okay";
+
+			at91bootstrap@0 {
+				label = "at91bootstrap";
+				reg = <0x0 0x40000>;
+			};
+
+			bootloader@40000 {
+				label = "bootloader";
+				reg = <0x40000 0x80000>;
+			};
+
+			bootloaderenv@c0000 {
+				label = "bootloader env";
+				reg = <0xc0000 0xc0000>;
+			};
+
+			dtb@180000 {
+				label = "device tree";
+				reg = <0x180000 0x80000>;
+			};
+
+			kernel@200000 {
+				label = "kernel";
+				reg = <0x200000 0x600000>;
+			};
+
+			rootfs@800000 {
+				label = "rootfs";
+				reg = <0x800000 0x0f800000>;
+			};
+		};
+	};
+
+	gpio_keys {
+		compatible = "gpio-keys";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_key_gpio>;
+
+		pb_user1 {
+			label = "pb_user1";
+			gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
+			linux,code = <0x100>;
+			gpio-key,wakeup;
+		};
+	};
+};
-- 
1.9.1

