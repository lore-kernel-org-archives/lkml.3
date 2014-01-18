Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaARLzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:55:50 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38396 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaARLzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:55:47 -0500
Message-ID: <52DA6BCC.7010402@kernel.org>
Date: Sat, 18 Jan 2014 11:55:56 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] iio: gyro: itg3200: Add DT support.
References: <1389475047-4353-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1389475047-4353-1-git-send-email-marek@goldelico.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/01/14 21:17, Marek Belisko wrote:
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Marek Belisko <marek@goldelico.com>
Unless it is very recent, I don't the the invensense vendor-prefix is in
vendor-prefixes.txt. Please add that to the patch.

Otherwise, there is nothing here that isn't covered by the trivial
i2c bindings - thus perhaps it should be an entry in bindings/i2c/trivial-devices.txt?

Personally I'm not that fond of the trivial file as a single location
for the relevant info makes more sense to me.  Still thought I'd bring
it up as a possibility.

Jonathan
> ---
>   .../devicetree/bindings/iio/gyro/itg3200.txt       | 22 ++++++++++++++++++++++
>   drivers/iio/gyro/itg3200_core.c                    |  9 +++++++++
>   2 files changed, 31 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/iio/gyro/itg3200.txt
>
> diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
> new file mode 100644
> index 0000000..b1b18dc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
> @@ -0,0 +1,22 @@
> +* InvenSense ITG-3200 gyroscope
> +
> +http://www.invensense.com/mems/gyro/itg3200.html
> +
> +Required properties:
> +
> +  - compatible : should be "invensense,itg3200"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
> +  - interrupt-parent : should be the phandle for the interrupt controller
> +  - interrupts : interrupt mapping for GPIO IRQ
> +
> +Example:
> +
> +itg3200@68 {
> +	compatible = "invensense,itg3200";
> +	reg = <0x68>;
> +	interrupt-parent = <&gpio2>;
> +	interrupts = <29 IRQ_TYPE_EDGE_RISING>;
> +};
> diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200_core.c
> index 4d3f3b9..adbf20d 100644
> --- a/drivers/iio/gyro/itg3200_core.c
> +++ b/drivers/iio/gyro/itg3200_core.c
> @@ -374,10 +374,19 @@ static const struct i2c_device_id itg3200_id[] = {
>   };
>   MODULE_DEVICE_TABLE(i2c, itg3200_id);
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id itg3200_of_match[] = {
> +	{ .compatible = "invensense,itg3200", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, itg3200_of_match);
> +#endif
> +
>   static struct i2c_driver itg3200_driver = {
>   	.driver = {
>   		.owner  = THIS_MODULE,
>   		.name	= "itg3200",
> +		.of_match_table = of_match_ptr(itg3200_of_match),
>   	},
>   	.id_table	= itg3200_id,
>   	.probe		= itg3200_probe,
>
