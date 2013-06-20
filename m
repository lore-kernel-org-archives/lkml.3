Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3FTID4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:03:56 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62088 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3FTIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:03:52 -0400
Date: Thu, 20 Jun 2013 10:03:46 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: patrice.chotard.st@gmail.com
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: Re: [PATCH 1/2] pinctrl: abx500: Add device tree support
Message-ID: <20130620080346.GA20594@balto.lan>
References: <1371713002-18974-1-git-send-email-patrice.chotard.st@gmail.com>
 <1371713002-18974-2-git-send-email-patrice.chotard.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371713002-18974-2-git-send-email-patrice.chotard.st@gmail.com>
X-Operating-System: Linux balto 3.10.0-rc6-00001-g8177a9d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrice,

this looks good, just a couple of minor notes, check below...

On Thu, Jun 20, 2013 at 09:23:21AM +0200, patrice.chotard.st@gmail.com wrote:
> From: Patrice Chotard <patrice.chotard@st.com>
> 
> We use the same way to define pin muxing and pin configuration 
> than for nomadik. So pickup code from pinctrl_nomadik.c to be 
> able to implement pin multiplexing and pin configuration using
> the device tree. Pin configuration uses generic parsing code.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> ---
>  .../devicetree/bindings/pinctrl/ste,abx500.txt     |  352 ++++++++++++++++++++
>  drivers/pinctrl/pinctrl-abx500.c                   |  184 ++++++++++
>  2 files changed, 536 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt b/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
> new file mode 100644
> index 0000000..e74a72d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
> @@ -0,0 +1,352 @@
> +ST Ericsson abx500 pinmux controller
> +
> +Required properties:
> +- compatible: "stericsson,ab8500-gpio",  "stericsson,ab8540-gpio",
> +	      "stericsson,ab8505-gpio", "stericsson,ab9540-gpio",
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +ST Ericsson's pin configuration nodes act as a container for an arbitrary number of
> +subnodes. Each of these subnodes represents some desired configuration for a
> +pin, a group, or a list of pins or groups. This configuration can include the
> +mux function to select on those pin(s)/group(s), and various pin configuration
> +parameters, such as input, output, pull up, pull down...
> +
> +The name of each subnode is not important; all subnodes should be enumerated
> +and processed purely based on their content.
> +
> +Required subnode-properties:
> +- ste,pins : An array of strings. Each string contains the name of a pin or
> +    group.
> +
> +Optional subnode-properties:
> +- ste,function: A string containing the name of the function to mux to the
> +  pin or group.
> +
> +- generic pin configuration option to use. Example :
> +
> +	default_cfg {
> +		ste,pins = "GPIO1";
> +		bias-disable;
> +	};
> +
> +- ste,config: Handle of pin configuration node containing the generic
> +  pinconfig options to use, as described in pinctrl-bindings.txt in
> +  this directory. Example :
> +
> +	pcfg_bias_disable: pcfg_bias_disable {
> +		bias-disable;
> +	};
> +
> +	default_cfg {
> +		ste,pins = "GPIO1";
> +		ste.config = <&pcfg_bias_disable>;
> +	};
> +
> +Example board file extract:
> +
> +&pinctrl_abx500 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&sysclkreq2_default_mode>, <&sysclkreq3_default_mode>, <&gpio3_default_mode>, <&sysclkreq6_default_mode>, <&pwmout1_default_mode>, <&pwmout2_default_mode>, <&pwmout3_default_mode>, <&adi1_default_mode>, <&dmic12_default_mode>, <&dmic34_default_mode>, <&dmic56_default_mode>, <&sysclkreq5_default_mode>, <&batremn_default_mode>, <&service_default_mode>, <&pwrctrl0_default_mode>, <&pwrctrl1_default_mode>, <&pwmextvibra1_default_mode>, <&pwmextvibra2_default_mode>, <&gpio51_default_mode>, <&gpio52_default_mode>, <&gpio53_default_mode>, <&gpio54_default_mode>, <&pdmclkdat_default_mode>;
> +
> +	sysclkreq2 {
> +		sysclkreq2_default_mode: sysclkreq2_default {
> +			default_mux {
> +				ste,function = "sysclkreq";
> +				ste,pins = "sysclkreq2_d_1";
> +			};
> +			default_cfg {
> +				ste,pins = "GPIO1";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	sysclkreq3 {
> +		sysclkreq3_default_mode: sysclkreq3_default {
> +			default_mux {
> +				ste,function = "sysclkreq";
> +				ste,pins = "sysclkreq3_d_1";
> +			};
> +			default_cfg {
> +				ste,pins = "GPIO2";
> +				output-low;
> +			};
> +		};
> +	};
> +	gpio3 {
> +		gpio3_default_mode: gpio3_default {
> +			default_mux {
> +				ste,function = "gpio";
> +				ste,pins = "gpio3_a_1";
> +			};
> +			default_cfg {
> +				ste,pins = "GPIO3";
> +				output-low;
> +			};
> +		};
> +	};
> +	sysclkreq6 {
> +		sysclkreq6_default_mode: sysclkreq6_default {
> +			default_mux {
> +				ste,function = "sysclkreq";
> +				ste,pins = "sysclkreq6_d_1";
> +			};
> +			default_cfg {
> +				ste,pins = "GPIO4";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	pwmout1 {
> +		pwmout1_default_mode: pwmout1_default {
> +			default_mux {
> +				ste,function = "pwmout";
> +				ste,pins = "pwmout1_d_1";
> +			};
> +			default_cfg {
> +				ste,pins = "GPIO14";
> +				output-low;
> +			};
> +		};
> +	};
> +	pwmout2 {
> +		pwmout2_default_mode: pwmout2_default {
> +			pwmout2_default_mux {
> +				ste,function = "pwmout";
> +				ste,pins = "pwmout2_d_1";
> +			};
> +			pwmout2_default_cfg {
> +				ste,pins = "GPIO15";
> +				output-low;
> +			};
> +		};
> +	};
> +	pwmout3 {
> +		pwmout3_default_mode: pwmout3_default {
> +			pwmout3_default_mux {
> +				ste,function = "pwmout";
> +				ste,pins = "pwmout3_d_1";
> +			};
> +			pwmout3_default_cfg {
> +				ste,pins = "GPIO16";
> +				output-low;
> +			};
> +		};
> +	};
> +	adi1 {{

Two '{'? (I know that's just documentation but better get it right too)

> +
> +		adi1_default_mode: adi1_default {
> +			adi1_default_mux {
> +				ste,function = "adi1";
> +				ste,pins = "adi1_d_1";
> +			};
> +			adi1_default_cfg1 {
> +				ste,pins = "GPIO17","GPIO19","GPIO20";
> +				bias-disable;
> +			};
> +			adi1_default_cfg2 {
> +				ste,pins = "GPIO18";
> +				output-low;
> +			};
> +		};
> +	};
> +	dmic12 {
> +		dmic12_default_mode: dmic12_default {
> +			dmic12_default_mux {
> +				ste,function = "dmic";
> +				ste,pins = "dmic12_d_1";
> +			};
> +			dmic12_default_cfg1 {
> +				ste,pins = "GPIO27";
> +				output-low;
> +			};
> +			dmic12_default_cfg2 {
> +				ste,pins = "GPIO28";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	dmic34 {
> +		dmic34_default_mode: dmic34_default {
> +			dmic34_default_mux {
> +				ste,function = "dmic";
> +				ste,pins = "dmic34_d_1";
> +			};
> +			dmic34_default_cfg1 {
> +				ste,pins = "GPIO29";
> +				output-low;
> +			};
> +			dmic34_default_cfg2 {
> +				ste,pins = "GPIO30";
> +				bias-disable;{
> +
> +			};
> +		};
> +	};
> +	dmic56 {
> +		dmic56_default_mode: dmic56_default {
> +			dmic56_default_mux {
> +				ste,function = "dmic";
> +				ste,pins = "dmic56_d_1";
> +			};
> +			dmic56_default_cfg1 {
> +				ste,pins = "GPIO31";
> +				output-low;
> +			};
> +			dmic56_default_cfg2 {
> +				ste,pins = "GPIO32";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	sysclkreq5 {
> +		sysclkreq5_default_mode: sysclkreq5_default {
> +			sysclkreq5_default_mux {
> +				ste,function = "sysclkreq";
> +				ste,pins = "sysclkreq5_d_1";
> +			};
> +			sysclkreq5_default_cfg {
> +				ste,pins = "GPIO42";
> +				output-low;
> +			};
> +		};
> +	};
> +	batremn {
> +		batremn_default_mode: batremn_default {
> +			batremn_default_mux {
> +				ste,function = "batremn";
> +				ste,pins = "batremn_d_1";
> +			};
> +			batremn_default_cfg {
> +				ste,pins = "GPIO43";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	service {
> +		service_default_mode: service_default {
> +			service_default_mux {
> +				ste,function = "service";
> +				ste,pins = "service_d_1";
> +			};
> +			service_default_cfg {
> +				ste,pins = "GPIO44";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	pwrctrl0 {
> +		pwrctrl0_default_mux: pwrctrl0_mux {
> +			pwrctrl0_default_mux {
> +				ste,function = "pwrctrl";
> +				ste,pins = "pwrctrl0_d_1";
> +			};
> +		};
> +		pwrctrl0_default_mode: pwrctrl0_default {
> +			pwrctrl0_default_cfg {
> +				ste,pins = "GPIO45";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	pwrctrl1 {
> +		pwrctrl1_default_mux: pwrctrl1_mux {
> +			pwrctrl1_default_mux {
> +				ste,function = "pwrctrl";
> +				ste,pins = "pwrctrl1_d_1";
> +			};
> +		};
> +		pwrctrl1_default_mode: pwrctrl1_default {
> +			pwrctrl1_default_cfg {
> +				ste,pins = "GPIO46";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	pwmextvibra1 {
> +		pwmextvibra1_default_mode: pwmextvibra1_default {
> +			pwmextvibra1_default_mux {
> +				ste,function = "pwmextvibra";
> +				ste,pins = "pwmextvibra1_d_1";
> +			};
> +			pwmextvibra1_default_cfg {
> +				ste,pins = "GPIO47";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	pwmextvibra2 {
> +		pwmextvibra2_default_mode: pwmextvibra2_default {
> +			pwmextvibra2_default_mux {
> +				ste,function = "pwmextvibra";
> +				ste,pins = "pwmextvibra2_d_1";
> +			};
> +			pwmextvibra1_default_cfg {
> +				ste,pins = "GPIO48";
> +				bias-disable;
> +			};
> +		};
> +	};
> +	gpio51 {
> +		gpio51_default_mode: gpio51_default {
> +				gpio51_default_mux {
> +				ste,function = "gpio";
> +				ste,pins = "gpio51_a_1";
> +			};
> +			gpio51_default_cfg {
> +				ste,pins = "GPIO51";
> +				output-low;
> +			};
> +		};
> +	};
> +	gpio52 {
> +		gpio52_default_mode: gpio52_default {
> +			gpio52_default_mux {
> +				ste,function = "gpio";
> +				ste,pins = "gpio52_a_1";
> +			};
> +			gpio52_default_cfg {
> +				ste,pins = "GPIO52";
> +				bias-pull-down;
> +			};
> +		};
> +	};
> +	gpio53 {
> +		gpio53_default_mode: gpio53_default {
> +			gpio53_default_mux {
> +				ste,function = "gpio";
> +				ste,pins = "gpio53_a_1";
> +			};
> +			gpio53_default_cfg {
> +				ste,pins = "GPIO53";
> +				bias-pull-down;
> +		};
> +	};

Wrong indentation here.

> +	};
> +	gpio54 {
> +		gpio54_default_mode: gpio54_default {
> +			gpio54_default_mux {
> +				ste,function = "gpio";
> +				ste,pins = "gpio54_a_1";
> +			};
> +			gpio54_default_cfg {
> +				ste,pins = "GPIO54";
> +				output-low;
> +			};
> +		};
> +	};
> +	pdmclkdat {
> +		pdmclkdat_default_mode: pdmclkdat_default {
> +			pdmclkdat_default_mux {
> +				ste,function = "pdm";
> +				ste,pins = "pdmclkdat_d_1";
> +			};
> +			pdmclkdat_default_cfg {
> +				ste,pins = "GPIO55", "GPIO56";
> +				bias-disable;
> +			};
> +		};
> +	};
> +};
> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
> index 84b40f7..b5b5460 100644
> --- a/drivers/pinctrl/pinctrl-abx500.c
> +++ b/drivers/pinctrl/pinctrl-abx500.c
> @@ -30,8 +30,10 @@
>  #include <linux/pinctrl/pinmux.h>
>  #include <linux/pinctrl/pinconf.h>
>  #include <linux/pinctrl/pinconf-generic.h>
> +#include <linux/pinctrl/machine.h>
>  
>  #include "pinctrl-abx500.h"
> +#include "pinconf.h"
>  
>  /*
>   * The AB9540 and AB8540 GPIO support are extended versions
> @@ -757,11 +759,193 @@ static void abx500_pin_dbg_show(struct pinctrl_dev *pctldev,
>  				 chip->base + offset - 1);
>  }
>  
> +static void abx500_dt_free_map(struct pinctrl_dev *pctldev,
> +		struct pinctrl_map *map, unsigned num_maps)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_maps; i++)
> +		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
> +			kfree(map[i].data.configs.configs);
> +	kfree(map);
> +}
> +
> +static int abx500_dt_reserve_map(struct pinctrl_map **map,
> +		unsigned *reserved_maps,
> +		unsigned *num_maps,
> +		unsigned reserve)
> +{
> +	unsigned old_num = *reserved_maps;
> +	unsigned new_num = *num_maps + reserve;
> +	struct pinctrl_map *new_map;
> +
> +	if (old_num >= new_num)
> +		return 0;
> +
> +	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
> +	if (!new_map)
> +		return -ENOMEM;
> +
> +	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
> +
> +	*map = new_map;
> +	*reserved_maps = new_num;
> +
> +	return 0;
> +}
> +
> +static int abx500_dt_add_map_mux(struct pinctrl_map **map,
> +		unsigned *reserved_maps,
> +		unsigned *num_maps, const char *group,
> +		const char *function)
> +{
> +	if (*num_maps == *reserved_maps)
> +		return -ENOSPC;
> +
> +	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
> +	(*map)[*num_maps].data.mux.group = group;
> +	(*map)[*num_maps].data.mux.function = function;
> +	(*num_maps)++;
> +
> +	return 0;
> +}
> +
> +static int abx500_dt_add_map_configs(struct pinctrl_map **map,
> +		unsigned *reserved_maps,
> +		unsigned *num_maps, const char *group,
> +		unsigned long *configs, unsigned num_configs)
> +{
> +	unsigned long *dup_configs;
> +
> +	if (*num_maps == *reserved_maps)
> +		return -ENOSPC;
> +
> +	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
> +			      GFP_KERNEL);
> +	if (!dup_configs)
> +		return -ENOMEM;
> +
> +	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_PIN;
> +
> +	(*map)[*num_maps].data.configs.group_or_pin = group;
> +	(*map)[*num_maps].data.configs.configs = dup_configs;
> +	(*map)[*num_maps].data.configs.num_configs = num_configs;
> +	(*num_maps)++;
> +
> +	return 0;
> +}
> +
> +static const char *abx500_find_pin_name(struct pinctrl_dev *pctldev,
> +					const char *pin_name)
> +{
> +	int i, pin_number;
> +	struct abx500_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
> +
> +	if (sscanf((char *)pin_name, "GPIO%d", &pin_number) == 1)
> +		for (i = 0; i < npct->soc->npins; i++)
> +			if (npct->soc->pins[i].number == pin_number)
> +				return npct->soc->pins[i].name;
> +	return NULL;
> +}
> +
> +int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,

Missing static?

> +		struct device_node *np,
> +		struct pinctrl_map **map,
> +		unsigned *reserved_maps,
> +		unsigned *num_maps)
> +{
> +	int ret;
> +	const char *function = NULL;
> +	unsigned long *configs;
> +	unsigned int nconfigs = 0;
> +	bool has_config = 0;
> +	unsigned reserve = 0;
> +	struct property *prop;
> +	const char *group, *gpio_name;
> +	struct device_node *np_config;
> +
> +	ret = of_property_read_string(np, "ste,function", &function);
> +	if (ret >= 0)
> +		reserve = 1;
> +
> +	ret = pinconf_generic_parse_dt_config(np, &configs, &nconfigs);
> +	if (nconfigs)
> +		has_config = 1;
> +
> +	np_config = of_parse_phandle(np, "ste,config", 0);
> +	if (np_config) {
> +		ret = pinconf_generic_parse_dt_config(np_config, &configs,
> +				&nconfigs);
> +		if (ret)
> +			goto exit;
> +		has_config |= nconfigs;
> +	}
> +
> +	ret = of_property_count_strings(np, "ste,pins");
> +	if (ret < 0)
> +		goto exit;
> +
> +	if (has_config)
> +		reserve++;
> +
> +	reserve *= ret;
> +
> +	ret = abx500_dt_reserve_map(map, reserved_maps, num_maps, reserve);
> +	if (ret < 0)
> +		goto exit;
> +
> +	of_property_for_each_string(np, "ste,pins", prop, group) {
> +		if (function) {
> +			ret = abx500_dt_add_map_mux(map, reserved_maps,
> +					num_maps, group, function);
> +			if (ret < 0)
> +				goto exit;
> +		}
> +		if (has_config) {
> +			gpio_name = abx500_find_pin_name(pctldev, group);
> +
> +			ret = abx500_dt_add_map_configs(map, reserved_maps,
> +					num_maps, gpio_name, configs, 1);
> +			if (ret < 0)
> +				goto exit;
> +		}
> +
> +	}
> +exit:
> +	return ret;
> +}
> +
> +int abx500_dt_node_to_map(struct pinctrl_dev *pctldev,

Same here.

Fabio

> +				 struct device_node *np_config,
> +				 struct pinctrl_map **map, unsigned *num_maps)
> +{
> +	unsigned reserved_maps;
> +	struct device_node *np;
> +	int ret;
> +
> +	reserved_maps = 0;
> +	*map = NULL;
> +	*num_maps = 0;
> +
> +	for_each_child_of_node(np_config, np) {
> +		ret = abx500_dt_subnode_to_map(pctldev, np, map,
> +				&reserved_maps, num_maps);
> +		if (ret < 0) {
> +			abx500_dt_free_map(pctldev, *map, *num_maps);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct pinctrl_ops abx500_pinctrl_ops = {
>  	.get_groups_count = abx500_get_groups_cnt,
>  	.get_group_name = abx500_get_group_name,
>  	.get_group_pins = abx500_get_group_pins,
>  	.pin_dbg_show = abx500_pin_dbg_show,
> +	.dt_node_to_map = abx500_dt_node_to_map,
> +	.dt_free_map = abx500_dt_free_map,
>  };
>  
>  static int abx500_pin_config_get(struct pinctrl_dev *pctldev,
> -- 
> 1.7.10
> 

-- 
Fabio Baltieri
