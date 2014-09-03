Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbaICOUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:20:41 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:39539 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbaICOUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:20:39 -0400
Date: Wed, 3 Sep 2014 15:20:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, a.zummo@towertech.it,
        mturquette@linaro.org, akpm@linux-foundation.org, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v8 1/5] dt-bindings: Add RK808 device tree bindings
 document
Message-ID: <20140903142029.GH28985@lee--X1>
References: <1409752307-29044-1-git-send-email-zyw@rock-chips.com>
 <1409752307-29044-2-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409752307-29044-2-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014, Chris Zhong wrote:

> Add device tree bindings documentation and a header file
> for rockchip's RK808 pmic.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> 
> Tested-by: Heiko <heiko@sntech.de>
> ---
> 
> Changes in v8:
> Advices by Doug
> - add description about "vccn-supply"
> - modify description about clock-cells
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
>  Documentation/devicetree/bindings/mfd/rk808.txt |  177 +++++++++++++++++++++++
>  include/dt-bindings/clock/rockchip,rk808.h      |   11 ++
>  2 files changed, 188 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
>  create mode 100644 include/dt-bindings/clock/rockchip,rk808.h

Applied, thanks.

> diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
> new file mode 100644
> index 0000000..9e6e259
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/rk808.txt
> @@ -0,0 +1,177 @@
> +RK808 Power Management Integrated Circuit
> +
> +Required properties:
> +- compatible: "rockchip,rk808"
> +- reg: I2C slave address
> +- interrupt-parent: The parent interrupt controller.
> +- interrupts: the interrupt outputs of the controller.
> +- #clock-cells: from common clock binding; shall be set to 1 (multiple clock
> +  outputs). See <dt-bindings/clock/rockchip,rk808.h> for clock IDs.
> +
> +Optional properties:
> +- clock-output-names: From common clock binding to override the
> +  default output clock name
> +- rockchip,system-power-controller: Telling whether or not this pmic is controlling
> +  the system power.
> +- vcc1-supply:  The input supply for DCDC_REG1
> +- vcc2-supply:  The input supply for DCDC_REG2
> +- vcc3-supply:  The input supply for DCDC_REG3
> +- vcc4-supply:  The input supply for DCDC_REG4
> +- vcc6-supply:  The input supply for LDO_REG1 and LDO_REG2
> +- vcc7-supply:  The input supply for LDO_REG3 and LDO_REG7
> +- vcc8-supply:  The input supply for SWITCH_REG1
> +- vcc9-supply:  The input supply for LDO_REG4 and LDO_REG5
> +- vcc10-supply: The input supply for LDO_REG6
> +- vcc11-supply: The input supply for LDO_REG8
> +- vcc12-supply: The input supply for SWITCH_REG2
> +
> +Regulators: All the regulators of RK808 to be instantiated shall be
> +listed in a child node named 'regulators'. Each regulator is represented
> +by a child node of the 'regulators' node.
> +
> +	regulator-name {
> +		/* standard regulator bindings here */
> +	};
> +
> +Following regulators of the RK808 PMIC block are supported. Note that
> +the 'n' in regulator name, as in DCDC_REGn or LDOn, represents the DCDC or LDO
> +number as described in RK808 datasheet.
> +
> +	- DCDC_REGn
> +		- valid values for n are 1 to 4.
> +	- LDO_REGn
> +		- valid values for n are 1 to 8.
> +	- SWITCH_REGn
> +		- valid values for n are 1 to 2
> +
> +Standard regulator bindings are used inside regulator subnodes. Check
> +  Documentation/devicetree/bindings/regulator/regulator.txt
> +for more details
> +
> +Example:
> +	rk808: pmic@1b {
> +		compatible = "rockchip,rk808";
> +		clock-output-names = "xin32k", "rk808-clkout2";
> +		interrupt-parent = <&gpio0>;
> +		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pmic_int>;
> +		reg = <0x1b>;
> +		rockchip,system-power-controller;
> +		wakeup-source;
> +		#clock-cells = <1>;
> +
> +		vcc8-supply = <&vcc_18>;
> +		vcc9-supply = <&vcc_io>;
> +		vcc10-supply = <&vcc_io>;
> +		vcc12-supply = <&vcc_io>;
> +		vddio-supply = <&vccio_pmu>;
> +
> +		regulators {
> +			vdd_cpu: DCDC_REG1 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <750000>;
> +				regulator-max-microvolt = <1300000>;
> +				regulator-name = "vdd_arm";
> +			};
> +
> +			vdd_gpu: DCDC_REG2 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <850000>;
> +				regulator-max-microvolt = <1250000>;
> +				regulator-name = "vdd_gpu";
> +			};
> +
> +			vcc_ddr: DCDC_REG3 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-name = "vcc_ddr";
> +			};
> +
> +			vcc_io: DCDC_REG4 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <3300000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-name = "vcc_io";
> +			};
> +
> +			vccio_pmu: LDO_REG1 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <3300000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-name = "vccio_pmu";
> +			};
> +
> +			vcc_tp: LDO_REG2 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <3300000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-name = "vcc_tp";
> +			};
> +
> +			vdd_10: LDO_REG3 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1000000>;
> +				regulator-name = "vdd_10";
> +			};
> +
> +			vcc18_lcd: LDO_REG4 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-name = "vcc18_lcd";
> +			};
> +
> +			vccio_sd: LDO_REG5 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-name = "vccio_sd";
> +			};
> +
> +			vdd10_lcd: LDO_REG6 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1000000>;
> +				regulator-name = "vdd10_lcd";
> +			};
> +
> +			vcc_18: LDO_REG7 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-name = "vcc_18";
> +			};
> +
> +			vcca_codec: LDO_REG8 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-min-microvolt = <3300000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-name = "vcca_codec";
> +			};
> +
> +			vcc_wl: SWITCH_REG1 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-name = "vcc_wl";
> +			};
> +
> +			vcc_lcd: SWITCH_REG2 {
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-name = "vcc_lcd";
> +			};
> +		};
> +	};
> diff --git a/include/dt-bindings/clock/rockchip,rk808.h b/include/dt-bindings/clock/rockchip,rk808.h
> new file mode 100644
> index 0000000..1a87343
> --- /dev/null
> +++ b/include/dt-bindings/clock/rockchip,rk808.h
> @@ -0,0 +1,11 @@
> +/*
> + * This header provides constants clk index RK808 pmic clkout
> + */
> +#ifndef _CLK_ROCKCHIP_RK808
> +#define _CLK_ROCKCHIP_RK808
> +
> +/* CLOCKOUT index */
> +#define RK808_CLKOUT0		0
> +#define RK808_CLKOUT1		1
> +
> +#endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
