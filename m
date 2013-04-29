Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3D2OCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:02:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51352 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab3D2OCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:02:49 -0400
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
Subject: Re: [PATCH] media: i2c: adv7343: add OF support
Date: Mon, 29 Apr 2013 16:02:54 +0200
Message-ID: <3966422.nINo6Q1vph@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366982286-22950-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366982286-22950-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Friday 26 April 2013 18:48:06 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the adv7343 driver.
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
>  .../devicetree/bindings/media/i2c/adv7343.txt      |   69 +++++++++++++++++
>  drivers/media/i2c/adv7343.c                        |   75 ++++++++++++++++-
>  2 files changed, 142 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> b/Documentation/devicetree/bindings/media/i2c/adv7343.txt new file mode
> 100644
> index 0000000..8426f8d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> @@ -0,0 +1,69 @@
> +* Analog Devices adv7343 video encoder
> +
> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead
> LQFP +package. Six high speed, 3.3 V, 11-bit video DACs provide support for
> composite +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs
> in standard +definition (SD), enhanced definition (ED), or high definition
> (HD) video +formats.
> +
> +The ADV7343 have a 24-bit pixel input port that can be configured in a
> variety +of ways. SD video formats are supported over an SDR interface, and
> ED/HD video +formats are supported over SDR and DDR interfaces. Pixel data
> can be supplied +in either the YCrCb or RGB color spaces.
> +
> +Required Properties :
> +- compatible: Must be "ad,adv7343-encoder"
> +
> +Optional Properties :
> +- ad-adv7343-power-mode-sleep-mode: on enable the current consumption is
> +                                    reduced to micro ampere level. All DACs
> +                                    and the internal PLL circuit are 
> +                                    disabled.
> +- ad-adv7343-power-mode-pll-ctrl: PLL and oversampling control. This
> +                                  control allows internal PLL 1 circuit to
> +                                  be powered down and the oversampling to
> +                                  be switched off.
> +
> +- ad-adv7343-power-mode-dac-1: power on/off DAC 1.
> +- ad-adv7343-power-mode-dac-2: power on/off DAC 2.
> +- ad-adv7343-power-mode-dac-3: power on/off DAC 3.
> +- ad-adv7343-power-mode-dac-4: power on/off DAC 4.
> +- ad-adv7343-power-mode-dac-5: power on/off DAC 5.
> +- ad-adv7343-power-mode-dac-6: power on/off DAC 6.
> +- ad-adv7343-sd-config-dac-out-1: Configure SD DAC Output 1.
> +- ad-adv7343-sd-config-dac-out-2: Configure SD DAC Output 2.

s/ad-/ad,/

Do all those properties really need to be specified at the endpoint level 
instead of the device node level ?

I'll let Hans comment on the individual properties, he knows more than I do 
about DACs.

> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +
> +	adv7343@2a {
> +		compatible = "ad,adv7343-encoder";
> +		reg = <0x2a>;
> +
> +		port {
> +			adv7343_1: endpoint {
> +					/* Active high (Defaults to false) */

Active high ?

> +					ad-adv7343-power-mode-sleep-mode;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-pll-ctrl;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-dac-1;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-dac-2;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-dac-3;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-dac-4;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-dac-5;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-dac-6;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-sd-config-dac-out-1;
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-sd-config-dac-out-2 = <0>;
> +			};
> +		};
> +	};
> +	...
> +};
> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> index 469e262..eb12d1a 100644
> --- a/drivers/media/i2c/adv7343.c
> +++ b/drivers/media/i2c/adv7343.c
> @@ -25,12 +25,14 @@
>  #include <linux/module.h>
>  #include <linux/videodev2.h>
>  #include <linux/uaccess.h>
> +#include <linux/of_device.h>
> 
>  #include <media/adv7343.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-of.h>
> 
>  #include "adv7343_regs.h"
> 
> @@ -409,6 +411,75 @@ static int adv7343_initialize(struct v4l2_subdev *sd)
>  	return err;
>  }
> 
> +#if defined(CONFIG_OF)
> +static const struct of_device_id adv7343_of_match[] = {
> +	{.compatible = "ad,adv7343-encoder", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, adv7343_of_match);
> +
> +static void adv7343_get_pdata(struct i2c_client *client,
> +			      struct adv7343_state *decoder)
> +{
> +	if (!client->dev.platform_data && client->dev.of_node) {
> +		struct device_node *np;
> +		struct adv7343_platform_data *pdata;
> +
> +		np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +		if (!np)
> +			return;
> +
> +		pdata = devm_kzalloc(&client->dev,
> +				     sizeof(struct adv7343_platform_data),
> +				     GFP_KERNEL);
> +		if (!pdata) {
> +			pr_warn("adv7343 failed allocate memeory\n");
> +			return;
> +		}
> +
> +		pdata->mode_config.sleep_mode =
> +		  of_property_read_bool(np, "ad-adv7343-power-mode-sleep-mode");
> +
> +		pdata->mode_config.pll_control =
> +		    of_property_read_bool(np, "ad-adv7343-power-mode-pll-ctrl");
> +
> +		pdata->mode_config.dac_1 =
> +		       of_property_read_bool(np, "ad-adv7343-power-mode-dac-1");
> +
> +		pdata->mode_config.dac_2 =
> +		       of_property_read_bool(np, "ad-adv7343-power-mode-dac-2");
> +
> +		pdata->mode_config.dac_3 =
> +		       of_property_read_bool(np, "ad-adv7343-power-mode-dac-3");
> +
> +		pdata->mode_config.dac_4 =
> +		       of_property_read_bool(np, "ad-adv7343-power-mode-dac-4");
> +
> +		pdata->mode_config.dac_5 =
> +		       of_property_read_bool(np, "ad-adv7343-power-mode-dac-5");
> +
> +		pdata->mode_config.dac_6 =
> +		       of_property_read_bool(np, "ad-adv7343-power-mode-dac-6");
> +
> +		pdata->sd_config.sd_dac_out1 =
> +		    of_property_read_bool(np, "ad-adv7343-sd-config-dac-out-1");
> +
> +		pdata->sd_config.sd_dac_out2 =
> +		    of_property_read_bool(np, "ad-adv7343-sd-config-dac-out-2");
> +
> +		decoder->pdata = pdata;
> +	}
> +}
> +#else
> +#define adv7343_of_match NULL
> +
> +static void adv7343_get_pdata(struct i2c_client *client,
> +			      struct adv7343_state *decoder)
> +{
> +	decoder->pdata = client->dev.platform_data;
> +}
> +#endif
> +
>  static int adv7343_probe(struct i2c_client *client,
>  				const struct i2c_device_id *id)
>  {
> @@ -426,8 +497,7 @@ static int adv7343_probe(struct i2c_client *client,
>  	if (state == NULL)
>  		return -ENOMEM;
> 
> -	/* Copy board specific information here */
> -	state->pdata = client->dev.platform_data;
> +	adv7343_get_pdata(client, state);
> 
>  	state->reg00	= 0x80;
>  	state->reg01	= 0x00;
> @@ -496,6 +566,7 @@ MODULE_DEVICE_TABLE(i2c, adv7343_id);
> 
>  static struct i2c_driver adv7343_driver = {
>  	.driver = {
> +		.of_match_table = adv7343_of_match,
>  		.owner	= THIS_MODULE,
>  		.name	= "adv7343",
>  	},
-- 
Regards,

Laurent Pinchart

