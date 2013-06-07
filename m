Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3FGMIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:08:32 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57037 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3FGMIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:08:30 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH] pinctrl: pinctrl-abx500: Add device tree support
Date: Fri,  7 Jun 2013 14:07:35 +0200
Message-Id: <1370606855-19403-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

We use the same way to define pin muxing and pin
configuration than for nomadik. So pickup code
from pinctrl_nomadik.c to be able to implement
pin multiplexing and pin configuration using
the device tree.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 .../devicetree/bindings/pinctrl/ste,abx500.txt     |  344 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-abx500.c                   |  238 ++++++++++++++
 2 files changed, 582 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,abx500.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt b/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
new file mode 100644
index 0000000..77b623b
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/ste,abx500.txt
@@ -0,0 +1,344 @@
+ST Ericsson abx500 pinmux controller
+
+Required properties:
+- compatible: "stericsson,ab8500-gpio",  "stericsson,ab8540-gpio",
+	      "stericsson,ab8505-gpio", "stericsson,ab9540-gpio",
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+ST Ericsson's pin configuration nodes act as a container for an arbitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin, a group, or a list of pins or groups. This configuration can include the
+mux function to select on those pin(s)/group(s), and various pin configuration
+parameters, such as input, output, pull up, pull down...
+
+The name of each subnode is not important; all subnodes should be enumerated
+and processed purely based on their content.
+
+Required subnode-properties:
+- ste,pins : An array of strings. Each string contains the name of a pin or
+    group.
+
+Optional subnode-properties:
+- ste,function: A string containing the name of the function to mux to the
+  pin or group.
+
+- ste,config: Handle of pin configuration node (e.g. ste,config = <&slpm_in_wkup_pdis>)
+
+- ste,input : <0/1/2>
+	0: input with no pull
+	1: input with pull up,
+	2: input with pull down,
+
+- ste,output: <0/1/2>
+	0: output low,
+	1: output high,
+	2: output (value is not specified).
+
+Example board file extract:
+
+&pinctrl_abx500 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sysclkreq2_default_mode>, <&sysclkreq3_default_mode>, <&gpio3_default_mode>, <&sysclkreq6_default_mode>, <&pwmout1_default_mode>, <&pwmout2_default_mode>, <&pwmout3_default_mode>, <&adi1_default_mode>, <&dmic12_default_mode>, <&dmic34_default_mode>, <&dmic56_default_mode>, <&sysclkreq5_default_mode>, <&batremn_default_mode>, <&service_default_mode>, <&pwrctrl0_default_mode>, <&pwrctrl1_default_mode>, <&pwmextvibra1_default_mode>, <&pwmextvibra2_default_mode>, <&gpio51_default_mode>, <&gpio52_default_mode>, <&gpio53_default_mode>, <&gpio54_default_mode>, <&pdmclkdat_default_mode>;
+
+	sysclkreq2 {
+		sysclkreq2_default_mode: sysclkreq2_default {
+			default_mux {
+				ste,function = "sysclkreq";
+				ste,pins = "sysclkreq2_d_1";
+			};
+			default_cfg {
+				ste,pins = "GPIO1";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	sysclkreq3 {
+		sysclkreq3_default_mode: sysclkreq3_default {
+			default_mux {
+				ste,function = "sysclkreq";
+				ste,pins = "sysclkreq3_d_1";
+			};
+			default_cfg {
+				ste,pins = "GPIO2";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	gpio3 {
+		gpio3_default_mode: gpio3_default {
+			default_mux {
+				ste,function = "gpio";
+				ste,pins = "gpio3_a_1";
+			};
+			default_cfg {
+				ste,pins = "GPIO3";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	sysclkreq6 {
+		sysclkreq6_default_mode: sysclkreq6_default {
+			default_mux {
+				ste,function = "sysclkreq";
+				ste,pins = "sysclkreq6_d_1";
+			};
+			default_cfg {
+				ste,pins = "GPIO4";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	pwmout1 {
+		pwmout1_default_mode: pwmout1_default {
+			default_mux {
+				ste,function = "pwmout";
+				ste,pins = "pwmout1_d_1";
+			};
+			default_cfg {
+				ste,pins = "GPIO14";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	pwmout2 {
+		pwmout2_default_mode: pwmout2_default {
+			pwmout2_default_mux {
+				ste,function = "pwmout";
+				ste,pins = "pwmout2_d_1";
+			};
+			pwmout2_default_cfg {
+				ste,pins = "GPIO15";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	pwmout3 {
+		pwmout3_default_mode: pwmout3_default {
+			pwmout3_default_mux {
+				ste,function = "pwmout";
+				ste,pins = "pwmout3_d_1";
+			};
+			pwmout3_default_cfg {
+				ste,pins = "GPIO16";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	adi1 {{
+
+		adi1_default_mode: adi1_default {
+			adi1_default_mux {
+				ste,function = "adi1";
+				ste,pins = "adi1_d_1";
+			};
+			adi1_default_cfg1 {
+				ste,pins = "GPIO17","GPIO19","GPIO20";
+				ste,config = <&in_nopull>;
+			};
+			adi1_default_cfg2 {
+				ste,pins = "GPIO18";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	dmic12 {
+		dmic12_default_mode: dmic12_default {
+			dmic12_default_mux {
+				ste,function = "dmic";
+				ste,pins = "dmic12_d_1";
+			};
+			dmic12_default_cfg1 {
+				ste,pins = "GPIO27";
+				ste,config = <&out_lo>;
+			};
+			dmic12_default_cfg2 {
+				ste,pins = "GPIO28";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	dmic34 {
+		dmic34_default_mode: dmic34_default {
+			dmic34_default_mux {
+				ste,function = "dmic";
+				ste,pins = "dmic34_d_1";
+			};
+			dmic34_default_cfg1 {
+				ste,pins = "GPIO29";
+				ste,config = <&out_lo>;
+			};
+			dmic34_default_cfg2 {
+				ste,pins = "GPIO30";
+				ste,config = <&in_nopull>;{
+
+			};
+		};
+	};
+	dmic56 {
+		dmic56_default_mode: dmic56_default {
+			dmic56_default_mux {
+				ste,function = "dmic";
+				ste,pins = "dmic56_d_1";
+			};
+			dmic56_default_cfg1 {
+				ste,pins = "GPIO31";
+				ste,config = <&out_lo>;
+			};
+			dmic56_default_cfg2 {
+				ste,pins = "GPIO32";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	sysclkreq5 {
+		sysclkreq5_default_mode: sysclkreq5_default {
+			sysclkreq5_default_mux {
+				ste,function = "sysclkreq";
+				ste,pins = "sysclkreq5_d_1";
+			};
+			sysclkreq5_default_cfg {
+				ste,pins = "GPIO42";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	batremn {
+		batremn_default_mode: batremn_default {
+			batremn_default_mux {
+				ste,function = "batremn";
+				ste,pins = "batremn_d_1";
+			};
+			batremn_default_cfg {
+				ste,pins = "GPIO43";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	service {
+		service_default_mode: service_default {
+			service_default_mux {
+				ste,function = "service";
+				ste,pins = "service_d_1";
+			};
+			service_default_cfg {
+				ste,pins = "GPIO44";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	pwrctrl0 {
+		pwrctrl0_default_mux: pwrctrl0_mux {
+			pwrctrl0_default_mux {
+				ste,function = "pwrctrl";
+				ste,pins = "pwrctrl0_d_1";
+			};
+		};
+		pwrctrl0_default_mode: pwrctrl0_default {
+			pwrctrl0_default_cfg {
+				ste,pins = "GPIO45";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	pwrctrl1 {
+		pwrctrl1_default_mux: pwrctrl1_mux {
+			pwrctrl1_default_mux {
+				ste,function = "pwrctrl";
+				ste,pins = "pwrctrl1_d_1";
+			};
+		};
+		pwrctrl1_default_mode: pwrctrl1_default {
+			pwrctrl1_default_cfg {
+				ste,pins = "GPIO46";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	pwmextvibra1 {
+		pwmextvibra1_default_mode: pwmextvibra1_default {
+			pwmextvibra1_default_mux {
+				ste,function = "pwmextvibra";
+				ste,pins = "pwmextvibra1_d_1";
+			};
+			pwmextvibra1_default_cfg {
+				ste,pins = "GPIO47";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	pwmextvibra2 {
+		pwmextvibra2_default_mode: pwmextvibra2_default {
+			pwmextvibra2_default_mux {
+				ste,function = "pwmextvibra";
+				ste,pins = "pwmextvibra2_d_1";
+			};
+			pwmextvibra1_default_cfg {
+				ste,pins = "GPIO48";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+	gpio51 {
+		gpio51_default_mode: gpio51_default {
+				gpio51_default_mux {
+				ste,function = "gpio";
+				ste,pins = "gpio51_a_1";
+			};
+			gpio51_default_cfg {
+				ste,pins = "GPIO51";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	gpio52 {
+		gpio52_default_mode: gpio52_default {
+			gpio52_default_mux {
+				ste,function = "gpio";
+				ste,pins = "gpio52_a_1";
+			};
+			gpio52_default_cfg {
+				ste,pins = "GPIO52";
+				ste,config = <&in_pd>;
+			};
+		};
+	};
+	gpio53 {
+		gpio53_default_mode: gpio53_default {
+			gpio53_default_mux {
+				ste,function = "gpio";
+				ste,pins = "gpio53_a_1";
+			};
+			gpio53_default_cfg {
+				ste,pins = "GPIO53";
+				ste,config = <&in_pd>;
+		};
+	};
+	};
+	gpio54 {
+		gpio54_default_mode: gpio54_default {
+			gpio54_default_mux {
+				ste,function = "gpio";
+				ste,pins = "gpio54_a_1";
+			};
+			gpio54_default_cfg {
+				ste,pins = "GPIO54";
+				ste,config = <&out_lo>;
+			};
+		};
+	};
+	pdmclkdat {
+		pdmclkdat_default_mode: pdmclkdat_default {
+			pdmclkdat_default_mux {
+				ste,function = "pdm";
+				ste,pins = "pdmclkdat_d_1";
+			};
+			pdmclkdat_default_cfg {
+				ste,pins = "GPIO55", "GPIO56";
+				ste,config = <&in_nopull>;
+			};
+		};
+	};
+};
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 504b867..a6992c3 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -30,6 +30,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf.h>
 #include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/machine.h>
 
 #include "pinctrl-abx500.h"
 
@@ -758,11 +759,248 @@ static void abx500_pin_dbg_show(struct pinctrl_dev *pctldev,
 				 chip->base + offset - 1);
 }
 
+static void abx500_dt_free_map(struct pinctrl_dev *pctldev,
+		struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
+			kfree(map[i].data.configs.configs);
+	kfree(map);
+}
+
+static int abx500_dt_reserve_map(struct pinctrl_map **map,
+		unsigned *reserved_maps,
+		unsigned *num_maps,
+		unsigned reserve)
+{
+	unsigned old_num = *reserved_maps;
+	unsigned new_num = *num_maps + reserve;
+	struct pinctrl_map *new_map;
+
+	if (old_num >= new_num)
+		return 0;
+
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map)
+		return -ENOMEM;
+
+	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
+
+	*map = new_map;
+	*reserved_maps = new_num;
+
+	return 0;
+}
+
+static int abx500_dt_add_map_mux(struct pinctrl_map **map,
+		unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		const char *function)
+{
+	if (*num_maps == *reserved_maps)
+		return -ENOSPC;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[*num_maps].data.mux.group = group;
+	(*map)[*num_maps].data.mux.function = function;
+	(*num_maps)++;
+
+	return 0;
+}
+
+static int abx500_dt_add_map_configs(struct pinctrl_map **map,
+		unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		unsigned long *configs, unsigned num_configs)
+{
+	unsigned long *dup_configs;
+
+	if (*num_maps == *reserved_maps)
+		return -ENOSPC;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs)
+		return -ENOMEM;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_PIN;
+
+	(*map)[*num_maps].data.configs.group_or_pin = group;
+	(*map)[*num_maps].data.configs.configs = dup_configs;
+	(*map)[*num_maps].data.configs.num_configs = num_configs;
+	(*num_maps)++;
+
+	return 0;
+}
+
+#define ABX500_CONFIG_PIN_ARRAY(x, y) { .property = x, .choice = y, \
+	.size = ARRAY_SIZE(y), }
+
+static const unsigned long abx500_pin_input_modes[] = {
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_DOWN, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 1),
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_DOWN, 1),
+};
+
+static const unsigned long abx500_pin_output_modes[] = {
+	PIN_CONF_PACKED(PIN_CONFIG_OUTPUT, 0),
+	PIN_CONF_PACKED(PIN_CONFIG_OUTPUT, 1),
+};
+
+struct abx500_cfg_param {
+	const char *property;
+	unsigned long config;
+	const unsigned long *choice;
+	int size;
+};
+
+static const struct abx500_cfg_param abx500_cfg_params[] = {
+	ABX500_CONFIG_PIN_ARRAY("ste,input",	abx500_pin_input_modes),
+	ABX500_CONFIG_PIN_ARRAY("ste,output",	abx500_pin_output_modes),
+};
+
+static int abx500_dt_pin_config(int index, int val, unsigned long *config)
+{
+	int ret = 0;
+
+	if (abx500_cfg_params[index].choice == NULL)
+		*config = abx500_cfg_params[index].config;
+	else {
+		/* test if out of range */
+		if  (val < abx500_cfg_params[index].size) {
+			*config = abx500_cfg_params[index].config |
+				abx500_cfg_params[index].choice[val];
+		}
+	}
+	return ret;
+}
+
+static const char *abx500_find_pin_name(struct pinctrl_dev *pctldev,
+					const char *pin_name)
+{
+	int i, pin_number;
+	struct abx500_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+
+	if (sscanf((char *)pin_name, "GPIO%d", &pin_number) == 1)
+		for (i = 0; i < npct->soc->npins; i++)
+			if (npct->soc->pins[i].number == pin_number)
+				return npct->soc->pins[i].name;
+	return NULL;
+}
+
+static bool abx500_dt_get_config(struct device_node *np,
+		unsigned long *configs)
+{
+	bool has_config = 0;
+	unsigned long cfg = 0;
+	int i, val, ret;
+
+	for (i = 0; i < ARRAY_SIZE(abx500_cfg_params); i++) {
+		ret = of_property_read_u32(np,
+				abx500_cfg_params[i].property, &val);
+		if (ret != -EINVAL) {
+			if (abx500_dt_pin_config(i, val, &cfg) == 0) {
+				*configs |= cfg;
+				has_config = 1;
+			}
+		}
+	}
+
+	return has_config;
+}
+
+int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *np,
+		struct pinctrl_map **map,
+		unsigned *reserved_maps,
+		unsigned *num_maps)
+{
+	int ret;
+	const char *function = NULL;
+	unsigned long configs = 0;
+	bool has_config = 0;
+	unsigned reserve = 0;
+	struct property *prop;
+	const char *group, *gpio_name;
+	struct device_node *np_config;
+
+	ret = of_property_read_string(np, "ste,function", &function);
+	if (ret >= 0)
+		reserve = 1;
+
+	has_config = abx500_dt_get_config(np, &configs);
+
+	np_config = of_parse_phandle(np, "ste,config", 0);
+	if (np_config)
+		has_config |= abx500_dt_get_config(np_config, &configs);
+
+	ret = of_property_count_strings(np, "ste,pins");
+	if (ret < 0)
+		goto exit;
+
+	if (has_config)
+		reserve++;
+
+	reserve *= ret;
+
+	ret = abx500_dt_reserve_map(map, reserved_maps, num_maps, reserve);
+	if (ret < 0)
+		goto exit;
+
+	of_property_for_each_string(np, "ste,pins", prop, group) {
+		if (function) {
+			ret = abx500_dt_add_map_mux(map, reserved_maps,
+					num_maps, group, function);
+			if (ret < 0)
+				goto exit;
+		}
+		if (has_config) {
+			gpio_name = abx500_find_pin_name(pctldev, group);
+
+			ret = abx500_dt_add_map_configs(map, reserved_maps,
+					num_maps, gpio_name, &configs, 1);
+			if (ret < 0)
+				goto exit;
+		}
+
+	}
+exit:
+	return ret;
+}
+
+int abx500_dt_node_to_map(struct pinctrl_dev *pctldev,
+				 struct device_node *np_config,
+				 struct pinctrl_map **map, unsigned *num_maps)
+{
+	unsigned reserved_maps;
+	struct device_node *np;
+	int ret;
+
+	reserved_maps = 0;
+	*map = NULL;
+	*num_maps = 0;
+
+	for_each_child_of_node(np_config, np) {
+		ret = abx500_dt_subnode_to_map(pctldev, np, map,
+				&reserved_maps, num_maps);
+		if (ret < 0) {
+			abx500_dt_free_map(pctldev, *map, *num_maps);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static const struct pinctrl_ops abx500_pinctrl_ops = {
 	.get_groups_count = abx500_get_groups_cnt,
 	.get_group_name = abx500_get_group_name,
 	.get_group_pins = abx500_get_group_pins,
 	.pin_dbg_show = abx500_pin_dbg_show,
+	.dt_node_to_map = abx500_dt_node_to_map,
+	.dt_free_map = abx500_dt_free_map,
 };
 
 static int abx500_pin_config_get(struct pinctrl_dev *pctldev,
-- 
1.7.10

