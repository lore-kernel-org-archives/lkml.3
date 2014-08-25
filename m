Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaHYETD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 00:19:03 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:64995 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHYETB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 00:19:01 -0400
MIME-Version: 1.0
In-Reply-To: <1408789763-16369-1-git-send-email-zyw@rock-chips.com>
References: <1408789763-16369-1-git-send-email-zyw@rock-chips.com>
Date: Sun, 24 Aug 2014 21:18:59 -0700
X-Google-Sender-Auth: PnZEapvfEj62ZJe3DvzSbYSeC7o
Message-ID: <CAD=FV=VcPHCZv4UoZBHkW+3hUJBG1W2Pi7drH_wQsga9S4_bbg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] MFD: Add rk808 device tree bindings documentation
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Sat, Aug 23, 2014 at 3:29 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> rk808.txt: Add device tree bindings for rockchip's rk808 pmic.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v4:
> Adviced by doug
> - add "clock-output-names" propertiey
> - add a header file "rockchip,rk808.h"
>
> Changes in v3:
> - fix compile err
>
> Changes in v2:
> Adviced by javier.martinez
> - separated from rtc-rk808.c
>
>  Documentation/devicetree/bindings/mfd/rk808.txt |  133 +++++++++++++++++++++++
>  1 file changed, 133 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
>
> diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
> new file mode 100644
> index 0000000..a9368fc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/rk808.txt
> @@ -0,0 +1,133 @@
> +RK808 Power Management Integrated Circuit
> +
> +Required properties:
> +- compatible: "rockchip,rk808"
> +- reg: I2C slave address
> +- interrupt-parent: The parent interrupt controller.
> +- interrupts: the interrupt outputs of the controller.
> +- pinctrl-names: Should contain only one value - "default".
> +- pinctrl-0: Should specify pin control groups used for this controller.
> +- regulators: This is the list of child nodes that specify the regulator
> +  initialization data for defined regulators. Not all regulators for the given
> +  device need to be present. The definition for each of these nodes is defined
> +  using the standard binding for regulators found at
> +  Documentation/devicetree/bindings/regulator/regulator.txt.
> +- #clock-cells: the value should be 1

Mark Brown said:

You need to identify all the valid names for regulators on the device so
people know which string to use for which regulator.

...and you haven't incorporated that feedback yet.  The Example below
is not enough.  You should have a string like:

The following are the names of the regulators that the rk808 pmic block
supports. Note: The 'n' below represents the number as per the datasheet:

        - DCDC_REGn
                  - valid values for n are 1 to 3.
        - LDO_REGn
                  - valid values for n are 1 to 8.
        - SWITCH_REGn
                  - valid values for n are 1 to 2.

> +
> +Optional properties:
> +- clock-output-names : From common clock binding to override the
> +  default output clock name
> +- rockchip,system-power-controller: Telling whether or not this pmic is controlling
> +  the system power.
> +
> +Example:
> +rk808: pmic@1b {
> +       compatible = "rockchip,rk808";
> +       interrupt-parent = <&gpio0>;
> +       interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pmic_int>;
> +       reg = <0x1b>;
> +       #clock-cells = <1>;
> +       clock-output-names = "xin32k0", "xin32k1";
> +       rockchip,system-power-controller;
> +
> +               regulators {
> +                       rk808_dcdc1_reg: DCDC_REG1 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                               regulator-name = "vdd_arm";
> +                       };
> +
> +                       rk808_dcdc2_reg: DCDC_REG2 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <850000>;
> +                               regulator-max-microvolt = <1250000>;
> +                               regulator-name = "vdd_gpu";
> +                       };
> +
> +                       rk808_dcdc3_reg: DCDC_REG3 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-name = "vdd_ddr";
> +                       };
> +
> +                       rk808_dcdc4_reg: DCDC_REG4 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <3300000>;
> +                               regulator-max-microvolt = <3300000>;
> +                               regulator-name = "vccio";
> +                       };
> +
> +                       rk808_ldo1_reg: LDO_REG1 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <3300000>;
> +                               regulator-max-microvolt = <3300000>;
> +                       };
> +
> +                       rk808_ldo2_reg: LDO_REG2 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <3300000>;
> +                               regulator-max-microvolt = <3300000>;
> +                       };
> +
> +                       rk808_ldo3_reg: LDO_REG3 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-name = "LDO_REG3";
> +                       };
> +
> +                       rk808_ldo4_reg: LDO_REG4 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                       };
> +
> +                       rk808_ldo5_reg: LDO_REG5 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <3300000>;
> +                       };
> +
> +                       rk808_ldo6_reg: LDO_REG6 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                       };
> +
> +                       rk808_ldo7_reg: LDO_REG7 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                       };
> +
> +                       rk808_ldo8_reg: LDO_REG8 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <3300000>;
> +                               regulator-max-microvolt = <3300000>;
> +                       };
> +
> +                       rk808_switch1_reg: SWITCH_REG1 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                       };
> +
> +                       rk808_switch2_reg: SWITCH_REG2 {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                       };
> +               };
> +       };
> --
> 1.7.9.5
>
>
