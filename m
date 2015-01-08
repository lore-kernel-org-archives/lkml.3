Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbbAHKrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:47:11 -0500
Received: from smtp-out-080.synserver.de ([212.40.185.80]:1094 "EHLO
	smtp-out-080.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbbAHKrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:47:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9322
Message-ID: <54AE6024.8050303@metafoo.de>
Date: Thu, 08 Jan 2015 11:47:00 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [RFC PATCH] iio: Add new operating mode for non triggered sw
 buffers
References: <1420655771-22465-1-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1420655771-22465-1-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 07:36 PM, Karol Wrona wrote:
> There was a need for non triggered software buffer type.  It can be used when
> triggered model does not fit and INDIO_BUFFER_HARDWARE causes confusion because
> the data stream can be obtained not directly form hardware backend.
>
> Suggested-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>

Looks good, thanks.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>   drivers/iio/industrialio-buffer.c |    2 ++
>   include/linux/iio/iio.h           |    6 ++++--
>   2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
> index f971f79..15e6de3 100644
> --- a/drivers/iio/industrialio-buffer.c
> +++ b/drivers/iio/industrialio-buffer.c
> @@ -680,6 +680,8 @@ static int __iio_update_buffers(struct iio_dev *indio_dev,
>   		indio_dev->currentmode = INDIO_BUFFER_TRIGGERED;
>   	} else if (indio_dev->modes & INDIO_BUFFER_HARDWARE) {
>   		indio_dev->currentmode = INDIO_BUFFER_HARDWARE;
> +	} else if (indio_dev->modes & INDIO_BUFFER_SOFTWARE) {
> +		indio_dev->currentmode = INDIO_BUFFER_SOFTWARE;
>   	} else { /* Should never be reached */
>   		ret = -EINVAL;
>   		goto error_run_postdisable;
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index 3642ce7..55e63fd 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -284,10 +284,11 @@ static inline s64 iio_get_time_ns(void)
>   /* Device operating modes */
>   #define INDIO_DIRECT_MODE		0x01
>   #define INDIO_BUFFER_TRIGGERED		0x02
> +#define INDIO_BUFFER_SOFTWARE		0x04
>   #define INDIO_BUFFER_HARDWARE		0x08
>
>   #define INDIO_ALL_BUFFER_MODES					\
> -	(INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE)
> +	(INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE | INDIO_BUFFER_SOFTWARE)
>
>   #define INDIO_MAX_RAW_ELEMENTS		4
>
> @@ -591,7 +592,8 @@ void devm_iio_trigger_free(struct device *dev, struct iio_trigger *iio_trig);
>   static inline bool iio_buffer_enabled(struct iio_dev *indio_dev)
>   {
>   	return indio_dev->currentmode
> -		& (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE);
> +		& (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE |
> +		   INDIO_BUFFER_SOFTWARE);
>   }
>
>   /**
>

