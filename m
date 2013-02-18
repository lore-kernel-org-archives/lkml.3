Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab3BRAHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:07:39 -0500
Received: from gloria.sntech.de ([95.129.55.99]:44747 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab3BRAHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:07:37 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH v2 3/3] ARM: S3C24XX: Add devicetree support and dt-board file for s3c2416 SoCs
Date: Mon, 18 Feb 2013 01:07:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201302180103.53084.heiko@sntech.de>
In-Reply-To: <201302180103.53084.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302180107.30265.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a board file and the devicetree source files to support boards
using the Samsung S3C2416 SoC.

The dt source files contain the definitions generic to all S3C24XX SoCs
in the s3c24xx.dtsi file which then gets extendes with S3C2416 specific
definitions.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/boot/dts/Makefile              |    1 +
 arch/arm/boot/dts/s3c2416-smdk2416.dts  |   79 +++++++++++++
 arch/arm/boot/dts/s3c2416.dtsi          |  193 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/s3c24xx.dtsi          |  165 ++++++++++++++++++++++++++
 arch/arm/mach-s3c24xx/Kconfig           |   10 ++
 arch/arm/mach-s3c24xx/Makefile          |    1 +
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c |   91 +++++++++++++++
 7 files changed, 540 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/s3c2416-smdk2416.dts
 create mode 100644 arch/arm/boot/dts/s3c2416.dtsi
 create mode 100644 arch/arm/boot/dts/s3c24xx.dtsi
 create mode 100644 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index ee9e0ca..3778d69 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -134,6 +134,7 @@ dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
 	hrefprev60.dtb \
 	hrefv60plus.dtb \
 	ccu9540.dtb
+dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
 dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
 	r8a7740-armadillo800eva.dtb \
 	r8a7779-marzen-reference.dtb \
diff --git a/arch/arm/boot/dts/s3c2416-smdk2416.dts b/arch/arm/boot/dts/s3c2416-smdk2416.dts
new file mode 100644
index 0000000..6863be6
--- /dev/null
+++ b/arch/arm/boot/dts/s3c2416-smdk2416.dts
@@ -0,0 +1,79 @@
+/*
+ * SAMSUNG SMDK2416 board device tree source
+ *
+ * Copyright (c) 2012 Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+/include/ "s3c2416.dtsi"
+
+/ {
+	model = "SMDK2416";
+	compatible = "samsung,s3c2416";
+
+	memory {
+		reg =  <0x30000000 0x8000000>;
+	};
+
+	sdhci@4AC00000 {
+		bus-width = <4>;
+		gpios = <&gpe 5 2 0>,  /* clock line */
+			<&gpe 6 2 0>,  /* command line */
+			<&gpe 7 2 0>,  /* data line 0 */
+			<&gpe 8 2 0>,  /* data line 1 */
+			<&gpe 9 2 0>,  /* data line 2 */
+			<&gpe 10 2 0>;  /* data line 3 */
+		cd-gpios = <&gpf 1 2 2>;
+		cd-inverted;
+		status = "okay";
+	};
+
+	sdhci@4A800000 {
+		bus-width = <4>;
+		gpios = <&gpl 9 2 0>,  /* clock line */
+			<&gpl 8 2 0>,  /* command line */
+			<&gpl 0 2 0>,  /* data line 0 */
+			<&gpl 1 2 0>,  /* data line 1 */
+			<&gpl 2 2 0>,  /* data line 2 */
+			<&gpl 3 2 0>;  /* data line 3 */
+
+		broken-cd;
+		status = "okay";
+	};
+
+	serial@50000000 {
+		status = "okay";
+	};
+
+	serial@50004000 {
+		status = "okay";
+	};
+
+	serial@50008000 {
+		status = "okay";
+	};
+
+	serial@5000C000 {
+		status = "okay";
+	};
+
+	watchdog@53000000 {
+		status = "okay";
+	};
+
+	rtc@57000000 {
+		status = "okay";
+	};
+
+	i2c@54000000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-max-bus-freq = <100000>;
+		gpios = <&gpe 15 2 0>, /* SDA */
+			<&gpe 14 2 0>; /* SCL */
+		status = "okay";
+	};
+};
diff --git a/arch/arm/boot/dts/s3c2416.dtsi b/arch/arm/boot/dts/s3c2416.dtsi
new file mode 100644
index 0000000..ef41ff2
--- /dev/null
+++ b/arch/arm/boot/dts/s3c2416.dtsi
@@ -0,0 +1,193 @@
+/*
+ * Samsung's S3C2416 SoC device tree source
+ *
+ * Copyright (c) 2012 Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/include/ "s3c24xx.dtsi"
+
+/ {
+	model = "Samsung S3C2416 SoC";
+	compatible = "samsung,s3c2416";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+			reg = <0>;
+		};
+	};
+
+	intc:interrupt-controller@4a000000 {
+		s3c24xx,irqlist = <1 0 /* EINT0 */
+				   1 0 /* EINT1 */
+				   1 0 /* EINT2 */
+				   1 0 /* EINT3 */
+				   3 0 /* EINT4to7 */
+				   3 0 /* EINT8to23 */
+				   0 0 /* reserved */
+				   2 0 /* nBATT_FLT */
+				   2 0 /* TICK */
+				   3 0 /* WDT/AC97 */
+				   2 0 /* TIMER0 */
+				   2 0 /* TIMER1 */
+				   2 0 /* TIMER2 */
+				   2 0 /* TIMER3 */
+				   2 0 /* TIMER4 */
+				   3 0 /* UART2 */
+				   3 0 /* LCD */
+				   3 0 /* DMA */
+				   3 0 /* UART3 */
+				   0 0 /* reserved */
+				   2 0 /* SDI1 */
+				   2 0 /* SDI0 */
+				   2 0 /* SPI0 */
+				   3 0 /* UART1 */
+				   2 0 /* NAND */
+				   2 0 /* USBD */
+				   2 0 /* USBH */
+				   2 0 /* IIC */
+				   3 0 /* UART0 */
+				   0 0 /* reserved */
+				   2 0 /* RTC */
+				   3 0>; /* ADCPARENT */
+	};
+
+	subintc:interrupt-controller@4a000018 {
+		s3c24xx,irqlist = <3 28 /* UART0-RX */
+				   3 28 /* UART0-TX */
+				   3 28 /* UART0-ERR */
+				   3 23 /* UART1-RX */
+				   3 23 /* UART1-TX */
+				   3 23 /* UART1-ERR */
+				   3 15 /* UART2-RX */
+				   3 15 /* UART2-TX */
+				   3 15 /* UART2-ERR */
+				   2 31 /* TC */
+				   2 31 /* ADC */
+				   0 0 /* reserved */
+				   0 0 /* reserved */
+				   0 0 /* reserved */
+				   0 0 /* reserved */
+				   3 16 /* LCD2 */
+				   3 16 /* LCD3 */
+				   3 16 /* LCD4 */
+				   3 17 /* DMA0 */
+				   3 17 /* DMA1 */
+				   3 17 /* DMA2 */
+				   3 17 /* DMA3 */
+				   3 17 /* DMA4 */
+				   3 17 /* DMA5 */
+				   3 18 /* UART3-RX */
+				   3 18 /* UART3-TX */
+				   3 18 /* UART3-ERR */
+				   3 9 /* WDT */
+				   3 9>; /* AC97 */
+	};
+
+	intc2:interrupt-controller@4a000040 {
+		compatible = "samsung,s3c24xx-irq";
+		reg = <0x4a000040 0x18>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+
+		s3c24xx,irqlist = <2 0 /* 2D */
+				   2 0 /* IIC1 */
+				   0 0 /* reserved */
+				   0 0 /* reserved */
+				   2 0 /* PCM0 */
+				   2 0 /* PCM1 */
+				   2 0 /* I2S0 */
+				   2 0>; /* I2S1 */
+	};
+
+	serial@50000000 {
+		compatible = "samsung,s3c2440-uart";
+		status = "disabled";
+	};
+
+	serial@50004000 {
+		compatible = "samsung,s3c2440-uart";
+		status = "disabled";
+	};
+
+	serial@50008000 {
+		compatible = "samsung,s3c2440-uart";
+		status = "disabled";
+	};
+
+	serial@5000C000 {
+		compatible = "samsung,s3c2440-uart";
+		reg = <0x5000C000 0x4000>;
+		interrupt-parent = <&subintc>;
+		interrupts = <24 0>, <25 0>;
+		status = "disabled";
+	};
+
+	sdhci@4AC00000 {
+		compatible = "samsung,s3c6410-sdhci";
+		reg = <0x4AC00000 0x100>;
+		interrupt-parent = <&intc>;
+		interrupts = <21 0>;
+		status = "disabled";
+	};
+
+	sdhci@4A800000 {
+		compatible = "samsung,s3c6410-sdhci";
+		reg = <0x4A800000 0x100>;
+		interrupt-parent = <&intc>;
+		interrupts = <20 0>;
+		status = "disabled";
+	};
+
+	watchdog@53000000 {
+		interrupt-parent = <&subintc>;
+		interrupts = <27 0>;
+	};
+
+	rtc@57000000 {
+		compatible = "samsung,s3c2416-rtc";
+	};
+
+	i2c@54000000 {
+		compatible = "samsung,s3c2440-i2c";
+		reg = <0x54000000 0x100>;
+		interrupt-parent = <&intc>;
+		interrupts = <27 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+	};
+
+	gpio-controllers {
+		gpj: gpio-controller@560000D0 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x560000D0 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpk: gpio-controller@560000E0 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x560000E0 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpl: gpio-controller@560000F0 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x560000F0 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpm: gpio-controller@56000100 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000100 0x10>;
+			#gpio-cells = <3>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/s3c24xx.dtsi b/arch/arm/boot/dts/s3c24xx.dtsi
new file mode 100644
index 0000000..e332598
--- /dev/null
+++ b/arch/arm/boot/dts/s3c24xx.dtsi
@@ -0,0 +1,165 @@
+/*
+ * Samsung's S3C24XX family device tree source
+ *
+ * Copyright (c) 2012 Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Samsung S3C24XX SoC family";
+
+	intc:interrupt-controller@4a000000 {
+		compatible = "samsung,s3c24xx-irq";
+		reg = <0x4a000000 0x18>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	extintc:interrupt-controller@560000a4 {
+		compatible = "samsung,s3c24xx-irq";
+		reg = <0x560000a4 0x8>;
+		interrupt-controller;
+		interrupt-parent = <&intc>;
+		#interrupt-cells = <2>;
+
+		s3c24xx,irqlist = <0 0 /* reserved */
+				   0 0 /* reserved */
+				   0 0 /* reserved */
+				   0 0 /* reserved */
+				   1 4 /* EINT4 */
+				   1 4 /* EINT5 */
+				   1 4 /* EINT6 */
+				   1 4 /* EINT7 */
+				   1 5 /* EINT8 */
+				   1 5 /* EINT9 */
+				   1 5 /* EINT10 */
+				   1 5 /* EINT11 */
+				   1 5 /* EINT12 */
+				   1 5 /* EINT13 */
+				   1 5 /* EINT14 */
+				   1 5 /* EINT15 */
+				   1 5 /* EINT16 */
+				   1 5 /* EINT17 */
+				   1 5 /* EINT18 */
+				   1 5 /* EINT19 */
+				   1 5 /* EINT20 */
+				   1 5 /* EINT21 */
+				   1 5 /* EINT22 */
+				   1 5>; /* EINT23 */
+	};
+
+	subintc:interrupt-controller@4a000018 {
+		compatible = "samsung,s3c24xx-irq";
+		reg = <0x4a000018 0x8>;
+		interrupt-controller;
+		interrupt-parent = <&intc>;
+		#interrupt-cells = <2>;
+	};
+
+	timer@7f006000 {
+		compatible = "samsung,s3c24xx-pwm-timer";
+		reg = <0x51000000 0x1000>;
+		interrupt-parent = <&intc>;
+		interrupts = <10 0>, <11 0>, <12 0>, <13 0>, <14 0>;
+	};
+
+	gpio-controllers {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		gpio-controller;
+		ranges;
+
+		gpa: gpio-controller@56000000 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000000 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpb: gpio-controller@56000010 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000010 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpc: gpio-controller@56000020 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000020 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpd: gpio-controller@56000030 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000030 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpe: gpio-controller@56000040 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000040 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpf: gpio-controller@56000050 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000050 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gpg: gpio-controller@56000060 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000060 0x10>;
+			#gpio-cells = <3>;
+		};
+
+		gph: gpio-controller@56000070 {
+			compatible = "samsung,s3c24xx-gpio";
+			reg = <0x56000070 0x10>;
+			#gpio-cells = <3>;
+		};
+	};
+
+	serial@50000000 {
+		compatible = "samsung,s3c2410-uart";
+		reg = <0x50000000 0x4000>;
+		interrupt-parent = <&subintc>;
+		interrupts = <0 0>, <1 0>;
+		status = "disabled";
+	};
+
+	serial@50004000 {
+		compatible = "samsung,s3c2410-uart";
+		reg = <0x50004000 0x4000>;
+		interrupt-parent = <&subintc>;
+		interrupts = <3 0>, <4 0>;
+		status = "disabled";
+	};
+
+	serial@50008000 {
+		compatible = "samsung,s3c2410-uart";
+		reg = <0x50008000 0x4000>;
+		interrupt-parent = <&subintc>;
+		interrupts = <6 0>, <7 0>;
+		status = "disabled";
+	};
+
+	watchdog@53000000 {
+		compatible = "samsung,s3c2410-wdt";
+		reg = <0x53000000 0x100>;
+		interrupt-parent = <&intc>;
+		interrupts = <9 0>;
+		status = "disabled";
+	};
+
+	rtc@57000000 {
+		compatible = "samsung,s3c2410-rtc";
+		reg = <0x57000000 0x100>;
+		interrupt-parent = <&intc>;
+		interrupts = <30 0>, <8 0>;
+		status = "disabled";
+	};
+};
diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 0a8663c..8bbd502 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -496,6 +496,16 @@ config MACH_SMDK2416
 	help
 	  Say Y here if you are using an SMDK2416
 
+config MACH_S3C2416_DT
+	bool "Samsung S3C2416 machine using devicetree"
+	select CLKSRC_OF
+	select USE_OF
+	help
+	  Machine support for Samsung S3C2416 machines with device tree enabled.
+	  Select this if a fdt blob is available for the S3C2416 SoC based board.
+	  Note: This is under development and not all peripherals can be supported
+	  with this machine file.
+
 endif	# CPU_S3C2416
 
 if CPU_S3C2440
diff --git a/arch/arm/mach-s3c24xx/Makefile b/arch/arm/mach-s3c24xx/Makefile
index 6f46ecf..6de730b 100644
--- a/arch/arm/mach-s3c24xx/Makefile
+++ b/arch/arm/mach-s3c24xx/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_MACH_SMDK2413)		+= mach-smdk2413.o
 obj-$(CONFIG_MACH_VSTMS)		+= mach-vstms.o
 
 obj-$(CONFIG_MACH_SMDK2416)		+= mach-smdk2416.o
+obj-$(CONFIG_MACH_S3C2416_DT)		+= mach-s3c2416-dt.o
 
 obj-$(CONFIG_MACH_ANUBIS)		+= mach-anubis.o
 obj-$(CONFIG_MACH_AT2440EVB)		+= mach-at2440evb.o
diff --git a/arch/arm/mach-s3c24xx/mach-s3c2416-dt.c b/arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
new file mode 100644
index 0000000..c6b10b0
--- /dev/null
+++ b/arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
@@ -0,0 +1,91 @@
+/*
+ * Samsung's S3C2416 flattened device tree enabled machine
+ *
+ * Copyright (c) 2012 Heiko Stuebner <heiko@sntech.de>
+ *
+ * based on mach-exynos/mach-exynos4-dt.c
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Copyright (c) 2010-2011 Linaro Ltd.
+ *		www.linaro.org
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/clocksource.h>
+#include <linux/irqchip.h>
+#include <linux/of_platform.h>
+#include <linux/serial_core.h>
+
+#include <asm/mach/arch.h>
+#include <mach/map.h>
+
+#include <plat/cpu.h>
+#include <plat/pm.h>
+#include <plat/regs-serial.h>
+
+#include "common.h"
+
+/*
+ * The following lookup table is used to override device names when devices
+ * are registered from device tree. This is temporarily added to enable
+ * device tree support addition for the S3C2416 architecture.
+ *
+ * For drivers that require platform data to be provided from the machine
+ * file, a platform data pointer can also be supplied along with the
+ * devices names. Usually, the platform data elements that cannot be parsed
+ * from the device tree by the drivers (example: function pointers) are
+ * supplied. But it should be noted that this is a temporary mechanism and
+ * at some point, the drivers should be capable of parsing all the platform
+ * data from the device tree.
+ */
+static const struct of_dev_auxdata s3c2416_auxdata_lookup[] __initconst = {
+	OF_DEV_AUXDATA("samsung,s3c2440-uart", S3C2410_PA_UART0,
+				"s3c2440-uart.0", NULL),
+	OF_DEV_AUXDATA("samsung,s3c2440-uart", S3C2410_PA_UART1,
+				"s3c2440-uart.1", NULL),
+	OF_DEV_AUXDATA("samsung,s3c2440-uart", S3C2410_PA_UART2,
+				"s3c2440-uart.2", NULL),
+	OF_DEV_AUXDATA("samsung,s3c2440-uart", S3C2443_PA_UART3,
+				"s3c2440-uart.3", NULL),
+	OF_DEV_AUXDATA("samsung,s3c6410-sdhci", S3C_PA_HSMMC0,
+				"s3c-sdhci.0", NULL),
+	OF_DEV_AUXDATA("samsung,s3c6410-sdhci", S3C_PA_HSMMC1,
+				"s3c-sdhci.1", NULL),
+	OF_DEV_AUXDATA("samsung,s3c2440-i2c", S3C_PA_IIC,
+				"s3c2440-i2c.0", NULL),
+	{},
+};
+
+static void __init s3c2416_dt_map_io(void)
+{
+	s3c24xx_init_io(NULL, 0);
+	s3c24xx_init_clocks(12000000);
+}
+
+static void __init s3c2416_dt_machine_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+				s3c2416_auxdata_lookup, NULL);
+
+	s3c_pm_init();
+}
+
+static char const *s3c2416_dt_compat[] __initdata = {
+	"samsung,s3c2416",
+	"samsung,s3c2450",
+	NULL
+};
+
+DT_MACHINE_START(S3C2416_DT, "Samsung S3C2416 (Flattened Device Tree)")
+	/* Maintainer: Heiko Stuebner <heiko@sntech.de> */
+	.dt_compat	= s3c2416_dt_compat,
+	.map_io		= s3c2416_dt_map_io,
+	.init_irq	= irqchip_init,
+	.init_machine	= s3c2416_dt_machine_init,
+	.init_time	= clocksource_of_init,
+	.restart	= s3c2416_restart,
+MACHINE_END
-- 
1.7.2.3

