Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3JXH3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:29:03 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58955 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3JXH3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:29:01 -0400
Message-ID: <5268DA76.6060503@kernel.org>
Date: Thu, 24 Oct 2013 09:29:42 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        linux-iio@vger.kernel.org
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Brenner - TAOS <jbrenner@taosinc.com>
Subject: Re: [PATCH] iio:light:tsl2563: Add DT support
References: <1382565063-17083-1-git-send-email-sre@debian.org>
In-Reply-To: <1382565063-17083-1-git-send-email-sre@debian.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/13 22:51, Sebastian Reichel wrote:
> Add Device Tree support for the TSL2563 driver
> and document the binding.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  .../devicetree/bindings/iio/light/tsl2563.txt         | 19 +++++++++++++++++++
>  drivers/iio/light/tsl2563.c                           |  4 ++++
>  2 files changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/light/tsl2563.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2563.txt b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> new file mode 100644
> index 0000000..b52cf4b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> @@ -0,0 +1,19 @@
> +* TAOS TSL2563 ambient light sensor
> +
> +Required properties:
> +
> +  - compatible : should be "taos,tsl2563"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
So two options for this one.  Either pitch it as a possible general parameter, or
mark it with a vendor prefix.  It seems like something fairly general, but in that case it
probably needs a more detailed proposal and explanation of exactly what it is.

Also, is taos listed in vendor-prefixes.txt?  Jon, is that the right vendor prefix to use?
I'm guessing you have some non mainline bindings out there already so it would be good
to match those...

> +  - cover-comp-gain : integer used as multiplier for gain
> +                      compensation (default = 1)
> +
> +Example:
> +
> +tsl2563@29 {
> +	compatible = "taos,tsl2563";
> +	reg = <0x29>;
> +	cover-comp-gain = <16>;
> +};
> diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
> index ebb962c..bd30b1d 100644
> --- a/drivers/iio/light/tsl2563.c
> +++ b/drivers/iio/light/tsl2563.c
> @@ -699,6 +699,7 @@ static int tsl2563_probe(struct i2c_client *client,
>  	struct iio_dev *indio_dev;
>  	struct tsl2563_chip *chip;
>  	struct tsl2563_platform_data *pdata = client->dev.platform_data;
> +	struct device_node *np = client->dev.of_node;
>  	int err = 0;
>  	u8 id = 0;
>  
> @@ -735,6 +736,9 @@ static int tsl2563_probe(struct i2c_client *client,
>  
>  	if (pdata)
>  		chip->cover_comp_gain = pdata->cover_comp_gain;
> +	else if (np)
> +		of_property_read_u32_index(np, "cover-comp-gain", 0,
> +							&chip->cover_comp_gain);
>  	else
>  		chip->cover_comp_gain = 1;
>  
> 
