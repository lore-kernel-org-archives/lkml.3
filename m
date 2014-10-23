Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaJWPyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:54:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42451 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJWPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:54:01 -0400
Date: Thu, 23 Oct 2014 08:53:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH] input: soc_button_array: update calls to gpiod_get*()
Message-ID: <20141023155357.GD18714@dtor-ws>
References: <1414052275-20310-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414052275-20310-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 05:17:55PM +0900, Alexandre Courbot wrote:
> Add the new flags argument to calls of (devm_)gpiod_get*().
> 
> Currently both forms (with or without the flags argument)
> are valid thanks to transitional macros in
> <linux/gpio/consumer.h>. These macros will be removed once
> all consumers are updated and the flags argument will become
> compulsary.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Applied, thank you.

> ---
>  drivers/input/misc/soc_button_array.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
> index 735604753568..e097f1ab427f 100644
> --- a/drivers/input/misc/soc_button_array.c
> +++ b/drivers/input/misc/soc_button_array.c
> @@ -55,7 +55,7 @@ static int soc_button_lookup_gpio(struct device *dev, int acpi_index)
>  	struct gpio_desc *desc;
>  	int gpio;
>  
> -	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index);
> +	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index, GPIOD_ASIS);
>  	if (IS_ERR(desc))
>  		return PTR_ERR(desc);
>  
> -- 
> 2.1.2
> 

-- 
Dmitry
