Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaLRX5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:57:30 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3851 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbaLRX53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:57:29 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Thu, 18 Dec 2014 15:57:22 -0800
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 2/2] leds: add Qualcomm PM8941 WLED driver
Message-ID: <20141218235721.GF19036@sonymobile.com>
References: <1418084551-28946-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1418084551-28946-2-git-send-email-bjorn.andersson@sonymobile.com>
 <5490D92A.3070107@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5490D92A.3070107@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16 Dec 17:15 PST 2014, Stephen Boyd wrote:

> On 12/08/2014 04:22 PM, Bjorn Andersson wrote:
> > diff --git a/drivers/leds/leds-pm8941-wled.c b/drivers/leds/leds-pm8941-wled.c

[..]

> > +#include <linux/leds.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> > +#include <linux/regmap.h>
> 
> Missing <linux/kernel.h> for container_of() macro.
> 

Thanks

> > +
> > +enum pm8941_wled_reg {
> > +	PM8941_WLED_REG_VAL_BASE		= 0x40,
> > +#define PM8941_WLED_REG_VAL_MAX			0xFFF
> > +
> > +	PM8941_WLED_REG_MOD_EN			= 0x46,
> > +#define PM8941_WLED_REG_MOD_EN_BIT		BIT(7)
> > +#define PM8941_WLED_REG_MOD_EN_MASK		BIT(7)
> > +
> > +	PM8941_WLED_REG_SYNC			= 0x47,
> > +#define PM8941_WLED_REG_SYNC_MASK		0x07
> > +#define PM8941_WLED_REG_SYNC_LED1		BIT(0)
> > +#define PM8941_WLED_REG_SYNC_LED2		BIT(1)
> > +#define PM8941_WLED_REG_SYNC_LED3		BIT(2)
> > +#define PM8941_WLED_REG_SYNC_ALL		0x07
> > +#define PM8941_WLED_REG_SYNC_CLEAR		0x00
> > +
> > +	PM8941_WLED_REG_FREQ			= 0x4c,
> > +#define PM8941_WLED_REG_FREQ_MASK		0x0f
> > +
> > +	PM8941_WLED_REG_OVP			= 0x4d,
> > +#define PM8941_WLED_REG_OVP_MASK		0x03
> > +
> > +	PM8941_WLED_REG_BOOST			= 0x4e,
> > +#define PM8941_WLED_REG_BOOST_MASK		0x07
> > +
> > +	PM8941_WLED_REG_SINK			= 0x4f,
> > +#define PM8941_WLED_REG_SINK_MASK		0xe0
> > +#define PM8941_WLED_REG_SINK_SHFT		0x05
> > +
> > +/* Per-'string' registers below */
> > +#define PM8941_WLED_REG_STR_OFFSET		0x10
> > +
> > +	PM8941_WLED_REG_STR_MOD_EN_BASE		= 0x60,
> > +#define PM8941_WLED_REG_STR_MOD_EN		BIT(7)
> > +#define PM8941_WLED_REG_STR_MOD_MASK		BIT(7)
> > +
> > +	PM8941_WLED_REG_STR_SCALE_BASE		= 0x62,
> > +#define PM8941_WLED_REG_STR_SCALE_MASK		0x1f
> > +
> > +	PM8941_WLED_REG_STR_MOD_SRC_BASE	= 0x63,
> > +#define PM8941_WLED_REG_STR_MOD_SRC_MASK	0x01
> > +#define PM8941_WLED_REG_STR_MOD_SRC_INT		0x00
> > +#define PM8941_WLED_REG_STR_MOD_SRC_EXT		0x01
> > +
> > +	PM8941_WLED_REG_STR_CABC_BASE		= 0x66,
> > +#define PM8941_WLED_REG_STR_CABC_MASK		BIT(7)
> > +#define PM8941_WLED_REG_STR_CABC_EN		BIT(7)
> > +};
> 
> I don't see any value in this enum. It's never used in a switch
> statement so why not just have #defines for the register offsets. It
> would make reading this a lot easier too.
> 

Make sense, I'll rework it.

> > +
> > +static int pm8941_wled_set(struct led_classdev *cdev,
> > +			   enum led_brightness value)
> > +{
> > +	struct pm8941_wled_context *ctx;
> > +	struct pm8941_wled *wled;
> > +	u8 ctrl = 0;
> > +	u16 val;
> > +	int rc;
> > +	int i;
> > +
> > +	wled = container_of(cdev, struct pm8941_wled, cdev);
> > +	ctx = container_of(wled, struct pm8941_wled_context, wled);
> > +
> > +	if (value != 0)
> > +		ctrl = PM8941_WLED_REG_MOD_EN_BIT;
> > +
> > +	val = (value * PM8941_WLED_REG_VAL_MAX) / LED_FULL;
> 
> Unnecessary parens here.
> 

Agreed

> > +
> > +	rc = regmap_update_bits(ctx->regmap,
> >
> > +
> > +static int pm8941_wled_configure(struct pm8941_wled *wled, struct device *dev)
> > +{
> [...]
> > +
> > +	if (dev->of_node == NULL) {
> > +		dev_err(dev, "no OF node!\n");
> > +		return -EINVAL;
> > +	}
> 
> Seems like an unnecessary check. Everything's DT so far.
> 

Agreed.

> > +
> > +	rc = of_property_read_u32(dev->of_node, "reg", &val);
> > +	if (rc || val > 0xffff) {
> > +		dev_err(dev, "invalid IO resources\n");
> > +		return rc ? rc : -EINVAL;
> > +	}
> > +	wled->addr = val;
> > +
> > +	rc = of_property_read_string(dev->of_node, "label", &wled->cdev.name);
> > +	if (rc)
> > +		wled->cdev.name = dev->of_node->name;
> > +
> > +	wled->cdev.default_trigger = of_get_property(dev->of_node,
> > +			"linux,default-trigger", NULL);
> > +
> > +	*cfg = pm8941_wled_config_defaults;
> > +	for (i = 0; i < ARRAY_SIZE(u32_opts); ++i) {
> > +		u32 sel, c;
> > +		int j, rj;
> > +
> > +		rc = of_property_read_u32(dev->of_node, u32_opts[i].name, &val);
> > +		if (rc) {
> > +			if (rc != -EINVAL) {
> > +				dev_err(dev, "error reading '%s'\n",
> > +						u32_opts[i].name);
> > +				return rc;
> > +			}
> > +			continue;
> > +		}
> > +
> > +		sel = UINT_MAX;
> > +		rj = -1;
> > +		c = pm8941_wled_values(u32_opts[i].cfg, 0);
> > +		for (j = 0; c != UINT_MAX; ++j) {
> > +			if (c <= val && (sel == UINT_MAX || c >= sel)) {
> > +				sel = c;
> > +				rj = j;
> > +			}
> > +			c = pm8941_wled_values(u32_opts[i].cfg, j + 1);
> > +		}
> > +		if (sel == UINT_MAX) {
> > +			dev_err(dev, "invalid value for '%s'\n",
> > +					u32_opts[i].name);
> > +			return rc;
> > +		}
> > +		if (sel != val) {
> > +			dev_warn(dev, "rounding '%s' down to %u\n",
> > +					u32_opts[i].name, sel);
> > +		}
> 
> Do we really want to do all this complicated rounding and checking?
> Can't we just assume the DT is correct?
> 

We could remove the printout about rounding, but the logic turns human-readable
values into register values (indices), so we need something for that.

> > +		dev_dbg(dev, "'%s' = %u\n", u32_opts[i].name, sel);
> > +		*u32_opts[i].val_ptr = rj;
> > +	};
> > +
> > +	for (i = 0; i < ARRAY_SIZE(bool_opts); ++i) {
> > +		if (of_property_read_bool(dev->of_node, bool_opts[i].name))
> > +			*bool_opts[i].val_ptr = true;
> > +	}
> > +
> > +	cfg->num_strings = cfg->num_strings + 1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int pm8941_wled_probe(struct platform_device *pdev)
> > +{
> > +	struct pm8941_wled_context *ctx;
> > +	struct regmap *regmap;
> > +	int rc;
> > +
> > +	regmap = dev_get_regmap(pdev->dev.parent, NULL);
> > +	if (!regmap) {
> > +		dev_err(&pdev->dev, "Unable to get regmap\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
> > +	if (ctx == NULL)
> 
> Nitpick only because it doesn't match the !regmap style above. Please
> use the !ctx style here as well.
> 

Agreed

> > +		return -ENOMEM;
> > +
> > +	ctx->regmap = regmap;
> > +
> > +	rc = pm8941_wled_configure(&ctx->wled, &pdev->dev);
> > +	if (rc)
> > +		return rc;
> > +
> > +	rc = pm8941_wled_setup(&ctx->wled);
> > +	if (rc)
> > +		return rc;
> > +
> > +	ctx->wled.cdev.brightness_set = pm8941_wled_set_brightness;
> > +
> > +	rc = led_classdev_register(&pdev->dev, &ctx->wled.cdev);
> > +	if (rc)
> > +		return rc;
> > +
> > +	platform_set_drvdata(pdev, ctx);
> > +	dev_info(&pdev->dev, "registered led \"%s\"\n", ctx->wled.cdev.name);
> 
> Please don't spam the log with "I'm alive!" messages.
> 

Ok

> > +
> > +	return 0;
> > +};
> > +

[..]

> > +
> > +static const struct of_device_id pm8941_wled_match_table[] = {
> > +	{ .compatible = "qcom,pm8941-wled" },
> > +	{}
> > +};
> 
> MODULE_DEVICE_TABLE?
> 

Indeed

Thanks for the review Stephen.

Regards,
Bjorn
