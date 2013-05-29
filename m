Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934755Ab3E2BXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:23:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3E2BXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:23:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5] media: i2c: tvp514x: add OF support
Date: Wed, 29 May 2013 03:22:59 +0200
Message-ID: <1417519.vVjfDJcATe@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369574386-24486-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369574386-24486-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thanks for the patch.

On Sunday 26 May 2013 18:49:46 Prabhakar Lad wrote:
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

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(with two small comment below).

> ---
> Tested on da850-evm.
> 
>  RFC v1: https://patchwork.kernel.org/patch/2030061/
>  RFC v2: https://patchwork.kernel.org/patch/2061811/
> 
>  Changes for current version from RFC v2:
>  1: Fixed review comments pointed by Sylwester.
> 
>  Changes for v2:
>  1: Listed all the compatible property values in the documentation text
> file. 2: Removed "-decoder" from compatible property values.
>  3: Added a reference to the V4L2 DT bindings documentation to explain
>     what the port and endpoint nodes are for.
>  4: Fixed some Nits pointed by Laurent.
>  5: Removed unnecessary header file includes and sort them alphabetically.
> 
>  Changes for v3:
>  1: Rebased on patch https://patchwork.kernel.org/patch/2539411/
> 
>  Changes for v4:
>  1: added missing call for of_node_put().
>  2: Rebased the patch on v3.11.
> 
>  Changes for v5:
>  1: Fixed calling to a wrong label.
> 
>  .../devicetree/bindings/media/i2c/tvp514x.txt      |   45 ++++++++++++++
>  drivers/media/i2c/tvp514x.c                        |   62 +++++++++++++++--
>  2 files changed, 101 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt new file mode
> 100644
> index 0000000..cc09424
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> @@ -0,0 +1,45 @@
> +* Texas Instruments TVP514x video decoder
> +
> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality, single-chip
> +digital video decoder that digitizes and decodes all popular baseband
> analog +video formats into digital video component. The tvp514x decoder
> supports analog- +to-digital (A/D) conversion of component RGB and YPbPr
> signals as well as A/D +conversion and decoding of NTSC, PAL and SECAM
> composite and S-video into +component YCbCr.
> +
> +Required Properties :
> +- compatible : value should be either one among the following
> +	(a) "ti,tvp5146" for tvp5146 decoder.
> +	(b) "ti,tvp5146m2" for tvp5146m2 decoder.
> +	(c) "ti,tvp5147" for tvp5147 decoder.
> +	(d) "ti,tvp5147m1" for tvp5147m1 decoder.
> +
> +- hsync-active: HSYNC Polarity configuration for endpoint.
> +
> +- vsync-active: VSYNC Polarity configuration for endpoint.
> +
> +- pclk-sample: Clock polarity of the endpoint.
> +
> +
> +For further reading of port node refer

s/of port/on port/
s/refer/refer to/

> Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	i2c0@1c22000 {
> +		...
> +		...
> +		tvp514x@5c {
> +			compatible = "ti,tvp5146";
> +			reg = <0x5c>;
> +
> +			port {
> +				tvp514x_1: endpoint {
> +					hsync-active = <1>;
> +					vsync-active = <1>;
> +					pclk-sample = <0>;
> +				};
> +			};
> +		};
> +		...
> +	};
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 7438e01..7ed999b 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -39,6 +39,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-mediabus.h>
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/tvp514x.h>
> @@ -1055,6 +1056,42 @@ static struct tvp514x_decoder tvp514x_dev = {
> 
>  };
> 
> +static struct tvp514x_platform_data *
> +tvp514x_get_pdata(struct i2c_client *client)
> +{
> +	struct tvp514x_platform_data *pdata = NULL;

No need to initialize pdata to NULL.

> +	struct v4l2_of_endpoint bus_cfg;
> +	struct device_node *endpoint;
> +	unsigned int flags;
> +
> +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +		return client->dev.platform_data;
> +
> +	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!endpoint)
> +		return NULL;
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		goto done;
> +
> +	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +	flags = bus_cfg.bus.parallel.flags;
> +
> +	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		pdata->hs_polarity = 1;
> +
> +	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		pdata->vs_polarity = 1;
> +
> +	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		pdata->clk_polarity = 1;
> +
> +done:
> +	of_node_put(endpoint);
> +	return pdata;
> +}
> +
>  /**
>   * tvp514x_probe() - decoder driver i2c probe handler
>   * @client: i2c driver client device structure
> @@ -1066,19 +1103,20 @@ static struct tvp514x_decoder tvp514x_dev = {
>  static int
>  tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
> +	struct tvp514x_platform_data *pdata = tvp514x_get_pdata(client);
>  	struct tvp514x_decoder *decoder;
>  	struct v4l2_subdev *sd;
>  	int ret;
> 
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "No platform data\n");
> +		return -EINVAL;
> +	}
> +
>  	/* Check if the adapter supports the needed features */
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -EIO;
> 
> -	if (!client->dev.platform_data) {
> -		v4l2_err(client, "No platform data!!\n");
> -		return -ENODEV;
> -	}
> -
>  	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
>  	if (!decoder)
>  		return -ENOMEM;
> @@ -1090,7 +1128,7 @@ tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id *id) sizeof(tvp514x_reg_list_default));
> 
>  	/* Copy board specific information here */
> -	decoder->pdata = client->dev.platform_data;
> +	decoder->pdata = pdata;
> 
>  	/**
>  	 * Fetch platform specific data, and configure the
> @@ -1230,8 +1268,20 @@ static const struct i2c_device_id tvp514x_id[] = {
> 
>  MODULE_DEVICE_TABLE(i2c, tvp514x_id);
> 
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id tvp514x_of_match[] = {
> +	{ .compatible = "ti,tvp5146", },
> +	{ .compatible = "ti,tvp5146m2", },
> +	{ .compatible = "ti,tvp5147", },
> +	{ .compatible = "ti,tvp5147m1", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, tvp514x_of_match);
> +#endif
> +
>  static struct i2c_driver tvp514x_driver = {
>  	.driver = {
> +		.of_match_table = of_match_ptr(tvp514x_of_match),
>  		.owner = THIS_MODULE,
>  		.name = TVP514X_MODULE_NAME,
>  	},
-- 
Regards,

Laurent Pinchart

