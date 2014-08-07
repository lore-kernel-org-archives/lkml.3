Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbaHGNqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:46:13 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37970 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbaHGNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:46:11 -0400
Message-ID: <53E38321.1000804@kernel.org>
Date: Thu, 07 Aug 2014 14:46:09 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] staging: iio: ad9951: Use devm_iio_device_register
References: <20140803100048.GA6936@himangi-Dell>
In-Reply-To: <20140803100048.GA6936@himangi-Dell>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/14 11:00, Himangi Saraogi wrote:
> This patch introduces the use of devm_iio_device_register and does away
> with the unregister in the remove function. The remove function is no
> longer required and is completely removed.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Applied to the togreg branch of iio.git

Thanks,

J
> ---
>  drivers/staging/iio/frequency/ad9951.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/iio/frequency/ad9951.c b/drivers/staging/iio/frequency/ad9951.c
> index 5e8990a..d465db0 100644
> --- a/drivers/staging/iio/frequency/ad9951.c
> +++ b/drivers/staging/iio/frequency/ad9951.c
> @@ -175,7 +175,7 @@ static int ad9951_probe(struct spi_device *spi)
>  	idev->info = &ad9951_info;
>  	idev->modes = INDIO_DIRECT_MODE;
>  
> -	ret = iio_device_register(idev);
> +	ret = devm_iio_device_register(&spi->dev, idev);
>  	if (ret)
>  		return ret;
>  	spi->max_speed_hz = 2000000;
> @@ -186,20 +186,12 @@ static int ad9951_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ad9951_remove(struct spi_device *spi)
> -{
> -	iio_device_unregister(spi_get_drvdata(spi));
> -
> -	return 0;
> -}
> -
>  static struct spi_driver ad9951_driver = {
>  	.driver = {
>  		.name = DRV_NAME,
>  		.owner = THIS_MODULE,
>  	},
>  	.probe = ad9951_probe,
> -	.remove = ad9951_remove,
>  };
>  module_spi_driver(ad9951_driver);
>  
> 
