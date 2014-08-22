Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaHVRXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:23:07 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51231 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbaHVRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <1408627674-16130-1-git-send-email-zyw@rock-chips.com>
References: <1408627674-16130-1-git-send-email-zyw@rock-chips.com>
Date: Fri, 22 Aug 2014 10:23:03 -0700
X-Google-Sender-Auth: 93onLlxUGq6THmi5UNUDIcZuCX4
Message-ID: <CAD=FV=VKafGeurYc3OJk1tbdyCAKu6w2qDetgDQ0MRKEFquiAQ@mail.gmail.com>
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

On Thu, Aug 21, 2014 at 6:27 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> rk808.txt: Add device tree bindings for rockchip's rk808 pmic.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v3:
> - fix compile err

Please make sure to address comments that were made against your v2
version, too.

>
> Changes in v2:
> Adviced by javier.martinez
> - separated from rtc-rk808.c
>
>  Documentation/devicetree/bindings/mfd/rk808.txt |  128 +++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
>
> diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
> new file mode 100644
> index 0000000..876291d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/rk808.txt
> @@ -0,0 +1,128 @@
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

I think you need a "#clock-cells = <1>;" in here.  You should also
create a "include/dt-bindings/clock/rockchip,rk808.h" file that lists
numbers for your two clocks.


> +Optional properties:
> +- rockchip,system-power-controller: Telling whether or not this pmic is controlling
> +  the system power.

You should add "clock-output-names" as haoyu,hym8563.txt has.

> +
> +Example:
> +rk808: pmic@1b {
> +       compatible = "rockchip,rk808";
> +       interrupt-parent = <&gpio0>;
> +       interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pmic_int>;
> +       reg = <0x1b>;
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
