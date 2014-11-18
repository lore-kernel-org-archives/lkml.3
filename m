Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaKRHjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:39:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19371 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaKRHjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:39:22 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-19-546af799d774
Date: Tue, 18 Nov 2014 08:38:57 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/1] thermal: of: improve of-thermal sensor registration API
Message-id: <20141118083857.18e07130@amdc2363>
In-reply-to: <1416269103-14149-1-git-send-email-edubezval@gmail.com>
References: <1416264255-10083-1-git-send-email-edubezval@gmail.com>
 <1416269103-14149-1-git-send-email-edubezval@gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd2Z37NCDPYeVLP48rmPzWL+kXOs
	FvOvXGO1OPfqEYvFgT87GC2W3v3EZnF51xw2i8+9RxgtOr/MYrN4svAMk8WdaXvZLG5/OMBs
	0br3CLvFk4dAA14dbGOx+LlrHlDvqWZmB0GPnbPusnss3vOSyePSuT/MHptWdbJ53Lm2h83j
	wcTdbB69ze/YPP7O2s/isfN7A7vH5tPVHp83yXlsnBsawBPFZZOSmpNZllqkb5fAlfH7wA/W
	godZFSfvBDQwbgntYuTkkBAwkTjx/RojhC0mceHeerYuRi4OIYFFjBJrzs5hhXB+MUqcaZ4O
	VsUioCpxdc4aFhCbTUBP4vPdp0wgtoiAlsSJS9uZQBqYBQ6ySLy5tpQNJCEsECDx+l4rM4jN
	C9TQ3PYVrIFTwEWia8klsKFCArUSi+YcBavhF5CUaP/3gxniJDuJc582sEP0Ckr8mHwPbDEz
	0LLN25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P
	3cQIjtJn0jsYVzVYHGIU4GBU4uFNnJoVIsSaWFZcmXuIUYKDWUmE91w3UIg3JbGyKrUoP76o
	NCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAMjX/9mqwVzlix2arJmmn7ReY/J
	jBCXa9XaqvJ++UecXd867y9/9VDNXqNIcR4z96n3mQ3q7RFPMhf+3nb216arJ7dFzbXhmlBx
	xK9rZbsRu4HVefWcCfPbGR8urwpOkJ/qPnX39eiWKusmrca1++5dUsiY96bOJTRye1v2bw6g
	zpsmiUcfqCixFGckGmoxFxUnAgDFRHygzgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

In the mail topic we have PATCH 1/1 but I think that it should be PATCH
v3 1/1.

> Different drivers request API extensions in of-thermal. For this
> reason, additional callbacks are required to fit the new drivers
> needs.
> 
> The current API implementation expects the registering sensor driver
> to provide a get_temp and get_trend callbacks as function parameters.
> As the amount of callbacks is growing, this patch changes the existing
> implementation to use a .ops field to hold all the of thermal
> callbacks to sensor drivers.
> 
> This patch also changes the existing of-thermal users to fit the new
> API design. No functional change is introduced in this patch.
> 
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: devicetree@vger.kernel.org
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: lm-sensors@lm-sensors.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
> ---
> Difference from V2:
>   - Fix wrong assignment in tegra driver.
> Difference from V1:
>   - Fix error handling when .get_trend is not provided.
> ---
>  drivers/hwmon/lm75.c                               |  9 +++--
>  drivers/hwmon/ntc_thermistor.c                     |  6 +++-
>  drivers/hwmon/tmp102.c                             |  6 +++-
>  drivers/thermal/of-thermal.c                       | 41
> +++++++++-------------
> drivers/thermal/tegra_soctherm.c                   |  7 ++--
> drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  8 +++--
> include/linux/thermal.h                            | 24 +++++++++----
> 7 files changed, 62 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
> index d16dbb3..e7c8bf9 100644
> --- a/drivers/hwmon/lm75.c
> +++ b/drivers/hwmon/lm75.c
> @@ -176,6 +176,10 @@ static struct attribute *lm75_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(lm75);
>  
> +static const struct thermal_zone_of_device_ops lm75_of_thermal_ops =
> {
> +	.get_temp = lm75_read_temp,
> +};
> +
>  /*-----------------------------------------------------------------------*/
>  
>  /* device probe and removal */
> @@ -291,10 +295,9 @@ lm75_probe(struct i2c_client *client, const
> struct i2c_device_id *id) if (IS_ERR(data->hwmon_dev))
>  		return PTR_ERR(data->hwmon_dev);
>  
> -	data->tz = thermal_zone_of_sensor_register(data->hwmon_dev,
> -						   0,
> +	data->tz = thermal_zone_of_sensor_register(data->hwmon_dev,
> 0, data->hwmon_dev,
> -						   lm75_read_temp,
> NULL);
> +
> &lm75_of_thermal_ops); if (IS_ERR(data->tz))
>  		data->tz = NULL;
>  
> diff --git a/drivers/hwmon/ntc_thermistor.c
> b/drivers/hwmon/ntc_thermistor.c index 4ff89b2..bca8521c8 100644
> --- a/drivers/hwmon/ntc_thermistor.c
> +++ b/drivers/hwmon/ntc_thermistor.c
> @@ -486,6 +486,10 @@ static const struct attribute_group
> ntc_attr_group = { .attrs = ntc_attributes,
>  };
>  
> +static const struct thermal_zone_of_device_ops ntc_of_thermal_ops = {
> +	.get_temp = ntc_read_temp,
> +};
> +
>  static int ntc_thermistor_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *of_id =
> @@ -579,7 +583,7 @@ static int ntc_thermistor_probe(struct
> platform_device *pdev) pdev_id->name);
>  
>  	data->tz = thermal_zone_of_sensor_register(data->dev, 0,
> data->dev,
> -						ntc_read_temp, NULL);
> +
> &ntc_of_thermal_ops); if (IS_ERR(data->tz)) {
>  		dev_dbg(&pdev->dev, "Failed to register to thermal
> fw.\n"); data->tz = NULL;
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> index 5171995..ba9f478 100644
> --- a/drivers/hwmon/tmp102.c
> +++ b/drivers/hwmon/tmp102.c
> @@ -158,6 +158,10 @@ ATTRIBUTE_GROUPS(tmp102);
>  #define TMP102_CONFIG  (TMP102_CONF_TM | TMP102_CONF_EM |
> TMP102_CONF_CR1) #define TMP102_CONFIG_RD_ONLY (TMP102_CONF_R0 |
> TMP102_CONF_R1 | TMP102_CONF_AL) 
> +static const struct thermal_zone_of_device_ops tmp102_of_thermal_ops
> = {
> +	.get_temp = tmp102_read_temp,
> +};
> +
>  static int tmp102_probe(struct i2c_client *client,
>  				  const struct i2c_device_id *id)
>  {
> @@ -215,7 +219,7 @@ static int tmp102_probe(struct i2c_client *client,
>  	}
>  	tmp102->hwmon_dev = hwmon_dev;
>  	tmp102->tz = thermal_zone_of_sensor_register(hwmon_dev, 0,
> hwmon_dev,
> -
> tmp102_read_temp, NULL);
> +
> &tmp102_of_thermal_ops); if (IS_ERR(tmp102->tz))
>  		tmp102->tz = NULL;
>  
> diff --git a/drivers/thermal/of-thermal.c
> b/drivers/thermal/of-thermal.c index f8eb625..3e025f0 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -30,6 +30,7 @@
>  #include <linux/err.h>
>  #include <linux/export.h>
>  #include <linux/string.h>
> +#include <linux/thermal.h>
>  
>  #include "thermal_core.h"
>  
> @@ -77,8 +78,7 @@ struct __thermal_bind_params {
>   * @num_tbps: number of thermal bind params
>   * @tbps: an array of thermal bind params (0..num_tbps - 1)
>   * @sensor_data: sensor private data used while reading temperature
> and trend
> - * @get_temp: sensor callback to read temperature
> - * @get_trend: sensor callback to read temperature trend
> + * @ops: set of callbacks to handle the thermal zone based on DT
>   */
>  
>  struct __thermal_zone {
> @@ -96,8 +96,7 @@ struct __thermal_zone {
>  
>  	/* sensor interface */
>  	void *sensor_data;
> -	int (*get_temp)(void *, long *);
> -	int (*get_trend)(void *, long *);
> +	const struct thermal_zone_of_device_ops *ops;
>  };
>  
>  /***   DT thermal zone device callbacks   ***/
> @@ -107,10 +106,7 @@ static int of_thermal_get_temp(struct
> thermal_zone_device *tz, {
>  	struct __thermal_zone *data = tz->devdata;
>  
> -	if (!data->get_temp)
> -		return -EINVAL;

To be consistent, I think that we should keep the above check [1]. 

	if (!data->ops->get_temp)
		return -EINVAL;

The same check is done with get_trend callback.

> -
> -	return data->get_temp(data->sensor_data, temp);
> +	return data->ops->get_temp(data->sensor_data, temp);
>  }
>  
>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int
> trip, @@ -120,10 +116,10 @@ static int of_thermal_get_trend(struct
> thermal_zone_device *tz, int trip, long dev_trend;
>  	int r;
>  
> -	if (!data->get_trend)
> +	if (!data->ops->get_trend)
>  		return -EINVAL;
>  
> -	r = data->get_trend(data->sensor_data, &dev_trend);
> +	r = data->ops->get_trend(data->sensor_data, &dev_trend);
>  	if (r)
>  		return r;
>  
> @@ -324,8 +320,7 @@ static struct thermal_zone_device_ops
> of_thermal_ops = { static struct thermal_zone_device *
>  thermal_zone_of_add_sensor(struct device_node *zone,
>  			   struct device_node *sensor, void *data,
> -			   int (*get_temp)(void *, long *),
> -			   int (*get_trend)(void *, long *))
> +			   const struct thermal_zone_of_device_ops
> *ops) {
>  	struct thermal_zone_device *tzd;
>  	struct __thermal_zone *tz;
> @@ -336,9 +331,11 @@ thermal_zone_of_add_sensor(struct device_node
> *zone, 
>  	tz = tzd->devdata;
>  
> +	if (!(ops && ops->get_temp))
> +		return ERR_PTR(-EINVAL);

IMHO, here we should only check:
	if (!ops)
		return ERR_PTR(-EINVAL);

	And check if specific callbacks are available in other
	functions (like [1])

> +
>  	mutex_lock(&tzd->lock);
> -	tz->get_temp = get_temp;
> -	tz->get_trend = get_trend;
> +	tz->ops = ops;
>  	tz->sensor_data = data;
>  
>  	tzd->ops->get_temp = of_thermal_get_temp;
> @@ -356,8 +353,8 @@ thermal_zone_of_add_sensor(struct device_node
> *zone,
>   *             than one sensors
>   * @data: a private pointer (owned by the caller) that will be passed
>   *        back, when a temperature reading is needed.
> - * @get_temp: a pointer to a function that reads the sensor
> temperature.
> - * @get_trend: a pointer to a function that reads the sensor
> temperature trend.
> + * @ops: struct thermal_zone_of_device *. Must contain at
> least .get_trend and
> + *       .get_temp.
>   *
>   * This function will search the list of thermal zones described in
> device
>   * tree and look for the zone that refer to the sensor device
> pointed by @@ -382,9 +379,8 @@ thermal_zone_of_add_sensor(struct
> device_node *zone,
>   * check the return value with help of IS_ERR() helper.
>   */
>  struct thermal_zone_device *
> -thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> -				void *data, int (*get_temp)(void *,
> long *),
> -				int (*get_trend)(void *, long *))
> +thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> void *data,
> +				const struct
> thermal_zone_of_device_ops *ops) {
>  	struct device_node *np, *child, *sensor_np;
>  
> @@ -424,9 +420,7 @@ thermal_zone_of_sensor_register(struct device
> *dev, int sensor_id, if (sensor_specs.np == sensor_np && id ==
> sensor_id) { of_node_put(np);
>  			return thermal_zone_of_add_sensor(child,
> sensor_np,
> -							  data,
> -							  get_temp,
> -							  get_trend);
> +							  data, ops);
>  		}
>  	}
>  	of_node_put(np);
> @@ -468,8 +462,7 @@ void thermal_zone_of_sensor_unregister(struct
> device *dev, tzd->ops->get_temp = NULL;
>  	tzd->ops->get_trend = NULL;
>  
> -	tz->get_temp = NULL;
> -	tz->get_trend = NULL;
> +	tz->ops = NULL;
>  	tz->sensor_data = NULL;
>  	mutex_unlock(&tzd->lock);
>  }
> diff --git a/drivers/thermal/tegra_soctherm.c
> b/drivers/thermal/tegra_soctherm.c index 70f7e9e..9197fc0 100644
> --- a/drivers/thermal/tegra_soctherm.c
> +++ b/drivers/thermal/tegra_soctherm.c
> @@ -317,6 +317,10 @@ static int tegra_thermctl_get_temp(void *data,
> long *out_temp) return 0;
>  }
>  
> +static const struct thermal_zone_of_device_ops tegra_of_thermal_ops
> = {
> +	.get_temp = tegra_thermctl_get_temp,
> +};
> +
>  static const struct of_device_id tegra_soctherm_of_match[] = {
>  	{ .compatible = "nvidia,tegra124-soctherm" },
>  	{ },
> @@ -416,8 +420,7 @@ static int tegra_soctherm_probe(struct
> platform_device *pdev) zone->shift =
> t124_thermctl_temp_zones[i].shift; 
>  		tz = thermal_zone_of_sensor_register(&pdev->dev, i,
> zone,
> -
> tegra_thermctl_get_temp,
> -						     NULL);
> +
> &tegra_of_thermal_ops); if (IS_ERR(tz)) {
>  			err = PTR_ERR(tz);
>  			dev_err(&pdev->dev, "failed to register
> sensor: %d\n", diff --git
> a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c index
> 9eec26d..5fd0386 100644 ---
> a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c +++
> b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c @@ -286,6
> +286,11 @@ static int ti_thermal_get_crit_temp(struct
> thermal_zone_device *thermal, return
> ti_thermal_get_trip_temp(thermal, OMAP_TRIP_NUMBER - 1, temp); }
> +static const struct thermal_zone_of_device_ops ti_of_thermal_ops = {
> +	.get_temp = __ti_thermal_get_temp,
> +	.get_trend = __ti_thermal_get_trend,
> +};
> +
>  static struct thermal_zone_device_ops ti_thermal_ops = {
>  	.get_temp = ti_thermal_get_temp,
>  	.get_trend = ti_thermal_get_trend,
> @@ -333,8 +338,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap
> *bgp, int id, 
>  	/* in case this is specified by DT */
>  	data->ti_thermal = thermal_zone_of_sensor_register(bgp->dev,
> id,
> -					data, __ti_thermal_get_temp,
> -					__ti_thermal_get_trend);
> +					data, &ti_of_thermal_ops);
>  	if (IS_ERR(data->ti_thermal)) {
>  		/* Create thermal zone */
>  		data->ti_thermal =
> thermal_zone_device_register(domain, diff --git
> a/include/linux/thermal.h b/include/linux/thermal.h index
> ef90838..b565964 100644 --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -289,19 +289,31 @@ struct thermal_genl_event {
>  	enum events event;
>  };
>  
> +/**
> + * struct thermal_zone_of_device_ops - scallbacks for handling DT
> based zones
> + *
> + * Mandatory:
> + * @get_temp: a pointer to a function that reads the sensor
> temperature.
> + *
> + * Optional:
> + * @get_trend: a pointer to a function that reads the sensor
> temperature trend.
> + */
> +struct thermal_zone_of_device_ops {
> +	int (*get_temp)(void *, long *);
> +	int (*get_trend)(void *, long *);
> +};
> +
>  /* Function declarations */
>  #ifdef CONFIG_THERMAL_OF
>  struct thermal_zone_device *
> -thermal_zone_of_sensor_register(struct device *dev, int id,
> -				void *data, int (*get_temp)(void *,
> long *),
> -				int (*get_trend)(void *, long *));
> +thermal_zone_of_sensor_register(struct device *dev, int id, void
> *data,
> +				const struct
> thermal_zone_of_device_ops *); void
> thermal_zone_of_sensor_unregister(struct device *dev, struct
> thermal_zone_device *tz); #else
>  static inline struct thermal_zone_device *
> -thermal_zone_of_sensor_register(struct device *dev, int id,
> -				void *data, int (*get_temp)(void *,
> long *),
> -				int (*get_trend)(void *, long *))
> +thermal_zone_of_sensor_register(struct device *dev, int id, void
> *data,
> +				const struct
> thermal_zone_of_device_ops *) {
>  	return NULL;
>  }

Despite this minor comments, feel free to add :-)

Reviewed-by: Lukasz Majewski <l.majewski@samsung.com>

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
