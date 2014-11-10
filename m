Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaKJJaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:30:13 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42575 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaKJJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:30:11 -0500
Date: Mon, 10 Nov 2014 09:30:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: dln2: add support for USB-SPI module
Message-ID: <20141110093005.GF21424@x1>
References: <1415364314-30320-1-git-send-email-laurentiu.palcu@intel.com>
 <1415364314-30320-3-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415364314-30320-3-git-send-email-laurentiu.palcu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Laurentiu Palcu wrote:

> Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
> ---
>  drivers/mfd/dln2.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
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

Is this ever fiddled with?  If not, const?

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
