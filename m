Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3G0Kvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:51:43 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53673 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab3G0Kvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:51:42 -0400
Message-ID: <51F3B450.9010502@kernel.org>
Date: Sat, 27 Jul 2013 12:51:44 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH] iio: core: Avoid double minus in sysfs output
References: <1374491763-16149-1-git-send-email-x0199363@ti.com>
In-Reply-To: <1374491763-16149-1-git-send-email-x0199363@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/13 12:16, Oleksandr Kravchenko wrote:
> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> 
> This patch fixes the issue with double minus in output when
> reading channels from sysfs for IIO_VAL_INT_PLUS_MICRO and
> IIO_VAL_INT_PLUS_NANO cases. Until this patch if val and val2
> both are negatives output string contains "--" before
> digits. It is result of "-%d..." in sprintf() format.
> 
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Applied to the togreg branch of iio.git

Not taken this as a fix as I don't know of any current drivers where this will
be a problem.

Thanks.
> ---
>  drivers/iio/industrialio-core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index d56d122..97f0297 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -383,14 +383,14 @@ static ssize_t iio_read_channel_info(struct device *dev,
>  		scale_db = true;
>  	case IIO_VAL_INT_PLUS_MICRO:
>  		if (val2 < 0)
> -			return sprintf(buf, "-%d.%06u%s\n", val, -val2,
> +			return sprintf(buf, "-%ld.%06u%s\n", abs(val), -val2,
>  				scale_db ? " dB" : "");
>  		else
>  			return sprintf(buf, "%d.%06u%s\n", val, val2,
>  				scale_db ? " dB" : "");
>  	case IIO_VAL_INT_PLUS_NANO:
>  		if (val2 < 0)
> -			return sprintf(buf, "-%d.%09u\n", val, -val2);
> +			return sprintf(buf, "-%ld.%09u\n", abs(val), -val2);
>  		else
>  			return sprintf(buf, "%d.%09u\n", val, val2);
>  	case IIO_VAL_FRACTIONAL:
> 
