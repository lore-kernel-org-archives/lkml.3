Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaB0V4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:56:48 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:26243 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaB0V4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:56:45 -0500
X-IronPort-AV: E=Sophos;i="4.97,557,1389772800"; 
   d="scan'208";a="17176950"
From: Markus Mayer <markus.mayer@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <matt.porter@linaro.org>
CC: Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 3/3] ARM: dts: bcm21664: Add device tree files.
Date: Thu, 27 Feb 2014 13:56:06 -0800
Message-ID: <1393538166-22868-4-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393538166-22868-1-git-send-email-markus.mayer@linaro.org>
References: <1393538166-22868-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree files for the Broadcom BCM21664 SoC.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/boot/dts/Makefile            |    3 +-
 arch/arm/boot/dts/bcm21664-garnet.dts |   56 +++++++
 arch/arm/boot/dts/bcm21664.dtsi       |  292 +++++++++++++++++++++++++++++++++
 3 files changed, 350 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/bcm21664-garnet.dts
 create mode 100644 arch/arm/boot/dts/bcm21664.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 0320303..0c1853a 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -48,7 +48,8 @@ dtb-$(CONFIG_ARCH_AT91)	+= sama5d36ek.dtb
 dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm11351-brt.dtb \
-	bcm28155-ap.dtb
+	bcm28155-ap.dtb \
+	bcm21664-garnet.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 dtb-$(CONFIG_ARCH_BERLIN) += \
 	berlin2-sony-nsz-gs7.dtb	\
diff --git a/arch/arm/boot/dts/bcm21664-garnet.dts b/arch/arm/boot/dts/bcm21664-garnet.dts
new file mode 100644
index 0000000..e87cb26
--- /dev/null
+++ b/arch/arm/boot/dts/bcm21664-garnet.dts
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
+
+#include "bcm21664.dtsi"
+
+/ {
+	model = "BCM21664 Garnet board";
+	compatible = "brcm,bcm21664-garnet", "brcm,bcm21664";
+
+	memory {
+		reg = <0x80000000 0x40000000>; /* 1 GB */
+	};
+
+	uart@3e000000 {
+		status = "okay";
+	};
+
+	sdio1: sdio@3f180000 {
+		max-frequency = <48000000>;
+		status = "okay";
+	};
+
+	sdio2: sdio@3f190000 {
+		non-removable;
+		max-frequency = <48000000>;
+		status = "okay";
+	};
+
+	sdio4: sdio@3f1b0000 {
+		max-frequency = <48000000>;
+		cd-gpios = <&gpio 91 GPIO_ACTIVE_LOW>;
+		status = "okay";
+	};
+
+	usbotg: usb@3f120000 {
+		status = "okay";
+	};
+
+	usbphy: usb-phy@3f130000 {
+		status = "okay";
+	};
+};
diff --git a/arch/arm/boot/dts/bcm21664.dtsi b/arch/arm/boot/dts/bcm21664.dtsi
new file mode 100644
index 0000000..08a44d4
--- /dev/null
+++ b/arch/arm/boot/dts/bcm21664.dtsi
@@ -0,0 +1,292 @@
+/*
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+#include "skeleton.dtsi"
+
+/ {
+	model = "BCM21664 SoC";
+	compatible = "brcm,bcm21664";
+	interrupt-parent = <&gic>;
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8";
+	};
+
+	gic: interrupt-controller@3ff00100 {
+		compatible = "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <0>;
+		interrupt-controller;
+		reg = <0x3ff01000 0x1000>,
+		      <0x3ff00100 0x100>;
+	};
+
+	smc@0x3404e000 {
+		compatible = "brcm,bcm21664-smc", "brcm,kona-smc";
+		reg = <0x3404e000 0x400>; /* 1 KiB in SRAM */
+	};
+
+	uart@3e000000 {
+		compatible = "brcm,bcm21664-dw-apb-uart", "snps,dw-apb-uart";
+		status = "disabled";
+		reg = <0x3e000000 0x118>;
+		clocks = <&uartb_clk>;
+		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+	};
+
+	uart@3e001000 {
+		compatible = "brcm,bcm21664-dw-apb-uart", "snps,dw-apb-uart";
+		status = "disabled";
+		reg = <0x3e001000 0x118>;
+		clocks = <&uartb2_clk>;
+		interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+	};
+
+	uart@3e002000 {
+		compatible = "brcm,bcm21664-dw-apb-uart", "snps,dw-apb-uart";
+		status = "disabled";
+		reg = <0x3e002000 0x118>;
+		clocks = <&uartb3_clk>;
+		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+	};
+
+	L2: l2-cache {
+		compatible = "arm,pl310-cache";
+		reg = <0x3ff20000 0x1000>;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	brcm,resetmgr@35001f00 {
+		compatible = "brcm,bcm21664-resetmgr";
+		reg = <0x35001f00 0x24>;
+	};
+
+	timer@35006000 {
+		compatible = "brcm,kona-timer";
+		reg = <0x35006000 0x1c>;
+		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&hub_timer_clk>;
+	};
+
+	gpio: gpio@35003000 {
+		compatible = "brcm,bcm21664-gpio", "brcm,kona-gpio";
+		reg = <0x35003000 0x524>;
+		interrupts =
+		       <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH
+			GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH
+			GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH
+			GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+		#gpio-cells = <2>;
+		#interrupt-cells = <2>;
+		gpio-controller;
+		interrupt-controller;
+	};
+
+	sdio1: sdio@3f180000 {
+		compatible = "brcm,kona-sdhci";
+		reg = <0x3f180000 0x801c>;
+		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio1_clk>;
+		status = "disabled";
+	};
+
+	sdio2: sdio@3f190000 {
+		compatible = "brcm,kona-sdhci";
+		reg = <0x3f190000 0x801c>;
+		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio2_clk>;
+		status = "disabled";
+	};
+
+	sdio3: sdio@3f1a0000 {
+		compatible = "brcm,kona-sdhci";
+		reg = <0x3f1a0000 0x801c>;
+		interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio3_clk>;
+		status = "disabled";
+	};
+
+	sdio4: sdio@3f1b0000 {
+		compatible = "brcm,kona-sdhci";
+		reg = <0x3f1b0000 0x801c>;
+		interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio4_clk>;
+		status = "disabled";
+	};
+
+	i2c@3e016000 {
+		compatible = "brcm,bcm21664-i2c", "brcm,kona-i2c";
+		reg = <0x3e016000 0x70>;
+		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&bsc1_clk>;
+		status = "disabled";
+	};
+
+	i2c@3e017000 {
+		compatible = "brcm,bcm21664-i2c", "brcm,kona-i2c";
+		reg = <0x3e017000 0x70>;
+		interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&bsc2_clk>;
+		status = "disabled";
+	};
+
+	i2c@3e018000 {
+		compatible = "brcm,bcm21664-i2c", "brcm,kona-i2c";
+		reg = <0x3e018000 0x70>;
+		interrupts = <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&bsc3_clk>;
+		status = "disabled";
+	};
+
+	i2c@3e01c000 {
+		compatible = "brcm,bcm21664-i2c", "brcm,kona-i2c";
+		reg = <0x3e01c000 0x70>;
+		interrupts = <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&bsc4_clk>;
+		status = "disabled";
+	};
+
+	clocks {
+		bsc1_clk: bsc1 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		bsc2_clk: bsc2 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		bsc3_clk: bsc3 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		bsc4_clk: bsc4 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		pmu_bsc_clk: pmu_bsc {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		hub_timer_clk: hub_timer {
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+			#clock-cells = <0>;
+		};
+
+		pwm_clk: pwm {
+			compatible = "fixed-clock";
+			clock-frequency = <26000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio1_clk: sdio1 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio2_clk: sdio2 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio3_clk: sdio3 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		sdio4_clk: sdio4 {
+			compatible = "fixed-clock";
+			clock-frequency = <48000000>;
+			#clock-cells = <0>;
+		};
+
+		tmon_1m_clk: tmon_1m {
+			compatible = "fixed-clock";
+			clock-frequency = <1000000>;
+			#clock-cells = <0>;
+		};
+
+		uartb_clk: uartb {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		uartb2_clk: uartb2 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		uartb3_clk: uartb3 {
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
+			#clock-cells = <0>;
+		};
+
+		usb_otg_ahb_clk: usb_otg_ahb {
+			compatible = "fixed-clock";
+			clock-frequency = <52000000>;
+			#clock-cells = <0>;
+		};
+	};
+
+	usbotg: usb@3f120000 {
+		compatible = "snps,dwc2";
+		reg = <0x3f120000 0x10000>;
+		interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&usb_otg_ahb_clk>;
+		clock-names = "otg";
+		phys = <&usbphy>;
+		phy-names = "usb2-phy";
+		status = "disabled";
+	};
+
+	usbphy: usb-phy@3f130000 {
+		compatible = "brcm,kona-usb2-phy";
+		reg = <0x3f130000 0x28>;
+		#phy-cells = <0>;
+		status = "disabled";
+	};
+};
-- 
1.7.9.5

