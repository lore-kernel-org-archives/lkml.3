Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3D2IVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:21:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37943 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3D2IVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:21:48 -0400
Date: Mon, 29 Apr 2013 10:21:28 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH RFC] media: i2c: mt9p031: add OF support
Message-ID: <20130429082128.GG32299@pengutronix.de>
References: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:05:17 up 309 days, 23:16, 90 users,  load average: 0.54, 0.65,
 1.31
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 01:30:01PM +0530, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the mt9p031 sensor driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../devicetree/bindings/media/i2c/mt9p031.txt      |   43 ++++++++++++++
>  drivers/media/i2c/mt9p031.c                        |   61 +++++++++++++++++++-
>  2 files changed, 103 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> new file mode 100644
> index 0000000..b985e63
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> @@ -0,0 +1,43 @@
> +* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
> +
> +The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image sensor with
> +an active imaging pixel array of 2592H x 1944V. It incorporates sophisticated
> +camera functions on-chip such as windowing, column and row skip mode, and
> +snapshot mode. It is programmable through a simple two-wire serial interface.
> +
> +The MT9P031 is a progressive-scan sensor that generates a stream of pixel data
> +at a constant frame rate. It uses an on-chip, phase-locked loop (PLL) to
> +generate all internal clocks from a single master input clock running between 6
> +and 27 MHz. The maximum pixel rate is 96 Mp/s, corresponding to a clock rate of
> +96 MHz.
> +
> +Required Properties :
> +- compatible : value should be either one among the following
> +	(a) "aptina,mt9p031-sensor" for mt9p031 sensor
> +	(b) "aptina,mt9p031m-sensor" for mt9p031m sensor
> +
> +- ext_freq: Input clock frequency.
> +
> +- target_freq:  Pixel clock frequency.

For devicetree properties '-' is preferred over '_'. Most devicetree
bindings we already have suggest that we shoud use 'frequency' and no
abbreviation. probably 'clock-frequency' should be used.

> +
> +Optional Properties :
> +-reset: Chip reset GPIO (If not specified defaults to -1)

gpios must be specified as phandles, see of_get_named_gpio().

> +
> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +	mt9p031@5d {
> +		compatible = "aptina,mt9p031-sensor";
> +		reg = <0x5d>;
> +
> +		port {
> +			mt9p031_1: endpoint {
> +				ext_freq = <6000000>;
> +				target_freq = <96000000>;
> +			};
> +		};
> +	};
> +	...
> +};
> \ No newline at end of file
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 28cf95b..66078a6 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -23,11 +23,13 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> +#include <linux/of_device.h>
>  
>  #include <media/mt9p031.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-subdev.h>
>  
>  #include "aptina-pll.h"
> @@ -928,10 +930,66 @@ static const struct v4l2_subdev_internal_ops mt9p031_subdev_internal_ops = {
>   * Driver initialization and probing
>   */
>  
> +#if defined(CONFIG_OF)
> +static const struct of_device_id mt9p031_of_match[] = {
> +	{.compatible = "aptina,mt9p031-sensor", },
> +	{.compatible = "aptina,mt9p031m-sensor", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, mt9p031_of_match);
> +
> +static struct mt9p031_platform_data
> +	*mt9p031_get_pdata(struct i2c_client *client)
> +
> +{
> +	if (!client->dev.platform_data && client->dev.of_node) {

Just because the Kernel is compiled with devicetree support does not
necessarily mean you actually boot from devicetree. You must still
handle platform data properly.

> +		struct device_node *np;
> +		struct mt9p031_platform_data *pdata;
> +		int ret;
> +
> +		np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +		if (!np)
> +			return NULL;
> +
> +		pdata = devm_kzalloc(&client->dev,
> +				     sizeof(struct mt9p031_platform_data),
> +				     GFP_KERNEL);
> +		if (!pdata) {
> +			pr_warn("mt9p031 failed allocate memeory\n");

Use dev_* for messages inside drivers.

> +			return NULL;
> +		}
> +		ret = of_property_read_u32(np, "reset", &pdata->reset);
> +		if (ret == -EINVAL)
> +			pdata->reset = -1;
> +		else if (ret == -ENODATA)
> +			return NULL;
> +
> +		if (of_property_read_u32(np, "ext_freq", &pdata->ext_freq))
> +			return NULL;
> +
> +		if (of_property_read_u32(np, "target_freq",
> +					 &pdata->target_freq))
> +			return NULL;
> +
> +		return pdata;
> +	}
> +
> +	return NULL;
> +}
> +#else
> +#define mt9p031_of_match NULL
> +
> +static struct mt9p031_platform_data
> +	*mt9p031_get_pdata(struct i2c_client *client)
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
> @@ -1072,6 +1130,7 @@ MODULE_DEVICE_TABLE(i2c, mt9p031_id);
>  
>  static struct i2c_driver mt9p031_i2c_driver = {
>  	.driver = {
> +		.of_match_table = mt9p031_of_match,
>  		.name = "mt9p031",
>  	},
>  	.probe          = mt9p031_probe,
> -- 
> 1.7.4.1
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
