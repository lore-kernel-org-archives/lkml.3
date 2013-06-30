Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3F3P5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 11:57:37 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42663 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3F3P5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 11:57:33 -0400
Message-ID: <51D05568.3090009@gmail.com>
Date: Sun, 30 Jun 2013 17:57:28 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] media: i2c: tvp7002: add OF support
References: <1371923055-29623-1-git-send-email-prabhakar.csengg@gmail.com> <1371923055-29623-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1371923055-29623-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/22/2013 07:44 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar"<prabhakar.csengg@gmail.com>
>
> add OF support for the tvp7002 driver.
>
> Signed-off-by: Lad, Prabhakar<prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil<hans.verkuil@cisco.com>
> Cc: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab<mchehab@redhat.com>
> Cc: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Cc: Sakari Ailus<sakari.ailus@iki.fi>
> Cc: Grant Likely<grant.likely@secretlab.ca>
> Cc: Rob Herring<rob.herring@calxeda.com>
> Cc: Rob Landley<rob@landley.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> ---
>   Depends on patch https://patchwork.kernel.org/patch/2765851/
>
>   .../devicetree/bindings/media/i2c/tvp7002.txt      |   43 +++++++++++++
>   drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
>   2 files changed, 103 insertions(+), 7 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> new file mode 100644
> index 0000000..9daebe1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> @@ -0,0 +1,43 @@
> +* Texas Instruments TV7002 video decoder
> +
> +The TVP7002 device supports digitizing of video and graphics signal in RGB and
> +YPbPr color space.
> +
> +Required Properties :
> +- compatible : Must be "ti,tvp7002"
> +
> +- hsync-active: HSYNC Polarity configuration for endpoint.
> +
> +- vsync-active: VSYNC Polarity configuration for endpoint.
> +
> +- pclk-sample: Clock polarity of the endpoint.
> +
> +- video-sync: Video sync property of the endpoint.
> +
> +- ti,tvp7002-fid-polarity: Active-high Field ID polarity of the endpoint.

I thought it was agreed 'field-even-active' would be used instead of
this device specific property. Did you run into any issues with that ?

> +
> +For further reading of port node refer Documentation/devicetree/bindings/media/
> +video-interfaces.txt.
> +
> +Example:
> +
> +	i2c0@1c22000 {
> +		...
> +		...
> +		tvp7002@5c {
> +			compatible = "ti,tvp7002";
> +			reg =<0x5c>;
> +
> +			port {
> +				tvp7002_1: endpoint {
> +					hsync-active =<1>;
> +					vsync-active =<1>;
> +					pclk-sample =<0>;
> +					video-sync =<V4L2_MBUS_VIDEO_SYNC_ON_GREEN>;
> +					ti,tvp7002-fid-polarity;
> +				};
> +			};
> +		};
> +		...
> +	};
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index b577548..4896024 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -35,6 +35,8 @@
>   #include<media/v4l2-device.h>
>   #include<media/v4l2-common.h>
>   #include<media/v4l2-ctrls.h>
> +#include<media/v4l2-of.h>
> +
>   #include "tvp7002_reg.h"
>
>   MODULE_DESCRIPTION("TI TVP7002 Video and Graphics Digitizer driver");
> @@ -943,6 +945,48 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
>   	.pad =&tvp7002_pad_ops,
>   };
>
> +static struct tvp7002_config *
> +tvp7002_get_pdata(struct i2c_client *client)

nit: unnecessary line break

> +{
> +	struct v4l2_of_endpoint bus_cfg;
> +	struct tvp7002_config *pdata;
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
> +	v4l2_of_parse_endpoint(endpoint,&bus_cfg);
> +	flags = bus_cfg.bus.parallel.flags;
> +
> +	if (flags&  V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		pdata->hs_polarity = 1;
> +
> +	if (flags&  V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		pdata->vs_polarity = 1;
> +
> +	if (flags&  V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		pdata->clk_polarity = 1;
> +
> +	if (flags&  V4L2_MBUS_VIDEO_SYNC_ON_GREEN)
> +		pdata->sog_polarity = 1;

This clearly shows that you're using this property for something different
you have defined it for. I asked previously if what you really needed for
this TVP7002 chip is a DT property indicating sync-on-green _polarity_ or
the sync-on-green _usage_. And you clearly need the polarity information.

So I would just define a standard "sync-on-green-active" property and
V4L2_MBUS_VIDEO_SOG_ACTIVE_{HIGH,LOW} flags. Presumably you don't need
anything else, and the extra sync polarity flags would need eventually
to be defined anyway, independently of any video sync selection property,
should something like this ever need to be specified by firmware.

> +	pdata->fid_polarity = of_property_read_bool(endpoint,
> +						    "ti,tvp7002-fid-polarity");

This could be just:

	if (flags & V4L2_MBUS_FIELD_EVEN_HIGH)
		pdata->fid_polarity = 1;

if you used standard 'field-even-active' property.

And this is what we find in the TVP7002 datasheet, in the section describing
MISC Control 3 (18h) register's FID POL bit (pdata->fid_polarity is written
directly to FID POL):

"FID POL: Active-high Field ID output polarity control. Under normal
operation,  the field ID output is set to logic 1 for an odd field (field 1)
and set to logic 0 for an even field (field 0).
0 = Normal operation (default)
1 = FID output polarity inverted
NOTE: This control bit also affects the polarity of the data enable output
when selected (see Test output control [2:0] at subaddress 17h)."


And include/media/tvp70002.h:

  * fid_polarity:
  *			0 -> the field ID output is set to logic 1 for an odd
  *			     field (field 1) and set to logic 0 for an even
  *			     field (field 0).
  *			1 -> operation with polarity inverted.


Do you know if the chip automatically selects video sync source 
(sync-on-green
vs. VSYNC/HSYNC) and there is no need to configure this on the analogue 
input
side ? At least the driver seems to always select the default SOGIN_1 input
(TVP7002_IN_MUX_SEL_1 register is set only at initialization time).

Or perhaps it just outputs on SOGOUT, VSOUT, HSOUT lines whatever is fed to
its analogue inputs, and any further processing unit need to determine what
synchronization signal is present and should be used ?

I suspect that we don't need, e.g. another endpoint node to specify the
configuration of the TVP7002 analogue input interface, that would contain
a property like video-sync.

> +done:
> +	of_node_put(endpoint);
> +	return pdata;
> +}

Regards,
Sylwester
