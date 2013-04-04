Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605Ab3DDPmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:42:37 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:38102 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760711Ab3DDPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:42:35 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <jhovold@gmail.com>,
        <dgilbert@interlog.com>, <robertcnelson@gmail.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3] ARM: at91: add Acme Systems Aria G25 board
Date: Thu, 4 Apr 2013 17:42:33 +0200
Message-ID: <1365090153-1807-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <20130402184947.GA8015@quad.lixom.net>
References: <20130402184947.GA8015@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi all,

Here is the third revision of this patch. I plan to include it in a
pull-request real-soon-now!

v3: - move to "at91-" prefix for .dts[i] files
    - remove the rtc activation code because of the ongoing discussions
      about this IP and its DT binding.

 arch/arm/boot/dts/Makefile         |   1 +
 arch/arm/boot/dts/at91-ariag25.dts | 171 +++++++++++++++++++++++++++++++++++++
 2 files changed, 172 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91-ariag25.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 4c7f8a8..b07f162 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -27,6 +27,7 @@ dtb-$(CONFIG_ARCH_AT91) += pm9g45.dtb
 # sam9n12
 dtb-$(CONFIG_ARCH_AT91) += at91sam9n12ek.dtb
 # sam9x5
+dtb-$(CONFIG_ARCH_AT91) += at91-ariag25.dtb
 dtb-$(CONFIG_ARCH_AT91) += at91sam9g15ek.dtb
 dtb-$(CONFIG_ARCH_AT91) += at91sam9g25ek.dtb
 dtb-$(CONFIG_ARCH_AT91) += at91sam9g35ek.dtb
diff --git a/arch/arm/boot/dts/at91-ariag25.dts b/arch/arm/boot/dts/at91-ariag25.dts
new file mode 100644
index 0000000..c7aebba
--- /dev/null
+++ b/arch/arm/boot/dts/at91-ariag25.dts
@@ -0,0 +1,171 @@
+/*
+ * at91-ariag25.dts - Device Tree file for Acme Systems Aria G25 (AT91SAM9G25 based)
+ *
+ * Copyright (C) 2013 Douglas Gilbert <dgilbert@interlog.com>,
+ *                    Robert Nelson <robertcnelson@gmail.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+/dts-v1/;
+/include/ "at91sam9g25.dtsi"
+
+/ {
+	model = "Acme Systems Aria G25";
+	compatible = "acme,ariag25", "atmel,at91sam9x5ek",
+		     "atmel,at91sam9x5", "atmel,at91sam9";
+
+	aliases {
+		serial0 = &dbgu;
+		serial1 = &usart0;
+		serial2 = &usart1;
+		serial3 = &usart2;
+		serial4 = &usart3;
+		serial5 = &uart0;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200 root=/dev/mmcblk0p2 rw rootwait";
+	};
+
+	memory {
+		/* 128 MB, change this for 256 MB revision */
+		reg = <0x20000000 0x8000000>;
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
+	};
+
+	ahb {
+		apb {
+			mmc0: mmc@f0008000 {
+				/* N.B. Aria has no SD card detect (CD), assumed present */
+
+				pinctrl-0 = <
+					&pinctrl_mmc0_slot0_clk_cmd_dat0
+					&pinctrl_mmc0_slot0_dat1_3>;
+				status = "okay";
+				slot@0 {
+					reg = <0>;
+					bus-width = <4>;
+				};
+			};
+
+			i2c0: i2c@f8010000 {
+				status = "okay";
+			};
+
+			i2c1: i2c@f8014000 {
+				status = "okay";
+			};
+
+			/* TWD2+TCLK2 hidden behind ethernet, so no i2c2 */
+
+			usart0: serial@f801c000 {
+				pinctrl-0 = <&pinctrl_usart0
+					     &pinctrl_usart0_rts
+					     &pinctrl_usart0_cts>;
+				status = "okay";
+			};
+
+			usart1: serial@f8020000 {
+				pinctrl-0 = <&pinctrl_usart1
+					     /* &pinctrl_usart1_rts */
+					     /* &pinctrl_usart1_cts */
+					    >;
+				status = "okay";
+			};
+
+			usart2: serial@f8024000 {
+				/* cannot activate RTS2+CTS2, clash with
+				 * ethernet on PB0 and PB1 */
+				pinctrl-0 = <&pinctrl_usart2>;
+				status = "okay";
+			};
+
+			usart3: serial@f8028000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8028000 0x200>;
+				interrupts = <8 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_usart3
+					     /* &pinctrl_usart3_rts */
+					     /* &pinctrl_usart3_cts */
+					    >;
+				status = "okay";
+			};
+
+			macb0: ethernet@f802c000 {
+				phy-mode = "rmii";
+				/*
+				 * following can be overwritten by bootloader:
+				 * for example u-boot 'ftd set' command
+				 */
+				local-mac-address = [00 00 00 00 00 00];
+				status = "okay";
+			};
+
+			uart0: serial@f8040000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8040000 0x200>;
+				interrupts = <15 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_uart0>;
+				status = "okay";
+			};
+
+			adc0: adc@f804c000 {
+				status = "okay";
+				atmel,adc-channels-used = <0xf>;
+				atmel,adc-num-channels = <4>;
+			};
+
+			dbgu: serial@fffff200 {
+				status = "okay";
+			};
+
+			pinctrl@fffff400 {
+				w1_0 {
+					pinctrl_w1_0: w1_0-0 {
+						atmel,pins = <0 21 0x0 0x1>; /* PA21 PIO, pull-up */
+					};
+				};
+			};
+		};
+
+		usb0: ohci@00600000 {
+			status = "okay";
+			num-ports = <3>;
+		};
+
+		usb1: ehci@00700000 {
+			status = "okay";
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		/* little green LED in middle of Aria G25 module */
+		aria_led {
+			label = "aria_led";
+			gpios = <&pioB 8 0>; /* PB8 */
+			linux,default-trigger = "heartbeat";
+		};
+
+	};
+
+	onewire@0 {
+		compatible = "w1-gpio";
+		gpios = <&pioA 21 1>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_w1_0>;
+	};
+};
-- 
1.8.0

