Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3D2Qvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:51:44 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40109 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab3D2Qvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:51:42 -0400
X-AuditID: cbfec7f5-b7fa36d000007f20-28-517ea51ca07e
Message-id: <517EA519.4040202@samsung.com>
Date: Mon, 29 Apr 2013 18:51:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] media: i2c: adv7343: add OF support
References: <1366982286-22950-1-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1366982286-22950-1-git-send-email-prabhakar.csengg@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e/4NV2ZpXWBBrvecFqcu9XAanFg9kNW
	i/cb5zFZvDqzkc1iyc9dTBadE5ewWyxsW8JicXnXHDaLng1bWS32HD3MbvHy/gpmi8MrDjBZ
	rHs5ncXizP6VbA58Hgs+X2H3mPJ7I6vHzll32T0+fIzzmN0xk9Xj8NeFLB6vVgNZc6Y1sXic
	n7GQ0eP9vqtsHj9f6nh83iQXwBPFZZOSmpNZllqkb5fAlbFt+W2Wgs8GFUvOXWdpYPyr2sXI
	ySEhYCKx+t4UNghbTOLCvfVANheHkMBSRon9X7ugnE+MErO7r7GAVPEKaElcePyJFcRmEVCV
	ODh7P1icTcBQovdoHyOILSoQILF4yTl2iHpBiR+T74HViAjoSSxZcIwZZCizQB+LxMTOw2Cr
	hQUsJLqefmcCsYUEvCQ2n+hjBrE5Bbwl+lcuBRvELKAjsb91GhuELS+xec1b5gmMArOQ7JiF
	pGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi7usOxqXHrA4xCnAwKvHwBm6u
	DRRiTSwrrsw9xCjBwawkwhu/sC5QiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NziNnaOHM+9mNH
	M1W/xKe+n75vR/lM6YBMLoE7Em57xVdMeM97forh16tc23M5eG//vmIkGr53VmKw4gLPw57x
	wVwSwR9SDml//hLveJhJLeZhvbuv1PGQHH/liUcWpvltFBLIbTvgtHWh7qFYbqUYz6t89lHM
	/EGdazY7TWqJMF+7Z9fEA0osxRmJhlrMRcWJAC5QaXmWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/26/2013 03:18 PM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the adv7343 driver.

> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> @@ -0,0 +1,69 @@
> +* Analog Devices adv7343 video encoder
> +
> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
> +package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
> +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
> +definition (SD), enhanced definition (ED), or high definition (HD) video
> +formats.
> +
> +The ADV7343 have a 24-bit pixel input port that can be configured in a variety
> +of ways. SD video formats are supported over an SDR interface, and ED/HD video
> +formats are supported over SDR and DDR interfaces. Pixel data can be supplied
> +in either the YCrCb or RGB color spaces.
> +
> +Required Properties :
> +- compatible: Must be "ad,adv7343-encoder"

As Laurent pointed out, "-encoder" is probably not necessary, since
there is nothing else in the ADV7343 chip than the video encoder ?

> +Optional Properties :
> +- ad-adv7343-power-mode-sleep-mode: on enable the current consumption is
> +                                    reduced to micro ampere level. All DACs and
> +                                    the internal PLL circuit are disabled.

Why this needs to be specified in the device tree ? How will the hardware
be switched over to normal state if this property is set ?
Couldn't it be a default state by the driver ? And how is it related to
ad-adv7343-power-mode-dac-? properties ?

As pointed out earlier, vendor name in the property names should be separated
with commas, rather than dashes.

> +- ad-adv7343-power-mode-pll-ctrl: PLL and oversampling control. This control
> +                                  allows internal PLL 1 circuit to be powered
> +                                  down and the oversampling to beswitched off.

> +- ad-adv7343-power-mode-dac-1: power on/off DAC 1.
> +- ad-adv7343-power-mode-dac-2: power on/off DAC 2.
> +- ad-adv7343-power-mode-dac-3: power on/off DAC 3.
> +- ad-adv7343-power-mode-dac-4: power on/off DAC 4.
> +- ad-adv7343-power-mode-dac-5: power on/off DAC 5.
> +- ad-adv7343-power-mode-dac-6: power on/off DAC 6.

Is this somehow related to actual wiring on a PCB ? It's also not really
explicit what value corresponds to which state.

> +- ad-adv7343-sd-config-dac-out-1: Configure SD DAC Output 1.
> +- ad-adv7343-sd-config-dac-out-2: Configure SD DAC Output 2.

What are valid values and their meaning ?

> +Example:
> +
> +i2c0@1c22000 {

> +	adv7343@2a {
> +		compatible = "ad,adv7343-encoder";
> +		reg = <0x2a>;
> +
> +		port {
> +			adv7343_1: endpoint {
> +					/* Active high (Defaults to false) */
> +					ad-adv7343-power-mode-sleep-mode;
> +					/* Active high (Defaults to false) */

Isn't it obvious that if property is not listed it will default to false ?

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

Note that (devm_)k*alloc() functions already log any errors. If this function
would be returning pointer to platform data this error message would not be
needed for sure.
	
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

Looks like you transformed the platform data structure directly into device
tree properties, which in most cases is a wrong approach. I wonder how these
properties are related to actual hardware architecture and if there are no
more hardware specific properties from which these DAC power modes could be
derived.

If you need to always configure all DACs, wouldn't an array property be a
better option ?

> +		pdata->sd_config.sd_dac_out1 =
> +		    of_property_read_bool(np, "ad-adv7343-sd-config-dac-out-1");
> +
> +		pdata->sd_config.sd_dac_out2 =
> +		    of_property_read_bool(np, "ad-adv7343-sd-config-dac-out-2");
> +
> +		decoder->pdata = pdata;
> +	}
> +}

Thanks,
Sylwester
