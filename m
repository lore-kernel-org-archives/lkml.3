Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaHZQfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:35:22 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:46599 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaHZQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:35:21 -0400
Date: Tue, 26 Aug 2014 17:35:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 07/18] backlight: ili922x: remove 'else' after a return
Message-ID: <20140826163515.GQ26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00b101cfc12d$8954aa30$9bfdfe90$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b101cfc12d$8954aa30$9bfdfe90$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/ili922x.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> index ea67fe199e34..e7f0890cc211 100644
> --- a/drivers/video/backlight/ili922x.c
> +++ b/drivers/video/backlight/ili922x.c
> @@ -495,17 +495,18 @@ static int ili922x_probe(struct spi_device *spi)
>  			"no LCD found: Chip ID 0x%x, ret %d\n",
>  			reg, ret);
>  		return -ENODEV;
> -	} else {
> -		dev_info(&spi->dev, "ILI%x found, SPI freq %d, mode %d\n",
> -			 reg, spi->max_speed_hz, spi->mode);
>  	}
>  
> +	dev_info(&spi->dev, "ILI%x found, SPI freq %d, mode %d\n",
> +		 reg, spi->max_speed_hz, spi->mode);
> +
>  	ret = ili922x_read_status(spi, &reg);
>  	if (ret) {
>  		dev_err(&spi->dev, "reading RS failed...\n");
>  		return ret;
> -	} else
> -		dev_dbg(&spi->dev, "status: 0x%x\n", reg);
> +	}
> +
> +	dev_dbg(&spi->dev, "status: 0x%x\n", reg);
>  
>  	ili922x_display_init(spi);
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
