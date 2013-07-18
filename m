Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab3GRQXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:23:53 -0400
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1083 "EHLO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab3GRQXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:23:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32582
Message-ID: <51E816BD.9010302@metafoo.de>
Date: Thu, 18 Jul 2013 18:24:29 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH] iio: core: Avoid double minus in sysfs output
References: <1374162430-30709-1-git-send-email-x0199363@ti.com>
In-Reply-To: <1374162430-30709-1-git-send-email-x0199363@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 05:47 PM, Oleksandr Kravchenko wrote:
> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> 
> This patch fixes the issue with double minus in output when
> reading channels from sysfs for IIO_VAL_INT_PLUS_MICRO and
> IIO_VAL_INT_PLUS_NANO cases. Until this patch if val and val2
> both are negatives output string contains "--" before
> digits. It is result of "-%d..." in sprintf() format.
> 

Hm, this might be a bug in a driver that is triggering this. The idea is
that val2 is only allowed to be negative if val is 0.

- Lars

> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> ---
>  drivers/iio/industrialio-core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index d56d122..b3d3959 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -383,14 +383,14 @@ static ssize_t iio_read_channel_info(struct device *dev,
>  		scale_db = true;
>  	case IIO_VAL_INT_PLUS_MICRO:
>  		if (val2 < 0)
> -			return sprintf(buf, "-%d.%06u%s\n", val, -val2,
> +			return sprintf(buf, "-%d.%06u%s\n", abs(val), -val2,
>  				scale_db ? " dB" : "");
>  		else
>  			return sprintf(buf, "%d.%06u%s\n", val, val2,
>  				scale_db ? " dB" : "");
>  	case IIO_VAL_INT_PLUS_NANO:
>  		if (val2 < 0)
> -			return sprintf(buf, "-%d.%09u\n", val, -val2);
> +			return sprintf(buf, "-%d.%09u\n", abs(val), -val2);
>  		else
>  			return sprintf(buf, "%d.%09u\n", val, val2);
>  	case IIO_VAL_FRACTIONAL:
> 

