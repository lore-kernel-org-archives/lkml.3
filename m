Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaG3NGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:06:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbaG3NGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:06:42 -0400
Message-ID: <53D8EDDC.7010407@suse.de>
Date: Wed, 30 Jul 2014 15:06:36 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] ARM: dts: exynos5250: Add Spring device tree
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>	<1405704009-8430-5-git-send-email-afaerber@suse.de> <CAD=FV=Xu9b6433pV=bqi3jZZR03G6nyi2iNgbSXwAcRY4Y=4yA@mail.gmail.com>
In-Reply-To: <CAD=FV=Xu9b6433pV=bqi3jZZR03G6nyi2iNgbSXwAcRY4Y=4yA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Am 25.07.2014 18:02, schrieb Doug Anderson:
> Andreas,
> 
> On Fri, Jul 18, 2014 at 10:20 AM, Andreas Färber <afaerber@suse.de> wrote:
>> +       gpio-keys {
>> +               compatible = "gpio-keys";
>> +
>> +               power {
>> +                       label = "Power";
>> +                       gpios = <&gpx1 3 1>;
>> +                       linux,code = <116>; /* KEY_POWER */
>> +                       gpio-key,wakeup;
>> +               };
> 
> Is the lid switch not working?

No, I don't see any reaction at least. I notice that 3.8 has pinctrls on
gpio-keys directly though...

> Where is your pinctrl?

Maybe that's what you mean here?

> Can you match this in sort order with snow to make diffs easier?

Done.

>> +       };
>> +};
>> +
>> +&i2c_0 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <378000>;
>> +
>> +       s5m8767_pmic@66 {
>> +               compatible = "samsung,s5m8767-pmic";
>> +               reg = <0x66>;
>> +               interrupt-parent = <&gpx3>;
>> +               interrupts = <2 0>;
>> +               pinctrl-names = "default";
>> +               pinctrl-0 = <&s5m8767_irq &s5m8767_dvs &s5m8767_ds>;
>> +               wakeup-source;
>> +
>> +               s5m8767,pmic-buck-dvs-gpios = <&gpd1 0 1>, /* DVS1 */
>> +                                             <&gpd1 1 1>, /* DVS2 */
>> +                                             <&gpd1 2 1>; /* DVS3 */
>> +
>> +               s5m8767,pmic-buck-ds-gpios = <&gpx2 3 1>, /* SET1 */
>> +                                            <&gpx2 4 1>, /* SET2 */
>> +                                            <&gpx2 5 1>; /* SET3 */
>> +
>> +               /*
>> +                * The following arrays of DVS voltages are not used, since we are
>> +                * not using GPIOs to control PMIC bucks, but they must be defined
>> +                * to please the driver.
>> +                */
>> +               s5m8767,pmic-buck2-dvs-voltage = <1350000>, <1300000>,
>> +                                                <1250000>, <1200000>,
>> +                                                <1150000>, <1100000>,
>> +                                                <1000000>, <950000>;
>> +
>> +               s5m8767,pmic-buck3-dvs-voltage = <1100000>, <1100000>,
>> +                                                <1100000>, <1100000>,
>> +                                                <1000000>, <1000000>,
>> +                                                <1000000>, <1000000>;
>> +
>> +               s5m8767,pmic-buck4-dvs-voltage = <1200000>, <1200000>,
>> +                                                <1200000>, <1200000>,
>> +                                                <1200000>, <1200000>,
>> +                                                <1200000>, <1200000>;
>> +
>> +               clocks {
>> +                       compatible = "samsung,s5m8767-clk";
>> +                       #clock-cells = <1>;
>> +                       clock-output-names = "en32khz_ap",
>> +                                            "en32khz_cp",
>> +                                            "en32khz_bt";
>> +               };
>> +
>> +               regulators {
>> +                       s5m_ldo4_reg: LDO4 {
>> +                               regulator-name = "P1.0V_LDO_OUT4";
>> +                               regulator-min-microvolt = <1000000>;
>> +                               regulator-max-microvolt = <1000000>;
>> +                               regulator-always-on;
>> +                               op_mode = <0>;
>> +                       };
>> +
>> +                       s5m_ldo5_reg: LDO5 {
>> +                               regulator-name = "P1.0V_LDO_OUT5";
>> +                               regulator-min-microvolt = <1000000>;
>> +                               regulator-max-microvolt = <1000000>;
>> +                               regulator-always-on;
>> +                               op_mode = <0>;
>> +                       };
>> +
>> +                       s5m_ldo6_reg: LDO6 {
>> +                               regulator-name = "vdd_mydp";
>> +                               regulator-min-microvolt = <1000000>;
>> +                               regulator-max-microvolt = <1000000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo7_reg: LDO7 {
>> +                               regulator-name = "P1.1V_LDO_OUT7";
>> +                               regulator-min-microvolt = <1100000>;
>> +                               regulator-max-microvolt = <1100000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo8_reg: LDO8 {
>> +                               regulator-name = "P1.0V_LDO_OUT8";
>> +                               regulator-min-microvolt = <1000000>;
>> +                               regulator-max-microvolt = <1000000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo10_reg: LDO10 {
>> +                               regulator-name = "P1.8V_LDO_OUT10";
>> +                               regulator-min-microvolt = <1800000>;
>> +                               regulator-max-microvolt = <1800000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo11_reg: LDO11 {
>> +                               regulator-name = "P1.8V_LDO_OUT11";
>> +                               regulator-min-microvolt = <1800000>;
>> +                               regulator-max-microvolt = <1800000>;
>> +                               regulator-always-on;
>> +                               op_mode = <0>;
>> +                       };
>> +
>> +                       s5m_ldo12_reg: LDO12 {
>> +                               regulator-name = "P3.0V_LDO_OUT12";
>> +                               regulator-min-microvolt = <3000000>;
>> +                               regulator-max-microvolt = <3000000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo13_reg: LDO13 {
>> +                               regulator-name = "P1.8V_LDO_OUT13";
>> +                               regulator-min-microvolt = <1800000>;
>> +                               regulator-max-microvolt = <1800000>;
>> +                               regulator-always-on;
>> +                               op_mode = <0>;
>> +                       };
>> +
>> +                       s5m_ldo14_reg: LDO14 {
>> +                               regulator-name = "P1.8V_LDO_OUT14";
>> +                               regulator-min-microvolt = <1800000>;
>> +                               regulator-max-microvolt = <1800000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo15_reg: LDO15 {
>> +                               regulator-name = "P1.0V_LDO_OUT15";
>> +                               regulator-min-microvolt = <1000000>;
>> +                               regulator-max-microvolt = <1000000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo16_reg: LDO16 {
>> +                               regulator-name = "P1.8V_LDO_OUT16";
>> +                               regulator-min-microvolt = <1800000>;
>> +                               regulator-max-microvolt = <1800000>;
>> +                               regulator-always-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       s5m_ldo17_reg: LDO17 {
>> +                               regulator-name = "P2.8V_LDO_OUT17";
>> +                               regulator-min-microvolt = <2800000>;
>> +                               regulator-max-microvolt = <2800000>;
>> +                               regulator-always-on;
>> +                               op_mode = <0>;
>> +                       };
>> +
>> +                       s5m_ldo25_reg: LDO25 {
>> +                               regulator-name = "vdd_bridge";
>> +                               regulator-min-microvolt = <1200000>;
>> +                               regulator-max-microvolt = <1200000>;
>> +                               regulator-always-on;
>> +                               op_mode = <1>;
>> +                       };
>> +
>> +                       BUCK1 {
>> +                               regulator-name = "vdd_mif";
>> +                               regulator-min-microvolt = <950000>;
>> +                               regulator-max-microvolt = <1300000>;
>> +                               regulator-always-on;
>> +                               regulator-boot-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       BUCK2 {
>> +                               regulator-name = "vdd_arm";
>> +                               regulator-min-microvolt = <850000>;
>> +                               regulator-max-microvolt = <1350000>;
>> +                               regulator-always-on;
>> +                               regulator-boot-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       BUCK3 {
>> +                               regulator-name = "vdd_int";
>> +                               regulator-min-microvolt = <900000>;
>> +                               regulator-max-microvolt = <1200000>;
>> +                               regulator-always-on;
>> +                               regulator-boot-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       BUCK4 {
>> +                               regulator-name = "vdd_g3d";
>> +                               regulator-min-microvolt = <850000>;
>> +                               regulator-max-microvolt = <1300000>;
>> +                               regulator-boot-on;
>> +                               op_mode = <3>;
>> +                       };
>> +
>> +                       BUCK5 {
>> +                               regulator-name = "P1.8V_BUCK_OUT5";
>> +                               regulator-min-microvolt = <1800000>;
>> +                               regulator-max-microvolt = <1800000>;
>> +                               regulator-always-on;
>> +                               regulator-boot-on;
>> +                               op_mode = <1>;
>> +                       };
>> +
>> +                       BUCK6 {
>> +                               regulator-name = "P1.2V_BUCK_OUT6";
>> +                               regulator-min-microvolt = <1200000>;
>> +                               regulator-max-microvolt = <1200000>;
>> +                               regulator-always-on;
>> +                               regulator-boot-on;
>> +                               op_mode = <0>;
>> +                       };
>> +
>> +                       BUCK9 {
>> +                               regulator-name = "vdd_ummc";
>> +                               regulator-min-microvolt = <950000>;
>> +                               regulator-max-microvolt = <3000000>;
>> +                               regulator-always-on;
>> +                               regulator-boot-on;
>> +                               op_mode = <3>;
>> +                       };
>> +               };
>> +       };
>> +};
>> +
>> +&i2c_1 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <378000>;
>> +};
>> +
>> +&i2c_2 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <66000>;
>> +
>> +       hdmiddc@50 {
>> +               compatible = "samsung,exynos4210-hdmiddc";
>> +               reg = <0x50>;
>> +       };
>> +};
>> +
>> +&i2c_3 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <66000>;
>> +};
>> +
>> +&i2c_4 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <66000>;
>> +
>> +       cros_ec: embedded-controller {
>> +               compatible = "google,cros-ec-i2c";
>> +               reg = <0x1e>;
>> +               interrupts = <6 0>;
>> +               interrupt-parent = <&gpx1>;
> 
> I think you want a pinctrl for gpx1-6, like Snow's "ec_irq".

Done. On v1 you had asked about a pinctrl for the keyboard, which has
none, but cros_ec itself does in fact.

>> +               wakeup-source;
>> +       };
>> +};
>> +
>> +&i2c_5 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <66000>;
>> +};
>> +
>> +&i2c_7 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <66000>;
>> +};
>> +
>> +&i2c_8 {
>> +       status = "okay";
>> +       samsung,i2c-sda-delay = <100>;
>> +       samsung,i2c-max-bus-freq = <378000>;
>> +
>> +       hdmiphy: hdmiphy@38 {
>> +               compatible = "samsung,exynos4212-hdmiphy";
>> +               reg = <0x38>;
>> +       };
>> +};
>> +
>> +&mmc_0 {
>> +       status = "okay";
>> +       num-slots = <1>;
>> +       supports-highspeed;
>> +       broken-cd;
>> +       card-detect-delay = <200>;
>> +       samsung,dw-mshc-ciu-div = <3>;
>> +       samsung,dw-mshc-sdr-timing = <2 3>;
>> +       samsung,dw-mshc-ddr-timing = <1 2>;
>> +       pinctrl-names = "default";
>> +       pinctrl-0 = <&sd0_clk &sd0_cmd &sd0_cd &sd0_bus4 &sd0_bus8>;
>> +
>> +       slot@0 {
>> +               reg = <0>;
>> +               bus-width = <8>;
>> +       };
>> +};
>> +
>> +&mmc_1 {
>> +       status = "okay";
>> +       num-slots = <1>;
>> +       supports-highspeed;
>> +       broken-cd;
>> +       card-detect-delay = <200>;
>> +       samsung,dw-mshc-ciu-div = <3>;
>> +       samsung,dw-mshc-sdr-timing = <2 3>;
>> +       samsung,dw-mshc-ddr-timing = <1 2>;
>> +       pinctrl-names = "default";
>> +       pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_cd &sd1_bus4>;
>> +
>> +       slot@0 {
>> +               reg = <0>;
>> +               bus-width = <4>;
>> +       };
>> +};
> 
> mmc_1 on Spring matches with mmc_3 on Snow.  That means you need to
> make sure you've got the reduced drive strengths, too.  I don't think
> your device tree has these.  Specifically you need local overrides of
> sd1_clk, sd1_cmd, etc to lower drive strengths.

Done. Wasn't sure about _cd, so I included it.

>> +
>> +&mmc_2 {
>> +       /* MMC2 pins are used as GPIO for eDP bridge control. */
>> +       status = "disabled";
>> +};
> 
> Remove the mmc_2 reference.  It's disabled in exynos5250.dtsi already.

Done. That drops the documentation of why, too, though.

>> +
>> +&pinctrl_0 {
>> +       /*
>> +        * Disabled pullups since external part has its own pullups and
>> +        * double-pulling gets us out of spec in some cases.
>> +        */
>> +       i2c2_bus: i2c2-bus {
>> +               samsung,pin-pud = <0>;
>> +       };
>> +
>> +       s5m8767_dvs: s5m8767-dvs {
>> +               samsung,pins = "gpd1-0", "gpd1-1", "gpd1-2";
>> +               samsung,pin-function = <0>;
>> +               samsung,pin-pud = <1>;
>> +               samsung,pin-drv = <0>;
>> +       };
>> +
>> +       s5m8767_ds: s5m8767-ds {
>> +               samsung,pins = "gpx2-3", "gpx2-4", "gpx2-5";
>> +               samsung,pin-function = <0>;
>> +               samsung,pin-pud = <1>;
>> +               samsung,pin-drv = <0>;
>> +       };
>> +
>> +       s5m8767_irq: s5m8767-irq {
>> +               samsung,pins = "gpx3-2";
>> +               samsung,pin-function = <0>;
>> +               samsung,pin-pud = <0>;
>> +               samsung,pin-drv = <0>;
>> +       };
>> +
>> +       hdmi_hpd_irq: hdmi-hpd-irq {
>> +               samsung,pins = "gpx3-7";
>> +               samsung,pin-function = <0>;
>> +               samsung,pin-pud = <1>;
>> +               samsung,pin-drv = <0>;
>> +       };
> 
> Ideally you could do one more cleanup patch to snow first to make
> diffs easier between the two dts files.  Moving things in the snow
> file from "pinctrl@11400000" to the pinctrl_0 section would help.
> ...and other cleanups you could do to snow to make diffs similar would
> also be really great.

Done.

>> +};
>> +
>> +&pinctrl_1 {
>> +       hsic_reset: hsic-reset {
>> +               samsung,pins = "gpe1-0";
>> +               samsung,pin-function = <1>;
>> +               samsung,pin-pud = <0>;
>> +               samsung,pin-drv = <0>;
>> +       };
>> +};
>> +
>> +&spi_1 {
>> +       status = "okay";
>> +       samsung,spi-src-clk = <0>;
>> +       num-cs = <1>;
>> +};
>> +
>> +&usbdrd_phy {
>> +       vbus-supply = <&usb3_vbus_reg>;
>> +};
>> +
>> +#include "cros-ec-keyboard.dtsi"
>> --
>> 1.9.3

Also found some unresolved review comments from v1 that I incorporated.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
