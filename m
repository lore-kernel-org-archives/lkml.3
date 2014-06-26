Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbaFZSRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:17:13 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33425 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998AbaFZSRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:17:09 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v5 14/14] ARM: dts: Add max77802 to exynos5420-peach-pit and exynos5800-peach-pi
Date: Thu, 26 Jun 2014 20:15:46 +0200
Message-Id: <1403806546-31122-15-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peach pit and pi boards uses a Maxim 77802 power management
IC to drive regulators and its Real Time Clock. This patch
adds support for this chip.

These are the device nodes and pinctrl configuration that
are present on the Peach pit DeviceTree source file in the
the Chrome OS kernel 3.8 tree.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---

Changes since v4: None

Changes since v3:
 - Add support for Exynos5800 based Peach pi board. Suggested by Doug Anderson.
 - Model the actual regulators relationship instead of a simplistic model.
   Suggested by Mark Brown.

Changes since v2: None

Changes since v1:
 - Use "regulators" for child node instead of "voltage-regulators" to be
   consistent with other PMIC. Suggested by Mark Brown.
 - Use regulators node names instead of the deprecated "regulator-compatible"
   property. Suggested by Mark Brown.

 arch/arm/boot/dts/exynos5420-peach-pit.dts | 343 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 343 +++++++++++++++++++++++++++++
 2 files changed, 686 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index b2f1237..d124394 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -143,6 +143,311 @@
 	ddc = <&i2c_2>;
 };
 
+&hsi2c_4 {
+	status = "okay";
+	clock-frequency = <400000>;
+
+	max77802-pmic@9 {
+		compatible = "maxim,max77802";
+		interrupt-parent = <&gpx3>;
+		interrupts = <1 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&max77802_irq>, <&pmic_selb>,
+			    <&pmic_dvs_1>, <&pmic_dvs_2>, <&pmic_dvs_3>;
+		wakeup-source;
+		reg = <0x9>;
+		#clock-cells = <1>;
+
+		/* Using idx 1 means warm reset will get good voltage */
+		max77802,pmic-buck-default-dvs-idx = <1>;
+		max77802,pmic-buck-dvs-gpios = <&gpy7 6 GPIO_ACTIVE_HIGH>,
+					       <&gpj4 2 GPIO_ACTIVE_HIGH>,
+					       <&gpj4 3 GPIO_ACTIVE_HIGH>;
+		max77802,pmic-buck-selb-gpios = <&gph0 2 GPIO_ACTIVE_HIGH>,
+						<&gph0 3 GPIO_ACTIVE_HIGH>,
+						<&gph0 4 GPIO_ACTIVE_HIGH>,
+						<&gph0 5 GPIO_ACTIVE_HIGH>,
+						<&gph0 6 GPIO_ACTIVE_HIGH>;
+
+		inb1-supply = <&tps65090_dcdc2>;
+		inb2-supply = <&tps65090_dcdc1>;
+		inb3-supply = <&tps65090_dcdc2>;
+		inb4-supply = <&tps65090_dcdc2>;
+		inb5-supply = <&tps65090_dcdc1>;
+		inb6-supply = <&tps65090_dcdc2>;
+		inb7-supply = <&tps65090_dcdc1>;
+		inb8-supply = <&tps65090_dcdc1>;
+		inb9-supply = <&tps65090_dcdc1>;
+		inb10-supply = <&tps65090_dcdc1>;
+
+		inl1-supply = <&buck5_reg>;
+		inl2-supply = <&buck7_reg>;
+		inl3-supply = <&buck9_reg>;
+		inl4-supply = <&buck9_reg>;
+		inl5-supply = <&buck9_reg>;
+		inl6-supply = <&tps65090_dcdc2>;
+		inl7-supply = <&buck9_reg>;
+		inl9-supply = <&tps65090_dcdc2>;
+		inl10-supply = <&buck7_reg>;
+
+		regulators {
+			buck1_reg: BUCK1 {
+				regulator-name = "vdd_mif";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck2_reg: BUCK2 {
+				regulator-name = "vdd_arm_real";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck3_reg: BUCK3 {
+				regulator-name = "vdd_int_real";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck4_reg: BUCK4 {
+				regulator-name = "vdd_g3d";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck5_reg: BUCK5 {
+				regulator-name = "vdd_1v2";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck6_reg: BUCK6 {
+				regulator-name = "vdd_kfc";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck7_reg: BUCK7 {
+				regulator-name = "vdd_1v35";
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck8_reg: BUCK8 {
+				regulator-name = "vdd_emmc";
+				regulator-min-microvolt = <2850000>;
+				regulator-max-microvolt = <2850000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck9_reg: BUCK9 {
+				regulator-name = "vdd_2v";
+				regulator-min-microvolt = <2000000>;
+				regulator-max-microvolt = <2000000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck10_reg: BUCK10 {
+				regulator-name = "vdd_1v8";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo1_reg: LDO1 {
+				regulator-name = "vdd_1v0";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo2_reg: LDO2 {
+				regulator-name = "vdd_1v2_2";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+			};
+			ldo3_reg: LDO3 {
+				regulator-name = "vdd_1v8_3";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			vqmmc_sdcard: ldo4_reg: LDO4 {
+				regulator-name = "vdd_sd";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+
+			};
+			ldo5_reg: LDO5 {
+				regulator-name = "vdd_1v8_5";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo6_reg: LDO6 {
+				regulator-name = "vdd_1v8_6";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo7_reg: LDO7 {
+				regulator-name = "vdd_1v8_7";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo8_reg: LDO8 {
+				regulator-name = "vdd_ldo8";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo9_reg: LDO9 {
+				regulator-name = "vdd_ldo9";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo10_reg: LDO10 {
+				regulator-name = "vdd_ldo10";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo11_reg: LDO11 {
+				regulator-name = "vdd_ldo11";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo12_reg: LDO12 {
+				regulator-name = "vdd_ldo12";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-always-on;
+			};
+			ldo13_reg: LDO13 {
+				regulator-name = "vdd_ldo13";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo14_reg: LDO14 {
+				regulator-name = "vdd_ldo14";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo15_reg: LDO15 {
+				regulator-name = "vdd_ldo15";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo17_reg: LDO17 {
+				regulator-name = "vdd_g3ds";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+			};
+			ldo18_reg: LDO18 {
+				regulator-name = "ldo_18";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo19_reg: LDO19 {
+				regulator-name = "ldo_19";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo20_reg: LDO20 {
+				regulator-name = "ldo_20";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo21_reg: LDO21 {
+				regulator-name = "ldo_21";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
+			ldo23_reg: LDO23 {
+				regulator-name = "ld0_23";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+			ldo24_reg: LDO24 {
+				regulator-name = "ldo_24";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
+			ldo25_reg: LDO25 {
+				regulator-name = "ldo_25";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+			ldo26_reg: LDO26 {
+				regulator-name = "ldo_26";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+			};
+			ldo27_reg: LDO27 {
+				regulator-name = "ldo_27";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+			};
+			ldo28_reg: LDO28 {
+				regulator-name = "ldo_28";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo29_reg: LDO29 {
+				regulator-name = "ldo_29";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo30_reg: LDO30 {
+				regulator-name = "vdd_mifs";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo32_reg: LDO32 {
+				regulator-name = "ldo_32";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+			};
+			ldo33_reg: LDO33 {
+				regulator-name = "ldo_33";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
+			ldo34_reg: LDO34 {
+				regulator-name = "ldo_34";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+			};
+			ldo35_reg: LDO35 {
+				regulator-name = "ldo_35";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				inl2-supply = <&buck7_reg>;
+			};
+		};
+	};
+};
+
 &hsi2c_7 {
 	status = "okay";
 
@@ -264,12 +569,42 @@
 		samsung,pin-drv = <0>;
 	};
 
+	max77802_irq: max77802-irq {
+		samsung,pins = "gpx3-1";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	hdmi_hpd_irq: hdmi-hpd-irq {
 		samsung,pins = "gpx3-7";
 		samsung,pin-function = <0>;
 		samsung,pin-pud = <1>;
 		samsung,pin-drv = <0>;
 	};
+
+	pmic_dvs_1: pmic-dvs-1 {
+		samsung,pins = "gpy7-6";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_2 {
+	pmic_dvs_2: pmic-dvs-2 {
+		samsung,pins = "gpj4-2";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pmic_dvs_3: pmic-dvs-3 {
+		samsung,pins = "gpj4-3";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
 };
 
 &pinctrl_3 {
@@ -299,6 +634,14 @@
 		samsung,pin-pud = <0>;
 		samsung,pin-drv = <0>;
 	};
+
+	pmic_selb: pmic-selb {
+		samsung,pins = "gph0-2", "gph0-3", "gph0-4", "gph0-5",
+			       "gph0-6";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
 };
 
 &rtc {
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 5c60bbe..c36c9ce 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -141,6 +141,311 @@
 	ddc = <&i2c_2>;
 };
 
+&hsi2c_4 {
+	status = "okay";
+	clock-frequency = <400000>;
+
+	max77802-pmic@9 {
+		compatible = "maxim,max77802";
+		interrupt-parent = <&gpx3>;
+		interrupts = <1 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&max77802_irq>, <&pmic_selb>,
+			    <&pmic_dvs_1>, <&pmic_dvs_2>, <&pmic_dvs_3>;
+		wakeup-source;
+		reg = <0x9>;
+		#clock-cells = <1>;
+
+		/* Using idx 1 means warm reset will get good voltage */
+		max77802,pmic-buck-default-dvs-idx = <1>;
+		max77802,pmic-buck-dvs-gpios = <&gpy7 6 GPIO_ACTIVE_HIGH>,
+					       <&gpj4 2 GPIO_ACTIVE_HIGH>,
+					       <&gpj4 3 GPIO_ACTIVE_HIGH>;
+		max77802,pmic-buck-selb-gpios = <&gph0 2 GPIO_ACTIVE_HIGH>,
+						<&gph0 3 GPIO_ACTIVE_HIGH>,
+						<&gph0 4 GPIO_ACTIVE_HIGH>,
+						<&gph0 5 GPIO_ACTIVE_HIGH>,
+						<&gph0 6 GPIO_ACTIVE_HIGH>;
+
+		inb1-supply = <&tps65090_dcdc2>;
+		inb2-supply = <&tps65090_dcdc1>;
+		inb3-supply = <&tps65090_dcdc2>;
+		inb4-supply = <&tps65090_dcdc2>;
+		inb5-supply = <&tps65090_dcdc1>;
+		inb6-supply = <&tps65090_dcdc2>;
+		inb7-supply = <&tps65090_dcdc1>;
+		inb8-supply = <&tps65090_dcdc1>;
+		inb9-supply = <&tps65090_dcdc1>;
+		inb10-supply = <&tps65090_dcdc1>;
+
+		inl1-supply = <&buck5_reg>;
+		inl2-supply = <&buck7_reg>;
+		inl3-supply = <&buck9_reg>;
+		inl4-supply = <&buck9_reg>;
+		inl5-supply = <&buck9_reg>;
+		inl6-supply = <&tps65090_dcdc2>;
+		inl7-supply = <&buck9_reg>;
+		inl9-supply = <&tps65090_dcdc2>;
+		inl10-supply = <&buck7_reg>;
+
+		regulators {
+			buck1_reg: BUCK1 {
+				regulator-name = "vdd_mif";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck2_reg: BUCK2 {
+				regulator-name = "vdd_arm_real";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck3_reg: BUCK3 {
+				regulator-name = "vdd_int_real";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck4_reg: BUCK4 {
+				regulator-name = "vdd_g3d";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck5_reg: BUCK5 {
+				regulator-name = "vdd_1v2";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck6_reg: BUCK6 {
+				regulator-name = "vdd_kfc";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-ramp-delay = <12500>;
+			};
+			buck7_reg: BUCK7 {
+				regulator-name = "vdd_1v35";
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck8_reg: BUCK8 {
+				regulator-name = "vdd_emmc";
+				regulator-min-microvolt = <2850000>;
+				regulator-max-microvolt = <2850000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck9_reg: BUCK9 {
+				regulator-name = "vdd_2v";
+				regulator-min-microvolt = <2000000>;
+				regulator-max-microvolt = <2000000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			buck10_reg: BUCK10 {
+				regulator-name = "vdd_1v8";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo1_reg: LDO1 {
+				regulator-name = "vdd_1v0";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo2_reg: LDO2 {
+				regulator-name = "vdd_1v2_2";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+			};
+			ldo3_reg: LDO3 {
+				regulator-name = "vdd_1v8_3";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			vqmmc_sdcard: ldo4_reg: LDO4 {
+				regulator-name = "vdd_sd";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+
+			};
+			ldo5_reg: LDO5 {
+				regulator-name = "vdd_1v8_5";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo6_reg: LDO6 {
+				regulator-name = "vdd_1v8_6";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo7_reg: LDO7 {
+				regulator-name = "vdd_1v8_7";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo8_reg: LDO8 {
+				regulator-name = "vdd_ldo8";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo9_reg: LDO9 {
+				regulator-name = "vdd_ldo9";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo10_reg: LDO10 {
+				regulator-name = "vdd_ldo10";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo11_reg: LDO11 {
+				regulator-name = "vdd_ldo11";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo12_reg: LDO12 {
+				regulator-name = "vdd_ldo12";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-always-on;
+			};
+			ldo13_reg: LDO13 {
+				regulator-name = "vdd_ldo13";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo14_reg: LDO14 {
+				regulator-name = "vdd_ldo14";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo15_reg: LDO15 {
+				regulator-name = "vdd_ldo15";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo17_reg: LDO17 {
+				regulator-name = "vdd_g3ds";
+				regulator-min-microvolt = <900000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+			};
+			ldo18_reg: LDO18 {
+				regulator-name = "ldo_18";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo19_reg: LDO19 {
+				regulator-name = "ldo_19";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo20_reg: LDO20 {
+				regulator-name = "ldo_20";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			ldo21_reg: LDO21 {
+				regulator-name = "ldo_21";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
+			ldo23_reg: LDO23 {
+				regulator-name = "ld0_23";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+			ldo24_reg: LDO24 {
+				regulator-name = "ldo_24";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
+			ldo25_reg: LDO25 {
+				regulator-name = "ldo_25";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+			ldo26_reg: LDO26 {
+				regulator-name = "ldo_26";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+			};
+			ldo27_reg: LDO27 {
+				regulator-name = "ldo_27";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+			};
+			ldo28_reg: LDO28 {
+				regulator-name = "ldo_28";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo29_reg: LDO29 {
+				regulator-name = "ldo_29";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+			ldo30_reg: LDO30 {
+				regulator-name = "vdd_mifs";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+			ldo32_reg: LDO32 {
+				regulator-name = "ldo_32";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+			};
+			ldo33_reg: LDO33 {
+				regulator-name = "ldo_33";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+			};
+			ldo34_reg: LDO34 {
+				regulator-name = "ldo_34";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+			};
+			ldo35_reg: LDO35 {
+				regulator-name = "ldo_35";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				inl2-supply = <&buck7_reg>;
+			};
+		};
+	};
+};
+
 &hsi2c_7 {
 	status = "okay";
 
@@ -262,12 +567,42 @@
 		samsung,pin-drv = <0>;
 	};
 
+	max77802_irq: max77802-irq {
+		samsung,pins = "gpx3-1";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	hdmi_hpd_irq: hdmi-hpd-irq {
 		samsung,pins = "gpx3-7";
 		samsung,pin-function = <0>;
 		samsung,pin-pud = <1>;
 		samsung,pin-drv = <0>;
 	};
+
+	pmic_dvs_1: pmic-dvs-1 {
+		samsung,pins = "gpy7-6";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&pinctrl_2 {
+	pmic_dvs_2: pmic-dvs-2 {
+		samsung,pins = "gpj4-2";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	pmic_dvs_3: pmic-dvs-3 {
+		samsung,pins = "gpj4-3";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
 };
 
 &pinctrl_3 {
@@ -297,6 +632,14 @@
 		samsung,pin-pud = <0>;
 		samsung,pin-drv = <0>;
 	};
+
+	pmic_selb: pmic-selb {
+		samsung,pins = "gph0-2", "gph0-3", "gph0-4", "gph0-5",
+			       "gph0-6";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
 };
 
 &rtc {
-- 
2.0.0.rc2

