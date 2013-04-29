Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3D2N5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:57:31 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51317 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab3D2N5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:57:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] media: i2c: tvp514x: add OF support
Date: Mon, 29 Apr 2013 15:57:34 +0200
Message-ID: <7684541.nmKBKd3EoN@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366975430-31806-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366975430-31806-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch. Please see below for a couple of comments. Most of 
them apply to your adv7343 patch as well.

On Friday 26 April 2013 16:53:50 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the tvp514x driver.
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
> Cc: davinci-linux-open-source@linux.davincidsp.com
> ---
>  RFC v1: https://patchwork.kernel.org/patch/2030061/
>  RFC v2: https://patchwork.kernel.org/patch/2061811/
> 
>  Changes for current version from RFC v2:
>  1: Fixed review comments pointed by Sylwester.
> 
>  .../devicetree/bindings/media/i2c/tvp514x.txt      |   38 +++++++++++
>  drivers/media/i2c/tvp514x.c                        |   67 +++++++++++++++--
>  2 files changed, 98 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt new file mode
> 100644
> index 0000000..618640a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> @@ -0,0 +1,38 @@
> +* Texas Instruments TVP514x video decoder
> +
> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality, single-chip
> +digital video decoder that digitizes and decodes all popular baseband
> +analog video formats into digital video component. The tvp514x decoder
> +supports analog-to-digital (A/D) conversion of component RGB and YPbPr
> +signals as well as A/D conversion and decoding of NTSC, PAL and SECAM
> +composite and S-video into component YCbCr.
> +
> +Required Properties :
> +- compatible: Must be "ti,tvp514x-decoder"

According to the code below, it must be one of

        "ti,tvp5146-decoder"
        "ti,tvp5146m2-decoder"
        "ti,tvp5147-decoder"
        "ti,tvp5147m1-decoder"

Couldn't you remove "-decoder" ?

You should add a reference to the V4L2 DT bindings documentation to explain 
what the port and endpoint nodes are for.

> +- hsync-active: HSYNC Polarity configuration for current interface.
> +- vsync-active: VSYNC Polarity configuration for current interface.
> +- pclk-sample: Clock polarity of the current interface.

s/current interface/endpoint/ ?

> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +
> +	tvp514x@5c {
> +		compatible = "ti,tvp514x-decoder";
> +		reg = <0x5c>;
> +
> +		port {
> +			tvp514x_1: endpoint {
> +				/* Active high (Defaults to 0) */
> +				hsync-active = <1>;
> +				/* Active high (Defaults to 0) */
> +				vsync-active = <1>;
> +				/* Active low (Defaults to 0) */
> +				pclk-sample = <0>;
> +			};
> +		};
> +	};
> +	...
> +};
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 887bd93..d37b85e 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -35,7 +35,9 @@
>  #include <linux/videodev2.h>
>  #include <linux/module.h>
>  #include <linux/v4l2-mediabus.h>
> +#include <linux/of_device.h>
> 
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
> @@ -1056,6 +1058,58 @@ static struct tvp514x_decoder tvp514x_dev = {
> 
>  };
> 
> +#if defined(CONFIG_OF)
> +static const struct of_device_id tvp514x_of_match[] = {
> +	{.compatible = "ti,tvp5146-decoder", },
> +	{.compatible = "ti,tvp5146m2-decoder", },
> +	{.compatible = "ti,tvp5147-decoder", },
> +	{.compatible = "ti,tvp5147m1-decoder", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, tvp514x_of_match);
> +
> +static void tvp514x_get_pdata(struct i2c_client *client,
> +			      struct tvp514x_decoder *decoder)
> +{
> +	if (!client->dev.platform_data && client->dev.of_node) {
> +		struct device_node *endpoint;
> +
> +		endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +		if (endpoint) {
> +			struct tvp514x_platform_data *pdata;
> +			struct v4l2_of_endpoint bus_cfg;
> +			unsigned int flags;
> +
> +			pdata =
> +			   devm_kzalloc(&client->dev,
> +					sizeof(struct tvp514x_platform_data),

sizeof(*pdata) ? That's the preferred style, as it makes sure that you will 
still allocate the right amount of memory if the type of the pdata variable 
changes (that's pretty unlikely here of course, but the general principle 
holds true).

> +					GFP_KERNEL);
> +			if (!pdata)
> +				return;
> +
> +			v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +			flags = bus_cfg.bus.parallel.flags;
> +
> +			if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +				pdata->hs_polarity = 1;
> +			if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +				pdata->vs_polarity = 1;
> +			if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +				pdata->clk_polarity = 1;
> +			decoder->pdata = pdata;
> +		}
> +	}

As pointed out by Sascha in his review of your mt9p031 patch, you need to use 
client->dev.platform_data if client->dev.of_node is NULL.

> +}
> +#else
> +#define tvp514x_of_match NULL
> +
> +static void tvp514x_get_pdata(struct i2c_client *client,
> +			      struct tvp514x_decoder *decoder)
> +{
> +	decoder->pdata = client->dev.platform_data;
> +}
> +#endif
> +
>  /**
>   * tvp514x_probe() - decoder driver i2c probe handler
>   * @client: i2c driver client device structure
> @@ -1075,11 +1129,6 @@ tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id *id) if (!i2c_check_functionality(client->adapter,
> I2C_FUNC_SMBUS_BYTE_DATA)) return -EIO;
> 
> -	if (!client->dev.platform_data) {
> -		v4l2_err(client, "No platform data!!\n");
> -		return -ENODEV;
> -	}
> -
>  	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
>  	if (!decoder)
>  		return -ENOMEM;
> @@ -1090,8 +1139,11 @@ tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id *id) memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
>  			sizeof(tvp514x_reg_list_default));
> 
> -	/* Copy board specific information here */
> -	decoder->pdata = client->dev.platform_data;
> +	tvp514x_get_pdata(client, decoder);

Getter functions usually return a value. The code would (at least in my 
opinion) be clearer if you modifieid tvp514x_get_pdata() to return a pointer 
to the pdata instead of assigning it directly to decoder->pdata inside the 
function.

> +	if (!decoder->pdata) {
> +		v4l2_err(client, "No platform data!!\n");
> +		return -EPROBE_DEFER;

Why EPROBE_DEFER ? If there's no pdata now you won't magically get it later 
:-)

> +	}
> 
>  	/**
>  	 * Fetch platform specific data, and configure the
> @@ -1242,6 +1294,7 @@ MODULE_DEVICE_TABLE(i2c, tvp514x_id);
> 
>  static struct i2c_driver tvp514x_driver = {
>  	.driver = {
> +		.of_match_table = tvp514x_of_match,

Please use of_match_ptr() instead of defining tvp514x_of_match as NULL above.

>  		.owner = THIS_MODULE,
>  		.name = TVP514X_MODULE_NAME,
>  	},
-- 
Regards,

Laurent Pinchart

