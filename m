Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaHHGZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:25:03 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46567 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHHGY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:24:59 -0400
Date: Fri, 8 Aug 2014 15:24:49 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: rdunlap@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, jg1.han@samsung.com, cooloney@gmail.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, grant.likely@linaro.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, jack.yoo@skyworksinc.com, florian.vaussard@epfl.ch,
        thierry.reding@gmail.com, jason@lakedaemon.net, andrew@lunn.ch,
        silvio.fricke@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] Adding a support for Skyworks SKY81452
Message-ID: <20140808062449.GC14907@jack-ThinkPad-T520>
References: <1407398738-7582-1-git-send-email-jack.yoo@skyworksinc.com>
 <20140807123439.GC29832@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140807123439.GC29832@distanz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments.
I will fix them and resubmit.

On Thu, Aug 07, 2014 at 02:34:39PM +0200, Tobias Klauser wrote:
> On 2014-08-07 at 10:05:38 +0200, Gyungoh Yoo <gyungoh@gmail.com> wrote:
> > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > ---
> >  Documentation/backlight/sky81452.txt               |  25 ++
> >  Documentation/devicetree/bindings/mfd/sky81452.txt |  24 ++
> >  .../bindings/regulator/sky81452-regulator.txt      |  16 +
> >  .../devicetree/bindings/vendor-prefixes.txt        |   1 +
> >  .../video/backlight/sky81452-backlight.txt         |  20 ++
> >  drivers/mfd/Kconfig                                |  12 +
> >  drivers/mfd/Makefile                               |   1 +
> >  drivers/mfd/sky81452.c                             | 115 +++++++
> >  drivers/regulator/Kconfig                          |  11 +
> >  drivers/regulator/Makefile                         |   1 +
> >  drivers/regulator/sky81452-regulator.c             | 127 ++++++++
> >  drivers/video/backlight/Kconfig                    |  10 +
> >  drivers/video/backlight/Makefile                   |   1 +
> >  drivers/video/backlight/sky81452-backlight.c       | 333 +++++++++++++++++++++
> >  include/linux/mfd/sky81452.h                       |  31 ++
> >  include/linux/sky81452-backlight.h                 |  46 +++
> >  16 files changed, 774 insertions(+)
> >  create mode 100644 Documentation/backlight/sky81452.txt
> >  create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
> >  create mode 100644 Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
> >  create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
> >  create mode 100644 drivers/mfd/sky81452.c
> >  create mode 100644 drivers/regulator/sky81452-regulator.c
> >  create mode 100644 drivers/video/backlight/sky81452-backlight.c
> >  create mode 100644 include/linux/mfd/sky81452.h
> >  create mode 100644 include/linux/sky81452-backlight.h
> 
> [...]
> 
> > diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
> > new file mode 100644
> > index 0000000..18dd6ac
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
> > @@ -0,0 +1,24 @@
> > +SKY81452 bindings
> > +
> > +Required properties:
> > +- compatible		: Must be "sky,sky81452"
> > +
> > +Required child nodes:
> > +- backlight		: container node for backlight following the binding
> > +		in video/backlight/sky81452-backlight.txt
> > +- regulator		: container node for regulators following the binding
> > +		in regulator/sky81452-regulator.txt
> > +
> > +Example:
> > +
> > +        sky81452@2C {
> > +                compatible = "sky,sky81452";
> > +
> > +		backlight {
> > +			...
> > +		};
> > +
> > +		regulator {
> > +			...
> > +		};
> > +        };
> 
> Mixture of tabs and spaces in the example, please use tabs only. Same
> for the example in sky81452-backlight.txt
> 
> [...]
> 
> > diff --git a/drivers/mfd/sky81452.c b/drivers/mfd/sky81452.c
> > new file mode 100644
> > index 0000000..e09552f
> > --- /dev/null
> > +++ b/drivers/mfd/sky81452.c
> > @@ -0,0 +1,115 @@
> 
> [...]
> 
> > +static int sky81452_probe(struct i2c_client *client,
> > +		const struct i2c_device_id *id)
> > +{
> > +	const struct sky81452_platform_data *pdata;
> > +	struct device *dev = &client->dev;
> > +	struct regmap *map;
> > +
> > +#ifdef CONFIG_OF
> > +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> 
> You still should check the return value in this case.
> 
> > +#else
> > +	pdata = dev_get_platdata(dev);
> > +	if (unlikely(!pdata))
> 
> There's usually no need to use unlikely() in driver code, especially not
> in non-critical functions like probe()
> 
> > +		return -EINVAL;
> > +#endif
> > +
> > +	map = devm_regmap_init_i2c(client, &sky81452_config);
> > +	if (IS_ERR(map))
> > +		return PTR_ERR(map);
> > +
> > +	i2c_set_clientdata(client, map);
> > +
> > +	return sky81452_register_devices(dev, pdata);
> > +}
> > +
> > +static int sky81452_remove(struct i2c_client *client)
> > +{
> > +	mfd_remove_devices(&client->dev);
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id sky81452_ids[] = {
> > +	{"sky81452", 0},
> 
> Space between braces and content please.
> 
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, sky81452_ids);
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id sky81452_of_match[] = {
> > +	{.compatible = "sky,sky81452",},
> 
> Space between braces and content.
> 
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, sky81452_of_match);
> > +#endif
> 
> The #ifdefery here is not needed since you use of_match_ptr below, whcih
> will expand to NULL of CONFIG_OF is not set.
> 
> > +
> > +static struct i2c_driver sky81452_driver = {
> > +	.driver = {
> > +		.name = "sky81452",
> > +		.owner = THIS_MODULE,
> 
> No need to set this here, module_i2c_driver/i2c_register_driver will
> take care of it.
> 
> > +		.of_match_table = of_match_ptr(sky81452_of_match),
> > +	},
> > +	.probe = sky81452_probe,
> > +	.remove = sky81452_remove,
> > +	.id_table = sky81452_ids,
> > +};
> > +
> > +module_i2c_driver(sky81452_driver);
> > +
> > +MODULE_DESCRIPTION("Skyworks SKY81452 MFD driver");
> > +MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION("1.0");
> 
> [...]
> 
> > diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
> > new file mode 100644
> > index 0000000..15a7c0a
> > --- /dev/null
> > +++ b/drivers/regulator/sky81452-regulator.c
> > @@ -0,0 +1,127 @@
> 
> [...]
> 
> > +#ifdef CONFIG_OF
> > +static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
> > +{
> > +	struct regulator_init_data *init_data;
> > +	struct device_node *np;
> > +
> > +	np = of_get_child_by_name(dev->parent->of_node, "regulator");
> > +	if (unlikely(!np)) {
> > +		dev_err(dev, "regulator node not found");
> > +		return NULL;
> > +	}
> > +
> > +	init_data = of_get_regulator_init_data(dev, np);
> > +
> > +	of_node_put(np);
> > +	return init_data;
> > +}
> > +#endif
> > +
> > +static int sky81452_reg_probe(struct platform_device *pdev)
> > +{
> > +	const struct regulator_init_data *init_data;
> > +	struct device *dev = &pdev->dev;
> > +	struct regulator_config config = { };
> > +	struct regulator_dev *rdev;
> > +
> > +#ifdef CONFIG_OF
> > +	init_data = sky81452_reg_parse_dt(dev);
> > +#else
> > +	init_data = dev_get_platdata(dev);
> > +#endif
> 
> Better make the implementation of sky81452_reg_parse_dt dependent on
> CONFIG_OF and just return dev_get_platdata(dev) in case of !CONFIG_OF.
> You could then also rename sky81452_reg_parse_dt to something like
> sky81452_reg_get_init_data.
> 
> > +	if (unlikely(!init_data))
> > +		return -EINVAL;
> > +
> > +	config.dev = dev;
> > +	config.init_data = init_data;
> > +	config.of_node = dev->of_node;
> > +	config.regmap = dev_get_drvdata(dev->parent);
> > +
> > +	rdev = devm_regulator_register(dev, &sky81452_reg, &config);
> > +	if (IS_ERR(rdev))
> > +		return PTR_ERR(rdev);
> > +
> > +	platform_set_drvdata(pdev, rdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver sky81452_reg_driver = {
> > +	.driver = {
> > +		.name = "sky81452-regulator",
> > +		.owner = THIS_MODULE,
> 
> Not needed, this will be set by
> module_platform_driver/platform_driver_register
> 
> > +	},
> > +	.probe = sky81452_reg_probe,
> > +};
> > +
> > +module_platform_driver(sky81452_reg_driver);
> > +
> > +MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
> > +MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION("1.0");
> 
> [...]
> 
> > diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
> > new file mode 100644
> > index 0000000..1eb5706
> > --- /dev/null
> > +++ b/drivers/video/backlight/sky81452-backlight.c
> > @@ -0,0 +1,333 @@
> 
> [...]
> 
> > +#ifdef CONFIG_OF
> > +static struct sky81452_bl_platform_data *sky81452_bl_parse_dt
> > +		(struct device *dev)
> > +{
> > +	struct device_node *np = dev->parent->of_node;
> > +	struct sky81452_bl_platform_data *pdata;
> > +	int ret;
> > +
> > +	np = of_get_child_by_name(dev->parent->of_node, "backlight");
> > +	if (unlikely(!np)) {
> > +		dev_err(dev, "backlight node not found");
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (unlikely(!pdata)) {
> > +		of_node_put(np);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	of_property_read_string(np, "name", &pdata->name);
> > +	pdata->ignore_pwm = of_property_read_bool(np, "ignore-pwm");
> > +	pdata->dpwm_mode = of_property_read_bool(np, "dpwm-mode");
> > +	pdata->phase_shift = of_property_read_bool(np, "phase-shift");
> > +
> > +	pdata->gpio_enable = of_get_named_gpio(np, "gpio-enable", 0);
> > +	if (IS_ERR_VALUE(pdata->gpio_enable))
> > +		pdata->gpio_enable = -1;
> > +
> > +	ret = of_property_read_u32(np, "enable", &pdata->enable);
> > +	if (IS_ERR_VALUE(ret))
> > +		pdata->enable = SKY81452_EN >> CTZ(SKY81452_EN);
> > +
> > +	ret = of_property_read_u32(np, "short-detection-threshold",
> > +			&pdata->short_detection_threshold);
> > +	if (IS_ERR_VALUE(ret))
> > +		pdata->short_detection_threshold = 7;
> > +
> > +	ret = of_property_read_u32(np, "boost-current-limit",
> > +			&pdata->boost_current_limit);
> > +	if (IS_ERR_VALUE(ret))
> > +		pdata->boost_current_limit = 2750;
> > +
> > +	of_node_put(np);
> > +	return pdata;
> > +}
> > +#endif
> > +
> > +static int sky81452_bl_init_device(struct regmap *map,
> > +		struct sky81452_bl_platform_data *pdata)
> > +{
> > +	unsigned int value;
> > +
> > +	value = pdata->ignore_pwm ? SKY81452_IGPW : 0;
> > +	value |= pdata->dpwm_mode ? SKY81452_PWMMD : 0;
> > +	value |= pdata->phase_shift ? 0 : SKY81452_PHASE;
> > +
> > +	if (pdata->boost_current_limit == 2300)
> > +		value |= SKY81452_ILIM;
> > +	else if (pdata->boost_current_limit != 2720)
> > +		return -EINVAL;
> > +
> > +	if (pdata->short_detection_threshold < 4 ||
> > +			pdata->short_detection_threshold > 7)
> > +		return -EINVAL;
> > +	value |= (7 - pdata->short_detection_threshold) << CTZ(SKY81452_VSHRT);
> > +
> > +	return regmap_write(map, SKY81452_REG2, value);
> > +}
> > +
> > +static int sky81452_bl_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct regmap *map = dev_get_drvdata(dev->parent);
> > +	struct sky81452_bl_platform_data *pdata;
> > +	struct backlight_device *bd;
> > +	struct backlight_properties props;
> > +	const char *name;
> > +	int ret;
> > +
> > +#ifdef CONFIG_OF
> > +	pdata = sky81452_bl_parse_dt(dev);
> > +	if (IS_ERR(pdata))
> > +		return PTR_ERR(pdata);
> > +	dev->platform_data = pdata;
> > +#else
> > +	pdata = dev_get_platdata(dev);
> > +	if (unlikely(!pdata))
> 
> No need to use unlikely() here.
> 
> > +		return -EINVAL;
> > +#endif
> 
> Instead of the #ifdefery here, better define a function
> sky81452_get_pdata() dependent on CONFIG_OF which will return the right
> thing (i.e. what sky81452_bl_parse_dt currently does if CONFIG_OF is
> defined and dev_get_platdata or ERR_PTR(-EINVAL) if it is not
> defined). Then you could just do:
> 
> pdata = skysky81452_get_pdata(dev);
> if (IS_ERR(pdata))
> 	return PTR_ERR(pdata);
> 
> > +
> > +	if (pdata->gpio_enable >= 0) {
> > +		ret = devm_gpio_request_one(dev, pdata->gpio_enable,
> > +				GPIOF_OUT_INIT_HIGH, "sky81452-en");
> > +		if (IS_ERR_VALUE(ret))
> > +			return ret;
> > +	}
> > +
> > +	ret = sky81452_bl_init_device(map, pdata);
> > +	if (IS_ERR_VALUE(ret))
> > +		return ret;
> > +
> > +	memset(&props, 0, sizeof(props));
> > +	props.max_brightness = SKY81452_MAX_BRIGHTNESS,
> > +	name = pdata->name ? pdata->name : SKY81452_DEFAULT_NAME;
> > +	bd = devm_backlight_device_register(dev, name,
> > +			dev, map, &sky81452_bl_ops, &props);
> > +	if (IS_ERR(bd))
> > +		return PTR_ERR(bd);
> > +
> > +	platform_set_drvdata(pdev, bd);
> > +
> > +	ret  = sysfs_create_group(&bd->dev.kobj, &sky81452_bl_attr_group);
> > +	if (IS_ERR_VALUE(ret))
> > +		goto err;
> > +
> > +	return ret;
> > +err:
> > +	backlight_device_unregister(bd);
> > +	return ret;
> > +}
> > +
> > +static int sky81452_bl_remove(struct platform_device *pdev)
> > +{
> > +	const struct sky81452_bl_platform_data *pdata =
> > +			dev_get_platdata(&pdev->dev);
> > +	struct backlight_device *bd = platform_get_drvdata(pdev);
> > +
> > +	sysfs_remove_group(&bd->dev.kobj, &sky81452_bl_attr_group);
> > +
> > +	bd->props.power = FB_BLANK_UNBLANK;
> > +	bd->props.brightness = 0;
> > +	backlight_update_status(bd);
> > +
> > +	if (pdata->gpio_enable >= 0)
> > +		gpio_set_value_cansleep(pdata->gpio_enable, 0);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver sky81452_bl_driver = {
> > +	.driver = {
> > +		.name = "sky81452-bl",
> > +		.owner = THIS_MODULE,
> 
> module_platform_driver/platform_driver_register take care of this.
> 
> > +	},
> > +	.probe = sky81452_bl_probe,
> > +	.remove = sky81452_bl_remove,
> > +};
> > +
> > +module_platform_driver(sky81452_bl_driver);
> > +
> > +MODULE_DESCRIPTION("Skyworks SKY81452 backlight driver");
> > +MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION("1.0");
