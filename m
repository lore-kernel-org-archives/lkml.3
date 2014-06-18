Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965317AbaFRJUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:20:21 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52621 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840AbaFRJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:20:19 -0400
Date: Wed, 18 Jun 2014 10:20:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: broonie@kernel.org, Andrew Bresticker <abrestic@chromium.org>,
        swarren@wwwdotorg.org, olof@lixom.net,
        Sonny Rao <sonnyrao@chromium.org>, linux-samsung-soc@vger.kernel.org,
        Prathyush K <prathyush.k@samsung.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: cros_ec_spi: set wakeup capability
Message-ID: <20140618092012.GF23945@lee--X1>
References: <1402953143-24681-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402953143-24681-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Prathyush K <prathyush.k@samsung.com>
> 
> Set the device as wakeup capable and register the wakeup source.
> 
> Note: Though it makes more sense to have the SPI framework do this,
> (either via device tree or by board_info)
> this change is as per an existing mail chain:
> https://lkml.org/lkml/2009/8/27/291
> 
> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Note that I don't have suspend/resume actually working upstream, but I
> see that /sys/bus/spi/drivers/cros-ec-spi/spi2.0/power/wakeup exists
> with this patch and doesn't exist without it.

Very well.  Applied, thanks.

>  drivers/mfd/cros_ec_spi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 0b8d328..ef22dd5 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -385,6 +385,8 @@ static int cros_ec_spi_probe(struct spi_device *spi)
>  		return err;
>  	}
>  
> +	device_init_wakeup(&spi->dev, true);
> +
>  	return 0;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
