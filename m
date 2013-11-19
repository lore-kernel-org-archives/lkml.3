Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3KSKAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:00:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39715 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597Ab3KSKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:00:05 -0500
Date: Tue, 19 Nov 2013 09:59:29 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH v2] itg3200: add dt support.
Message-ID: <20131119095929.GG5914@e106331-lin.cambridge.arm.com>
References: <20131119113013.39dae3cd@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119113013.39dae3cd@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 12:30:13AM +0000, NeilBrown wrote:
> 
> 
> No new configuration, just a 'compatible' string and documentation.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
> b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt new file mode 100644
> index 000000000000..4581620632df
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
> @@ -0,0 +1,20 @@
> +* InvenSense ITG3200 3-axis gyroscope
> +
> +Required properties:
> +
> +  - compatible : "invensense,itg3200"

I couldn't see "invensense" in vendor-prefixes.txt. Assuming I haven't
missed a patch adding it, could you amend this patch to do so?

Otherwise this looks fine to me.

Cheers,
Mark.

> +  - reg : I2C address, typically 0x68
> +
> +Optional properties:
> +
> +  - interrupt-parent : should be the phandle for the interrupt controller
> +  - interrupts : interrupt mapping for IRQ
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


