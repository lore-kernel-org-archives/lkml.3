Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3EHPWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:22:36 -0400
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:43386 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756693Ab3EHPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:22:33 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2013 11:22:32 EDT
Date: Wed, 8 May 2013 17:06:29 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linus.walleij@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        linux-doc@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC 4/8] pinctrl:stixxxx: Add pinctrl and pinconf support.
Message-ID: <20130508150629.GA3041@game.jcrosoft.org>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022284-2283-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368022284-2283-1-git-send-email-srinivas.kandagatla@st.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7708755188602809306
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:11 Wed 08 May     , Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch add pinctrl support to ST SoCs.
> 
> About hardware:
> ST Set-Top-Box parts have two blocks called PIO and PIO-mux which handle
> pin configurations.
> 
> Each multi-function pin is controlled, driven and routed through the PIO
> multiplexing block. Each pin supports GPIO functionality (ALT0) and
> multiple alternate functions(ALT1 - ALTx) that directly connect the pin
> to different hardware blocks. When a pin is in GPIO mode, Output Enable
> (OE), Open Drain(OD), and Pull Up (PU) are driven by the related PIO
> block. Otherwise the PIO multiplexing block configures these parameters
> and retiming the signal.
> 
g> About driver:
> This pinctrl driver manages both PIO and PIO-mux block using pinctrl,
> pinconf, pinmux, gpio subsystems. All the pinctrl related config
> information can only come from device trees.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stephen Gallimore <stephen.gallimore@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>
> ---
>  .../bindings/pinctrl/pinctrl-stixxxx.txt           |  160 +++
>  drivers/pinctrl/Kconfig                            |   13 +
>  drivers/pinctrl/Makefile                           |    1 +
>  drivers/pinctrl/pinctrl-stixxxx.c                  | 1151 ++++++++++++++++++++
>  drivers/pinctrl/pinctrl-stixxxx.h                  |  197 ++++
the pinctrl is present in older SoC ST40 not only stixxx

and you must provide a proper name not stixxxx

>  5 files changed, 1522 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-stixxxx.txt
>  create mode 100644 drivers/pinctrl/pinctrl-stixxxx.c
>  create mode 100644 drivers/pinctrl/pinctrl-stixxxx.h
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-stixxxx.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-stixxxx.txt
> new file mode 100644
> index 0000000..b0a93b5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-stixxxx.txt
> @@ -0,0 +1,160 @@
> +*ST pin controller.
> +
> +Each multi-function pin is controlled, driven and routed through the
> +PIO multiplexing block. Each pin supports GPIO functionality (ALT0)
> +and multiple alternate functions(ALT1 - ALTx) that directly connect
> +the pin to different hardware blocks.
> +
> +When a pin is in GPIO mode, Output Enable (OE), Open Drain(OD), and
> +Pull Up (PU) are driven by the related PIO block.
HighZ too

this driver look very similar with AT91 we should consolidate at binding and C
level
> 
> ---
> +
> +ST pinctrl driver controls PIO multiplexing block and also interacts with
> +gpio driver to configure a pin.
> +
> +Required properties: (PIO multiplexing block)
> +- compatible	: should be "st,stixxxx-pinctrl"
> +			each subnode should set "st,stixxxx-gpio"
> +			as compatible for each gpio-controller bank.
first soc where the IP is present
> +- gpio-controller : Indicates this device is a GPIO controller
> +- #gpio-cells	  : Should be one. The first cell is the pin number.
> +- #retime-delay-cells	: Should be number of possible retime delays.
> +- st,retime-in-delay	: Should be array of delays in nsecs.
> +- st,retime-out-delay	: Should be array of delays in nsecs.
> +- retime-style		: Should indicate which type of retime is used.
> +			possible values are "none", "packed" and "dedicated".
always prefix st, when specific property
st,
> +- st,retime-offset	: phandle to retime offsets in retime registers.
> +		These are not necessary for "dedicated" retime-style registers.
> +	- clk1notclk0	: Should define offset for clk1not clk0 in retime register.
> +	- delay-lsb	: Should define offset for delay-lsb in retime register.
> +	- delay-msb	: Should define offset for delay msb in retime register.
> +	- invertclk	: Should define offset for invertclk in retime register.
> +	- retime	: Should define offset for retime in retime register.
> +	- clknotdata	: Should define offset for clknotdata in retime register.
> +	- double_edge	: Should define offset for double edge in retime register.

As much as I like to describe the IP in the DT, I think it's too much this
time move this to C and use the compatible or detect it on the hardware to
handle this 

> +- st,alt-control		: Should be sysconf to control alternate function on pio.
> +- st,oe-control		: Should be sysconf to control output enable on pio.
> +- st,pu-control		: Should be sysconf to control pull up on pio.
> +- st,od-control		: Should be sysconf to control open drain on pio.
> +- st,retime-style		: Should indicate which type of retime is used.
> +			possible values are "none", "packed" and "dedicated".
> +- st,retime-pin-mask	: Should be mask to specify which pins can be retimed.
> +- retime-control[0...N]: These properties point to sysconfs which control retime.
> +			Depending on retime-style the number of retime-controls
> +			vary: 2 for "packed"; 8 for "dedicated".


> +- st,bank-name		: Should be a name string for this bank.
> +
> +Example:
> +	pio_retime_offset: pio-retime-offset {
> +		clk1notclk0	= <0>;
> +		delay-lsb	= <2>;
> +		delay-msb	= <3>;
> +		invertclk	= <4>;
> +		retime		= <5>;
> +		clknotdata	= <6>;
> +		double-edge	= <7>;
> +	};
> +
> +	pin-controller {
> +		#retime-delay-cells = <4>;
> +		compatible = "st,stixxxx-pinctrl", "simple-bus";
> +		st,retime-offset = <&pio_retime_offset>;
> +		st,retime-in-delay = <0 500 1000 1500>;
> +		st,retime-out-delay = <0 1000 2000 3000>;
> +		ranges;
> +		PIO0: pinctrl@fe610000 {
> +			gpio-controller;
> +			#gpio-cells = <1>;
> +			compatible = "st,stixxxx-gpio";
> +			reg = <0xfe610000 0x100>;
> +			st,bank-name  = "PIO0";
> +			st,alt-control = <&SYSCONF_SBC(0) 0 31>;
> +			st,oe-control = <&SYSCONF_SBC(5)  0 7>;
> +			st,pu-control = <&SYSCONF_SBC(7)  0 7>;
> +			st,od-control = <&SYSCONF_SBC(9)  0 7>;
> +			st,retime-style = "packed";
> +			st,retime-pin-mask = <0xff>;
> +			st,retime-control0 = <&SYSCONF_SBC(16) 0 31>;
> +			st,retime-control1 = <&SYSCONF_SBC(17) 0 31>;
> +		};
> +		...
> +		pin-functions nodes follow...
> +	};
> +
> +
> +Contents of function subnode node:
> +----------------------
> +Required properties for pin configuration node:
> +- st,function	: Should be alternate function number associated
> +		with this set of pins.
> +		possible altfunction values:
> +		ALT1
> +		ALT2
> +		ALT3
> +		ALT4
> +		ALT5
> +		ALT6
> +		ALT7
use number in the DoC


> +
> +- st,pins	: Child node with list of pins with configuration.
> +
> +Below is the format of how each pin conf should look like.
> +
> +<bank offset mode rt_type rt_delay rt_clk>
> +
> +Every PIO is represented with 4-7 parameters depending on retime configuration.
> +Each parameter is explained as below.
> +
> +-bank		: Should be bank phandle to which this PIO belongs.
> +-offset		: Offset in the PIO bank.
> +-mode		:pin configuration is selected from one of the below values.
> +		IN
> +		IN_PU
> +		OUT
> +		BIDIR
> +		BIDIR_PU
ditto
> +
> +-rt_type	Retiming Configuration for the pin.
> +		Possible retime configuration are:
> +
> +		-------		-------------
> +		value		args
> +		-------		-------------
> +		NICLK		<delay> <clk>
> +		ICLK_IO		<delay> <clk>
> +		BYPASS		<delay>
> +		DE_IO		<delay> <clk>
> +		SE_ICLK_IO	<delay> <clk>
> +		SE_NICLK_IO	<delay> <clk>
> +
> +- delay	is retime delay in pico seconds.
> +		Possible values are: refer to retime-in/out-delays
> +
> +- rt_clk	:clk to be use for retime.
> +		Possible values are:
> +		CLK_A
> +		CLK_B
> +		CLK_C
> +		CLK_D
> +
> +Example of mmcclk pin which is a bi-direction pull pu with retime config
> +as non inverted clock retimed with CLK_B and delay of 0 pico seconds:
> +
> +pin-controller {
> +	...
> +	mmc0 {
> +		pinctrl_mmc: mmc {
> +			st,function = <ALT4>;
> +			st,pins {
> +				mmcclk = <&PIO13 4 BIDIR_PU NICLK  0  CLK_B>;
> +				...
> +			};
> +		};
> +	...
> +	};
> +};
> +
> +sdhci0:sdhci@fe810000{
> +	...
> +	pinctrl-names = "default";
> +	pinctrl-0	= <&pinctrl_mmc>;
> +};
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index 34f51d2..611a399 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -179,6 +179,19 @@ config PINCTRL_SUNXI
>  	select PINMUX
>  	select GENERIC_PINCONF
>  
> +config PINCTRL_STIXXXX
> +	bool "ST Microelectronics pin controller driver for STixxxx SoCs"
> +	depends on PLAT_STIXXXX
> +	select PINMUX
> +	select PINCONF
> +	select MFD_SYSCON
> +	help
> +	  Say yes here to support pinctrl interface on STixxxx SOCs.
> +	  This driver is used to control both PIO block and PIO-mux
> +	  block to configure a pin.
> +
> +	  If unsure, say N.
> +
>  config PINCTRL_TEGRA
>  	bool
>  	select PINMUX
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> index f82cc5b..99a2c78 100644
> --- a/drivers/pinctrl/Makefile
> +++ b/drivers/pinctrl/Makefile
> @@ -47,6 +47,7 @@ obj-$(CONFIG_PINCTRL_EXYNOS)	+= pinctrl-exynos.o
>  obj-$(CONFIG_PINCTRL_EXYNOS5440)	+= pinctrl-exynos5440.o
>  obj-$(CONFIG_PINCTRL_XWAY)	+= pinctrl-xway.o
>  obj-$(CONFIG_PINCTRL_LANTIQ)	+= pinctrl-lantiq.o
> +obj-$(CONFIG_PINCTRL_STIXXXX) 	+= pinctrl-stixxxx.o
>  
>  obj-$(CONFIG_PLAT_ORION)        += mvebu/
>  obj-$(CONFIG_ARCH_SHMOBILE)	+= sh-pfc/
> diff --git a/drivers/pinctrl/pinctrl-stixxxx.c b/drivers/pinctrl/pinctrl-stixxxx.c
> new file mode 100644
> index 0000000..7d2c59c
> --- /dev/null
> +++ b/drivers/pinctrl/pinctrl-stixxxx.c
> @@ -0,0 +1,1151 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
> + * Authors:
> + *	Srinivas Kandagatla <srinivas.kandagatla@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_address.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinmux.h>
> +#include <linux/pinctrl/pinconf.h>
> +#include <linux/platform_device.h>
> +#include "core.h"
> +#include "pinctrl-stixxxx.h"
> +
> +struct stixxxx_pinconf {
> +	int		pin;
> +	const char	*name;
> +	unsigned long	config;
> +};
> +
> +struct stixxxx_pmx_func {
> +	const char	*name;
> +	const char	**groups;
> +	unsigned	ngroups;
> +};
> +
> +struct stixxxx_pctl_group {
> +	const char		*name;
> +	unsigned int		*pins;
> +	unsigned		npins;
> +	int			altfunc;
> +	struct stixxxx_pinconf	*pin_conf;
> +};
> +
> +#define to_stixxxx_gpio_port(chip) \
> +		container_of(chip, struct stixxxx_gpio_port, gpio_chip)
> +
> +struct stixxxx_gpio_port {
> +	struct gpio_chip	gpio_chip;
> +	struct pinctrl_gpio_range range;
> +	void __iomem		*base;
> +	struct device_node	*of_node;
> +	const char		*bank_name;
> +};
> +
> +static struct stixxxx_gpio_port *gpio_ports[STIXXXX_MAX_GPIO_BANKS];
> +
> +struct stixxxx_pinctrl {
> +	struct device			*dev;
> +	struct pinctrl_dev		*pctl;
> +	int				nbanks;
> +	struct stixxxx_pmx_func		*functions;
> +	int				nfunctions;
> +	struct stixxxx_pctl_group	*groups;
> +	int				ngroups;
> +	struct stixxxx_pio_control	*pio_controls;
> +};
> +
> +/* Low level functions.. */
> +static void stixxxx_pinconf_set_direction(struct stixxxx_pio_control *pc,
> +				int pin_id, unsigned long config)
> +{
> +	struct syscon_field *output_enable;
> +	struct syscon_field *pull_up;
> +	struct syscon_field *open_drain;
> +	unsigned long oe_value, pu_value, od_value;
> +	unsigned long mask;
> +	int pin = stixxxx_gpio_pin(pin_id);
> +
> +	output_enable = pc->oe;
> +	pull_up = pc->pu;
> +	open_drain = pc->od;
> +
> +	mask = BIT(pin);
> +
> +	oe_value = syscon_read(output_enable);
> +	pu_value = syscon_read(pull_up);
> +	od_value = syscon_read(open_drain);
> +
> +	/* Clear old values */
> +	oe_value &= ~mask;
> +	pu_value &= ~mask;
> +	od_value &= ~mask;
> +
> +	if (config & STIXXXX_PINCONF_OE)
> +		oe_value |= mask;
> +	if (config & STIXXXX_PINCONF_PU)
> +		pu_value |= mask;
> +	if (config & STIXXXX_PINCONF_OD)
> +		od_value |= mask;
> +
> +	syscon_write(output_enable, oe_value);
> +	syscon_write(pull_up, pu_value);
> +	syscon_write(open_drain, od_value);
> +}
> +
> +static void stixxxx_pctl_set_function(struct stixxxx_pio_control *pc,
> +				int pin_id, int function)
> +{
> +	struct syscon_field *selector;
> +	int offset;
> +	unsigned long val;
> +	int pin = stixxxx_gpio_pin(pin_id);
> +
> +	selector = pc->alt;
> +	offset = pin * 4;
> +	val = syscon_read(selector);
> +	val &= ~(0xf << offset);
> +	val |= function << offset;
> +	syscon_write(selector, val);
> +}
> +
> +static unsigned long stixxxx_pinconf_delay_to_bit(unsigned int delay,
> +		const struct stixxxx_retime_params *rt_params,
> +		unsigned long config)
> +{
> +	unsigned int *delay_times;
> +	int num_delay_times, i, closest_index = -1;
> +	unsigned int closest_divergence = UINT_MAX;
> +
> +	if (STIXXXX_PINCONF_UNPACK_OE(config)) {
> +		delay_times = rt_params->delay_times_out;
> +		num_delay_times = rt_params->num_delay_times_out;
> +	} else {
> +		delay_times = rt_params->delay_times_in;
> +		num_delay_times = rt_params->num_delay_times_in;
> +	}
> +
> +	for (i = 0; i < num_delay_times; i++) {
> +		unsigned int divergence = abs(delay - delay_times[i]);
> +
> +		if (divergence == 0)
> +			return i;
> +
> +		if (divergence < closest_divergence) {
> +			closest_divergence = divergence;
> +			closest_index = i;
> +		}
> +	}
> +
> +	pr_warn("Attempt to set delay %d, closest available %d\n",
> +	     delay, delay_times[closest_index]);
> +
> +	return closest_index;
> +}
> +
> +static unsigned long stixxxx_pinconf_bit_to_delay(unsigned int index,
> +		const struct stixxxx_retime_params *rt_params,
> +		unsigned long output)
> +{
> +	unsigned int *delay_times;
> +	int num_delay_times;
> +
> +	if (output) {
> +		delay_times = rt_params->delay_times_out;
> +		num_delay_times = rt_params->num_delay_times_out;
> +	} else {
> +		delay_times = rt_params->delay_times_in;
> +		num_delay_times = rt_params->num_delay_times_in;
> +	}
> +
> +	if (index < num_delay_times) {
> +		return delay_times[index];
> +	} else {
> +		pr_warn("Delay not found in/out delay list\n");
> +		return 0;
> +	}
> +}
> +
> +static void stixxxx_pinconf_set_retime_packed(
> +		struct stixxxx_pio_control *pc,
> +		unsigned long config, int pin)
> +{
> +	const struct stixxxx_retime_params *rt_params = pc->rt_params;
> +	const struct stixxxx_retime_offset *offset = rt_params->retime_offset;
> +	struct syscon_field **regs;
> +	unsigned long values[2];
> +	unsigned long mask;
> +	int i, j;
> +	int clk = STIXXXX_PINCONF_UNPACK_RT_CLK(config);
> +	int clknotdata = STIXXXX_PINCONF_UNPACK_RT_CLKNOTDATA(config);
> +	int double_edge = STIXXXX_PINCONF_UNPACK_RT_DOUBLE_EDGE(config);
> +	int invertclk = STIXXXX_PINCONF_UNPACK_RT_INVERTCLK(config);
> +	int retime = STIXXXX_PINCONF_UNPACK_RT(config);
> +	unsigned long delay = stixxxx_pinconf_delay_to_bit(
> +			STIXXXX_PINCONF_UNPACK_RT_DELAY(config),
> +			pc->rt_params, config);
> +
> +	unsigned long rt_cfg =
> +		((clk		& 1) << offset->clk1notclk0_offset) |
> +		((clknotdata	& 1) << offset->clknotdata_offset) |
> +		((delay		& 1) << offset->delay_lsb_offset) |
> +		(((delay >> 1)  & 1) << offset->delay_msb_offset) |
> +		((double_edge	& 1) << offset->double_edge_offset) |
> +		((invertclk	& 1) << offset->invertclk_offset) |
> +		((retime	& 1) << offset->retime_offset);
> +
> +	regs = pc->retiming;
> +	values[0] = syscon_read(regs[0]);
> +	values[1] = syscon_read(regs[1]);
> +
> +	for (i = 0; i < 2; i++) {
> +		mask = BIT(pin);
> +		for (j = 0; j < 4; j++) {
> +			if (rt_cfg & 1)
> +				values[i] |= mask;
> +			else
> +				values[i] &= ~mask;
> +			mask <<= 8;
> +			rt_cfg >>= 1;
> +		}
> +	}
> +
> +	syscon_write(regs[0], values[0]);
> +	syscon_write(regs[1], values[1]);
> +}
> +
> +static void stixxxx_pinconf_set_retime_dedicated(
> +	struct stixxxx_pio_control *pc,
> +	unsigned long config, int pin)
> +{
> +	struct syscon_field *reg;
> +	int input = STIXXXX_PINCONF_UNPACK_OE(config) ? 0 : 1;
> +	int clk = STIXXXX_PINCONF_UNPACK_RT_CLK(config);
> +	int clknotdata = STIXXXX_PINCONF_UNPACK_RT_CLKNOTDATA(config);
> +	int double_edge = STIXXXX_PINCONF_UNPACK_RT_DOUBLE_EDGE(config);
> +	int invertclk = STIXXXX_PINCONF_UNPACK_RT_INVERTCLK(config);
> +	int retime = STIXXXX_PINCONF_UNPACK_RT(config);
> +	unsigned long delay = stixxxx_pinconf_delay_to_bit(
> +			STIXXXX_PINCONF_UNPACK_RT_DELAY(config),
> +			pc->rt_params, config);
> +
> +	unsigned long retime_config =
> +		((clk		& 0x3) << 0) |
> +		((clknotdata	& 0x1) << 2) |
> +		((delay		& 0xf) << 3) |
> +		((input		& 0x1) << 7) |
> +		((double_edge	& 0x1) << 8) |
> +		((invertclk	& 0x1) << 9) |
> +		((retime	& 0x1) << 10);
> +
> +	reg = pc->retiming[pin];
> +	syscon_write(reg, retime_config);
> +}
> +
> +static void stixxxx_pinconf_get_direction(struct stixxxx_pio_control *pc,
> +	int pin_id, unsigned long *config)
> +{
> +	unsigned long oe_value, pu_value, od_value;
> +	int pin = stixxxx_gpio_pin(pin_id);
> +
> +	oe_value = (syscon_read(pc->oe) >> pin) & 1;
> +	pu_value = (syscon_read(pc->pu) >> pin) & 1;
> +	od_value = (syscon_read(pc->od) >> pin) & 1;
> +
> +	STIXXXX_PINCONF_PACK_OE(*config, oe_value);
> +	STIXXXX_PINCONF_PACK_PU(*config, pu_value);
> +	STIXXXX_PINCONF_PACK_OD(*config, od_value);
> +}
> +
> +static int stixxxx_pinconf_get_retime_packed(
> +		struct stixxxx_pio_control *pc,
> +		int pin, unsigned long *config)
> +{
> +	const struct stixxxx_retime_params *rt_params = pc->rt_params;
> +	const struct stixxxx_retime_offset *offset = rt_params->retime_offset;
> +	unsigned long delay_bits, delay, rt_reduced;
> +	unsigned long rt_value[2];
> +	int i, j;
> +	int output = STIXXXX_PINCONF_UNPACK_OE(*config);
> +
> +	rt_value[0] = syscon_read(pc->retiming[0]);
> +	rt_value[1] = syscon_read(pc->retiming[1]);
> +
> +	rt_reduced = 0;
> +	for (i = 0; i < 2; i++) {
> +		for (j = 0; j < 4; j++) {
> +			if (rt_value[i] & (1<<((8*j)+pin)))
> +				rt_reduced |= 1 << ((i*4)+j);
> +		}
> +	}
> +
> +	STIXXXX_PINCONF_PACK_RT(*config,
> +			(rt_reduced >> offset->retime_offset) & 1);
> +	STIXXXX_PINCONF_PACK_RT_CLK(*config,
> +			(rt_reduced >> offset->clk1notclk0_offset) & 1);
> +	STIXXXX_PINCONF_PACK_RT_CLKNOTDATA(*config,
> +			(rt_reduced >> offset->clknotdata_offset) & 1);
> +	STIXXXX_PINCONF_PACK_RT_DOUBLE_EDGE(*config,
> +			(rt_reduced >> offset->double_edge_offset) & 1);
> +	STIXXXX_PINCONF_PACK_RT_INVERTCLK(*config,
> +			(rt_reduced >> offset->invertclk_offset) & 1);
> +
> +	delay_bits =  (((rt_reduced >> offset->delay_msb_offset) & 1)<<1) |
> +			((rt_reduced >> offset->delay_lsb_offset) & 1);
> +	delay =  stixxxx_pinconf_bit_to_delay(delay_bits, rt_params, output);
> +	STIXXXX_PINCONF_PACK_RT_DELAY(*config, delay);
> +	return 0;
> +}
> +
> +static int stixxxx_pinconf_get_retime_dedicated(
> +		struct stixxxx_pio_control *pc,
> +		int pin, unsigned long *config)
> +{
> +	unsigned long value;
> +	unsigned long delay_bits, delay;
> +	const struct stixxxx_retime_params *rt_params = pc->rt_params;
> +	int output = STIXXXX_PINCONF_UNPACK_OE(*config);
> +
> +	value = syscon_read(pc->retiming[pin]);
> +	STIXXXX_PINCONF_PACK_RT_CLK(*config, ((value >> 0) & 0x3));
> +	STIXXXX_PINCONF_PACK_RT_CLKNOTDATA(*config, ((value >> 2) & 0x1));
> +	delay_bits = ((value >> 3) & 0xf);
> +	delay =  stixxxx_pinconf_bit_to_delay(delay_bits, rt_params, output);
> +	STIXXXX_PINCONF_PACK_RT_DELAY(*config, delay);
> +	STIXXXX_PINCONF_PACK_RT_DOUBLE_EDGE(*config, ((value >> 8) & 0x1));
> +	STIXXXX_PINCONF_PACK_RT_INVERTCLK(*config, ((value >> 9) & 0x1));
> +	STIXXXX_PINCONF_PACK_RT(*config, ((value >> 10) & 0x1));
> +
> +	return 0;
> +}
> +
> +/* GPIO related functions */
> +
> +static inline void __stixxxx_gpio_set(struct stixxxx_gpio_port *port,
> +	unsigned offset, int value)
> +{
> +	if (value)
> +		writel(BIT(offset), port->base + REG_PIO_SET_POUT);
> +	else
> +		writel(BIT(offset), port->base + REG_PIO_CLR_POUT);
> +}
> +
> +static void stixxxx_gpio_direction(unsigned int gpio, unsigned int direction)
> +{
> +	int port_num = stixxxx_gpio_port(gpio);
> +	int offset = stixxxx_gpio_pin(gpio);
> +	struct stixxxx_gpio_port *port  = gpio_ports[port_num];
> +	int i = 0;
> +
> +	for (i = 0; i <= 2; i++) {
> +		if (direction & BIT(i))
> +			writel(BIT(offset), port->base + REG_PIO_SET_PC(i));
> +		else
> +			writel(BIT(offset), port->base + REG_PIO_CLR_PC(i));
> +	}
> +}
> +
> +static int stixxxx_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	return pinctrl_request_gpio(chip->base + offset);
> +}
> +
> +static void stixxxx_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +	pinctrl_free_gpio(chip->base + offset);
> +}
> +
> +static int stixxxx_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct stixxxx_gpio_port *port = to_stixxxx_gpio_port(chip);
> +
> +	return (readl(port->base + REG_PIO_PIN) >> offset) & 1;
> +}
> +
> +static void stixxxx_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct stixxxx_gpio_port *port = to_stixxxx_gpio_port(chip);
> +	__stixxxx_gpio_set(port, offset, value);
> +}
> +
> +static int stixxxx_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +	pinctrl_gpio_direction_input(chip->base + offset);
> +	return 0;
> +}
> +
> +static int stixxxx_gpio_direction_output(struct gpio_chip *chip,
> +	unsigned offset, int value)
> +{
> +	struct stixxxx_gpio_port *port = to_stixxxx_gpio_port(chip);
> +
> +	__stixxxx_gpio_set(port, offset, value);
> +	pinctrl_gpio_direction_output(chip->base + offset);
> +
> +	return 0;
> +}
> +
> +static int stixxxx_gpio_xlate(struct gpio_chip *gc,
> +			const struct of_phandle_args *gpiospec, u32 *flags)
> +{
> +	if (WARN_ON(gc->of_gpio_n_cells < 1))
> +		return -EINVAL;
> +
> +	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
> +		return -EINVAL;
> +
> +	if (gpiospec->args[0] > gc->ngpio)
> +		return -EINVAL;
> +
> +	return gpiospec->args[0];
> +}
> +
> +/* Pinctrl Groups */
> +static int stixxxx_pctl_get_groups_count(struct pinctrl_dev *pctldev)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +
> +	return info->ngroups;
> +}
> +
> +static const char *stixxxx_pctl_get_group_name(struct pinctrl_dev *pctldev,
> +				       unsigned selector)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +
> +	return info->groups[selector].name;
> +}
> +
> +static int stixxxx_pctl_get_group_pins(struct pinctrl_dev *pctldev,
> +	unsigned selector, const unsigned **pins, unsigned *npins)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +
> +	if (selector >= info->ngroups)
> +		return -EINVAL;
> +
> +	*pins = info->groups[selector].pins;
> +	*npins = info->groups[selector].npins;
> +
> +	return 0;
> +}
> +
> +static const inline struct stixxxx_pctl_group *stixxxx_pctl_find_group_by_name(
> +	const struct stixxxx_pinctrl *info, const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < info->ngroups; i++) {
> +		if (!strcmp(info->groups[i].name, name))
> +			return &info->groups[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +static int stixxxx_pctl_dt_node_to_map(struct pinctrl_dev *pctldev,
> +	struct device_node *np, struct pinctrl_map **map, unsigned *num_maps)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +	const struct stixxxx_pctl_group *grp;
> +	struct pinctrl_map *new_map;
> +	struct device_node *parent;
> +	int map_num, i;
> +
> +	grp = stixxxx_pctl_find_group_by_name(info, np->name);
> +	if (!grp) {
> +		dev_err(info->dev, "unable to find group for node %s\n",
> +			np->name);
> +		return -EINVAL;
> +	}
> +
> +	map_num = grp->npins + 1;
> +	new_map = devm_kzalloc(pctldev->dev,
> +				sizeof(*new_map) * map_num, GFP_KERNEL);
> +	if (!new_map)
> +		return -ENOMEM;
> +
> +	parent = of_get_parent(np);
> +	if (!parent) {
> +		devm_kfree(pctldev->dev, new_map);
> +		return -EINVAL;
> +	}
> +
> +	*map = new_map;
> +	*num_maps = map_num;
> +	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
> +	new_map[0].data.mux.function = parent->name;
> +	new_map[0].data.mux.group = np->name;
> +	of_node_put(parent);
> +
> +	/* create config map per pin */
> +	new_map++;
> +	for (i = 0; i < grp->npins; i++) {
> +		new_map[i].type = PIN_MAP_TYPE_CONFIGS_PIN;
> +		new_map[i].data.configs.group_or_pin =
> +				pin_get_name(pctldev, grp->pins[i]);
> +		new_map[i].data.configs.configs = &grp->pin_conf[i].config;
> +		new_map[i].data.configs.num_configs = 1;
> +	}
> +	dev_info(pctldev->dev, "maps: function %s group %s num %d\n",
> +		(*map)->data.mux.function, grp->name, map_num);
> +
> +	return 0;
> +}
> +
> +static void stixxxx_pctl_dt_free_map(struct pinctrl_dev *pctldev,
> +				struct pinctrl_map *map, unsigned num_maps)
> +{
> +}
> +
> +static struct pinctrl_ops stixxxx_pctlops = {
> +	.get_groups_count	= stixxxx_pctl_get_groups_count,
> +	.get_group_pins		= stixxxx_pctl_get_group_pins,
> +	.get_group_name		= stixxxx_pctl_get_group_name,
> +	.dt_node_to_map		= stixxxx_pctl_dt_node_to_map,
> +	.dt_free_map		= stixxxx_pctl_dt_free_map,
> +};
> +
> +/* Pinmux */
> +static int stixxxx_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +
> +	return info->nfunctions;
> +}
> +
> +const char *stixxxx_pmx_get_fname(struct pinctrl_dev *pctldev,
> +	unsigned selector)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +
> +	return info->functions[selector].name;
> +}
> +
> +static int stixxxx_pmx_get_groups(struct pinctrl_dev *pctldev,
> +	unsigned selector, const char * const **grps, unsigned * const ngrps)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +	*grps = info->functions[selector].groups;
> +	*ngrps = info->functions[selector].ngroups;
> +
> +	return 0;
> +}
> +
> +static struct stixxxx_pio_control *stixxxx_get_pio_control(
> +			struct stixxxx_pinctrl *info, int pin_id)
> +{
> +	int port = stixxxx_gpio_port(pin_id);
> +	return &info->pio_controls[port];
> +}
> +
> +static int stixxxx_pmx_enable(struct pinctrl_dev *pctldev, unsigned fselector,
> +		unsigned group)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +	struct stixxxx_pinconf *conf = info->groups[group].pin_conf;
> +	struct stixxxx_pio_control *pc;
> +	int i;
> +
> +	for (i = 0; i < info->groups[group].npins; i++) {
> +		pc = stixxxx_get_pio_control(info, conf[i].pin);
> +		stixxxx_pctl_set_function(pc, conf[i].pin,
> +					info->groups[group].altfunc);
> +	}
> +
> +	return 0;
> +}
> +
> +static void stixxxx_pmx_disable(struct pinctrl_dev *pctldev, unsigned selector,
> +		unsigned group)
> +{
> +}
> +
> +static int stixxxx_pmx_set_gpio_direction(struct pinctrl_dev *pctldev,
> +			struct pinctrl_gpio_range *range, unsigned gpio,
> +			bool input)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +	struct stixxxx_pio_control *pc = &info->pio_controls[range->id];
> +	/*
> +	 * When a PIO port is used in its primary function mode (altfunc = 0)
> +	 * Output Enable (OE), Open Drain(OD), and Pull Up (PU)
> +	 * for the primary PIO functions are driven by the related PIO block
> +	 */
> +	stixxxx_pctl_set_function(pc, gpio, 0);
> +	stixxxx_gpio_direction(gpio, input ?
> +		STIXXXX_GPIO_DIRECTION_IN : STIXXXX_GPIO_DIRECTION_OUT);
> +
> +	return 0;
> +}
> +
> +static struct pinmux_ops stixxxx_pmxops = {
> +	.get_functions_count	= stixxxx_pmx_get_funcs_count,
> +	.get_function_name	= stixxxx_pmx_get_fname,
> +	.get_function_groups	= stixxxx_pmx_get_groups,
> +	.enable			= stixxxx_pmx_enable,
> +	.disable		= stixxxx_pmx_disable,
> +	.gpio_set_direction	= stixxxx_pmx_set_gpio_direction,
> +};
> +
> +/* Pinconf  */
> +static void stixxxx_pinconf_get_retime(struct stixxxx_pio_control *pc,
> +	int pin_id, unsigned long *config)
> +{
> +	int pin = stixxxx_gpio_pin(pin_id);
> +	if (pc->rt_style == stixxxx_retime_style_packed)
> +		stixxxx_pinconf_get_retime_packed(pc, pin, config);
> +	else if (pc->rt_style == stixxxx_retime_style_dedicated)
> +		if ((BIT(pin) & pc->rt_pin_mask))
> +			stixxxx_pinconf_get_retime_dedicated(pc, pin, config);
> +}
> +
> +static void stixxxx_pinconf_set_retime(struct stixxxx_pio_control *pc,
> +	int pin_id, unsigned long config)
> +{
> +	int pin = stixxxx_gpio_pin(pin_id);
> +
> +	if (pc->rt_style == stixxxx_retime_style_packed)
> +		stixxxx_pinconf_set_retime_packed(pc, config, pin);
> +	else if (pc->rt_style == stixxxx_retime_style_dedicated)
> +		if ((BIT(pin) & pc->rt_pin_mask))
> +			stixxxx_pinconf_set_retime_dedicated(pc, config, pin);
> +}
> +
> +static int stixxxx_pinconf_set(struct pinctrl_dev *pctldev,
> +			     unsigned pin_id, unsigned long config)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +	struct stixxxx_pio_control *pc = stixxxx_get_pio_control(info, pin_id);
> +
> +	stixxxx_pinconf_set_direction(pc, pin_id, config);
> +	stixxxx_pinconf_set_retime(pc, pin_id, config);
> +	return 0;
> +}
> +
> +static int stixxxx_pinconf_get(struct pinctrl_dev *pctldev,
> +			     unsigned pin_id, unsigned long *config)
> +{
> +	struct stixxxx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> +	struct stixxxx_pio_control *pc = stixxxx_get_pio_control(info, pin_id);
> +
> +	*config = 0;
> +	stixxxx_pinconf_get_direction(pc, pin_id, config);
> +	stixxxx_pinconf_get_retime(pc, pin_id, config);
> +
> +	return 0;
> +}
> +
> +static void stixxxx_pinconf_dbg_show(struct pinctrl_dev *pctldev,
> +				   struct seq_file *s, unsigned pin_id)
> +{
> +	unsigned long config;
> +	stixxxx_pinconf_get(pctldev, pin_id, &config);
> +
> +	seq_printf(s, "[OE:%ld,PU:%ld,OD:%ld]\n"
> +		"\t\t[retime:%ld,invclk:%ld,clknotdat:%ld,"
> +		"de:%ld,rt-clk:%ld,rt-delay:%ld]",
> +		STIXXXX_PINCONF_UNPACK_OE(config),
> +		STIXXXX_PINCONF_UNPACK_PU(config),
> +		STIXXXX_PINCONF_UNPACK_OD(config),
> +		STIXXXX_PINCONF_UNPACK_RT(config),
> +		STIXXXX_PINCONF_UNPACK_RT_INVERTCLK(config),
> +		STIXXXX_PINCONF_UNPACK_RT_CLKNOTDATA(config),
> +		STIXXXX_PINCONF_UNPACK_RT_DOUBLE_EDGE(config),
> +		STIXXXX_PINCONF_UNPACK_RT_CLK(config),
> +		STIXXXX_PINCONF_UNPACK_RT_DELAY(config));
> +}
> +
> +static struct pinconf_ops stixxxx_confops = {
> +	.pin_config_get		= stixxxx_pinconf_get,
> +	.pin_config_set		= stixxxx_pinconf_set,
> +	.pin_config_dbg_show	= stixxxx_pinconf_dbg_show,
> +};
> +
> +/* pinctrl */
> +static struct pinctrl_desc stixxxx_pctl_desc = {
> +	.owner		= THIS_MODULE,
> +	.pctlops	= &stixxxx_pctlops,
> +	.pmxops		= &stixxxx_pmxops,
> +	.confops	= &stixxxx_confops,
> +};
> +
> +static int stixxxx_pinconf_dt_parse_rt_params(struct stixxxx_pinctrl *info,
> +	struct device_node *np,	struct stixxxx_retime_params *params)
> +{
> +	const __be32 *ip;
> +	struct device_node *offset_np;
> +	struct stixxxx_retime_offset *rt_offset;
> +	int delay_count = 0;
> +
> +	ip = of_get_property(np, "#retime-delay-cells", NULL);
> +	if (ip)
> +		delay_count = be32_to_cpup(ip);
> +	else
> +		pr_warn("No #retime-delay-cells specified\n");
> +
> +	params->num_delay_times_out = delay_count;
> +	params->num_delay_times_in = delay_count;
> +	params->delay_times_in = devm_kzalloc(info->dev,
> +				sizeof(u32) * delay_count, GFP_KERNEL);
> +	params->delay_times_out = devm_kzalloc(info->dev,
> +				sizeof(u32) * delay_count, GFP_KERNEL);
> +
> +	if (!params->delay_times_in || !params->delay_times_out)
> +		return -ENOMEM;
> +
> +	of_property_read_u32_array(np, "st,retime-in-delay",
> +				(u32 *)params->delay_times_in, delay_count);
> +	of_property_read_u32_array(np, "st,retime-out-delay",
> +				(u32 *)params->delay_times_out, delay_count);
> +
> +	offset_np = of_parse_phandle(np, "st,retime-offset", 0);
> +
> +	if (offset_np) {
> +		rt_offset = devm_kzalloc(info->dev,
> +				sizeof(*rt_offset), GFP_KERNEL);
> +		if (!rt_offset)
> +			return -ENOMEM;
> +
> +		params->retime_offset = rt_offset;
> +		WARN_ON(of_property_read_u32(offset_np, "retime",
> +					&rt_offset->retime_offset));
> +		WARN_ON(of_property_read_u32(offset_np, "clk1notclk0",
> +					&rt_offset->clk1notclk0_offset));
> +		WARN_ON(of_property_read_u32(offset_np, "clknotdata",
> +					&rt_offset->clknotdata_offset));
> +		WARN_ON(of_property_read_u32(offset_np, "double-edge",
> +					&rt_offset->double_edge_offset));
> +		WARN_ON(of_property_read_u32(offset_np, "invertclk",
> +					&rt_offset->invertclk_offset));
> +		WARN_ON(of_property_read_u32(offset_np, "delay-lsb",
> +					&rt_offset->delay_lsb_offset));
> +		WARN_ON(of_property_read_u32(offset_np, "delay-msb",
> +					&rt_offset->delay_msb_offset));
> +	}
> +
> +	return 0;
> +}
> +
> +static const char *gpio_compat = "st,stixxxx-gpio";
> +
> +static void stixxxx_pctl_dt_child_count(struct stixxxx_pinctrl *info,
> +				     struct device_node *np)
> +{
> +	struct device_node *child;
> +	for_each_child_of_node(np, child) {
> +		if (of_device_is_compatible(child, gpio_compat)) {
> +			info->nbanks++;
> +		} else {
> +			info->nfunctions++;
> +			info->ngroups += of_get_child_count(child);
> +		}
> +	}
> +}
> +
> +static int stixxxx_pctl_dt_get_retime_conf(struct device_node *np,
> +	struct stixxxx_pio_control *pc)
> +{
> +	const char *style;
> +	char name[20];
> +	unsigned int j;
> +	of_property_read_string(np, "st,retime-style", &style);
> +
> +	if (strcmp(style, "packed") == 0) {
> +		pc->rt_style = stixxxx_retime_style_packed;
> +		for (j = 0; j < 2; j++) {
> +			snprintf(name, sizeof(name), "st,retime-control%d", j);
> +			pc->retiming[j] = syscon_claim(np, name);
> +			if (!pc->retiming[j])
> +				return -ENODATA;
> +		}
> +	} else if (strcmp(style, "dedicated") == 0) {
> +		pc->rt_style = stixxxx_retime_style_dedicated;
> +		for (j = 0; j < 8; j++) {
> +			if ((1<<j) & pc->rt_pin_mask) {
> +				snprintf(name, sizeof(name),
> +						"st,retime-control%d", j);
> +				pc->retiming[j] = syscon_claim(np, name);
> +				if (!pc->retiming[j])
> +					return -ENODATA;
> +			}
> +		}
> +	} else if (strcmp(style, "none") == 0) {
> +		pc->rt_style = stixxxx_retime_style_none;
> +	}
> +
> +	return 0;
> +}
> +
> +static int stixxxx_pctl_dt_init(struct stixxxx_pinctrl *info,
> +			struct device_node *np)
> +{
> +	struct stixxxx_pio_control *pc;
> +	struct stixxxx_retime_params *rt_params;
> +	struct device *dev = info->dev;
> +	unsigned int i = 0;
> +	struct device_node *child = NULL;
> +
> +	pc = devm_kzalloc(dev, sizeof(*pc) * info->nbanks, GFP_KERNEL);
> +	rt_params = devm_kzalloc(dev, sizeof(*rt_params), GFP_KERNEL);
> +
> +	if (!pc || !rt_params)
> +		return -ENOMEM;
> +
> +	info->pio_controls = pc;
> +	if (stixxxx_pinconf_dt_parse_rt_params(info, np, rt_params))
> +		return -ENOMEM;
> +
> +	for_each_child_of_node(np, child) {
> +		if (of_device_is_compatible(child, gpio_compat)) {
> +			pc[i].rt_params = rt_params;
> +
> +			pc[i].alt = syscon_claim(child, "st,alt-control");
> +			if (!pc[i].alt)
> +				goto failed;
> +
> +			pc[i].oe = syscon_claim(child, "st,oe-control");
> +			if (!pc[i].oe)
> +				goto failed;
> +
> +			pc[i].pu = syscon_claim(child, "st,pu-control");
> +			if (!pc[i].pu)
> +				goto failed;
> +
> +			pc[i].od = syscon_claim(child, "st,od-control");
> +			if (!pc[i].od)
> +				goto failed;
> +
> +			of_property_read_u32(child, "st,retime-pin-mask",
> +							&pc[i].rt_pin_mask);
> +
> +			stixxxx_pctl_dt_get_retime_conf(child, &pc[i]);
> +			i++;
> +		}
> +	}
> +
> +	return 0;
> +failed:
> +	return -ENODATA;
> +}
> +
> +#define OF_GPIO_ARGS_MIN	(3)
> +/*
> + * Each pin is represented in of the below forms.
> + * <bank offset direction func rt_type rt_delay rt_clk>
> + */
> +static int stixxxx_pctl_dt_parse_groups(struct device_node *np,
> +	struct stixxxx_pctl_group *grp, struct stixxxx_pinctrl *info, int idx)
> +{
> +	/* bank pad direction val altfunction */
> +	const __be32 *list;
> +	struct property *pp;
> +	struct stixxxx_pinconf *conf;
> +	phandle phandle;
> +	struct device_node *pins;
> +	u32 pin;
> +	int i = 0, npins = 0, nr_props;
> +
> +	pins = of_get_child_by_name(np, "st,pins");
> +	if (!pins)
> +		return -ENODATA;
> +
> +	for_each_property_of_node(pins, pp) {
> +		/* Skip those we do not want to proceed */
> +		if (!strcmp(pp->name, "name"))
> +			continue;
> +
> +		if (pp  && (pp->length/sizeof(__be32)) >= OF_GPIO_ARGS_MIN) {
> +			npins++;
> +		} else {
> +			pr_warn("Invalid st,pins in %s node\n", np->name);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	grp->npins = npins;
> +	grp->name = np->name;
> +	grp->pins = devm_kzalloc(info->dev, npins * sizeof(u32), GFP_KERNEL);
> +	grp->pin_conf = devm_kzalloc(info->dev,
> +					npins * sizeof(*conf), GFP_KERNEL);
> +	of_property_read_u32(np, "st,function", &grp->altfunc);
> +
> +	if (!grp->pins || !grp->pin_conf)
> +		return -ENOMEM;
> +
> +	/* <bank offset direction func rt_type rt_delay rt_clk> */
> +	for_each_property_of_node(pins, pp) {
> +		if (!strcmp(pp->name, "name"))
> +			continue;
> +		nr_props = pp->length/sizeof(u32);
> +		list = pp->value;
> +		conf = &grp->pin_conf[i];
> +
> +		/* bank & offset */
> +		phandle = be32_to_cpup(list++);
> +		pin = be32_to_cpup(list++);
> +		conf->pin = of_get_named_gpio(pins, pp->name, 0);
> +		conf->name = pp->name;
> +		grp->pins[i] = conf->pin;
> +
> +		conf->config = 0;
> +		/* direction */
> +		conf->config |= be32_to_cpup(list++);
> +		/* rt_type rt_delay rt_clk */
> +		if (nr_props >= OF_GPIO_ARGS_MIN + 2) {
> +			/* rt_type */
> +			conf->config |= be32_to_cpup(list++);
> +			/* rt_delay */
> +			conf->config |= be32_to_cpup(list++);
> +			/* rt_clk */
> +			if (nr_props > OF_GPIO_ARGS_MIN + 2)
> +				conf->config |= be32_to_cpup(list++);
> +		}
> +		i++;
> +	}
> +	of_node_put(pins);
> +
> +	return 0;
> +}
> +
> +static int stixxxx_pctl_parse_functions(struct device_node *np,
> +			struct stixxxx_pinctrl *info, u32 index, int *grp_index)
> +{
> +	struct device_node *child;
> +	struct stixxxx_pmx_func *func;
> +	struct stixxxx_pctl_group *grp;
> +	int ret, i;
> +
> +	func = &info->functions[index];
> +	func->name = np->name;
> +	func->ngroups = of_get_child_count(np);
> +	if (func->ngroups <= 0) {
> +		dev_err(info->dev, "No groups defined\n");
> +		return -EINVAL;
> +	}
> +	func->groups = devm_kzalloc(info->dev,
> +			func->ngroups * sizeof(char *), GFP_KERNEL);
> +	if (!func->groups)
> +		return -ENOMEM;
> +
> +	i = 0;
> +	for_each_child_of_node(np, child) {
> +		func->groups[i] = child->name;
> +		grp = &info->groups[*grp_index];
> +		*grp_index += 1;
> +		ret = stixxxx_pctl_dt_parse_groups(child, grp, info, i++);
> +		if (ret)
> +			return ret;
> +	}
> +	dev_info(info->dev, "Function[%d\t name:%s,\tgroups:%d]\n",
> +				index, func->name, func->ngroups);
> +
> +	return 0;
> +}
> +
> +static int stixxxx_pctl_probe_dt(struct platform_device *pdev,
> +				 struct stixxxx_pinctrl *info)
> +{
> +	int ret = 0;
> +	int i = 0, j = 0, k = 0;
> +	struct pinctrl_pin_desc *pdesc;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device_node *child;
> +	int grp_index = 0;
> +
> +	stixxxx_pctl_dt_child_count(info, np);
> +	if (info->nbanks < 1) {
> +		dev_err(&pdev->dev, "you need atleast one gpio bank\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = stixxxx_pctl_dt_init(info, np);
> +	if (ret)
> +		return ret;
> +
> +	dev_info(&pdev->dev, "nbanks = %d\n", info->nbanks);
> +	dev_info(&pdev->dev, "nfunctions = %d\n", info->nfunctions);
> +	dev_info(&pdev->dev, "ngroups = %d\n", info->ngroups);
> +	info->functions = devm_kzalloc(&pdev->dev,
> +		info->nfunctions * sizeof(*info->functions), GFP_KERNEL);
> +
> +	info->groups = devm_kzalloc(&pdev->dev,
> +		info->ngroups * sizeof(*info->groups) ,	GFP_KERNEL);
> +
> +	if (!info->functions || !info->groups)
> +		return -ENOMEM;
> +
> +	stixxxx_pctl_desc.npins = info->nbanks * STIXXXX_GPIO_PINS_PER_PORT;
> +	pdesc =	devm_kzalloc(&pdev->dev,
> +			sizeof(*pdesc) * stixxxx_pctl_desc.npins, GFP_KERNEL);
> +	if (!pdesc)
> +		return -ENOMEM;
> +
> +	stixxxx_pctl_desc.pins = pdesc;
> +
> +	for_each_child_of_node(np, child) {
> +		if (of_device_is_compatible(child, gpio_compat)) {
> +			for (j = 0; j < STIXXXX_GPIO_PINS_PER_PORT; j++, k++) {
> +				const char *port_name = NULL;
> +				pdesc->number = k;
> +				of_property_read_string(child, "st,bank-name",
> +							&port_name);
> +				pdesc->name = kasprintf(GFP_KERNEL, "%s[%d]",
> +							port_name ? : "PIO",
> +							port_name ? j : k);
> +				pdesc++;
> +			}
> +		} else {
> +			ret = stixxxx_pctl_parse_functions(child, info,
> +							i++, &grp_index);
> +			if (ret) {
> +				dev_err(&pdev->dev, "No functions found.\n");
> +				return ret;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int stixxxx_pctl_probe(struct platform_device *pdev)
> +{
> +	struct stixxxx_pinctrl *info;
> +	int ret, i;
> +
> +	if (!pdev->dev.of_node) {
> +		dev_err(&pdev->dev, "device node not found.\n");
> +		return -EINVAL;
> +	}
> +
> +	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, info);
> +	ret = stixxxx_pctl_probe_dt(pdev, info);
> +	if (ret)
> +		return ret;
> +
> +	stixxxx_pctl_desc.name = dev_name(&pdev->dev);
> +	info->pctl = pinctrl_register(&stixxxx_pctl_desc, &pdev->dev, info);
> +	if (IS_ERR(info->pctl)) {
> +		dev_err(&pdev->dev, "Failed pinctrl registration\n");
> +		return PTR_ERR(info->pctl);
> +	}
> +
> +	for (i = 0; i < info->nbanks; i++)
> +		pinctrl_add_gpio_range(info->pctl, &gpio_ports[i]->range);
> +
> +	return 0;
> +}
> +
> +static struct gpio_chip stixxxx_gpio_template = {
> +	.request		= stixxxx_gpio_request,
> +	.free			= stixxxx_gpio_free,
> +	.get			= stixxxx_gpio_get,
> +	.set			= stixxxx_gpio_set,
> +	.direction_input	= stixxxx_gpio_direction_input,
> +	.direction_output	= stixxxx_gpio_direction_output,
> +	.ngpio			= STIXXXX_GPIO_PINS_PER_PORT,
> +	.of_gpio_n_cells	= 1,
> +	.of_xlate		= stixxxx_gpio_xlate,
> +};
> +
> +static int stixxxx_gpio_probe(struct platform_device *pdev)
> +{
> +	struct stixxxx_gpio_port *port;
> +	struct pinctrl_gpio_range *range;
> +	struct device_node *np  = pdev->dev.of_node;
> +	int port_num = of_alias_get_id(np, "gpio");
> +	struct resource *res;
> +	int err;
> +
> +	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
> +	if (!port)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	port->base = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!port->base) {
> +		dev_err(&pdev->dev, "Can't get IO memory mapping!\n");
> +		return -ENODEV;
> +	}
> +
> +	of_property_read_string(np, "st,bank-name", &port->bank_name);
> +	port->of_node = np;
> +
> +	port->gpio_chip = stixxxx_gpio_template;
> +	port->gpio_chip.base = port_num * STIXXXX_GPIO_PINS_PER_PORT;
> +	port->gpio_chip.ngpio = STIXXXX_GPIO_PINS_PER_PORT;
> +	port->gpio_chip.of_node = np;
> +	port->gpio_chip.label = dev_name(&pdev->dev);
> +
> +	dev_set_drvdata(&pdev->dev, port);
> +	range = &port->range;
> +	range->name = port->gpio_chip.label;
> +	range->id = port_num;
> +	range->pin_base = range->base = range->id * STIXXXX_GPIO_PINS_PER_PORT;
> +	range->npins = port->gpio_chip.ngpio;
> +	range->gc = &port->gpio_chip;
> +	gpio_ports[port_num] = port;
> +	err  = gpiochip_add(&port->gpio_chip);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to add gpiochip(%d)!\n", port_num);
> +		return err;
> +	}
> +	dev_info(&pdev->dev, "gpioport[%s] Added as bank%d\n",
> +				port->bank_name, port_num);
> +	return 0;
> +}
> +
> +static struct of_device_id stixxxx_gpio_of_match[] = {
> +	{ .compatible = "st,stixxxx-gpio", },
> +	{ /* sentinel */ }
> +};
> +
> +static struct platform_driver stixxxx_gpio_driver = {
> +	.driver = {
> +		.name = "st-gpio",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(stixxxx_gpio_of_match),
> +	},
> +	.probe = stixxxx_gpio_probe,
> +};
> +
> +static struct of_device_id stixxxx_pctl_of_match[] = {
> +	{ .compatible = "st,stixxxx-pinctrl",},
> +	{ /* sentinel */ }
> +};
> +
> +static struct platform_driver stixxxx_pctl_driver = {
> +	.driver = {
> +		.name = "st-pinctrl",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(stixxxx_pctl_of_match),
> +	},
> +	.probe = stixxxx_pctl_probe,
> +};
> +
> +static int __init stixxxx_pctl_init(void)
> +{
> +	int ret = platform_driver_register(&stixxxx_gpio_driver);
> +	if (ret)
> +		return ret;
> +	return platform_driver_register(&stixxxx_pctl_driver);
> +}
> +arch_initcall(stixxxx_pctl_init);
> diff --git a/drivers/pinctrl/pinctrl-stixxxx.h b/drivers/pinctrl/pinctrl-stixxxx.h
> new file mode 100644
> index 0000000..a340964
> --- /dev/null
> +++ b/drivers/pinctrl/pinctrl-stixxxx.h
> @@ -0,0 +1,197 @@
> +
> +/*
> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
> + * Authors:
> + *	Srinivas Kandagatla <srinivas.kandagatla@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef __LINUX_DRIVERS_PINCTRL_STIXXXX_H
> +#define __LINUX_DRIVERS_PINCTRL_STIXXXX_H
> +
> +enum stixxxx_retime_style {
> +	stixxxx_retime_style_none,
> +	stixxxx_retime_style_packed,
> +	stixxxx_retime_style_dedicated,
> +};
> +
> +/* Byte positions in 2 syscon words, starts from 0 */
> +struct stixxxx_retime_offset {
> +	int retime_offset;
> +	int clk1notclk0_offset;
> +	int clknotdata_offset;
> +	int double_edge_offset;
> +	int invertclk_offset;
> +	int delay_lsb_offset;
> +	int delay_msb_offset;
> +};
> +
> +struct stixxxx_retime_params {
> +	const struct stixxxx_retime_offset *retime_offset;
> +	unsigned int *delay_times_in;
> +	int num_delay_times_in;
> +	unsigned int *delay_times_out;
> +	int num_delay_times_out;
> +};
> +
> +struct stixxxx_pio_control {
> +	enum stixxxx_retime_style rt_style;
> +	u32 rt_pin_mask;
> +	const struct stixxxx_retime_params *rt_params;
> +	struct syscon_field *alt;
> +	struct syscon_field *oe, *pu, *od;
> +	struct syscon_field *retiming[8];
> +};
> +
> +/* PIO Block registers */
> +/* PIO output */
> +#define REG_PIO_POUT			0x00
> +/* Set bits of POUT */
> +#define REG_PIO_SET_POUT		0x04
> +/* Clear bits of POUT */
> +#define REG_PIO_CLR_POUT		0x08
> +/* PIO input */
> +#define REG_PIO_PIN			0x10
> +/* PIO configuration */
> +#define REG_PIO_PC(n)			(0x20 + (n) * 0x10)
> +/* Set bits of PC[2:0] */
> +#define REG_PIO_SET_PC(n)		(0x24 + (n) * 0x10)
> +/* Clear bits of PC[2:0] */
> +#define REG_PIO_CLR_PC(n)		(0x28 + (n) * 0x10)
> +/* PIO input comparison */
> +#define REG_PIO_PCOMP			0x50
> +/* Set bits of PCOMP */
> +#define REG_PIO_SET_PCOMP		0x54
> +/* Clear bits of PCOMP */
> +#define REG_PIO_CLR_PCOMP		0x58
> +/* PIO input comparison mask */
> +#define REG_PIO_PMASK			0x60
> +/* Set bits of PMASK */
> +#define REG_PIO_SET_PMASK		0x64
> +/* Clear bits of PMASK */
> +#define REG_PIO_CLR_PMASK		0x68
> +
> +#define STIXXXX_MAX_GPIO_BANKS		32
> +
> +#define STIXXXX_GPIO_DIRECTION_BIDIR	0x1
> +#define STIXXXX_GPIO_DIRECTION_OUT	0x2
> +#define STIXXXX_GPIO_DIRECTION_IN	0x4
> +
> +#define STIXXXX_GPIO_PINS_PER_PORT	8
> +#define stixxxx_gpio_port(gpio) ((gpio) / STIXXXX_GPIO_PINS_PER_PORT)
> +#define stixxxx_gpio_pin(gpio) ((gpio) % STIXXXX_GPIO_PINS_PER_PORT)
> +
> +/* pinconf */
> +/*
> + * Pinconf is represented in an opaque unsigned long variable.
> + * Below is the bit allocation details for each possible configuration.
> + * All the bit fields can be encapsulated into four variables
> + * (direction, retime-type, retime-clk, retime-delay)
> + *
> + *	 +----------------+
> + *[31:28]| reserved-3     |
> + *	 +----------------+-------------
> + *[27]   |	oe	  |		|
> + *	 +----------------+		v
> + *[26]   |	pu	  |	[Direction	]
> + *	 +----------------+		^
> + *[25]   |	od	  |		|
> + *	 +----------------+-------------
> + *[24]   | reserved-2     |
> + *	 +----------------+-------------
> + *[23]   |    retime      |		|
> + *	 +----------------+		|
> + *[22]   | retime-invclk  |		|
> + *	 +----------------+		v
> + *[21]   |retime-clknotdat|	[Retime-type	]
> + *	 +----------------+		^
> + *[20]   | retime-de      |		|
> + *	 +----------------+-------------
> + *[19:18]| retime-clk     |------>[Retime-Clk	]
> + *	 +----------------+
> + *[17:16]|  reserved-1    |
> + *	 +----------------+
> + *[15..0]| retime-delay   |------>[Retime Delay]
> + *	 +----------------+
> + */
> +
> +#define STIXXXX_PINCONF_UNPACK(conf, param)\
> +				((conf >> STIXXXX_PINCONF_ ##param ##_SHIFT) \
> +				& STIXXXX_PINCONF_ ##param ##_MASK)
> +
> +#define STIXXXX_PINCONF_PACK(conf, val, param)	(conf |=\
> +				((val & STIXXXX_PINCONF_ ##param ##_MASK) << \
> +					STIXXXX_PINCONF_ ##param ##_SHIFT))
> +
> +/* Output enable */
> +#define STIXXXX_PINCONF_OE_MASK		0x1
> +#define STIXXXX_PINCONF_OE_SHIFT	27
> +#define STIXXXX_PINCONF_OE		BIT(27)
> +#define STIXXXX_PINCONF_UNPACK_OE(conf)	STIXXXX_PINCONF_UNPACK(conf, OE)
> +#define STIXXXX_PINCONF_PACK_OE(conf, val)  STIXXXX_PINCONF_PACK(conf, val, OE)
> +
> +/* Pull Up */
> +#define STIXXXX_PINCONF_PU_MASK		0x1
> +#define STIXXXX_PINCONF_PU_SHIFT	26
> +#define STIXXXX_PINCONF_PU		BIT(26)
> +#define STIXXXX_PINCONF_UNPACK_PU(conf)	STIXXXX_PINCONF_UNPACK(conf, PU)
> +#define STIXXXX_PINCONF_PACK_PU(conf, val) STIXXXX_PINCONF_PACK(conf, val, PU)
> +
> +/* Open Drain */
> +#define STIXXXX_PINCONF_OD_MASK		0x1
> +#define STIXXXX_PINCONF_OD_SHIFT	25
> +#define STIXXXX_PINCONF_OD		BIT(25)
> +#define STIXXXX_PINCONF_UNPACK_OD(conf)	STIXXXX_PINCONF_UNPACK(conf, OD)
> +#define STIXXXX_PINCONF_PACK_OD(conf, val) STIXXXX_PINCONF_PACK(conf, val, OD)
> +
> +#define STIXXXX_PINCONF_RT_MASK		0x1
> +#define STIXXXX_PINCONF_RT_SHIFT	23
> +#define STIXXXX_PINCONF_RT		BIT(23)
> +#define STIXXXX_PINCONF_UNPACK_RT(conf)	STIXXXX_PINCONF_UNPACK(conf, RT)
> +#define STIXXXX_PINCONF_PACK_RT(conf, val) STIXXXX_PINCONF_PACK(conf, val, RT)
> +
> +#define STIXXXX_PINCONF_RT_INVERTCLK_MASK	0x1
> +#define STIXXXX_PINCONF_RT_INVERTCLK_SHIFT	22
> +#define STIXXXX_PINCONF_RT_INVERTCLK		BIT(22)
> +#define STIXXXX_PINCONF_UNPACK_RT_INVERTCLK(conf) \
> +			STIXXXX_PINCONF_UNPACK(conf, RT_INVERTCLK)
> +#define STIXXXX_PINCONF_PACK_RT_INVERTCLK(conf, val) \
> +			STIXXXX_PINCONF_PACK(conf, val, RT_INVERTCLK)
> +
> +#define STIXXXX_PINCONF_RT_CLKNOTDATA_MASK	0x1
> +#define STIXXXX_PINCONF_RT_CLKNOTDATA_SHIFT	21
> +#define STIXXXX_PINCONF_RT_CLKNOTDATA		BIT(21)
> +#define STIXXXX_PINCONF_UNPACK_RT_CLKNOTDATA(conf)	\
> +				STIXXXX_PINCONF_UNPACK(conf, RT_CLKNOTDATA)
> +#define STIXXXX_PINCONF_PACK_RT_CLKNOTDATA(conf, val) \
> +				STIXXXX_PINCONF_PACK(conf, val, RT_CLKNOTDATA)
> +
> +#define STIXXXX_PINCONF_RT_DOUBLE_EDGE_MASK	0x1
> +#define STIXXXX_PINCONF_RT_DOUBLE_EDGE_SHIFT	20
> +#define STIXXXX_PINCONF_RT_DOUBLE_EDGE		BIT(20)
> +#define STIXXXX_PINCONF_UNPACK_RT_DOUBLE_EDGE(conf) \
> +				STIXXXX_PINCONF_UNPACK(conf, RT_DOUBLE_EDGE)
> +#define STIXXXX_PINCONF_PACK_RT_DOUBLE_EDGE(conf, val) \
> +				STIXXXX_PINCONF_PACK(conf, val, RT_DOUBLE_EDGE)
> +
> +#define STIXXXX_PINCONF_RT_CLK_MASK		0x3
> +#define STIXXXX_PINCONF_RT_CLK_SHIFT		18
> +#define STIXXXX_PINCONF_RT_CLK			BIT(18)
> +#define STIXXXX_PINCONF_UNPACK_RT_CLK(conf)	\
> +			STIXXXX_PINCONF_UNPACK(conf, RT_CLK)
> +#define STIXXXX_PINCONF_PACK_RT_CLK(conf, val) \
> +			STIXXXX_PINCONF_PACK(conf, val, RT_CLK)
> +
> +/* RETIME_DELAY in Pico Secs */
> +#define STIXXXX_PINCONF_RT_DELAY_MASK		0xffff
> +#define STIXXXX_PINCONF_RT_DELAY_SHIFT		0
> +#define STIXXXX_PINCONF_UNPACK_RT_DELAY(conf) \
> +				STIXXXX_PINCONF_UNPACK(conf, RT_DELAY)
> +#define STIXXXX_PINCONF_PACK_RT_DELAY(conf, val) \
> +				STIXXXX_PINCONF_PACK(conf, val, RT_DELAY)
> +
> +#endif /* __LINUX_DRIVERS_PINCTRL_STIXXXX_H */
> -- 
> 1.7.6.5
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
