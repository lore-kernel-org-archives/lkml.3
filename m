Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbaCUHfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:35:01 -0400
Received: from smtp-out-034.synserver.de ([212.40.185.34]:1077 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756886AbaCUHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:34:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17179
Message-ID: <532BEBCD.3020002@metafoo.de>
Date: Fri, 21 Mar 2014 08:35:41 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jimmy Li <coder.liss@gmail.com>
CC: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix some coding style in drivers/staging/iio
References: <20140321044546.GA12515@gmail.com>
In-Reply-To: <20140321044546.GA12515@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> diff --git a/drivers/staging/iio/accel/adis16220_core.c b/drivers/staging/iio/accel/adis16220_core.c
> index 6f38ca9..31c7a9d 100644
> --- a/drivers/staging/iio/accel/adis16220_core.c
> +++ b/drivers/staging/iio/accel/adis16220_core.c
> @@ -392,7 +392,8 @@ static const struct iio_info adis16220_info = {
>   };
>
>   static const char * const adis16220_status_error_msgs[] = {
> -	[ADIS16220_DIAG_STAT_VIOLATION_BIT] = "Capture period violation/interruption",
> +	[ADIS16220_DIAG_STAT_VIOLATION_BIT] =
> +		"Capture period violation/interruption",

This does not improve legibility. The 80 chars per line rule is to improve 
legibility, if it doesn't it's better to ignore it.

>   	[ADIS16220_DIAG_STAT_SPI_FAIL_BIT] = "SPI failure",
>   	[ADIS16220_DIAG_STAT_FLASH_UPT_BIT] = "Flash update failed",
>   	[ADIS16220_DIAG_STAT_POWER_HIGH_BIT] = "Power supply above 3.625V",
[...]
> diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
> index 36eedd8..d38df2e 100644
> --- a/drivers/staging/iio/resolver/ad2s1200.c
> +++ b/drivers/staging/iio/resolver/ad2s1200.c
> @@ -70,6 +70,7 @@ static int ad2s1200_read_raw(struct iio_dev *indio_dev,
>   		vel = (((s16)(st->rx[0])) << 4) | ((st->rx[1] & 0xF0) >> 4);
>   		vel = (vel << 4) >> 4;
>   		*val = vel;
> +		/* fall through */

This not a coding style issue, here is actually a break missing.

>   	default:
>   		mutex_unlock(&st->lock);
>   		return -EINVAL;
>

