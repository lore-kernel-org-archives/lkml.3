Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbaKSIWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:22:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61849 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaKSIWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:22:13 -0500
X-AuditID: cbfee61a-f79c06d000004e71-f6-546c53325ac1
Date: Wed, 19 Nov 2014 09:21:39 +0100
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
Subject: Re: [PATCHv4 1/1] thermal: of: improve of-thermal sensor registration
 API
Message-id: <20141119092139.1965e44e@amdc2363>
In-reply-to: <1416321575-18348-2-git-send-email-edubezval@gmail.com>
References: <1416321575-18348-1-git-send-email-edubezval@gmail.com>
 <1416321575-18348-2-git-send-email-edubezval@gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAV3j4JwQg9b/nBZfPvexWcw/co7V
	Yv6Va6wW5149YrE48GcHo8XSu5/YLC7vmsNm8bn3CKNF55dZbBZPFp5hsrgzbS+bxe0PB5gt
	WvceYbd48hBowKuDbSwWP3fNA+o91czsIOixc9Zddo/Fe14yeVw694fZY9OqTjaPO9f2sHk8
	mLibzaO3+R2bx99Z+1k8dn5vYPfYfLra4/MmOY+Nc0MDeKK4bFJSczLLUov07RK4Mjr2LWEv
	WJRd8WfiVqYGxr6wLkYODgkBE4kduzO6GDmBTDGJC/fWs4HYQgKLGCWOTrTrYuQCsn8xSrzo
	WgOWYBFQlXgzbRYTiM0moCfx+e5TMFtEQEvixKXtTCANzAIHWSTeXFsK1iAsECLxeOYxdhCb
	F6ih+dhvFhCbU8BF4v+aGywQ22olZjdeZgWx+QUkJdr//WCGuMhO4tynDVC9ghI/Jt8Dq2cG
	WrZ5WxMrhC0vsXnNW+YJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBMfpMagfjygaLQ4wCHIxKPLwv3maHCLEmlhVX5h5ilOBgVhLhPemdEyLEm5JYWZValB9f
	VJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBMXCbaMLrYiPFXvbfXk82FEi8
	m3RDs0Lol67Wa89vTu8vajwNsDv+/sUb3o9feuXj/x9pXZz0NOOmnvRtlRCW72c8Zl36PXP9
	vQ9vvp7NP3npu+yrGk5PlQWeFbMLRDMfHi546siSUMytPe9QT/+BfsXMtWrTenZ6TRAp2WZ3
	q+tDd76o80V+ZSWW4oxEQy3mouJEAM3iXXfNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

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
> Reviewed-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
> ---
>  drivers/hwmon/lm75.c                               |  9 +++--
>  drivers/hwmon/ntc_thermistor.c                     |  6 +++-
>  drivers/hwmon/tmp102.c                             |  6 +++-
>  drivers/thermal/of-thermal.c                       | 40
> ++++++++++------------
> drivers/thermal/tegra_soctherm.c                   |  7 ++--
> drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  8 +++--
> include/linux/thermal.h                            | 24 +++++++++----
> 7 files changed, 63 insertions(+), 37 deletions(-) ---
> Difference from V3:
>   - Keep the same behavior regarding callback checks.
>     Change in behavior may be sent in a separate patch.
> Difference from V2:
>   - Fix wrong assignment in tegra driver.
> Difference from V1:
>   - Fix error handling when .get_trend is not provided.
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
> b/drivers/thermal/of-thermal.c index f8eb625..e87ccdb 100644
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
> @@ -107,10 +106,10 @@ static int of_thermal_get_temp(struct
> thermal_zone_device *tz, {
>  	struct __thermal_zone *data = tz->devdata;
>  
> -	if (!data->get_temp)
> +	if (!data->ops->get_temp)
>  		return -EINVAL;
>  
> -	return data->get_temp(data->sensor_data, temp);
> +	return data->ops->get_temp(data->sensor_data, temp);
>  }
>  
>  static int of_thermal_get_trend(struct thermal_zone_device *tz, int
> trip, @@ -120,10 +119,10 @@ static int of_thermal_get_trend(struct
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
> @@ -324,8 +323,7 @@ static struct thermal_zone_device_ops
> of_thermal_ops = { static struct thermal_zone_device *
>  thermal_zone_of_add_sensor(struct device_node *zone,
>  			   struct device_node *sensor, void *data,
> -			   int (*get_temp)(void *, long *),
> -			   int (*get_trend)(void *, long *))
> +			   const struct thermal_zone_of_device_ops
> *ops) {
>  	struct thermal_zone_device *tzd;
>  	struct __thermal_zone *tz;
> @@ -336,9 +334,11 @@ thermal_zone_of_add_sensor(struct device_node
> *zone, 
>  	tz = tzd->devdata;
>  
> +	if (!ops)
> +		return ERR_PTR(-EINVAL);
> +
>  	mutex_lock(&tzd->lock);
> -	tz->get_temp = get_temp;
> -	tz->get_trend = get_trend;
> +	tz->ops = ops;
>  	tz->sensor_data = data;
>  
>  	tzd->ops->get_temp = of_thermal_get_temp;
> @@ -356,8 +356,8 @@ thermal_zone_of_add_sensor(struct device_node
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
> pointed by @@ -382,9 +382,8 @@ thermal_zone_of_add_sensor(struct
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
> @@ -424,9 +423,7 @@ thermal_zone_of_sensor_register(struct device
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
> @@ -468,8 +465,7 @@ void thermal_zone_of_sensor_unregister(struct
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

On which branch should I apply this patch?

I've tried to apply this patch on top of newest linux-soc-thermal/next:
git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
branch: next
SHA1:4027494124fd88e5d51127eebba315de5d8d57c8

Unfortunately, it conflicts with:
"thermal: fix multiple disbalanced device node counters"
c2aad93c Vladimir Zapolskiy


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
