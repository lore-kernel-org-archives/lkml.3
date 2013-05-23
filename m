Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3EWJpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:45:33 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:29129 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab3EWJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:45:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,727,1363132800"; 
   d="scan'208";a="82778883"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v3] media: i2c: tvp514x: add OF support
Date: Thu, 23 May 2013 11:45:13 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-2.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
References: <1368529236-18199-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368529236-18199-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231145.13303.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14 May 2013 13:00:36 Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the tvp514x driver. Alongside this patch
> removes unnecessary header file inclusion and sorts them alphabetically.
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
> Tested on da850-evm.
> 
>  RFC v1: https://patchwork.kernel.org/patch/2030061/
>  RFC v2: https://patchwork.kernel.org/patch/2061811/
> 
>  Changes for current version from RFC v2:
>  1: Fixed review comments pointed by Sylwester.
> 
>  Changes for v2:
>  1: Listed all the compatible property values in the documentation text file.
>  2: Removed "-decoder" from compatible property values.
>  3: Added a reference to the V4L2 DT bindings documentation to explain
>     what the port and endpoint nodes are for.
>  4: Fixed some Nits pointed by Laurent.
>  5: Removed unnecessary header file includes and sort them alphabetically.
> 
>  Changes for v3:
>  1: Rebased on patch https://patchwork.kernel.org/patch/2539411/
> 
>  .../devicetree/bindings/media/i2c/tvp514x.txt      |   45 ++++++++++++
>  drivers/media/i2c/tvp514x.c                        |   74 +++++++++++++++----
>  2 files changed, 103 insertions(+), 16 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> new file mode 100644
> index 0000000..cc09424
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> @@ -0,0 +1,45 @@
> +* Texas Instruments TVP514x video decoder
> +
> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality, single-chip
> +digital video decoder that digitizes and decodes all popular baseband analog
> +video formats into digital video component. The tvp514x decoder supports analog-
> +to-digital (A/D) conversion of component RGB and YPbPr signals as well as A/D
> +conversion and decoding of NTSC, PAL and SECAM composite and S-video into
> +component YCbCr.
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
> +For further reading of port node refer Documentation/devicetree/bindings/media/
> +video-interfaces.txt.
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
> index 01d9757..202c8cb 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -29,21 +29,16 @@
>   *
>   */
>  
> -#include <linux/i2c.h>
> -#include <linux/slab.h>
>  #include <linux/delay.h>
> -#include <linux/videodev2.h>
> +#include <linux/i2c.h>
>  #include <linux/module.h>
> -#include <linux/v4l2-mediabus.h>
>  
> +#include <media/media-entity.h>
> +#include <media/tvp514x.h>
>  #include <media/v4l2-async.h>
> -#include <media/v4l2-device.h>
> -#include <media/v4l2-common.h>
> -#include <media/v4l2-mediabus.h>
> -#include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
> -#include <media/tvp514x.h>
> -#include <media/media-entity.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>

Same issue as with other patches: be careful about removing headers, i.e. don't
rely on them being included in other headers. If you use something from a header,
then just include it.

Regards,

	Hans

>  
>  #include "tvp514x_regs.h"
>  
> @@ -1056,6 +1051,40 @@ static struct tvp514x_decoder tvp514x_dev = {
>  
>  };
>  
> +static struct tvp514x_platform_data *
> +tvp514x_get_pdata(struct i2c_client *client)
> +{
> +	struct tvp514x_platform_data *pdata;
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
> +		return NULL;
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
> +	return pdata;
> +}
> +
>  /**
>   * tvp514x_probe() - decoder driver i2c probe handler
>   * @client: i2c driver client device structure
> @@ -1067,19 +1096,20 @@ static struct tvp514x_decoder tvp514x_dev = {
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
> @@ -1091,7 +1121,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  			sizeof(tvp514x_reg_list_default));
>  
>  	/* Copy board specific information here */
> -	decoder->pdata = client->dev.platform_data;
> +	decoder->pdata = pdata;
>  
>  	/**
>  	 * Fetch platform specific data, and configure the
> @@ -1239,8 +1269,20 @@ static const struct i2c_device_id tvp514x_id[] = {
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
> 
