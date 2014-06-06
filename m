Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaFFP2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:28:52 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34957 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaFFP2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:28:49 -0400
Date: Fri, 6 Jun 2014 16:28:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V5 REPOST] mfd: add support for ams AS3722 PMIC
Message-ID: <20140606152840.GV24240@lee--X1>
References: <1382427526-2390-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382427526-2390-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laxman,

This patch has already been applied, but ...

> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
> controller, 11 LDOs, RTC, automatic battery, temperature and
> over-current monitoring, 8 GPIOs, ADC and a watchdog.
> 
> Add MFD core driver for the AS3722 to support core functionality.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> ---

[...]

> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
> new file mode 100644
> index 0000000..fc2191e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/as3722.txt
> @@ -0,0 +1,194 @@
> +* ams AS3722 Power management IC.
> +
> +Required properties:
> +-------------------
> +- compatible: Must be "ams,as3722".
> +- reg: I2C device address.
> +- interrupt-controller: AS3722 has internal interrupt controller which takes the
> +  interrupt request from internal sub-blocks like RTC, regulators, GPIOs as well
> +  as external input.
> +- #interrupt-cells: Should be set to 2 for IRQ number and flags.
> +  The first cell is the IRQ number. IRQ numbers for different interrupt source
> +  of AS3722 are defined at dt-bindings/mfd/as3722.h
> +  The second cell is the flags, encoded as the trigger masks from binding document
> +	interrupts.txt, using dt-bindings/irq.
> +
> +Optional submodule and their properties:
> +=======================================
> +
> +Pinmux and GPIO:
> +===============
> +Device has 8 GPIO pins which can be configured as GPIO as well as the special IO
> +functions.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +Following are properties which is needed if GPIO and pinmux functionality
> +is required:
> +    Required properties:
> +    -------------------
> +	- gpio-controller: Marks the device node as a GPIO controller.
> +	- #gpio-cells: Number of GPIO cells. Refer to binding document
> +			gpio/gpio.txt
> +
> +    Optional properties:
> +    --------------------
> +	Following properties are require if pin control setting is required
> +	at boot.
> +	- pinctrl-names: A pinctrl state named "default" be defined, using the
> +		bindings in pinctrl/pinctrl-binding.txt.
> +	- pinctrl[0...n]: Properties to contain the phandle that refer to
> +		different nodes of pin control settings. These nodes represents
> +		the pin control setting of state 0 to state n. Each of these
> +		nodes contains different subnodes to represents some desired
> +		configuration for a list of pins. This configuration can
> +		include the mux function to select on those pin(s), and
> +		various pin configuration parameters, such as pull-up,
> +		open drain.
> +
> +		Each subnode have following properties:
> +		Required properties:
> +		    - pins: List of pins. Valid values of pins properties are:
> +				gpio0, gpio1, gpio2, gpio3, gpio4, gpio5,
> +				gpio6, gpio7
> +
> +		Optional properties:
> +			function, bias-disable, bias-pull-up, bias-pull-down,
> +			bias-high-impedance, drive-open-drain.
> +
> +			Valid values for function properties are:
> +				gpio, interrupt-out, gpio-in-interrupt,
> +				vsup-vbat-low-undebounce-out,
> +				vsup-vbat-low-debounce-out,
> +				voltage-in-standby, oc-pg-sd0, oc-pg-sd6,
> +				powergood-out, pwm-in, pwm-out, clk32k-out,
> +				watchdog-in, soft-reset-in
> +
> +Regulators:
> +===========
> +Device has multiple DCDC and LDOs. The node "regulators" is require if regulator
> +functionality is needed.
> +
> +Following are properties of regulator subnode.
> +
> +    Optional properties:
> +    -------------------
> +	The input supply of regulators are the optional properties on the
> +	regulator node. The input supply of these regulators are provided
> +	through following properties:
> +		vsup-sd2-supply: Input supply for SD2.
> +		vsup-sd3-supply: Input supply for SD3.
> +		vsup-sd4-supply: Input supply for SD4.
> +		vsup-sd5-supply: Input supply for SD5.
> +		vin-ldo0-supply: Input supply for LDO0.
> +		vin-ldo1-6-supply: Input supply for LDO1 and LDO6.
> +		vin-ldo2-5-7-supply: Input supply for LDO2, LDO5 and LDO7.
> +		vin-ldo3-4-supply: Input supply for LDO3 and LDO4.
> +		vin-ldo9-10-supply: Input supply for LDO9 and LDO10.
> +		vin-ldo11-supply: Input supply for LDO11.
> +
> +    Optional sub nodes for regulators:
> +    ---------------------------------
> +	The subnodes name is the name of regulator and it must be one of:
> +	sd[0-6], ldo[0-7], ldo[9-11]
> +
> +	Each sub-node should contain the constraints and initialization
> +	information for that regulator. See regulator.txt for a description
> +	of standard properties for these sub-nodes.
> +	Additional optional custom properties  are listed below.
> +		ams,ext-control: External control of the rail. The option of
> +			this properties will tell which external input is
> +			controlling this rail. Valid values are 0, 1, 2 ad 3.
> +			0: There is no external control of this rail.
> +			1: Rail is controlled by ENABLE1 input pin.
> +			2: Rail is controlled by ENABLE2 input pin.
> +			3: Rail is controlled by ENABLE3 input pin.
> +			Missing this property on DT will be assume as no
> +			external control. The external control pin macros
> +			are defined @dt-bindings/mfd/as3722.h
> +
> +		ams,enable-tracking: Enable tracking with SD1, only supported
> +			by LDO3.
> +
> +Example:
> +--------
> +#include <dt-bindings/mfd/as3722.h>
> +...
> +ams3722 {
> +	compatible = "ams,as3722";
> +	reg = <0x48>;
> +
> +	interrupt-parent = <&intc>;
> +	interrupt-controller;
> +	#interrupt-cells = <2>;
> +
> +	gpio-controller;
> +	#gpio-cells = <2>;
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&as3722_default>;
> +
> +	as3722_default: pinmux {
> +			gpio0 {
> +				pins = "gpio0";
> +				function = "gpio";
> +				bias-pull-down;
> +			};
> +
> +			gpio1_2_4_7 {
> +				pins = "gpio1", "gpio2", "gpio4", "gpio7";
> +				function = "gpio";
> +				bias-pull-up;
> +			};
> +
> +			gpio5 {
> +				pins = "gpio5";
> +				function = "clk32k_out";
> +			};
> +	}
> +
> +	regulators {
> +			vsup-sd2-supply = <...>;
> +			...
> +
> +			sd0 {
> +				regulator-name = "vdd_cpu";
> +				regulator-min-microvolt = <700000>;
> +				regulator-max-microvolt = <1400000>;
> +				regulator-always-on;
> +				ams,ext-control = <2>;
> +			};
> +
> +			sd1 {
> +				regulator-name = "vdd_core";
> +				regulator-min-microvolt = <700000>;
> +				regulator-max-microvolt = <1400000>;
> +				regulator-always-on;
> +				ams,ext-control = <1>;
> +			};
> +
> +			sd2 {
> +				regulator-name = "vddio_ddr";
> +				regulator-min-microvolt = <1350000>;
> +				regulator-max-microvolt = <1350000>;
> +				regulator-always-on;
> +			};
> +
> +			sd4 {
> +				regulator-name = "avdd-hdmi-pex";
> +				regulator-min-microvolt = <1050000>;
> +				regulator-max-microvolt = <1050000>;
> +				regulator-always-on;
> +			};
> +
> +			sd5 {
> +				regulator-name = "vdd-1v8";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +			};
> +			....
> +	};
> +};

[...]

> +static int as3722_i2c_of_probe(struct i2c_client *i2c,
> +			struct as3722 *as3722)
> +{
> +	struct device_node *np = i2c->dev.of_node;
> +	struct irq_data *irq_data;
> +
> +	if (!np) {
> +		dev_err(&i2c->dev, "Device Tree not found\n");
> +		return -EINVAL;
> +	}
> +
> +	irq_data = irq_get_irq_data(i2c->irq);
> +	if (!irq_data) {
> +		dev_err(&i2c->dev, "Invalid IRQ: %d\n", i2c->irq);
> +		return -EINVAL;
> +	}
> +
> +	as3722->en_intern_int_pullup = of_property_read_bool(np,
> +					"ams,enable-internal-int-pullup");
> +	as3722->en_intern_i2c_pullup = of_property_read_bool(np,
> +					"ams,enable-internal-i2c-pullup");

These are still not documented.  Can you please do so?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
