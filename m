Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422873Ab3FUAgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:36:05 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38839 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778Ab3FUAgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:36:00 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 7/8] ARM: dts: Add dts file for S3C6410-based Mini6410 board
Date: Fri, 21 Jun 2013 02:35:23 +0200
Message-Id: <1371774924-9224-8-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic device tree sources for FriendlyARM Mini6410 board
based on Samsung S3C6410 SoC.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/Makefile             |   1 +
 arch/arm/boot/dts/s3c6410-mini6410.dts | 199 +++++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+)
 create mode 100644 arch/arm/boot/dts/s3c6410-mini6410.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 1357510..acf41d7 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -161,6 +161,7 @@ dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
 	hrefv60plus.dtb \
 	ccu9540.dtb
 dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
+dtb-$(CONFIG_ARCH_S3C64XX) += s3c6410-mini6410.dtb
 dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
 	r8a7740-armadillo800eva.dtb \
 	r8a7778-bockw.dtb \
diff --git a/arch/arm/boot/dts/s3c6410-mini6410.dts b/arch/arm/boot/dts/s3c6410-mini6410.dts
new file mode 100644
index 0000000..3f70671
--- /dev/null
+++ b/arch/arm/boot/dts/s3c6410-mini6410.dts
@@ -0,0 +1,199 @@
+/*
+ * Samsung's S3C6410 based Mini6410 board device tree source
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * Device tree source file for FriendlyARM Mini6410 board which is based on
+ * Samsung's S3C6410 SoC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+#include "s3c6410.dtsi"
+
+/ {
+	model = "FriendlyARM Mini6410 board based on S3C6410";
+	compatible = "friendlyarm,mini6410", "samsung,s3c6410";
+
+	memory {
+		reg = <0x50000000 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 earlyprintk rootwait root=/dev/mmcblk0p1";
+	};
+
+	fixed-rate-clocks {
+		xxti {
+			compatible = "samsung,clock-fin-pll";
+			clock-frequency = <12000000>;
+		};
+
+		xusbxti {
+			compatible = "samsung,clock-xusbxti";
+			clock-frequency = <48000000>;
+		};
+	};
+
+	srom-cs1@18000000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x18000000 0x8000000>;
+		ranges;
+
+		ethernet@18000000 {
+			compatible = "davicom,dm9000";
+			reg = <0x18000000 0x2 0x18000004 0x2>;
+			interrupt-parent = <&gpn>;
+			interrupts = <7 IRQ_TYPE_LEVEL_HIGH>;
+			davicom,no-eeprom;
+		};
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+		pinctrl-names = "default";
+		pinctrl-0 = <&gpio_keys>;
+		autorepeat;
+
+		button-k1 {
+			label = "K1";
+			gpios = <&gpn 0 GPIO_ACTIVE_LOW>;
+			linux,code = <2>;
+			debounce-interval = <20>;
+		};
+
+		button-k2 {
+			label = "K2";
+			gpios = <&gpn 1 GPIO_ACTIVE_LOW>;
+			linux,code = <3>;
+			debounce-interval = <20>;
+		};
+
+		button-k3 {
+			label = "K3";
+			gpios = <&gpn 2 GPIO_ACTIVE_LOW>;
+			linux,code = <4>;
+			debounce-interval = <20>;
+		};
+
+		button-k4 {
+			label = "K4";
+			gpios = <&gpn 3 GPIO_ACTIVE_LOW>;
+			linux,code = <5>;
+			debounce-interval = <20>;
+		};
+
+		button-k5 {
+			label = "K5";
+			gpios = <&gpn 4 GPIO_ACTIVE_LOW>;
+			linux,code = <6>;
+			debounce-interval = <20>;
+		};
+
+		button-k6 {
+			label = "K6";
+			gpios = <&gpn 5 GPIO_ACTIVE_LOW>;
+			linux,code = <7>;
+			debounce-interval = <20>;
+		};
+
+		button-k7 {
+			label = "K7";
+			gpios = <&gpl 11 GPIO_ACTIVE_LOW>;
+			linux,code = <8>;
+			debounce-interval = <20>;
+		};
+
+		button-k8 {
+			label = "K8";
+			gpios = <&gpl 12 GPIO_ACTIVE_LOW>;
+			linux,code = <9>;
+			debounce-interval = <20>;
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&gpio_leds>;
+
+		led-1 {
+			label = "LED1";
+			gpios = <&gpk 4 GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "heartbeat";
+		};
+
+		led-2 {
+			label = "LED2";
+			gpios = <&gpk 5 GPIO_ACTIVE_LOW>;
+			linux,default-trigger = "mmc0";
+		};
+
+		led-3 {
+			label = "LED3";
+			gpios = <&gpk 6 GPIO_ACTIVE_LOW>;
+		};
+
+		led-4 {
+			label = "LED4";
+			gpios = <&gpk 7 GPIO_ACTIVE_LOW>;
+		};
+	};
+};
+
+&sdhci0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd0_clk>, <&sd0_cmd>, <&sd0_cd>, <&sd0_bus4>;
+	bus-width = <4>;
+	status = "okay";
+};
+
+&uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_data>;
+	status = "okay";
+};
+
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_data>, <&uart1_fctl>;
+	status = "okay";
+};
+
+&uart2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart2_data>;
+	status = "okay";
+};
+
+&uart3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart3_data>;
+	status = "okay";
+};
+
+&pwm {
+	status = "okay";
+};
+
+&pinctrl0 {
+	gpio_leds: gpio-leds {
+		samsung,pins = "gpk-4", "gpk-5", "gpk-6", "gpk-7";
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+
+	gpio_keys: gpio-keys {
+		samsung,pins = "gpn-0", "gpn-1", "gpn-2", "gpn-3",
+				"gpn-4", "gpn-5", "gpl-11", "gpl-12";
+		samsung,pin-pud = <PIN_PULL_NONE>;
+	};
+};
-- 
1.8.2.1

