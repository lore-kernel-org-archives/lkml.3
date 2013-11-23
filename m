Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3KWKvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 05:51:18 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54727 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3KWKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 05:51:15 -0500
Message-ID: <529096F6.3040202@kernel.org>
Date: Sat, 23 Nov 2013 11:52:22 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        linux-iio@vger.kernel.org
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Kumar Gala <galak@codeaurora.org>, Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] iio:light:tsl2563: Add DT support
References: <1382565063-17083-1-git-send-email-sre@debian.org> <1382692210-9692-1-git-send-email-sre@debian.org>
In-Reply-To: <1382692210-9692-1-git-send-email-sre@debian.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 10:10, Sebastian Reichel wrote:
> Add Device Tree support for the TSL2563 driver,
> document the binding and add AMS-TAOS Inc. to the
> list of vendor prefixes.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Kumar Gala <galak@codeaurora.org>
Applied to the togreg branch of iio.git with the minor change Grant pointed out
to not use the indexed version of the of_property_read_u32

Thanks all,

Jonathan
> ---
>  .../devicetree/bindings/iio/light/tsl2563.txt         | 19 +++++++++++++++++++
>  Documentation/devicetree/bindings/vendor-prefixes.txt |  1 +
>  drivers/iio/light/tsl2563.c                           |  4 ++++
>  3 files changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/light/tsl2563.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2563.txt b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> new file mode 100644
> index 0000000..f91e809
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> @@ -0,0 +1,19 @@
> +* AMS TAOS TSL2563 ambient light sensor
> +
> +Required properties:
> +
> +  - compatible : should be "amstaos,tsl2563"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
> +  - amstaos,cover-comp-gain : integer used as multiplier for gain
> +                              compensation (default = 1)
> +
> +Example:
> +
> +tsl2563@29 {
> +	compatible = "amstaos,tsl2563";
> +	reg = <0x29>;
> +	amstaos,cover-comp-gain = <16>;
> +};
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 2cc3dad..8cf3edf 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -9,6 +9,7 @@ aeroflexgaisler	Aeroflex Gaisler AB
>  ak	Asahi Kasei Corp.
>  altr	Altera Corp.
>  amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
> +amstaos	AMS-Taos Inc.
>  apm	Applied Micro Circuits Corporation (APM)
>  arm	ARM Ltd.
>  atmel	Atmel Corporation
> diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
> index ebb962c..261660a 100644
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
> +		of_property_read_u32_index(np, "amstaos,cover-comp-gain", 0,
> +							&chip->cover_comp_gain);
>  	else
>  		chip->cover_comp_gain = 1;
>  
> 
