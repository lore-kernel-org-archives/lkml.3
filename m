Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaGaRAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:00:37 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:37347 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaGaRAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:00:33 -0400
MIME-Version: 1.0
In-Reply-To: <1406822910-6255-5-git-send-email-afaerber@suse.de>
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-5-git-send-email-afaerber@suse.de>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Thu, 31 Jul 2014 10:00:11 -0700
X-Google-Sender-Auth: fqyZQiJI7arxkh9FWYt9P8DUVII
Message-ID: <CAP_ceTz+KRJzF9XV=_aLE+6sV6d5GqCtQ_daKtpFJfCZQ1erpA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always a bit late to the game.
One small comment inline.

Reviewed-by: Vincent Palatin <vpalatin@chromium.org>

On Thu, Jul 31, 2014 at 9:08 AM, Andreas Färber <afaerber@suse.de> wrote:
> Adds initial support for the HP Chromebook 11.
>
> Cc: Vincent Palatin <vpalatin@chromium.org>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Stephan van Schaik <stephan@synkhronix.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v3 -> v4:
>  * Fixed samsung,pin-function 1 -> 0 for dp-hpd-gpio
>  * Replaced dp-hpd-gpio with existing dp_hpd, overriding it
>
>  v2 -> v3:
>  * Use GPIO_ACTIVE_{LOW,HIGH} (Doug Anderson)
>  * Use symbolic KEY_POWER instead of comment
>  * Moved hsic_reset to new USB3503 node's reset-gpios (Vincent Palatin)
>  * Use dp_hpd_gpio for dp-controller (Doug Anderson, Ajay Kumar)
>  * Override sd1_{clk,cmd,cd,bus4} pinctrl similar to Snow (Doug Anderson)
>  * Added ec_irq pinctrl for cros_ec (Doug Anderson)
>  * Reordered nodes to minimize diff against Snow (Doug Anderson)
>  * Dropped obsolete mmc_2 override (Doug Anderson)
>  * Added lid-switch node (Doug Anderson)
>  * Added gpio-keys pinctrl (Doug Anderson)
>  * Added bootargs to avoid empty /chosen node and to document console setting
>  * Renamed s5m8767_pmic node to avoid underscore
>  * Use new style for overriding inherited pinctrl nodes, too
>  * Enable i2s0 node
>
>  v1 -> v2:
>  * Use label-based overriding/extension of nodes. (Doug Anderson)
>  * Dropped tps65090 for now, until we know where to place it.
>  * Dropped non-Spring nodes from -cros-common.dtsi rather than disabling them.
>  * Enabled a missing MMC node for access to internal storage.
>  * Dropped display-timings from dp-controller node. (Ajay Kumar)
>
>  arch/arm/boot/dts/Makefile              |   1 +
>  arch/arm/boot/dts/exynos5250-spring.dts | 539 ++++++++++++++++++++++++++++++++
>  2 files changed, 540 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos5250-spring.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 80a781f76e88..dec4c292f63d 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -76,6 +76,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>         exynos5250-arndale.dtb \
>         exynos5250-smdk5250.dtb \
>         exynos5250-snow.dtb \
> +       exynos5250-spring.dtb \
>         exynos5260-xyref5260.dtb \
>         exynos5410-smdk5410.dtb \
>         exynos5420-arndale-octa.dtb \
> diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
> new file mode 100644
> index 000000000000..1fdfa04182fc
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5250-spring.dts
> @@ -0,0 +1,539 @@
> +/*
> + * Google Spring board device tree source
> + *
> + * Copyright (c) 2013 Google, Inc
> + * Copyright (c) 2014 SUSE LINUX Products GmbH
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/dts-v1/;
> +#include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/input/input.h>
> +#include "exynos5250.dtsi"
> +
> +/ {
> +       model = "Google Spring";
> +       compatible = "google,spring", "samsung,exynos5250", "samsung,exynos5";
> +
> +       memory {
> +               reg = <0x40000000 0x80000000>;
> +       };
> +
> +       chosen {
> +               bootargs = "console=tty1";
> +       };
> +
> +       gpio-keys {
> +               compatible = "gpio-keys";
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&power_key_irq>, <&lid_irq>;
> +
> +               power {
> +                       label = "Power";
> +                       gpios = <&gpx1 3 GPIO_ACTIVE_LOW>;
> +                       linux,code = <KEY_POWER>;
> +                       gpio-key,wakeup;
> +               };
> +
> +               lid-switch {
> +                       label = "Lid";
> +                       gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
> +                       linux,input-type = <5>; /* EV_SW */
> +                       linux,code = <0>; /* SW_LID */
> +                       debounce-interval = <1>;
> +                       gpio-key,wakeup;
> +               };
> +       };
> +
> +       usb3_vbus_reg: regulator-usb3 {
> +               compatible = "regulator-fixed";
> +               regulator-name = "P5.0V_USB3CON";
> +               regulator-min-microvolt = <5000000>;
> +               regulator-max-microvolt = <5000000>;
> +               gpio = <&gpe1 0 GPIO_ACTIVE_LOW>;
> +               enable-active-high;
> +       };

GPE1_0 GPIO is the HSIC hub (SMSC 3503) reset# line (already defined
below afaik).
On this design there is no external USB3 port, so no VBUS reg/load
switch for USB3.



> +
> +       usb@12110000 {
> +               samsung,vbus-gpio = <&gpx1 1 GPIO_ACTIVE_HIGH>;
> +       };
> +
> +       usb-hub {
> +               compatible = "smsc,usb3503a";
> +               reset-gpios = <&hsic_reset>;
> +       };
> +
> +       fixed-rate-clocks {
> +               xxti {
> +                       compatible = "samsung,clock-xxti";
> +                       clock-frequency = <24000000>;
> +               };
> +       };
> +
> +       hdmi {
> +               hpd-gpio = <&gpx3 7 GPIO_ACTIVE_HIGH>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&hdmi_hpd_irq>;
> +               phy = <&hdmiphy>;
> +               ddc = <&i2c_2>;
> +               hdmi-en-supply = <&s5m_ldo8_reg>;
> +               vdd-supply = <&s5m_ldo8_reg>;
> +               vdd_osc-supply = <&s5m_ldo10_reg>;
> +               vdd_pll-supply = <&s5m_ldo8_reg>;
> +       };
> +
> +       fimd@14400000 {
> +               status = "okay";
> +               samsung,invert-vclk;
> +       };
> +
> +       dp-controller@145B0000 {
> +               status = "okay";
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&dp_hpd>;
> +               samsung,color-space = <0>;
> +               samsung,dynamic-range = <0>;
> +               samsung,ycbcr-coeff = <0>;
> +               samsung,color-depth = <1>;
> +               samsung,link-rate = <0x0a>;
> +               samsung,lane-count = <1>;
> +               samsung,hpd-gpio = <&gpc3 0 GPIO_ACTIVE_HIGH>;
> +       };
> +};
> +
> +&dp_hpd {
> +       samsung,pins = "gpc3-0";
> +       samsung,pin-function = <0>;
> +       samsung,pin-pud = <3>;
> +       samsung,pin-drv = <0>;
> +};
> +
> +&i2c_0 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <378000>;
> +
> +       s5m8767-pmic@66 {
> +               compatible = "samsung,s5m8767-pmic";
> +               reg = <0x66>;
> +               interrupt-parent = <&gpx3>;
> +               interrupts = <2 0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&s5m8767_irq &s5m8767_dvs &s5m8767_ds>;
> +               wakeup-source;
> +
> +               s5m8767,pmic-buck-dvs-gpios = <&gpd1 0 GPIO_ACTIVE_LOW>, /* DVS1 */
> +                                             <&gpd1 1 GPIO_ACTIVE_LOW>, /* DVS2 */
> +                                             <&gpd1 2 GPIO_ACTIVE_LOW>; /* DVS3 */
> +
> +               s5m8767,pmic-buck-ds-gpios = <&gpx2 3 GPIO_ACTIVE_LOW>, /* SET1 */
> +                                            <&gpx2 4 GPIO_ACTIVE_LOW>, /* SET2 */
> +                                            <&gpx2 5 GPIO_ACTIVE_LOW>; /* SET3 */
> +
> +               /*
> +                * The following arrays of DVS voltages are not used, since we are
> +                * not using GPIOs to control PMIC bucks, but they must be defined
> +                * to please the driver.
> +                */
> +               s5m8767,pmic-buck2-dvs-voltage = <1350000>, <1300000>,
> +                                                <1250000>, <1200000>,
> +                                                <1150000>, <1100000>,
> +                                                <1000000>, <950000>;
> +
> +               s5m8767,pmic-buck3-dvs-voltage = <1100000>, <1100000>,
> +                                                <1100000>, <1100000>,
> +                                                <1000000>, <1000000>,
> +                                                <1000000>, <1000000>;
> +
> +               s5m8767,pmic-buck4-dvs-voltage = <1200000>, <1200000>,
> +                                                <1200000>, <1200000>,
> +                                                <1200000>, <1200000>,
> +                                                <1200000>, <1200000>;
> +
> +               clocks {
> +                       compatible = "samsung,s5m8767-clk";
> +                       #clock-cells = <1>;
> +                       clock-output-names = "en32khz_ap",
> +                                            "en32khz_cp",
> +                                            "en32khz_bt";
> +               };
> +
> +               regulators {
> +                       s5m_ldo4_reg: LDO4 {
> +                               regulator-name = "P1.0V_LDO_OUT4";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                               op_mode = <0>;
> +                       };
> +
> +                       s5m_ldo5_reg: LDO5 {
> +                               regulator-name = "P1.0V_LDO_OUT5";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                               op_mode = <0>;
> +                       };
> +
> +                       s5m_ldo6_reg: LDO6 {
> +                               regulator-name = "vdd_mydp";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo7_reg: LDO7 {
> +                               regulator-name = "P1.1V_LDO_OUT7";
> +                               regulator-min-microvolt = <1100000>;
> +                               regulator-max-microvolt = <1100000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo8_reg: LDO8 {
> +                               regulator-name = "P1.0V_LDO_OUT8";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo10_reg: LDO10 {
> +                               regulator-name = "P1.8V_LDO_OUT10";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo11_reg: LDO11 {
> +                               regulator-name = "P1.8V_LDO_OUT11";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                               op_mode = <0>;
> +                       };
> +
> +                       s5m_ldo12_reg: LDO12 {
> +                               regulator-name = "P3.0V_LDO_OUT12";
> +                               regulator-min-microvolt = <3000000>;
> +                               regulator-max-microvolt = <3000000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo13_reg: LDO13 {
> +                               regulator-name = "P1.8V_LDO_OUT13";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                               op_mode = <0>;
> +                       };
> +
> +                       s5m_ldo14_reg: LDO14 {
> +                               regulator-name = "P1.8V_LDO_OUT14";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo15_reg: LDO15 {
> +                               regulator-name = "P1.0V_LDO_OUT15";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo16_reg: LDO16 {
> +                               regulator-name = "P1.8V_LDO_OUT16";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       s5m_ldo17_reg: LDO17 {
> +                               regulator-name = "P2.8V_LDO_OUT17";
> +                               regulator-min-microvolt = <2800000>;
> +                               regulator-max-microvolt = <2800000>;
> +                               regulator-always-on;
> +                               op_mode = <0>;
> +                       };
> +
> +                       s5m_ldo25_reg: LDO25 {
> +                               regulator-name = "vdd_bridge";
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                               regulator-always-on;
> +                               op_mode = <1>;
> +                       };
> +
> +                       BUCK1 {
> +                               regulator-name = "vdd_mif";
> +                               regulator-min-microvolt = <950000>;
> +                               regulator-max-microvolt = <1300000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       BUCK2 {
> +                               regulator-name = "vdd_arm";
> +                               regulator-min-microvolt = <850000>;
> +                               regulator-max-microvolt = <1350000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       BUCK3 {
> +                               regulator-name = "vdd_int";
> +                               regulator-min-microvolt = <900000>;
> +                               regulator-max-microvolt = <1200000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       BUCK4 {
> +                               regulator-name = "vdd_g3d";
> +                               regulator-min-microvolt = <850000>;
> +                               regulator-max-microvolt = <1300000>;
> +                               regulator-boot-on;
> +                               op_mode = <3>;
> +                       };
> +
> +                       BUCK5 {
> +                               regulator-name = "P1.8V_BUCK_OUT5";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               op_mode = <1>;
> +                       };
> +
> +                       BUCK6 {
> +                               regulator-name = "P1.2V_BUCK_OUT6";
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               op_mode = <0>;
> +                       };
> +
> +                       BUCK9 {
> +                               regulator-name = "vdd_ummc";
> +                               regulator-min-microvolt = <950000>;
> +                               regulator-max-microvolt = <3000000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               op_mode = <3>;
> +                       };
> +               };
> +       };
> +};
> +
> +&i2c_1 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <378000>;
> +};
> +
> +/*
> + * Disabled pullups since external part has its own pullups and
> + * double-pulling gets us out of spec in some cases.
> + */
> +&i2c2_bus {
> +       samsung,pin-pud = <0>;
> +};
> +
> +&i2c_2 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <66000>;
> +
> +       hdmiddc@50 {
> +               compatible = "samsung,exynos4210-hdmiddc";
> +               reg = <0x50>;
> +       };
> +};
> +
> +&i2c_3 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <66000>;
> +};
> +
> +&i2c_4 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <66000>;
> +
> +       cros_ec: embedded-controller {
> +               compatible = "google,cros-ec-i2c";
> +               reg = <0x1e>;
> +               interrupts = <6 0>;
> +               interrupt-parent = <&gpx1>;
> +               wakeup-source;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&ec_irq>;
> +       };
> +};
> +
> +&i2c_5 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <66000>;
> +};
> +
> +&i2c_7 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <66000>;
> +};
> +
> +&i2c_8 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <378000>;
> +
> +       hdmiphy: hdmiphy@38 {
> +               compatible = "samsung,exynos4212-hdmiphy";
> +               reg = <0x38>;
> +       };
> +};
> +
> +&i2s0 {
> +       status = "okay";
> +};
> +
> +&mmc_0 {
> +       status = "okay";
> +       num-slots = <1>;
> +       supports-highspeed;
> +       broken-cd;
> +       card-detect-delay = <200>;
> +       samsung,dw-mshc-ciu-div = <3>;
> +       samsung,dw-mshc-sdr-timing = <2 3>;
> +       samsung,dw-mshc-ddr-timing = <1 2>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_cd &sd0_bus4 &sd0_bus8>;
> +
> +       slot@0 {
> +               reg = <0>;
> +               bus-width = <8>;
> +       };
> +};
> +
> +&mmc_1 {
> +       status = "okay";
> +       num-slots = <1>;
> +       supports-highspeed;
> +       broken-cd;
> +       card-detect-delay = <200>;
> +       samsung,dw-mshc-ciu-div = <3>;
> +       samsung,dw-mshc-sdr-timing = <2 3>;
> +       samsung,dw-mshc-ddr-timing = <1 2>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus4>;
> +
> +       slot@0 {
> +               reg = <0>;
> +               bus-width = <4>;
> +       };
> +};
> +
> +&pinctrl_0 {
> +       s5m8767_dvs: s5m8767-dvs {
> +               samsung,pins = "gpd1-0", "gpd1-1", "gpd1-2";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <1>;
> +               samsung,pin-drv = <0>;
> +       };
> +
> +       power_key_irq: power-key-irq {
> +               samsung,pins = "gpx1-3";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <0>;
> +               samsung,pin-drv = <0>;
> +       };
> +
> +       ec_irq: ec-irq {
> +               samsung,pins = "gpx1-6";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <0>;
> +               samsung,pin-drv = <0>;
> +       };
> +
> +       s5m8767_ds: s5m8767-ds {
> +               samsung,pins = "gpx2-3", "gpx2-4", "gpx2-5";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <1>;
> +               samsung,pin-drv = <0>;
> +       };
> +
> +       s5m8767_irq: s5m8767-irq {
> +               samsung,pins = "gpx3-2";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <0>;
> +               samsung,pin-drv = <0>;
> +       };
> +
> +       lid_irq: lid-irq {
> +               samsung,pins = "gpx3-5";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <0>;
> +               samsung,pin-drv = <0>;
> +       };
> +
> +       hdmi_hpd_irq: hdmi-hpd-irq {
> +               samsung,pins = "gpx3-7";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <1>;
> +               samsung,pin-drv = <0>;
> +       };
> +};
> +
> +&pinctrl_1 {
> +       hsic_reset: hsic-reset {
> +               samsung,pins = "gpe1-0";
> +               samsung,pin-function = <1>;
> +               samsung,pin-pud = <0>;
> +               samsung,pin-drv = <0>;
> +       };
> +};
> +
> +&sd1_clk {
> +       samsung,pin-drv = <0>;
> +};
> +
> +&sd1_cmd {
> +       samsung,pin-pud = <3>;
> +       samsung,pin-drv = <0>;
> +};
> +
> +&sd1_cd {
> +       samsung,pin-drv = <0>;
> +};
> +
> +&sd1_bus4 {
> +       samsung,pin-drv = <0>;
> +};
> +
> +&spi_1 {
> +       status = "okay";
> +       samsung,spi-src-clk = <0>;
> +       num-cs = <1>;
> +};
> +
> +&usbdrd_phy {
> +       vbus-supply = <&usb3_vbus_reg>;
> +};
> +
> +#include "cros-ec-keyboard.dtsi"
> --
> 1.9.3
>
