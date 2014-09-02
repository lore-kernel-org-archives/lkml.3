Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaIBDmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:42:32 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:42403 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaIBDm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:42:28 -0400
MIME-Version: 1.0
In-Reply-To: <1409562468-16586-2-git-send-email-zyw@rock-chips.com>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
	<1409562468-16586-2-git-send-email-zyw@rock-chips.com>
Date: Mon, 1 Sep 2014 20:42:26 -0700
X-Google-Sender-Auth: U3MUILlNlmEhQhPl0oESKoQC0G8
Message-ID: <CAD=FV=W75OA69xooHhuJT5tEGwOx53GFQEgyxFSr0ZzbfUUwWA@mail.gmail.com>
Subject: Re: [PATCH v7 1/5] dt-bindings: Add RK808 device tree bindings document
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Mon, Sep 1, 2014 at 2:07 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Add device tree bindings documentation and a header file
> for rockchip's RK808 pmic.
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
>
> ---
>
> Changes in v7:
> Advices by Mark Rutland
> - modify description about clock-cells
> - update the example
>
> Changes in v6:
> Advices by Mark Rutland
> - add description about clock-cells
> Advices by Doug
> - modify description about regulator
> - remove pinctrl description
>
> Changes in v5:
> Advices by Mark Brown
> - add description about regulator valid name.
> - add a header file "rockchip,rk808".
>
> Changes in v4:
> Advices by Doug
> - add a "#clock-cells" propertiy
> - update the example
>
> Changes in v3: None
> Changes in v2: None
>
>  Documentation/devicetree/bindings/mfd/rk808.txt |  166 +++++++++++++++++++++++
>  include/dt-bindings/clock/rockchip,rk808.h      |   11 ++
>  2 files changed, 177 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
>  create mode 100644 include/dt-bindings/clock/rockchip,rk808.h
>
> diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
> new file mode 100644
> index 0000000..f8932ac
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/rk808.txt
> @@ -0,0 +1,166 @@
> +RK808 Power Management Integrated Circuit
> +
> +Required properties:
> +- compatible: "rockchip,rk808"
> +- reg: I2C slave address
> +- interrupt-parent: The parent interrupt controller.
> +- interrupts: the interrupt outputs of the controller.
> +- #clock-cells: from common clock binding; shall be set to 1 (multiple clock
> +  outputs)

I think Mark Rutland was looking for something like:

- #clock-cells: from common clock binding; shall be set to 1 (multiple clock
  outputs).  See <dt-bindings/clock/rockchip,rk808.h> for clock IDs.


> +Optional properties:
> +- clock-output-names: From common clock binding to override the
> +  default output clock name
> +- rockchip,system-power-controller: Telling whether or not this pmic is controlling
> +  the system power.
> +
> +Regulators: All the regulators of RK808 to be instantiated shall be
> +listed in a child node named 'regulators'. Each regulator is represented
> +by a child node of the 'regulators' node.
> +
> +       regulator-name {
> +               /* standard regulator bindings here */
> +       };
> +
> +Following regulators of the RK808 PMIC block are supported. Note that
> +the 'n' in regulator name, as in DCDC_REGn or LDOn, represents the DCDC or LDO
> +number as described in RK808 datasheet.
> +
> +       - DCDC_REGn
> +               - valid values for n are 1 to 4.
> +       - LDO_REGn
> +               - valid values for n are 1 to 8.
> +       - SWITCH_REGn
> +               - valid values for n are 1 to 2
> +
> +Standard regulator bindings are used inside regulator subnodes. Check
> +  Documentation/devicetree/bindings/regulator/regulator.txt
> +for more details
> +
> +Example:
> +       rk808: pmic@1b {
> +               compatible = "rockchip,rk808";
> +               clock-output-names = "xin32k", "rk808-clkout2";
> +               interrupt-parent = <&gpio0>;
> +               interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&pmic_int>;
> +               reg = <0x1b>;
> +               rockchip,system-power-controller;
> +               wakeup-source;
> +               #clock-cells = <1>;
> +
> +               vcc8-supply = <&vcc_18>;
> +               vcc9-supply = <&vcc_io>;
> +               vcc10-supply = <&vcc_io>;
> +               vcc12-supply = <&vcc_io>;
> +               vddio-supply = <&vccio_pmu>;

Technically the "-supply" section shouldn't be here.  I plan to add
support for input supplies once you've landed your series.  See
<https://chromium-review.googlesource.com/#/c/214596/> for a preview.
Just leave the "-supply" section out for now.

Other than that, this looks great.

Reviewed-by: Doug Anderson <dianders@chromium.org>
