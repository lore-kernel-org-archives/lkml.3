Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaKSQ3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:29:34 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34969 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaKSQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:29:32 -0500
Date: Wed, 19 Nov 2014 16:29:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mfd: dln2: add support for USB-SPI module
Message-ID: <20141119162925.GE1875@x1>
References: <1416312599-5176-1-git-send-email-laurentiu.palcu@intel.com>
 <1416312599-5176-3-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416312599-5176-3-git-send-email-laurentiu.palcu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Laurentiu Palcu wrote:

> Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
> ---
>  drivers/mfd/dln2.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

For my own reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

So what's the plan for this set?

> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index 9765a17..0cdad2d 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -52,6 +52,7 @@ enum dln2_handle {
>  	DLN2_HANDLE_CTRL,
>  	DLN2_HANDLE_GPIO,
>  	DLN2_HANDLE_I2C,
> +	DLN2_HANDLE_SPI,
>  	DLN2_HANDLES
>  };
>  
> @@ -634,6 +635,12 @@ static struct dln2_platform_data dln2_pdata_i2c = {
>  	.port = 0,
>  };
>  
> +/* Only one SPI port supported */
> +static struct dln2_platform_data dln2_pdata_spi = {
> +	.handle = DLN2_HANDLE_SPI,
> +	.port = 0,
> +};
> +
>  static const struct mfd_cell dln2_devs[] = {
>  	{
>  		.name = "dln2-gpio",
> @@ -645,6 +652,11 @@ static const struct mfd_cell dln2_devs[] = {
>  		.platform_data = &dln2_pdata_i2c,
>  		.pdata_size = sizeof(struct dln2_platform_data),
>  	},
> +	{
> +		.name = "dln2-spi",
> +		.platform_data = &dln2_pdata_spi,
> +		.pdata_size = sizeof(struct dln2_platform_data),
> +	},
>  };
>  
>  static void dln2_disconnect(struct usb_interface *interface)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
