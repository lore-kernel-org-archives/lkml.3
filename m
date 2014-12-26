Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaLZMkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:40:52 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45277 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaLZMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:40:50 -0500
Message-ID: <549D574F.6010700@kernel.org>
Date: Fri, 26 Dec 2014 12:40:47 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hartmut Knaack <knaack.h@gmx.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: accel: sca3000_core.c:  Remove unused function
References: <1419087187-4250-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419087187-4250-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/14 14:53, Rickard Strandqvist wrote:
> Remove the function sca3000_check_status() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Applied to the togreg branch of iio.git - initially pushed out as testing
for the autobuilders to play with it.

Thanks,

Jonathan
> ---
>  drivers/staging/iio/accel/sca3000_core.c |   27 ---------------------------
>  1 file changed, 27 deletions(-)
> 
> diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
> index e4e5639..655e34c 100644
> --- a/drivers/staging/iio/accel/sca3000_core.c
> +++ b/drivers/staging/iio/accel/sca3000_core.c
> @@ -223,33 +223,6 @@ error_ret:
>  	return ret;
>  }
>  
> -#ifdef SCA3000_DEBUG
> -/**
> - * sca3000_check_status() check the status register
> - *
> - * Only used for debugging purposes
> - **/
> -static int sca3000_check_status(struct device *dev)
> -{
> -	int ret;
> -	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> -	struct sca3000_state *st = iio_priv(indio_dev);
> -
> -	mutex_lock(&st->lock);
> -	ret = sca3000_read_data_short(st, SCA3000_REG_ADDR_STATUS, 1);
> -	if (ret < 0)
> -		goto error_ret;
> -	if (st->rx[0] & SCA3000_EEPROM_CS_ERROR)
> -		dev_err(dev, "eeprom error\n");
> -	if (st->rx[0] & SCA3000_SPI_FRAME_ERROR)
> -		dev_err(dev, "Previous SPI Frame was corrupt\n");
> -
> -error_ret:
> -	mutex_unlock(&st->lock);
> -	return ret;
> -}
> -#endif /* SCA3000_DEBUG */
> -
>  /**
>   * sca3000_show_rev() - sysfs interface to read the chip revision number
>   **/
> 

