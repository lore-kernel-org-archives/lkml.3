Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3BEJJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:09:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3BEJI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:08:58 -0500
Date: Tue, 5 Feb 2013 10:08:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Jingoo Han <jg1.han@samsung.com>
cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-sh@vger.kernel.org, "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: add an AS3711 PMIC backlight driver
In-Reply-To: <00fe01cdfcf1$dcfdc970$96f95c50$%han@samsung.com>
Message-ID: <Pine.LNX.4.64.1302051004320.1275@axis700.grange>
References: <Pine.LNX.4.64.1301081846020.1794@axis700.grange>
 <00c901cdfabb$a9989570$fcc9c050$%han@samsung.com>
 <Pine.LNX.4.64.1301250836280.17518@axis700.grange>
 <00fe01cdfcf1$dcfdc970$96f95c50$%han@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:/ijg/wktXPVo42EdwJhMGLtNuYykEiiaHUsovjuldgE
 QRlkBum1Cr/r4zsG/yXxE29biEOvaz6+dc1qmkz+pdBVq5YsPZ
 w1EAHwQAzeyTyCyIfe2W3rD8QVkrtf2wyjU4YuFDJLuBuzRw7q
 9K5vwQH3DsUMM1jNnXqnd1Y/KRcrg5Duj1xOcf0M0i+ewyIDtA
 xUJDI7BzCseRulj4Csun30E1v0Af66esn4MgaH+tZqYJj1u4QZ
 F+ABVHCvW2IrczYGmi4yyM8ZmeW1ZRcNuJ1Vrr6JJQxmHpFvpF
 WXP51NCVkiIB772dqC1VpQPzJJCUon0v8KX6rj88fwnagkwDLW
 xLJ88jgFaAki0Z/vG6KXEUIdpbKHCKlrEqBDmy1YLNE5+SXCza
 31Fld9mARpzIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard

Could you tell us your opinion on this:

On Mon, 28 Jan 2013, Jingoo Han wrote:

> On Friday, January 25, 2013 4:49 PM, Guennadi Liakhovetski wrote
> > 
> > Hi Jingoo Han
> > 
> > On Fri, 25 Jan 2013, Jingoo Han wrote:
> > 
> > > On Wednesday, January 09, 2013 2:55 AM, Guennadi Liakhovetski wrote
> > > >
> > > > This is an initial commit of a backlight driver, using step-up DCDC power
> > > > supplies on AS3711 PMIC. Only one mode has actually been tested, several
> > > > further modes have been implemented "dry," but disabled to avoid accidental
> > > > hardware damage. Anyone wishing to use any of those modes will have to
> > > > modify the driver.
> > > >
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > >
> > > CC'ed Andrew Morton.
> > >
> > > Hi Guennadi Liakhovetski,
> > >
> > > I have reviewed this patch with AS3711 datasheet.
> > > I cannot find any problems. It looks good.
> > 
> > Thanks for the review.
> > 
> > > However, some hardcoded numbers need to be changed
> > > to the bit definitions.
> > 
> > Which specific hardcoded values do you mean? A while ago in a discussion
> > on one of kernel mailing lists a conclusion has been made, that macros do
> > not always improve code readability. E.g. in a statement like this
> > 
> > +	case AS3711_SU2_CURR_AUTO:
> > +		if (pdata->su2_auto_curr1)
> > +			ctl = 2;
> > +		if (pdata->su2_auto_curr2)
> > +			ctl |= 8;
> > +		if (pdata->su2_auto_curr3)
> > +			ctl |= 0x20;
> > 
> > making it
> > 
> > +	case AS3711_SU2_CURR_AUTO:
> > +		if (pdata->su2_auto_curr1)
> > +			ctl = SU2_AUTO_CURR1;
> > 
> > would hardly make it more readable. IMHO it is already pretty clear, that
> > bit 1 enables the current-1 sink. As long as these fields are only used at
> > one location in the driver (and they are), using a macro and defining it
> > elsewhere only makes it harder to see actual values. Speaking of this, a
> > comment like
> 
> I don't think so. Some people feel that it is not clear a bit.
> Of course, I know what you mean.
> Also, your comment is reasonable.
> However, personally, I prefer the latter.
> Because, I think that the meaning of bits is more important than
> actual bits. In the latter case, we can notice the meaning of bits
> more easily.

Do you also find preferable to use symbolic names for every single bit, 
occurring in a driver, or you agree, that excessive use of such macros can 
only needlessly clutter the code?

Thanks
Guennadi

> Best regards,
> Jingoo Han
> 
> > 
> > 		/*
> > 		 * Select, which current sinks shall be used for automatic
> > 		 * feedback selection
> > 		 */
> > 
> > would help much more than any macro names. But as it stands, I think the
> > current version is also possible to understand :-) If desired, however,
> > comments can be added in an incremental patch
> 
> > 
> > Thanks
> > Guennadi
> > 
> > > Acked-by: Jingoo Han <jg1.han@samsung.com>
> > >
> > >
> > > Best regards,
> > > Jingoo Han
> > >
> > > > ---
> > > >
> > > > Tested on sh73a0-based kzm9g board. As the commit message says, only one
> > > > mode has been tested and is enabled. That mode copies the sample code from
> > > > the manufacturer. Deviations from that code proved to be fatal for the
> > > > hardware...
> > > >
> > > >  drivers/video/backlight/Kconfig     |    7 +
> > > >  drivers/video/backlight/Makefile    |    1 +
> > > >  drivers/video/backlight/as3711_bl.c |  379 +++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 387 insertions(+), 0 deletions(-)
> > > >  create mode 100644 drivers/video/backlight/as3711_bl.c
> > > >
> > > > diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> > > > index 765a945..6ef0ede 100644
> > > > --- a/drivers/video/backlight/Kconfig
> > > > +++ b/drivers/video/backlight/Kconfig
> > > > @@ -390,6 +390,13 @@ config BACKLIGHT_TPS65217
> > > >  	  If you have a Texas Instruments TPS65217 say Y to enable the
> > > >  	  backlight driver.
> > > >
> > > > +config BACKLIGHT_AS3711
> > > > +	tristate "AS3711 Backlight"
> > > > +	depends on BACKLIGHT_CLASS_DEVICE && MFD_AS3711
> > > > +	help
> > > > +	  If you have an Austrian Microsystems AS3711 say Y to enable the
> > > > +	  backlight driver.
> > > > +
> > > >  endif # BACKLIGHT_CLASS_DEVICE
> > > >
> > > >  endif # BACKLIGHT_LCD_SUPPORT
> > > > diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> > > > index e7ce729..d3e188f 100644
> > > > --- a/drivers/video/backlight/Makefile
> > > > +++ b/drivers/video/backlight/Makefile
> > > > @@ -45,3 +45,4 @@ obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
> > > >  obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
> > > >  obj-$(CONFIG_BACKLIGHT_OT200) += ot200_bl.o
> > > >  obj-$(CONFIG_BACKLIGHT_TPS65217) += tps65217_bl.o
> > > > +obj-$(CONFIG_BACKLIGHT_AS3711) += as3711_bl.o
> > > > diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
> > > > new file mode 100644
> > > > index 0000000..c6bc65d
> > > > --- /dev/null
> > > > +++ b/drivers/video/backlight/as3711_bl.c
> > > > @@ -0,0 +1,379 @@
> > > > +/*
> > > > + * AS3711 PMIC backlight driver, using DCDC Step Up Converters
> > > > + *
> > > > + * Copyright (C) 2012 Renesas Electronics Corporation
> > > > + * Author: Guennadi Liakhovetski, <g.liakhovetski@gmx.de>
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or modify
> > > > + * it under the terms of the version 2 of the GNU General Public License as
> > > > + * published by the Free Software Foundation
> > > > + */
> > > > +
> > > > +#include <linux/backlight.h>
> > > > +#include <linux/delay.h>
> > > > +#include <linux/device.h>
> > > > +#include <linux/err.h>
> > > > +#include <linux/fb.h>
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/mfd/as3711.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/regmap.h>
> > > > +#include <linux/slab.h>
> > > > +
> > > > +enum as3711_bl_type {
> > > > +	AS3711_BL_SU1,
> > > > +	AS3711_BL_SU2,
> > > > +};
> > > > +
> > > > +struct as3711_bl_data {
> > > > +	bool powered;
> > > > +	const char *fb_name;
> > > > +	struct device *fb_dev;
> > > > +	enum as3711_bl_type type;
> > > > +	int brightness;
> > > > +	struct backlight_device *bl;
> > > > +};
> > > > +
> > > > +struct as3711_bl_supply {
> > > > +	struct as3711_bl_data su1;
> > > > +	struct as3711_bl_data su2;
> > > > +	const struct as3711_bl_pdata *pdata;
> > > > +	struct as3711 *as3711;
> > > > +};
> > > > +
> > > > +static struct as3711_bl_supply *to_supply(struct as3711_bl_data *su)
> > > > +{
> > > > +	switch (su->type) {
> > > > +	case AS3711_BL_SU1:
> > > > +		return container_of(su, struct as3711_bl_supply, su1);
> > > > +	case AS3711_BL_SU2:
> > > > +		return container_of(su, struct as3711_bl_supply, su2);
> > > > +	}
> > > > +	return NULL;
> > > > +}
> > > > +
> > > > +static int as3711_set_brightness_auto_i(struct as3711_bl_data *data,
> > > > +					unsigned int brightness)
> > > > +{
> > > > +	struct as3711_bl_supply *supply = to_supply(data);
> > > > +	struct as3711 *as3711 = supply->as3711;
> > > > +	const struct as3711_bl_pdata *pdata = supply->pdata;
> > > > +	int ret = 0;
> > > > +
> > > > +	/* Only all equal current values are supported */
> > > > +	if (pdata->su2_auto_curr1)
> > > > +		ret = regmap_write(as3711->regmap, AS3711_CURR1_VALUE,
> > > > +				   brightness);
> > > > +	if (!ret && pdata->su2_auto_curr2)
> > > > +		ret = regmap_write(as3711->regmap, AS3711_CURR2_VALUE,
> > > > +				   brightness);
> > > > +	if (!ret && pdata->su2_auto_curr3)
> > > > +		ret = regmap_write(as3711->regmap, AS3711_CURR3_VALUE,
> > > > +				   brightness);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int as3711_set_brightness_v(struct as3711 *as3711,
> > > > +				   unsigned int brightness,
> > > > +				   unsigned int reg)
> > > > +{
> > > > +	if (brightness > 31)
> > > > +		return -EINVAL;
> > > > +
> > > > +	return regmap_update_bits(as3711->regmap, reg, 0xf0,
> > > > +				  brightness << 4);
> > > > +}
> > > > +
> > > > +static int as3711_bl_su2_reset(struct as3711_bl_supply *supply)
> > > > +{
> > > > +	struct as3711 *as3711 = supply->as3711;
> > > > +	int ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_5,
> > > > +				     3, supply->pdata->su2_fbprot);
> > > > +	if (!ret)
> > > > +		ret = regmap_update_bits(as3711->regmap,
> > > > +					 AS3711_STEPUP_CONTROL_2, 1, 0);
> > > > +	if (!ret)
> > > > +		ret = regmap_update_bits(as3711->regmap,
> > > > +					 AS3711_STEPUP_CONTROL_2, 1, 1);
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Someone with less fragile or less expensive hardware could try to simplify
> > > > + * the brightness adjustment procedure.
> > > > + */
> > > > +static int as3711_bl_update_status(struct backlight_device *bl)
> > > > +{
> > > > +	struct as3711_bl_data *data = bl_get_data(bl);
> > > > +	struct as3711_bl_supply *supply = to_supply(data);
> > > > +	struct as3711 *as3711 = supply->as3711;
> > > > +	int brightness = bl->props.brightness;
> > > > +	int ret = 0;
> > > > +
> > > > +	dev_dbg(&bl->dev, "%s(): brightness %u, pwr %x, blank %x, state %x\n",
> > > > +		__func__, bl->props.brightness, bl->props.power,
> > > > +		bl->props.fb_blank, bl->props.state);
> > > > +
> > > > +	if (bl->props.power != FB_BLANK_UNBLANK ||
> > > > +	    bl->props.fb_blank != FB_BLANK_UNBLANK ||
> > > > +	    bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
> > > > +		brightness = 0;
> > > > +
> > > > +	if (data->type == AS3711_BL_SU1) {
> > > > +		ret = as3711_set_brightness_v(as3711, brightness,
> > > > +					      AS3711_STEPUP_CONTROL_1);
> > > > +	} else {
> > > > +		const struct as3711_bl_pdata *pdata = supply->pdata;
> > > > +
> > > > +		switch (pdata->su2_feedback) {
> > > > +		case AS3711_SU2_VOLTAGE:
> > > > +			ret = as3711_set_brightness_v(as3711, brightness,
> > > > +						      AS3711_STEPUP_CONTROL_2);
> > > > +			break;
> > > > +		case AS3711_SU2_CURR_AUTO:
> > > > +			ret = as3711_set_brightness_auto_i(data, brightness / 4);
> > > > +			if (ret < 0)
> > > > +				return ret;
> > > > +			if (brightness) {
> > > > +				ret = as3711_bl_su2_reset(supply);
> > > > +				if (ret < 0)
> > > > +					return ret;
> > > > +				udelay(500);
> > > > +				ret = as3711_set_brightness_auto_i(data, brightness);
> > > > +			} else {
> > > > +				ret = regmap_update_bits(as3711->regmap,
> > > > +						AS3711_STEPUP_CONTROL_2, 1, 0);
> > > > +			}
> > > > +			break;
> > > > +		/* Manual one current feedback pin below */
> > > > +		case AS3711_SU2_CURR1:
> > > > +			ret = regmap_write(as3711->regmap, AS3711_CURR1_VALUE,
> > > > +					   brightness);
> > > > +			break;
> > > > +		case AS3711_SU2_CURR2:
> > > > +			ret = regmap_write(as3711->regmap, AS3711_CURR2_VALUE,
> > > > +					   brightness);
> > > > +			break;
> > > > +		case AS3711_SU2_CURR3:
> > > > +			ret = regmap_write(as3711->regmap, AS3711_CURR3_VALUE,
> > > > +					   brightness);
> > > > +			break;
> > > > +		default:
> > > > +			ret = -EINVAL;
> > > > +		}
> > > > +	}
> > > > +	if (!ret)
> > > > +		data->brightness = brightness;
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int as3711_bl_get_brightness(struct backlight_device *bl)
> > > > +{
> > > > +	struct as3711_bl_data *data = bl_get_data(bl);
> > > > +
> > > > +	return data->brightness;
> > > > +}
> > > > +
> > > > +static const struct backlight_ops as3711_bl_ops = {
> > > > +	.update_status	= as3711_bl_update_status,
> > > > +	.get_brightness	= as3711_bl_get_brightness,
> > > > +};
> > > > +
> > > > +static int as3711_bl_init_su2(struct as3711_bl_supply *supply)
> > > > +{
> > > > +	struct as3711 *as3711 = supply->as3711;
> > > > +	const struct as3711_bl_pdata *pdata = supply->pdata;
> > > > +	u8 ctl = 0;
> > > > +	int ret;
> > > > +
> > > > +	dev_dbg(as3711->dev, "%s(): use %u\n", __func__, pdata->su2_feedback);
> > > > +
> > > > +	/* Turn SU2 off */
> > > > +	ret = regmap_write(as3711->regmap, AS3711_STEPUP_CONTROL_2, 0);
> > > > +	if (ret < 0)
> > > > +		return ret;
> > > > +
> > > > +	switch (pdata->su2_feedback) {
> > > > +	case AS3711_SU2_VOLTAGE:
> > > > +		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 0);
> > > > +		break;
> > > > +	case AS3711_SU2_CURR1:
> > > > +		ctl = 1;
> > > > +		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 1);
> > > > +		break;
> > > > +	case AS3711_SU2_CURR2:
> > > > +		ctl = 4;
> > > > +		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 2);
> > > > +		break;
> > > > +	case AS3711_SU2_CURR3:
> > > > +		ctl = 0x10;
> > > > +		ret = regmap_update_bits(as3711->regmap, AS3711_STEPUP_CONTROL_4, 3, 3);
> > > > +		break;
> > > > +	case AS3711_SU2_CURR_AUTO:
> > > > +		if (pdata->su2_auto_curr1)
> > > > +			ctl = 2;
> > > > +		if (pdata->su2_auto_curr2)
> > > > +			ctl |= 8;
> > > > +		if (pdata->su2_auto_curr3)
> > > > +			ctl |= 0x20;
> > > > +		ret = 0;
> > > > +		break;
> > > > +	default:
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	if (!ret)
> > > > +		ret = regmap_write(as3711->regmap, AS3711_CURR_CONTROL, ctl);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int as3711_bl_register(struct platform_device *pdev,
> > > > +			      unsigned int max_brightness, struct as3711_bl_data *su)
> > > > +{
> > > > +	struct backlight_properties props = {.type = BACKLIGHT_RAW,};
> > > > +	struct backlight_device *bl;
> > > > +
> > > > +	/* max tuning I = 31uA for voltage- and 38250uA for current-feedback */
> > > > +	props.max_brightness = max_brightness;
> > > > +
> > > > +	bl = backlight_device_register(su->type == AS3711_BL_SU1 ?
> > > > +				       "as3711-su1" : "as3711-su2",
> > > > +				       &pdev->dev, su,
> > > > +				       &as3711_bl_ops, &props);
> > > > +	if (IS_ERR(bl)) {
> > > > +		dev_err(&pdev->dev, "failed to register backlight\n");
> > > > +		return PTR_ERR(bl);
> > > > +	}
> > > > +
> > > > +	bl->props.brightness = props.max_brightness;
> > > > +
> > > > +	backlight_update_status(bl);
> > > > +
> > > > +	su->bl = bl;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int as3711_backlight_probe(struct platform_device *pdev)
> > > > +{
> > > > +	struct as3711_bl_pdata *pdata = dev_get_platdata(&pdev->dev);
> > > > +	struct as3711 *as3711 = dev_get_drvdata(pdev->dev.parent);
> > > > +	struct as3711_bl_supply *supply;
> > > > +	struct as3711_bl_data *su;
> > > > +	unsigned int max_brightness;
> > > > +	int ret;
> > > > +
> > > > +	if (!pdata || (!pdata->su1_fb && !pdata->su2_fb)) {
> > > > +		dev_err(&pdev->dev, "No platform data, exiting...\n");
> > > > +		return -ENODEV;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * Due to possible hardware damage I chose to block all modes,
> > > > +	 * unsupported on my hardware. Anyone, wishing to use any of those modes
> > > > +	 * will have to first review the code, then activate and test it.
> > > > +	 */
> > > > +	if (pdata->su1_fb ||
> > > > +	    pdata->su2_fbprot != AS3711_SU2_GPIO4 ||
> > > > +	    pdata->su2_feedback != AS3711_SU2_CURR_AUTO) {
> > > > +		dev_warn(&pdev->dev,
> > > > +			 "Attention! An untested mode has been chosen!\n"
> > > > +			 "Please, review the code, enable, test, and report success:-)\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +
> > > > +	supply = devm_kzalloc(&pdev->dev, sizeof(*supply), GFP_KERNEL);
> > > > +	if (!supply)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	supply->as3711 = as3711;
> > > > +	supply->pdata = pdata;
> > > > +
> > > > +	if (pdata->su1_fb) {
> > > > +		su = &supply->su1;
> > > > +		su->fb_name = pdata->su1_fb;
> > > > +		su->type = AS3711_BL_SU1;
> > > > +
> > > > +		max_brightness = min(pdata->su1_max_uA, 31);
> > > > +		ret = as3711_bl_register(pdev, max_brightness, su);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +	}
> > > > +
> > > > +	if (pdata->su2_fb) {
> > > > +		su = &supply->su2;
> > > > +		su->fb_name = pdata->su2_fb;
> > > > +		su->type = AS3711_BL_SU2;
> > > > +
> > > > +		switch (pdata->su2_fbprot) {
> > > > +		case AS3711_SU2_GPIO2:
> > > > +		case AS3711_SU2_GPIO3:
> > > > +		case AS3711_SU2_GPIO4:
> > > > +		case AS3711_SU2_LX_SD4:
> > > > +			break;
> > > > +		default:
> > > > +			ret = -EINVAL;
> > > > +			goto esu2;
> > > > +		}
> > > > +
> > > > +		switch (pdata->su2_feedback) {
> > > > +		case AS3711_SU2_VOLTAGE:
> > > > +			max_brightness = min(pdata->su2_max_uA, 31);
> > > > +			break;
> > > > +		case AS3711_SU2_CURR1:
> > > > +		case AS3711_SU2_CURR2:
> > > > +		case AS3711_SU2_CURR3:
> > > > +		case AS3711_SU2_CURR_AUTO:
> > > > +			max_brightness = min(pdata->su2_max_uA / 150, 255);
> > > > +			break;
> > > > +		default:
> > > > +			ret = -EINVAL;
> > > > +			goto esu2;
> > > > +		}
> > > > +
> > > > +		ret = as3711_bl_init_su2(supply);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +
> > > > +		ret = as3711_bl_register(pdev, max_brightness, su);
> > > > +		if (ret < 0)
> > > > +			goto esu2;
> > > > +	}
> > > > +
> > > > +	platform_set_drvdata(pdev, supply);
> > > > +
> > > > +	return 0;
> > > > +
> > > > +esu2:
> > > > +	backlight_device_unregister(supply->su1.bl);
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int as3711_backlight_remove(struct platform_device *pdev)
> > > > +{
> > > > +	struct as3711_bl_supply *supply = platform_get_drvdata(pdev);
> > > > +
> > > > +	backlight_device_unregister(supply->su1.bl);
> > > > +	backlight_device_unregister(supply->su2.bl);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static struct platform_driver as3711_backlight_driver = {
> > > > +	.driver		= {
> > > > +		.name	= "as3711-backlight",
> > > > +		.owner	= THIS_MODULE,
> > > > +	},
> > > > +	.probe		= as3711_backlight_probe,
> > > > +	.remove		= as3711_backlight_remove,
> > > > +};
> > > > +
> > > > +module_platform_driver(as3711_backlight_driver);
> > > > +
> > > > +MODULE_DESCRIPTION("Backlight Driver for AS3711 PMICs");
> > > > +MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de");
> > > > +MODULE_LICENSE("GPL");
> > > > +MODULE_ALIAS("platform:as3711-backlight");
> > > > --
> > > > 1.7.2.5
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
