Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3EBGzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:55:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58700 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3EBGzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:55:48 -0400
Date: Thu, 2 May 2013 08:55:18 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2] media: i2c: mt9p031: add OF support
Message-ID: <20130502065518.GN32299@pengutronix.de>
References: <1367475754-19477-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367475754-19477-1-git-send-email-prabhakar.csengg@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:42:27 up 312 days, 21:54, 81 users,  load average: 0.32, 0.54,
 0.60
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 11:52:34AM +0530, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the mt9p031 sensor driver.
> Alongside this patch sorts the header inclusion alphabetically.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Changes for v2:
>  1: Used '-' instead of '_' for device properties.
>  2: Specified gpio reset pin as phandle in device node.
>  3: Handle platform data properly even if kernel is compiled with
>     devicetree support.
>  4: Used dev_* for messages in drivers instead of pr_*.
>  5: Changed compatible property to "aptina,mt9p031" and "aptina,mt9p031m".
>  6: Sorted the header inclusion alphabetically and fixed some minor code nits.
> 
>  .../devicetree/bindings/media/i2c/mt9p031.txt      |   37 ++++++++++++
>  drivers/media/i2c/mt9p031.c                        |   62 +++++++++++++++++++-
>  2 files changed, 97 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> new file mode 100644
> index 0000000..cbe352b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> @@ -0,0 +1,37 @@
> +* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
> +
> +The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image sensor with
> +an active array size of 2592H x 1944V. It is programmable through a simple
> +two-wire serial interface.
> +
> +Required Properties :
> +- compatible : value should be either one among the following
> +	(a) "aptina,mt9p031" for mt9p031 sensor
> +	(b) "aptina,mt9p031m" for mt9p031m sensor
> +
> +- input-clock-frequency : Input clock frequency.
> +
> +- pixel-clock-frequency : Pixel clock frequency.
> +
> +Optional Properties :
> +-gpio-reset: Chip reset GPIO
> +
> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +	mt9p031@5d {
> +		compatible = "aptina,mt9p031";
> +		reg = <0x5d>;
> +		gpio-reset = <&gpio3 30 0>;
> +
> +		port {
> +			mt9p031_1: endpoint {
> +				input-clock-frequency = <6000000>;
> +				pixel-clock-frequency = <96000000>;
> +			};
> +		};
> +	};
> +	...
> +};
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 28cf95b..8ce3561 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -16,9 +16,11 @@
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/gpio.h>
> -#include <linux/module.h>
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
>  #include <linux/pm.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> @@ -28,6 +30,7 @@
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-subdev.h>
>  
>  #include "aptina-pll.h"
> @@ -928,10 +931,57 @@ static const struct v4l2_subdev_internal_ops mt9p031_subdev_internal_ops = {
>   * Driver initialization and probing
>   */
>  
> +#if defined(CONFIG_OF)
> +static struct mt9p031_platform_data *
> +	mt9p031_get_pdata(struct i2c_client *client)
> +
> +{
> +	if (client->dev.of_node) {

By inverting the logic here and returning immediately you can safe an
indention level for the bulk of this function.

> +		struct device_node *np;
> +		struct mt9p031_platform_data *pdata;
> +
> +		np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +		if (!np)
> +			return NULL;
> +
> +		pdata = devm_kzalloc(&client->dev,
> +				     sizeof(struct mt9p031_platform_data),
> +				     GFP_KERNEL);
> +		if (!pdata) {
> +			dev_err(&client->dev,
> +				"mt9p031 failed allocate memeory\n");
> +			return NULL;

s/memeory/memory/

Better drop this message completely. If you are really out of memory
you'll notice it quite fast anyway.

> +		}
> +		pdata->reset = of_get_named_gpio(client->dev.of_node,
> +						 "gpio-reset", 0);
> +		if (!gpio_is_valid(pdata->reset))
> +			pdata->reset = -1;
> +
> +		if (of_property_read_u32(np, "input-clock-frequency",
> +					 &pdata->ext_freq))
> +			return NULL;
> +
> +		if (of_property_read_u32(np, "pixel-clock-frequency",
> +					 &pdata->target_freq))
> +			return NULL;

returning NULL here means that when these properties are missing the
driver bails out with the message "No platform data\n" which is not
very helpful for users. How about just ignoring this here and return
pdata? The driver will probably print a more useful message later when
it notices that the clock params are invalid.

> +
> +		return pdata;
> +	}
> +
> +	return client->dev.platform_data;
> +}
> +#else
> +static struct mt9p031_platform_data *
> +	mt9p031_get_pdata(struct i2c_client *client)
> +{
> +	return client->dev.platform_data;
> +}
> +#endif
> +
>  static int mt9p031_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *did)
>  {
> -	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> +	struct mt9p031_platform_data *pdata = mt9p031_get_pdata(client);
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>  	struct mt9p031 *mt9p031;
>  	unsigned int i;
> @@ -1070,8 +1120,16 @@ static const struct i2c_device_id mt9p031_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, mt9p031_id);
>  
> +static const struct of_device_id mt9p031_of_match[] = {
> +	{ .compatible = "aptina,mt9p031", },
> +	{ .compatible = "aptina,mt9p031m", },
> +	{},
> +};

I would have expected something like:

static const struct of_device_id mt9p031_of_match[] = {
	{
		.compatible = "aptina,mt9p031-sensor",
		.data = (void *)MT9P031_MODEL_COLOR,
	}, {
		.compatible = "aptina,mt9p031m-sensor",
		.data = (void *)MT9P031_MODEL_MONOCHROME,
	}, {
		/* sentinel */
	},
};

	of_id = of_match_device(mt9p031_of_match, &client->dev);
	if (of_id)
		mt9p031->model = (enum mt9p031_model)of_id->data;

To handle monochrome sensors.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
