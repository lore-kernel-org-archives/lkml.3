Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaBUTvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:51:47 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39740 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753463AbaBUTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:49:49 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 4/9] ARM: at91: dt: sam9rl: Device Tree for the at91sam9rlek
Date: Fri, 21 Feb 2014 20:48:53 +0100
Message-Id: <1393012138-17255-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393012138-17255-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393012138-17255-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a device tree for the at91sam9rl-ek. For now it supports:
 - MMC
 - dbgu
 - usart1
 - watchdog
 - nand
 - leds
 - buttons

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/Makefile         |   2 +
 arch/arm/boot/dts/at91sam9rlek.dts | 151 +++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 6d1e43d46187..ce58477cfa33 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -29,6 +29,8 @@ dtb-$(CONFIG_ARCH_AT91) += at91sam9m10g45ek.dtb
 dtb-$(CONFIG_ARCH_AT91) += pm9g45.dtb
 # sam9n12
 dtb-$(CONFIG_ARCH_AT91) += at91sam9n12ek.dtb
+# sam9rl
+dtb-$(CONFIG_ARCH_AT91) += at91sam9rlek.dtb
 # sam9x5
 dtb-$(CONFIG_ARCH_AT91) += at91-ariag25.dtb
 dtb-$(CONFIG_ARCH_AT91) += at91-cosino_mega2560.dtb
diff --git a/arch/arm/boot/dts/at91sam9rlek.dts b/arch/arm/boot/dts/at91sam9rlek.dts
new file mode 100644
index 000000000000..04510135f2a0
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9rlek.dts
@@ -0,0 +1,151 @@
+/*
+ * at91sam9rlek.dts - Device Tree file for Atmel at91sam9rl reference board
+ *
+ *  Copyright (C) 2014  Alexandre Belloni <alexandre.belloni@free-electrons.com>
+ *
+ * Licensed under GPLv2 only
+ */
+/dts-v1/;
+#include "at91sam9rl.dtsi"
+
+/ {
+	model = "Atmel at91sam9rlek";
+	compatible = "atmel,at91sam9rlek", "atmel,at91sam9rl", "atmel,at91sam9";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 rootfstype=ubifs root=ubi0:rootfs ubi.mtd=5 rw";
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
+		main_clock: clock {
+			compatible = "atmel,osc", "fixed-clock";
+			clock-frequency = <12000000>;
+		};
+	};
+
+	ahb {
+		apb {
+			mmc0: mmc@fffa4000 {
+				pinctrl-0 = <
+					&pinctrl_board_mmc0
+					&pinctrl_mmc0_clk
+					&pinctrl_mmc0_slot0_cmd_dat0
+					&pinctrl_mmc0_slot0_dat1_3>;
+				status = "okay";
+				slot@0 {
+					reg = <0>;
+					bus-width = <4>;
+					cd-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
+				};
+			};
+
+			usart0: serial@fffb0000 {
+				pinctrl-0 = <
+					&pinctrl_usart0
+					&pinctrl_usart0_rts
+					&pinctrl_usart0_cts>;
+				status = "okay";
+			};
+
+			dbgu: serial@fffff200 {
+				status = "okay";
+			};
+
+			pinctrl@fffff400 {
+				mmc0 {
+					pinctrl_board_mmc0: mmc0-board {
+						atmel,pins =
+							<AT91_PIOA 15 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
+					};
+				};
+			};
+
+			watchdog@fffffd40 {
+				status = "okay";
+			};
+		};
+
+		nand0: nand@40000000 {
+			nand-bus-width = <8>;
+			nand-ecc-mode = "soft";
+			nand-on-flash-bbt = <1>;
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
+	leds {
+		compatible = "gpio-leds";
+
+		ds1 {
+			label = "ds1";
+			gpios = <&pioD 15 GPIO_ACTIVE_LOW>;
+		};
+
+		ds2 {
+			label = "ds2";
+			gpios = <&pioD 16 GPIO_ACTIVE_LOW>;
+		};
+
+		ds3 {
+			label = "ds3";
+			gpios = <&pioD 14 GPIO_ACTIVE_HIGH>;
+			linux,default-trigger = "heartbeat";
+		};
+	};
+
+	gpio_keys {
+		compatible = "gpio-keys";
+
+		right_click {
+			label = "right_click";
+			gpios = <&pioB 0 GPIO_ACTIVE_LOW>;
+			linux,code = <273>;
+			gpio-key,wakeup;
+		};
+
+		left_click {
+			label = "left_click";
+			gpios = <&pioB 1 GPIO_ACTIVE_LOW>;
+			linux,code = <272>;
+			gpio-key,wakeup;
+		};
+	};
+};
-- 
1.8.3.2

