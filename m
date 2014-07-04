Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbaGDRtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:49:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33588 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaGDRtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:00 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-cc-53b6e90a0ead
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 10/19] ARM: Samsung: DT: Add Device tree for S5PC110/S5PV210
 Boards
Date: Fri, 04 Jul 2014 19:48:10 +0200
Message-id: <1404496099-26708-11-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7pcL7cFG7zpt7T4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i1a4/jA5cHr9/TWL02Dnr
	LrvHplWdbB6bl9R7XDnRxOrRt2UVo8f2a/OYPT5vkgvgiOKySUnNySxLLdK3S+DK+PhvP2PB
	3PeMFY+bb7I0MC7ewdjFyMkhIWAiMathEhuELSZx4d56IJuLQ0hgKaPErAO/mCCcPiaJtjcn
	WEGq2ATUJD43PALrEBFQlfjctoC9i5GDg1ngNpNEqzCIKSwQKnFsazlIBQtQxc91d5lAwrwC
	zhI7rhhDrJKT6N32hhnE5gQKT1x3gQnEFhJwkvjzfz7LBEbeBYwMqxhFU0uTC4qT0nON9IoT
	c4tL89L1kvNzNzFCwvHrDsalx6wOMQpwMCrx8Da0bAsWYk0sK67MPcQowcGsJML7ZxVQiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA2P8NX71m/HdzoZbFq09MlXXeO9E+y0fKg4uaJH9LDe5aP0V
	raCNu6OUO3/q6X6XbJ1+b63ByWN8N33a2wqVbQxzey7/DDbg9HjO97HHtFr9tPINldSHjGwn
	ff5UipR9jna7zGmzdeZtN14LZaFpxTdnP7KuSfoxPyTrnO7b8N3NZq3y2VP5BZVYijMSDbWY
	i4oTAZ/ID3YlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>

Add DTS for s5pc110 boards: goni, aquila, smdkc110
s5pv210: smdkv210, tiny210, torbreck

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[t.figa: Rebased, fixed merge conflicts, neatened.]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/Makefile             |   5 +
 arch/arm/boot/dts/s5pv210-aquila.dts   | 392 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210-goni.dts     | 449 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210-smdkc110.dts |  78 ++++++
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 238 +++++++++++++++++
 arch/arm/boot/dts/s5pv210-torbreck.dts |  92 +++++++
 6 files changed, 1254 insertions(+)
 create mode 100644 arch/arm/boot/dts/s5pv210-aquila.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-goni.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkc110.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkv210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-torbreck.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 5986ff6..386c8d8 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -321,6 +321,11 @@ dtb-$(CONFIG_ARCH_QCOM) += \
 dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
 dtb-$(CONFIG_ARCH_S3C64XX) += s3c6410-mini6410.dtb \
 	s3c6410-smdk6410.dtb
+dtb-$(CONFIG_ARCH_S5PV210) += s5pv210-aquila.dtb \
+	s5pv210-goni.dtb \
+	s5pv210-smdkc110.dtb \
+	s5pv210-smdkv210.dtb \
+	s5pv210-torbreck.dtb
 dtb-$(CONFIG_ARCH_SHMOBILE_LEGACY) += r7s72100-genmai.dtb \
 	r8a7740-armadillo800eva.dtb \
 	r8a7778-bockw.dtb \
diff --git a/arch/arm/boot/dts/s5pv210-aquila.dts b/arch/arm/boot/dts/s5pv210-aquila.dts
new file mode 100644
index 0000000..aa31b84
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-aquila.dts
@@ -0,0 +1,392 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013-2014 Samsung Electronics, Co. Ltd.
+ *
+ * Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * Board device tree source for Samsung Aquila board.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "Samsung Aquila based on S5PC110";
+	compatible = "samsung,aquila", "samsung,s5pv210";
+
+	aliases {
+		i2c3 = &i2c_pmic;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC2,115200n8 root=/dev/mmcblk1p5 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x30000000 0x05000000
+			0x40000000 0x18000000>;
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			gpios = <&mp05 4 0>;
+			enable-active-high;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+	};
+
+	i2c_pmic: i2c-pmic {
+		compatible = "i2c-gpio";
+		gpios = <&gpj4 0 0>, /* sda */
+			<&gpj4 3 0>; /* scl */
+		i2c-gpio,delay-us = <2>;        /* ~100 kHz */
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pmic@66 {
+			compatible = "national,lp3974";
+			reg = <0x66>;
+
+			max8998,pmic-buck1-default-dvs-idx = <0>;
+			max8998,pmic-buck1-dvs-gpios = <&gph0 3 0>,
+							<&gph0 4 0>;
+			max8998,pmic-buck1-dvs-voltage = <1200000>, <1200000>,
+							<1200000>, <1200000>;
+
+			max8998,pmic-buck2-default-dvs-idx = <0>;
+			max8998,pmic-buck2-dvs-gpio = <&gph0 5 0>;
+			max8998,pmic-buck2-dvs-voltage = <1200000>, <1200000>;
+
+			regulators {
+				ldo2_reg: LDO2 {
+					regulator-name = "VALIVE_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo3_reg: LDO3 {
+					regulator-name = "VUSB+MIPI_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo4_reg: LDO4 {
+					regulator-name = "VADC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo5_reg: LDO5 {
+					regulator-name = "VTF_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo6_reg: LDO6 {
+					regulator-name = "VCC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo7_reg: LDO7 {
+					regulator-name = "VCC_3.0V";
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo8_reg: LDO8 {
+					regulator-name = "VUSB+VDAC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo9_reg: LDO9 {
+					regulator-name = "VCC+VCAM_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo10_reg: LDO10 {
+					regulator-name = "VPLL_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo11_reg: LDO11 {
+					regulator-name = "CAM_IO_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo12_reg: LDO12 {
+					regulator-name = "CAM_ISP_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				ldo13_reg: LDO13 {
+					regulator-name = "CAM_A_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo14_reg: LDO14 {
+					regulator-name = "CAM_CIF_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo15_reg: LDO15 {
+					regulator-name = "CAM_AF_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo16_reg: LDO16 {
+					regulator-name = "VMIPI_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo17_reg: LDO17 {
+					regulator-name = "CAM_8M_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck1_reg: BUCK1 {
+					regulator-name = "VARM_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				buck2_reg: BUCK2 {
+					regulator-name = "VINT_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				buck3_reg: BUCK3 {
+					regulator-name = "VCC_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck4_reg: BUCK4 {
+					regulator-name = "CAM_CORE_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				vichg_reg: ENVICHG {
+					regulator-name = "VICHG";
+				};
+
+				safeout1_reg: ESAFEOUT1 {
+					regulator-name = "SAFEOUT1";
+					regulator-always-on;
+				};
+
+				safeout2_reg: ESAFEOUT2 {
+					regulator-name = "SAFEOUT2";
+					regulator-boot-on;
+				};
+			};
+		};
+
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		power-key {
+			gpios = <&gph2 6 1>;
+			linux,code = <KEY_POWER>;
+			label = "power";
+			debounce-interval = <1>;
+			gpio-key,wakeup;
+		};
+	};
+};
+
+&xusbxti {
+	clock-frequency = <24000000>;
+};
+
+&keypad {
+	linux,input-no-autorepeat;
+	linux,input-wakeup;
+	samsung,keypad-num-rows = <3>;
+	samsung,keypad-num-columns = <3>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&keypad_row0>, <&keypad_row1>, <&keypad_row2>,
+			<&keypad_col0>, <&keypad_col1>, <&keypad_col2>;
+	status = "okay";
+
+	key_1 {
+		keypad,row = <0>;
+		keypad,column = <1>;
+		linux,code = <KEY_CONNECT>;
+	};
+
+	key_2 {
+		keypad,row = <0>;
+		keypad,column = <2>;
+		linux,code = <KEY_BACK>;
+	};
+
+	key_3 {
+		keypad,row = <1>;
+		keypad,column = <1>;
+		linux,code = <KEY_CAMERA_FOCUS>;
+	};
+
+	key_4 {
+		keypad,row = <1>;
+		keypad,column = <2>;
+		linux,code = <KEY_VOLUMEUP>;
+	};
+
+	key_5 {
+		keypad,row = <2>;
+		keypad,column = <1>;
+		linux,code = <KEY_CAMERA>;
+	};
+
+	key_6 {
+		keypad,row = <2>;
+		keypad,column = <2>;
+		linux,code = <KEY_VOLUMEDOWN>;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&uart3 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <4>;
+	non-removable;
+	status = "okay";
+	vmmc-supply = <&ldo5_reg>;
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_bus4>;
+	pinctrl-names = "default";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4 &t_flash_detect>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&onenand {
+	status = "okay";
+};
+
+&hsotg {
+	vusb_a-supply = <&ldo3_reg>;
+	vusb_d-supply = <&ldo8_reg>;
+	status = "okay";
+};
+
+&usbphy {
+	status = "okay";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24 &pwm1_out>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: timing {
+			clock-frequency = <0>;
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <16>;
+			hback-porch = <16>;
+			hsync-len = <2>;
+			vback-porch = <3>;
+			vfront-porch = <28>;
+			vsync-len = <1>;
+		};
+	};
+};
+
+&pinctrl0 {
+	t_flash_detect: t-flash-detect {
+		samsung,pins = "gph3-4";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+	};
+};
diff --git a/arch/arm/boot/dts/s5pv210-goni.dts b/arch/arm/boot/dts/s5pv210-goni.dts
new file mode 100644
index 0000000..6387c77
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-goni.dts
@@ -0,0 +1,449 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013-2014 Samsung Electronics, Co. Ltd.
+ *
+ * Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * Board device tree source for Samsung Goni board.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "Samsung Goni based on S5PC110";
+	compatible = "samsung,goni", "samsung,s5pv210";
+
+	aliases {
+		i2c3 = &i2c_pmic;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p5 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x30000000 0x05000000
+			0x40000000 0x10000000
+			0x50000000 0x08000000>;
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vtf_reg: fixed-regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_TF_2.8V";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <0>;
+			gpios = <&mp05 4 0>;
+			enable-active-high;
+		};
+
+		pda_reg: fixed-regulator@1 {
+			compatible = "regulator-fixed";
+			regulator-name = "VCC_1.8V_PDA";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			reg = <1>;
+		};
+
+		bat_reg: fixed-regulator@2 {
+			compatible = "regulator-fixed";
+			regulator-name = "V_BAT";
+			regulator-min-microvolt = <3700000>;
+			regulator-max-microvolt = <3700000>;
+			reg = <2>;
+		};
+
+		tsp_reg: fixed-regulator@3 {
+			compatible = "regulator-fixed";
+			regulator-name = "TSP_VDD";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			reg = <3>;
+			gpios = <&gpj1 3 0>;
+			enable-active-high;
+		};
+	};
+
+	i2c_pmic: i2c-pmic {
+		compatible = "i2c-gpio";
+		gpios = <&gpj4 0 0>, /* sda */
+			<&gpj4 3 0>; /* scl */
+		i2c-gpio,delay-us = <2>;        /* ~100 kHz */
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pmic@66 {
+			compatible = "national,lp3974";
+			reg = <0x66>;
+
+			max8998,pmic-buck1-default-dvs-idx = <0>;
+			max8998,pmic-buck1-dvs-gpios = <&gph0 3 0>,
+							<&gph0 4 0>;
+			max8998,pmic-buck1-dvs-voltage = <1200000>, <1200000>,
+							<1200000>, <1200000>;
+
+			max8998,pmic-buck2-default-dvs-idx = <0>;
+			max8998,pmic-buck2-dvs-gpio = <&gph0 5 0>;
+			max8998,pmic-buck2-dvs-voltage = <1200000>, <1200000>;
+
+			regulators {
+				ldo2_reg: LDO2 {
+					regulator-name = "VALIVE_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo3_reg: LDO3 {
+					regulator-name = "VUSB+MIPI_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo4_reg: LDO4 {
+					regulator-name = "VADC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo5_reg: LDO5 {
+					regulator-name = "VTF_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo6_reg: LDO6 {
+					regulator-name = "VCC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo7_reg: LDO7 {
+					regulator-name = "VLCD_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo8_reg: LDO8 {
+					regulator-name = "VUSB+VDAC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo9_reg: LDO9 {
+					regulator-name = "VCC+VCAM_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo10_reg: LDO10 {
+					regulator-name = "VPLL_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-boot-on;
+				};
+
+				ldo11_reg: LDO11 {
+					regulator-name = "CAM_IO_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo12_reg: LDO12 {
+					regulator-name = "CAM_ISP_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				ldo13_reg: LDO13 {
+					regulator-name = "CAM_A_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+				};
+
+				ldo14_reg: LDO14 {
+					regulator-name = "CAM_CIF_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				ldo15_reg: LDO15 {
+					regulator-name = "CAM_AF_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo16_reg: LDO16 {
+					regulator-name = "VMIPI_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+				};
+
+				ldo17_reg: LDO17 {
+					regulator-name = "CAM_8M_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck1_reg: BUCK1 {
+					regulator-name = "VARM_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				buck2_reg: BUCK2 {
+					regulator-name = "VINT_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				buck3_reg: BUCK3 {
+					regulator-name = "VCC_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				buck4_reg: BUCK4 {
+					regulator-name = "CAM_CORE_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+			};
+		};
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		power-key {
+			gpios = <&gph2 6 1>;
+			linux,code = <KEY_POWER>;
+			label = "power";
+			debounce-interval = <1>;
+			gpio-key,wakeup;
+		};
+	};
+};
+
+&xusbxti {
+	clock-frequency = <24000000>;
+};
+
+&keypad {
+	linux,input-no-autorepeat;
+	linux,input-wakeup;
+	samsung,keypad-num-rows = <3>;
+	samsung,keypad-num-columns = <3>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&keypad_row0>, <&keypad_row1>, <&keypad_row2>,
+			<&keypad_col0>, <&keypad_col1>, <&keypad_col2>;
+	status = "okay";
+
+	key_1 {
+		keypad,row = <0>;
+		keypad,column = <1>;
+		linux,code = <KEY_CONNECT>;
+	};
+
+	key_2 {
+		keypad,row = <0>;
+		keypad,column = <2>;
+		linux,code = <KEY_BACK>;
+	};
+
+	key_3 {
+		keypad,row = <1>;
+		keypad,column = <1>;
+		linux,code = <KEY_CAMERA_FOCUS>;
+	};
+
+	key_4 {
+		keypad,row = <1>;
+		keypad,column = <2>;
+		linux,code = <KEY_VOLUMEUP>;
+	};
+
+	key_5 {
+		keypad,row = <2>;
+		keypad,column = <1>;
+		linux,code = <KEY_CAMERA>;
+	};
+
+	key_6 {
+		keypad,row = <2>;
+		keypad,column = <2>;
+		linux,code = <KEY_VOLUMEDOWN>;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&uart3 {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <4>;
+	non-removable;
+	vmmc-supply = <&ldo5_reg>;
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_cd &sd0_bus1 &sd0_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	cd-gpios = <&gph3 4 1>;
+	vmmc-supply = <&vtf_reg>;
+	cd-inverted;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&hsotg {
+	vusb_a-supply = <&ldo3_reg>;
+	vusb_d-supply = <&ldo8_reg>;
+	status = "okay";
+};
+
+&usbphy {
+	status = "okay";
+};
+
+&i2c2 {
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <400000>;
+	samsung,i2c-slave-addr = <0x10>;
+	status = "okay";
+
+	tsp@4a {
+		compatible = "atmel,maxtouch";
+		reg = <0x4a>;
+		interrupt-parent = <&gpj0>;
+		interrupts = <5 2>;
+
+		atmel,x-line = <17>;
+		atmel,y-line = <11>;
+		atmel,x-size = <800>;
+		atmel,y-size = <480>;
+		atmel,burst-length = <0x21>;
+		atmel,threshold = <0x28>;
+		atmel,orientation = <1>;
+
+		vdd-supply = <&tsp_reg>;
+	};
+};
+
+&i2c0 {
+	samsung,i2c-sda-delay = <100>;
+	samsung,i2c-max-bus-freq = <100000>;
+	samsung,i2c-slave-addr = <0x10>;
+	status = "okay";
+
+	noon010pc30: sensor@30 {
+		compatible = "siliconfile,noon010pc30";
+		reg = <0x30>;
+		vddio-supply = <&ldo11_reg>;
+		vdda-supply = <&ldo13_reg>;
+		vdd_core-supply = <&ldo14_reg>;
+
+		clock-frequency = <16000000>;
+		clocks = <&clock_cam 0>;
+		clock-names = "mclk";
+		nreset-gpios = <&gpb 2 0>;
+		nstby-gpios = <&gpb 0 0>;
+
+		port {
+			noon010pc30_ep: endpoint {
+				remote-endpoint = <&fimc0_ep>;
+				bus-width = <8>;
+				hsync-active = <0>;
+				vsync-active = <1>;
+				pclk-sample = <1>;
+			};
+		};
+	};
+};
+
+&camera {
+	pinctrl-0 = <&cam_port_a_io &cam_port_a_clk_active>;
+	pinctrl-1 = <&cam_port_a_io &cam_port_a_clk_idle>;
+	pinctrl-names = "default", "idle";
+
+	parallel-ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* camera A input */
+		port@1 {
+			reg = <1>;
+			fimc0_ep: endpoint {
+				remote-endpoint = <&noon010pc30_ep>;
+				bus-width = <8>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+				pclk-sample = <0>;
+			};
+		};
+	};
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: timing {
+			/* 480x800@55Hz */
+			clock-frequency = <23439570>;
+			hactive = <480>;
+			hfront-porch = <16>;
+			hback-porch = <16>;
+			hsync-len = <2>;
+			vactive = <800>;
+			vback-porch = <2>;
+			vfront-porch = <28>;
+			vsync-len = <1>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+			de-active = <0>;
+			pixelclk-active = <0>;
+		};
+	};
+};
+
+&onenand {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/s5pv210-smdkc110.dts b/arch/arm/boot/dts/s5pv210-smdkc110.dts
new file mode 100644
index 0000000..1eedab7
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-smdkc110.dts
@@ -0,0 +1,78 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013-2014 Samsung Electronics, Co. Ltd.
+ *
+ * Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * Board device tree source for YIC System SMDC110 board.
+ *
+ * NOTE: This file is completely based on original board file for mach-smdkc110
+ * available in Linux 3.15 and intends to provide equivalent level of hardware
+ * support. Due to lack of hardware, _no_ testing has been performed.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "YIC System SMDKC110 based on S5PC110";
+	compatible = "yic,smdkc110", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p1 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x20000000 0x20000000>;
+	};
+};
+
+&xusbxti {
+	clock-frequency = <24000000>;
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&uart3 {
+	status = "okay";
+};
+
+&rtc {
+	status = "okay";
+};
+
+&i2c0 {
+	status = "okay";
+
+	audio-codec@1b {
+		compatible = "wlf,wm8580";
+		reg = <0x1b>;
+	};
+
+	eeprom@50 {
+		compatible = "atmel,24c08";
+		reg = <0x50>;
+	};
+};
+
+&i2s0 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
new file mode 100644
index 0000000..cb85218
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -0,0 +1,238 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013-2014 Samsung Electronics, Co. Ltd.
+ *
+ * Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * Board device tree source for YIC System SMDV210 board.
+ *
+ * NOTE: This file is completely based on original board file for mach-smdkv210
+ * available in Linux 3.15 and intends to provide equivalent level of hardware
+ * support. Due to lack of hardware, _no_ testing has been performed.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "YIC System SMDKV210 based on S5PV210";
+	compatible = "yic,smdkv210", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p1 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x20000000 0x40000000>;
+	};
+
+	ethernet@18000000 {
+		compatible = "davicom,dm9000";
+		reg = <0xA8000000 0x2 0xA8000002 0x2>;
+		interrupt-parent = <&gph1>;
+		interrupts = <1 4>;
+		local-mac-address = [00 00 de ad be ef];
+		davicom,no-eeprom;
+	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 3 5000000 0>;
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pwm3_out>;
+	};
+};
+
+&xusbxti {
+	clock-frequency = <24000000>;
+};
+
+&keypad {
+	linux,input-no-autorepeat;
+	linux,input-wakeup;
+	samsung,keypad-num-rows = <8>;
+	samsung,keypad-num-columns = <8>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&keypad_row0>, <&keypad_row1>, <&keypad_row2>,
+			<&keypad_row3>, <&keypad_row4>, <&keypad_row5>,
+			<&keypad_row6>, <&keypad_row7>,
+			<&keypad_col0>, <&keypad_col1>, <&keypad_col2>,
+			<&keypad_col3>, <&keypad_col4>, <&keypad_col5>,
+			<&keypad_col6>, <&keypad_col7>;
+	status = "okay";
+
+	key_1 {
+		keypad,row = <0>;
+		keypad,column = <3>;
+		linux,code = <KEY_1>;
+	};
+
+	key_2 {
+		keypad,row = <0>;
+		keypad,column = <4>;
+		linux,code = <KEY_2>;
+	};
+
+	key_3 {
+		keypad,row = <0>;
+		keypad,column = <5>;
+		linux,code = <KEY_3>;
+	};
+
+	key_4 {
+		keypad,row = <0>;
+		keypad,column = <6>;
+		linux,code = <KEY_4>;
+	};
+
+	key_5 {
+		keypad,row = <0
+		>;
+		keypad,column = <7>;
+		linux,code = <KEY_5>;
+	};
+
+	key_6 {
+		keypad,row = <1>;
+		keypad,column = <3>;
+		linux,code = <KEY_A>;
+	};
+	key_7 {
+		keypad,row = <1>;
+		keypad,column = <4>;
+		linux,code = <KEY_B>;
+	};
+
+	key_8 {
+		keypad,row = <1>;
+		keypad,column = <5>;
+		linux,code = <KEY_C>;
+	};
+
+	key_9 {
+		keypad,row = <1>;
+		keypad,column = <6>;
+		linux,code = <KEY_D>;
+	};
+
+	key_10 {
+		keypad,row = <1>;
+		keypad,column = <7>;
+		linux,code = <KEY_E>;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&uart3 {
+	status = "okay";
+};
+
+&rtc {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_cd &sd0_bus1 &sd0_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci1 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus1 &sd1_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus1 &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci3 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_cd &sd3_bus1 &sd3_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&hsotg {
+	status = "okay";
+};
+
+&usbphy {
+	status = "okay";
+};
+
+&fimd {
+	pinctrl-0 = <&lcd_clk &lcd_data24>;
+	pinctrl-names = "default";
+	status = "okay";
+
+	display-timings {
+		native-mode = <&timing0>;
+
+		timing0: timing@0 {
+			/* 800x480@60Hz */
+			clock-frequency = <24373920>;
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <8>;
+			hback-porch = <13>;
+			hsync-len = <3>;
+			vback-porch = <7>;
+			vfront-porch = <5>;
+			vsync-len = <1>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+			de-active = <1>;
+			pixelclk-active = <1>;
+		};
+	};
+};
+
+&pwm {
+	samsung,pwm-outputs = <3>;
+};
+
+&i2c0 {
+	status = "okay";
+
+	audio-codec@1b {
+		compatible = "wlf,wm8580";
+		reg = <0x1b>;
+	};
+
+	eeprom@50 {
+		compatible = "atmel,24c08";
+		reg = <0x50>;
+	};
+};
+
+&i2s0 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/s5pv210-torbreck.dts b/arch/arm/boot/dts/s5pv210-torbreck.dts
new file mode 100644
index 0000000..622599f
--- /dev/null
+++ b/arch/arm/boot/dts/s5pv210-torbreck.dts
@@ -0,0 +1,92 @@
+/*
+ * Samsung's S5PV210 SoC device tree source
+ *
+ * Copyright (c) 2013-2014 Samsung Electronics, Co. Ltd.
+ *
+ * Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * Board device tree source for Torbreck board.
+ *
+ * NOTE: This file is completely based on original board file for mach-torbreck
+ * available in Linux 3.15 and intends to provide equivalent level of hardware
+ * support. Due to lack of hardware, _no_ testing has been performed.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/dts-v1/;
+#include <dt-bindings/input/input.h>
+#include "s5pv210.dtsi"
+
+/ {
+	model = "aESOP Torbreck based on S5PV210";
+	compatible = "aesop,torbreck", "samsung,s5pv210";
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 root=/dev/mmcblk0p1 rw rootwait ignore_loglevel earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x20000000 0x20000000>;
+	};
+};
+
+&xusbxti {
+	clock-frequency = <24000000>;
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&uart3 {
+	status = "okay";
+};
+
+&rtc {
+	status = "okay";
+};
+
+&sdhci0 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_cd &sd0_bus1 &sd0_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci1 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus1 &sd1_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci2 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus1 &sd2_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&sdhci3 {
+	bus-width = <4>;
+	pinctrl-0 = <&sd3_clk &sd3_cmd &sd3_cd &sd3_bus1 &sd3_bus4>;
+	pinctrl-names = "default";
+	status = "okay";
+};
+
+&i2s0 {
+	status = "okay";
+};
-- 
1.9.3

