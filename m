Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbaGYQCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:02:10 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:65185 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675AbaGYQCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <1405704009-8430-5-git-send-email-afaerber@suse.de>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-5-git-send-email-afaerber@suse.de>
Date: Fri, 25 Jul 2014 09:02:05 -0700
X-Google-Sender-Auth: 83v3MbyKHT4qI_66SG5LH18XiTs
Message-ID: <CAD=FV=Xu9b6433pV=bqi3jZZR03G6nyi2iNgbSXwAcRY4Y=4yA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: dts: exynos5250: Add Spring device tree
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Fri, Jul 18, 2014 at 10:20 AM, Andreas Färber <afaerber@suse.de> wrote:
> Adds initial support for the HP Chromebook 11.
>
> Cc: Vincent Palatin <vpalatin@chromium.org>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Stephan van Schaik <stephan@synkhronix.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v1 -> v2:
>  * Use label-based overriding/extension of nodes. (Doug Anderson)
>  * Dropped tps65090 for now, until we know where to place it.
>  * Dropped non-Spring nodes from -cros-common.dtsi rather than disabling them.
>  * Enabled a missing MMC node for access to internal storage.
>  * Dropped display-timings from dp-controller node. (Ajay Kumar)
>
>  arch/arm/boot/dts/Makefile              |   1 +
>  arch/arm/boot/dts/exynos5250-spring.dts | 485 ++++++++++++++++++++++++++++++++
>  2 files changed, 486 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos5250-spring.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 80a781f..dec4c29 100644
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
> index 0000000..6695973
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5250-spring.dts
> @@ -0,0 +1,485 @@
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
> +       };
> +
> +       usb@12000000 {
> +               status = "okay";
> +       };
> +
> +       usb3_vbus_reg: regulator-usb3 {
> +               compatible = "regulator-fixed";
> +               regulator-name = "P5.0V_USB3CON";
> +               regulator-min-microvolt = <5000000>;
> +               regulator-max-microvolt = <5000000>;
> +               gpio = <&gpe1 0 1>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&hsic_reset>;
> +               enable-active-high;
> +       };
> +
> +       usb@12110000 {
> +               samsung,vbus-gpio = <&gpx1 1 0>;
> +               status = "okay";
> +       };
> +
> +       usb@12120000 {
> +               status = "okay";
> +       };
> +
> +       fimd@14400000 {
> +               status = "okay";
> +               samsung,invert-vclk;
> +       };
> +
> +       hdmi {
> +               hpd-gpio = <&gpx3 7 0>;
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
> +               samsung,hpd-gpio = <&gpc3 0 0>;
> +       };
> +
> +       fixed-rate-clocks {
> +               xxti {
> +                       compatible = "samsung,clock-xxti";
> +                       clock-frequency = <24000000>;
> +               };
> +       };
> +
> +       gpio-keys {
> +               compatible = "gpio-keys";
> +
> +               power {
> +                       label = "Power";
> +                       gpios = <&gpx1 3 1>;
> +                       linux,code = <116>; /* KEY_POWER */
> +                       gpio-key,wakeup;
> +               };

Is the lid switch not working?

Where is your pinctrl?

Can you match this in sort order with snow to make diffs easier?


> +       };
> +};
> +
> +&i2c_0 {
> +       status = "okay";
> +       samsung,i2c-sda-delay = <100>;
> +       samsung,i2c-max-bus-freq = <378000>;
> +
> +       s5m8767_pmic@66 {
> +               compatible = "samsung,s5m8767-pmic";
> +               reg = <0x66>;
> +               interrupt-parent = <&gpx3>;
> +               interrupts = <2 0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&s5m8767_irq &s5m8767_dvs &s5m8767_ds>;
> +               wakeup-source;
> +
> +               s5m8767,pmic-buck-dvs-gpios = <&gpd1 0 1>, /* DVS1 */
> +                                             <&gpd1 1 1>, /* DVS2 */
> +                                             <&gpd1 2 1>; /* DVS3 */
> +
> +               s5m8767,pmic-buck-ds-gpios = <&gpx2 3 1>, /* SET1 */
> +                                            <&gpx2 4 1>, /* SET2 */
> +                                            <&gpx2 5 1>; /* SET3 */
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

I think you want a pinctrl for gpx1-6, like Snow's "ec_irq".


> +               wakeup-source;
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

mmc_1 on Spring matches with mmc_3 on Snow.  That means you need to
make sure you've got the reduced drive strengths, too.  I don't think
your device tree has these.  Specifically you need local overrides of
sd1_clk, sd1_cmd, etc to lower drive strengths.


> +
> +&mmc_2 {
> +       /* MMC2 pins are used as GPIO for eDP bridge control. */
> +       status = "disabled";
> +};

Remove the mmc_2 reference.  It's disabled in exynos5250.dtsi already.


> +
> +&pinctrl_0 {
> +       /*
> +        * Disabled pullups since external part has its own pullups and
> +        * double-pulling gets us out of spec in some cases.
> +        */
> +       i2c2_bus: i2c2-bus {
> +               samsung,pin-pud = <0>;
> +       };
> +
> +       s5m8767_dvs: s5m8767-dvs {
> +               samsung,pins = "gpd1-0", "gpd1-1", "gpd1-2";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <1>;
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
> +       hdmi_hpd_irq: hdmi-hpd-irq {
> +               samsung,pins = "gpx3-7";
> +               samsung,pin-function = <0>;
> +               samsung,pin-pud = <1>;
> +               samsung,pin-drv = <0>;
> +       };

Ideally you could do one more cleanup patch to snow first to make
diffs easier between the two dts files.  Moving things in the snow
file from "pinctrl@11400000" to the pinctrl_0 section would help.
...and other cleanups you could do to snow to make diffs similar would
also be really great.


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
