Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab3DSKku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:40:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:27993 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab3DSKks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:40:48 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <dgilbert@interlog.com>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <robertcnelson@gmail.com>, <tanzilli@acmesystems.it>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 5/5 v2] ARM: at91: add Acme Systems Fox G20 board
Date: Fri, 19 Apr 2013 12:40:46 +0200
Message-ID: <1366368046-16758-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <a647ac59d50fdee9a0e9e87f362febe1ad2b1264.1366289869.git.nicolas.ferre@atmel.com>
References: <a647ac59d50fdee9a0e9e87f362febe1ad2b1264.1366289869.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
[nicolas.ferre@atmel.com: re-arranging nodes, removing nodes and some comments]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2: - removed the SPI node

 arch/arm/boot/dts/Makefile        |   1 +
 arch/arm/boot/dts/at91-foxg20.dts | 157 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91-foxg20.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b07f162..914fe65 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -16,6 +16,7 @@ dtb-$(CONFIG_ARCH_AT91) += at91sam9263ek.dtb
 dtb-$(CONFIG_ARCH_AT91) += tny_a9263.dtb
 dtb-$(CONFIG_ARCH_AT91) += usb_a9263.dtb
 # sam9g20
+dtb-$(CONFIG_ARCH_AT91) += at91-foxg20.dtb
 dtb-$(CONFIG_ARCH_AT91) += at91sam9g20ek.dtb
 dtb-$(CONFIG_ARCH_AT91) += at91sam9g20ek_2mmc.dtb
 dtb-$(CONFIG_ARCH_AT91) += kizbox.dtb
diff --git a/arch/arm/boot/dts/at91-foxg20.dts b/arch/arm/boot/dts/at91-foxg20.dts
new file mode 100644
index 0000000..f5e0427
--- /dev/null
+++ b/arch/arm/boot/dts/at91-foxg20.dts
@@ -0,0 +1,157 @@
+/*
+ * at91-foxg20.dts - Device Tree file for Acme Systems FoxG20 board
+ *
+ * Based on DT files for at91sam9g20ek evaluation board (AT91SAM9G20 SoC)
+ *
+ * Copyright (C) 2013 Douglas Gilbert <dgilbert@interlog.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+/dts-v1/;
+/include/ "at91sam9g20.dtsi"
+
+/ {
+	model = "Acme Systems FoxG20";
+	compatible = "acme,foxg20", "atmel,at91sam9g20", "atmel,at91sam9";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait";
+	};
+
+	memory {
+		reg = <0x20000000 0x4000000>;
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		main_clock: clock@0 {
+			compatible = "atmel,osc", "fixed-clock";
+			clock-frequency = <18432000>;
+		};
+	};
+
+	ahb {
+		apb {
+			usb1: gadget@fffa4000 {
+				atmel,vbus-gpio = <&pioC 6 0>;
+				status = "okay";
+			};
+
+			mmc0: mmc@fffa8000 {
+				pinctrl-0 = <
+					&pinctrl_mmc0_clk
+					&pinctrl_mmc0_slot1_cmd_dat0
+					&pinctrl_mmc0_slot1_dat1_3>;
+				status = "okay";
+
+				slot@1 {
+					reg = <1>;
+					bus-width = <4>;
+				};
+			};
+
+			usart0: serial@fffb0000 {
+				pinctrl-0 =
+					<&pinctrl_usart0
+					 &pinctrl_usart0_rts
+					 &pinctrl_usart0_cts
+					>;
+				status = "okay";
+			};
+
+			usart1: serial@fffb4000 {
+				status = "okay";
+			};
+
+			usart2: serial@fffb8000 {
+				status = "okay";
+			};
+
+			macb0: ethernet@fffc4000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+
+			usart3: serial@fffd0000 {
+				status = "okay";
+			};
+
+			uart0: serial@fffd4000 {
+				status = "okay";
+			};
+
+			uart1: serial@fffd8000 {
+				status = "okay";
+			};
+
+			dbgu: serial@fffff200 {
+				status = "okay";
+			};
+
+			pinctrl@fffff400 {
+				board {
+					pinctrl_pck0_as_mck: pck0_as_mck {
+						atmel,pins =
+							<2 1 0x2 0x0>;	/* PC1 periph B */
+					};
+				};
+
+				mmc0_slot1 {
+					pinctrl_board_mmc0_slot1: mmc0_slot1-board {
+						atmel,pins =
+							<2 9 0x0 0x5>;	/* PC9 gpio CD pin pull up and deglitch */
+					};
+				};
+
+				i2c0 {
+					pinctrl_i2c0: i2c0-0 {
+						atmel,pins =
+							<0 23 0x1 0x2	/* TWD (SDA) PA23 periph A, open drain */
+							 0 24 0x1 0x2>;	/* TWCK (SCL) PA24 periph A, open drain */
+					};
+				};
+			};
+
+			watchdog@fffffd40 {
+				status = "okay";
+			};
+		};
+
+		usb0: ohci@00500000 {
+			num-ports = <2>;
+			status = "okay";
+		};
+	};
+
+	i2c@0 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_i2c0>;
+		i2c-gpio,delay-us = <5>;	/* ~85 kHz */
+		status = "okay";
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		/* red LED marked "PC7" near mini USB (device) receptacle */
+		user_led {
+			label = "user_led";
+			gpios = <&pioC 7 0>;	/* PC7 */
+			linux,default-trigger = "heartbeat";
+		};
+	};
+
+	gpio_keys {
+		compatible = "gpio-keys";
+
+		btn {
+			label = "Button";
+			gpios = <&pioC 4 1>;
+			linux,code = <0x103>;
+			gpio-key,wakeup;
+		};
+	};
+};
-- 
1.8.0

