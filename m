Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3KRL6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:58:05 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49021 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab3KRL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:57:57 -0500
Date: Mon, 18 Nov 2013 11:57:42 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] itg3200: add dt support.
Message-ID: <20131118115742.GG30853@e106331-lin.cambridge.arm.com>
References: <20131101154854.2d7d1432@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101154854.2d7d1432@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 04:48:54AM +0000, NeilBrown wrote:
> 
> 
> No new configuration, just a 'compatible' string and documentation.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
> new file mode 100644
> index 000000000000..4581620632df
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
> @@ -0,0 +1,20 @@
> +* InvenSense ITG3200 3-axis gyroscope
> +
> +Required properties:
> +
> +  - compatible : "invensense,itg3200"
> +  - reg : I2C address, typically 0x68
> +
> +Optional properties:
> +
> +  - interrupt-parent : should be the phandle for the interrupt controller
> +  - interrupts : interrupt mapping for GPIO IRQ

Why is this a "GPIO IRQ"? This device das no GPIO. The fact that it
might be wired to a GPIO controller has nothing to do with the ITG3200,
and shouldn't be a concern of its binding.

Thanks,
Mark.

> +
> +Example:
> +
> +itg3200@68 {
> +	compatible = "invensense,itg3200";
> +	reg = <0x68>;
> +	interrupt-parent = <&gpio2>;
> +	interrupts = <24 IRQ_TYPE_EDGE_RISING>;
> +};
> diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200_core.c
> index 4d3f3b92b361..1ed3003ef41a 100644
> --- a/drivers/iio/gyro/itg3200_core.c
> +++ b/drivers/iio/gyro/itg3200_core.c
> @@ -374,10 +374,17 @@ static const struct i2c_device_id itg3200_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, itg3200_id);
>  
> +static const struct of_device_id itg3200_of_match[] = {
> +	{ .compatible = "invensense,itg3200", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, itg3200_of_match);
> +
>  static struct i2c_driver itg3200_driver = {
>  	.driver = {
>  		.owner  = THIS_MODULE,
>  		.name	= "itg3200",
> +		.of_match_table = of_match_ptr(itg3200_of_match),
>  	},
>  	.id_table	= itg3200_id,
>  	.probe		= itg3200_probe,


