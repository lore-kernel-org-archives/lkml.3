Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634Ab3DKNiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:38:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36894 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3DKNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:38:23 -0400
X-AuditID: cbfec7f4-b7f4c6d0000018de-d8-5166bccd99b9
Message-id: <5166BCCC.5020307@samsung.com>
Date: Thu, 11 Apr 2013 15:38:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: wm8994: Add some OF properties
References: <1365604763-13122-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1365604763-13122-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1365604763-13122-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7pn96QFGuxdp2vxb/YpNosDsx+y
	WvQuuMpmcXnXHDaL5W//s1mc7ma1uLjiC5MDu8e8k4Ee52csZPR4OfE3m0ffllWMHp83yQWw
	RnHZpKTmZJalFunbJXBl3Po3gbFgR2DF4vYJzA2MSxy6GDk5JARMJNp+TWCEsMUkLtxbz9bF
	yMUhJLCUUWJ5+zJWCOcTo8T3GyeYQap4BbQk3u96wtLFyMHBIqAqcWW1DEiYTcBQovdoH9gg
	UYEAicVLzrFDlAtK/Jh8D6xcBGjZ7/uVICOZBe4wSrR/vcEKUiMsYCOx9cYZsPFCAvMZJU7M
	rQKxOQXCJL7MWg42k1lAR2J/6zQ2CFteYvOat8wTGAVmIVkxC0nZLCRlCxiZVzGKppYmFxQn
	peca6hUn5haX5qXrJefnbmKEBPiXHYyLj1kdYhTgYFTi4VVoTg0UYk0sK67MPcQowcGsJMLL
	ODstUIg3JbGyKrUoP76oNCe1+BAjEwenVAOj15F9zBprtqz9tD7nUaLk6WuR/d90Up1enJ4v
	yTA14FOefNi0vg/Ll97J0V33pT+Q749OhnI0pxlPw/rWt1HC1ryC9xWT7js37CwrTVm0qXzS
	U+OqI/P+vWz8u37e+rCvrKVqM1kKhDhPnzU05tw1YY/UuaXvI6bYxbas6v38tP+g3LYnR/9P
	VmIpzkg01GIuKk4EAGQBQ2FOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On 04/10/2013 04:39 PM, Mark Brown wrote:
> Add properties for some of the more important bits of platform data and
> fill out the binding document.
> 
> Not all of the current platform data is suitable for the sort of fixed
> configuration that is done using DT, some of it should have runtime
> mechanisms added instead and some is unlikely to ever be used in practical
> systems.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Untested at present.

I've tested it with wm1811 codec and found a few issues/things that are 
a bit confusing to me.
 
>  Documentation/devicetree/bindings/sound/wm8994.txt |   56 +++++++++++++-
>  drivers/mfd/wm8994-core.c                          |   81 +++++++++++++++++++-
>  2 files changed, 134 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/sound/wm8994.txt b/Documentation/devicetree/bindings/sound/wm8994.txt
> index 7a7eb1e..51edc5f 100644
> --- a/Documentation/devicetree/bindings/sound/wm8994.txt
> +++ b/Documentation/devicetree/bindings/sound/wm8994.txt
> @@ -5,14 +5,68 @@ on the board).
>  
>  Required properties:
>  
> -  - compatible : "wlf,wm1811", "wlf,wm8994", "wlf,wm8958"
> +  - compatible : One of "wlf,wm1811", "wlf,wm8994" or "wlf,wm8958"
>  
>    - reg : the I2C address of the device for I2C, the chip select
>            number for SPI.
>  
> +  - gpio-controller : Indicates this device is a GPIO controller.
> +  - #gpio-cells : Must be 2. The first cell is the pin number and the
> +    second cell is used to specify optional parameters (currently unused).
> +
> +  - AVDD2-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
> +    SPKVDD1-supply, SPKVDD2-supply : power supplies for the device, as covered

These capitalized regulator supply names look like standard ones. Sorry, 
I'm quite new to all this ASoC stuff. I was wondering, what about LDO1, LDO2
regulators that are present in the wm1811 chip for instance ? Are those
regulators supposed to be associated with some of the supply names above ?

AFAICS LDO1, LDO2 need to be enabled before we can actually perform any I2C 
communication.

Besides that, I needed to specify following regulator supplies in order to
to get the wm8994 codec successfully initialized:

  DCVDD-supply
  AVDD1-supply

That might be something specific to the sound machine driver though, I'm not
certain. 

> +    in Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +Optional properties:
> +
> +  - interrupts : The interrupt line the IRQ signal for the device is
> +    connected to.  This is optional, if it is not connected then none
> +    of the interrupt related properties should be specified.
> +  - interrupt-controller : These devices contain interrupt controllers
> +    and may provide interrupt services to other devices if they have an
> +    interrupt line connected.
> +  - interrupt-parent : The parent interrupt controller.
> +  - #interrupt-cells: the number of cells to describe an IRQ, this should be 2.
> +    The first cell is the IRQ number.
> +    The second cell is the flags, encoded as the trigger masks from
> +    Documentation/devicetree/bindings/interrupts.txt
> +
> +  - gpio-cfg : A list of GPIO configuration register values. If absent,
> +    no configuration of these registers is performed. If any value is
> +    over 0xffff then the register will be left as default. If present 11
> +    values must be supplied.
> +
> +  - micbias-cfg : Three MICBIAS register values for WM1811 or

Aren't there just 2 MICBIAS registers ? At least I've found the wm8994 driver
handles only 2 values.

> +    WM8958.  If absent the register defaults will be used.
> +
> +  - ldo1ena : GPIO specifier for control of LDO1ENA input to device.
> +  - ldo2ena : GPIO specifier for control of LDO2ENA input to device.

Hmm, don't we need to specify the constraints for the regulators as well ?
AFAICS for wm8994 you choose not to specify functions of this MFD as child
DT nodes.

I might be missing something, but to make the codec working I have defined 
regulator as child node of this mfd device node, i.e.

	i2c@138A0000 {
		...
		wm1811: wm1811@1a {
			compatible = "wlf,wm1811";
			reg = <0x1a>;
			interrupt-parent = <&gpx3>;
			interrupts = <6 4>;

			gpio-cfg = <0x3 0x0 0x0 0x0
				 0x0 0x0 0x0 0x8000
				 0x0 0x0 0x0>;
			micbias-cfg = <0x2f 0x2b>;

			lineout2-feedback;
			lineout1-se;
			lineout2-se;

			AVDD2-supply = <&vbatt_reg>;
			DBVDD1-supply = <&ldo3_reg>;
			DBVDD2-supply = <&wm1811_ldo1_reg>;
			DBVDD3-supply = <&vbatt_reg>;
			CPVDD-supply = <&vbatt_reg>;
			SPKVDD1-supply = <&vbatt_reg>;
			SPKVDD2-supply = <&vbatt_reg>;
			DCVDD-supply = <&vbatt_reg>;
			AVDD1-supply = <&vbatt_reg>;

			wm1811_ldo1_reg: ldo1 {
				compatible = "wlf,wm8994-ldo";

				regulator-compatible = "LDO1";
				regulator-name = "WM1811_LDO1";
				gpio = <&gpj0 4 0>;
				regulator-always-on;
			};
		};
	};

Then in wm8994_ldo_probe() I made a change as below:

	if (pdata) {
		config.init_data = pdata->ldo[id].init_data;
		config.ena_gpio = pdata->ldo[id].enable;
-	}
+	} else {
+		config.init_data = of_get_regulator_init_data(dev, dev->of_node);
+		config.ena_gpio = of_get_named_gpio(dev->of_node, "gpio", 0);
+		config.of_node = dev->of_node;
+	}


Is there any other way to get the LDO1/LDO2 regulators properly registered
and enabled before any I2C communication is done with the device ?

platform_data (wm8994->dev->platform_data) in wm8994_ldo_probe() is NULL
when booting from DT. I guess something like this could be done, but then 
how to associate the voltage regulators with the codec ?

---8<--------------
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 1a63261..0235148 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -119,6 +119,9 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
        int ret;
 
+       if (pdev->dev.of_node)
+               pdata = &wm8994->pdata;
+
        ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm8994_ldo), GFP_KERNEL);
        if (ldo == NULL) {
                dev_err(&pdev->dev, "Unable to allocate private data\n");
---8<--------------

The "only" issue I had was that there are 2 wm8994-ldo mfd cells, and for
each of them the mfd core iterated over all wm1811 child nodes, trying
to register each regulator twice. So I temporarily removed one entry from
the wm8994_regulator_devs array.

> +  - lineout1-se : If present LINEOUT1 is in single ended mode.
> +  - lineout2-se : If present LINEOUT2 is in single ended mode.
> +
> +  - lineout1-feedback : If present LINEOUT1 has common mode feedback connected.
> +  - lineout2-feedback : If present LINEOUT2 has common mode feedback connected.
> +
> +  - ldoena-always-driven : If present LDOENA is always driven

I suppose the custom properties should be prefixed with "wlf,".

>  Example:
>  
>  codec: wm8994@1a {
>  	compatible = "wlf,wm8994";
>  	reg = <0x1a>;
> +
> +	gpio-controoler;

s/controoler/controller ?

> +	#gpio-cells = <2>;
> +
> +        lineout1-se;
> +
> +	AVDD2-supply = <&regulator>;
> +	CPVDD-supply = <&regulator>;
> +	DBVDD1-supply = <&regulator>;
> +	DBVDD2-supply = <&regulator>;
> +	DBVDD3-supply = <&regulator>;
> +	SPKVDD1-supply = <&regulator>;
> +	SPKVDD2-supply = <&regulator>;
>  };
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index 3f8d591..3f87f25 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -19,6 +19,9 @@
>  #include <linux/err.h>
>  #include <linux/delay.h>
>  #include <linux/mfd/core.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/regmap.h>
>  #include <linux/regulator/consumer.h>
> @@ -396,6 +399,68 @@ static const struct reg_default wm1811_reva_patch[] = {
>  	{ 0x102, 0x0 },
>  };
>  
> +#ifdef CONFIG_OF
> +static int wm8994_set_pdata_from_of(struct wm8994 *wm8994)
> +{
> +	struct device_node *np = wm8994->dev->of_node;
> +	struct wm8994_pdata *pdata = &wm8994->pdata;
> +	int i;
> +
> +	if (!np)
> +		return 0;
> +
> +	if (of_property_read_u32_array(np, "gpio-cfg", pdata->gpio_defaults,
> +				       ARRAY_SIZE(pdata->gpio_defaults)) >= 0) {
> +		for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
> +			if (wm8994->pdata.gpio_defaults[i] == 0) {
> +				pdata->gpio_defaults[i]
> +					= WM8994_CONFIGURE_GPIO;

Hmm, that's not obvious from the binding, that 0 is replaced with 0x10000
by the implementation.

> +			} else if (pdata->gpio_defaults[i] == 0xffffffff) {
> +				pdata->gpio_defaults[i] = 0;
> +			} else if (pdata->gpio_defaults[i] > 0xffff) {

And this is not specified as an error condition at the binding. I expected
in such case the default value of a register would be used.

> +				dev_err(wm8994->dev,
> +					"Invalid gpio-cfg[%d] %x\n",
> +					i, pdata->gpio_defaults[i]);
> +				return -EINVAL;
> +			}
> +		}
> +	}
> +
> +	of_property_read_u32_array(np, "micbias-cfg", pdata->micbias,
> +				   ARRAY_SIZE(pdata->micbias));
> +
> +	pdata->lineout1_diff = true;
> +	pdata->lineout2_diff = true;
> +	if (of_find_property(np, "lineout1-se", NULL))
> +		pdata->lineout1_diff = false;
> +	if (of_find_property(np, "lineout2-se", NULL))
> +		pdata->lineout2_diff = false;

I guess you preferred it that way, rather than

	pdata->lineout1_diff = !of_property_read_bool(np, "lineout1-se");
	pdata->lineout2_diff = !of_property_read_bool(np, "lineout2-se");

?
> +	if (of_find_property(np, "lineout1-feedback", NULL))
> +		pdata->lineout1fb = true;
> +	if (of_find_property(np, "lineout2-feedback", NULL))
> +		pdata->lineout2fb = true;
> +
> +	if (of_find_property(np, "ldoena-always-driven", NULL))
> +		pdata->lineout2fb = true;
> +
> +	pdata->ldo[0].enable = of_get_named_gpio(np, "ldo1ena", 0);
> +	if (pdata->ldo[0].enable < 0)
> +		pdata->ldo[0].enable = 0;
> +
> +	pdata->ldo[1].enable = of_get_named_gpio(np, "ldo2ena", 0);
> +	if (pdata->ldo[1].enable < 0)
> +		pdata->ldo[1].enable = 0;
> +
> +	return 0;
> +}


Thanks,
Sylwester

