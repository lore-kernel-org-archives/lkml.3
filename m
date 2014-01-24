Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaAXNqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:46:16 -0500
Received: from smtp-out-210.synserver.de ([212.40.185.210]:1102 "EHLO
	smtp-out-209.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752359AbaAXNqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:46:14 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1831
Message-ID: <52E26E9A.9040002@metafoo.de>
Date: Fri, 24 Jan 2014 14:46:02 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Marcus Folkesson <marcus.folkesson@gmail.com>
CC: Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adis16400: Set timestamp as the last element in
 chan_spec
References: <marcus.folkesson@gmail.com> <1390562644-25124-1-git-send-email-marcus.folkesson@gmail.com> <1390562644-25124-2-git-send-email-marcus.folkesson@gmail.com>
In-Reply-To: <1390562644-25124-2-git-send-email-marcus.folkesson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 12:24 PM, Marcus Folkesson wrote:
> This is necessary since timestamp is calculated as the last element
> in iio_compute_scan_bytes().
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

Looks good, thanks.

Acked-by: Lars-Peter Clausen

That said, I think we should try to modify the core code so that the scan
index for the timestamp is auto assigned to be always the last one.

> ---
>  drivers/iio/imu/adis16400.h      |    1 +
>  drivers/iio/imu/adis16400_core.c |   10 +++++-----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/imu/adis16400.h b/drivers/iio/imu/adis16400.h
> index 2f8f9d6..0916bf6 100644
> --- a/drivers/iio/imu/adis16400.h
> +++ b/drivers/iio/imu/adis16400.h
> @@ -189,6 +189,7 @@ enum {
>  	ADIS16300_SCAN_INCLI_X,
>  	ADIS16300_SCAN_INCLI_Y,
>  	ADIS16400_SCAN_ADC,
> +	ADIS16400_SCAN_TIMESTAMP,
>  };
>  
>  #ifdef CONFIG_IIO_BUFFER
> diff --git a/drivers/iio/imu/adis16400_core.c b/drivers/iio/imu/adis16400_core.c
> index 3fb7757..7f98657 100644
> --- a/drivers/iio/imu/adis16400_core.c
> +++ b/drivers/iio/imu/adis16400_core.c
> @@ -632,7 +632,7 @@ static const struct iio_chan_spec adis16400_channels[] = {
>  	ADIS16400_MAGN_CHAN(Z, ADIS16400_ZMAGN_OUT, 14),
>  	ADIS16400_TEMP_CHAN(ADIS16400_TEMP_OUT, 12),
>  	ADIS16400_AUX_ADC_CHAN(ADIS16400_AUX_ADC, 12),
> -	IIO_CHAN_SOFT_TIMESTAMP(12)
> +	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
>  };
>  
>  static const struct iio_chan_spec adis16448_channels[] = {
> @@ -654,7 +654,7 @@ static const struct iio_chan_spec adis16448_channels[] = {
>  		.scan_type = IIO_ST('s', 16, 16, 0),
>  	},
>  	ADIS16400_TEMP_CHAN(ADIS16448_TEMP_OUT, 12),
> -	IIO_CHAN_SOFT_TIMESTAMP(11)
> +	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
>  };
>  
>  static const struct iio_chan_spec adis16350_channels[] = {
> @@ -672,7 +672,7 @@ static const struct iio_chan_spec adis16350_channels[] = {
>  	ADIS16400_MOD_TEMP_CHAN(X, ADIS16350_XTEMP_OUT, 12),
>  	ADIS16400_MOD_TEMP_CHAN(Y, ADIS16350_YTEMP_OUT, 12),
>  	ADIS16400_MOD_TEMP_CHAN(Z, ADIS16350_ZTEMP_OUT, 12),
> -	IIO_CHAN_SOFT_TIMESTAMP(11)
> +	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
>  };
>  
>  static const struct iio_chan_spec adis16300_channels[] = {
> @@ -685,7 +685,7 @@ static const struct iio_chan_spec adis16300_channels[] = {
>  	ADIS16400_AUX_ADC_CHAN(ADIS16300_AUX_ADC, 12),
>  	ADIS16400_INCLI_CHAN(X, ADIS16300_PITCH_OUT, 13),
>  	ADIS16400_INCLI_CHAN(Y, ADIS16300_ROLL_OUT, 13),
> -	IIO_CHAN_SOFT_TIMESTAMP(14)
> +	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
>  };
>  
>  static const struct iio_chan_spec adis16334_channels[] = {
> @@ -696,7 +696,7 @@ static const struct iio_chan_spec adis16334_channels[] = {
>  	ADIS16400_ACCEL_CHAN(Y, ADIS16400_YACCL_OUT, 14),
>  	ADIS16400_ACCEL_CHAN(Z, ADIS16400_ZACCL_OUT, 14),
>  	ADIS16400_TEMP_CHAN(ADIS16350_XTEMP_OUT, 12),
> -	IIO_CHAN_SOFT_TIMESTAMP(8)
> +	IIO_CHAN_SOFT_TIMESTAMP(ADIS16400_SCAN_TIMESTAMP),
>  };
>  
>  static struct attribute *adis16400_attributes[] = {
> 

