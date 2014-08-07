Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbaHGNrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:47:07 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37980 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbaHGNrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:47:04 -0400
Message-ID: <53E38356.5060800@kernel.org>
Date: Thu, 07 Aug 2014 14:47:02 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] staging:iio:ad9852: Use devm_iio_device_register
References: <20140803095833.GA6807@himangi-Dell>
In-Reply-To: <20140803095833.GA6807@himangi-Dell>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/14 10:58, Himangi Saraogi wrote:
> This patch introduces the use of devm_iio_device_register and does away
> with the unregister in the remove function.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Applied to the togreg branch of iio.git

Thanks,

J
> ---
>  drivers/staging/iio/frequency/ad9852.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/iio/frequency/ad9852.c b/drivers/staging/iio/frequency/ad9852.c
> index 11e4367..af2f2cc 100644
> --- a/drivers/staging/iio/frequency/ad9852.c
> +++ b/drivers/staging/iio/frequency/ad9852.c
> @@ -218,7 +218,7 @@ static int ad9852_probe(struct spi_device *spi)
>  	idev->info = &ad9852_info;
>  	idev->modes = INDIO_DIRECT_MODE;
>  
> -	ret = iio_device_register(idev);
> +	ret = devm_iio_device_register(&spi->dev, idev);
>  	if (ret)
>  		return ret;
>  	spi->max_speed_hz = 2000000;
> @@ -230,20 +230,12 @@ static int ad9852_probe(struct spi_device *spi)
>  	return 0;
>  }
>  
> -static int ad9852_remove(struct spi_device *spi)
> -{
> -	iio_device_unregister(spi_get_drvdata(spi));
> -
> -	return 0;
> -}
> -
>  static struct spi_driver ad9852_driver = {
>  	.driver = {
>  		.name = DRV_NAME,
>  		.owner = THIS_MODULE,
>  	},
>  	.probe = ad9852_probe,
> -	.remove = ad9852_remove,
>  };
>  module_spi_driver(ad9852_driver);
>  
> 
