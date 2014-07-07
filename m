Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaGGQOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:14:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:42282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaGGQOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:14:04 -0400
Message-ID: <53BAC7CF.2020501@kernel.org>
Date: Mon, 07 Jul 2014 17:16:15 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, pmeerw@pmeerw.net
CC: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: remove duplicate case labels
References: <1404742333-22681-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1404742333-22681-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/14 15:12, Daniel Baluta wrote:
> Otherwise, compiling iio_event_monitor program fails:
>
> io_event_monitor.c: In function ‘event_is_known’:
> iio_event_monitor.c:125:2: error: duplicate case value
>    case IIO_MOD_LIGHT_BOTH:
>    ^
> iio_event_monitor.c:121:2: error: previously used here
>    case IIO_MOD_LIGHT_BOTH:
>
> Fixes: da4db94 (iio staging: add recently added modifiers to iio_event_monitor)
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Applied to the togreg branch of iio.git.  It's a fix to example code so
probably not worth pushing out any faster.

Thanks,

Jonathan
> ---
>   drivers/staging/iio/Documentation/iio_event_monitor.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
> index cb35a97..569d6f8 100644
> --- a/drivers/staging/iio/Documentation/iio_event_monitor.c
> +++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
> @@ -122,8 +122,6 @@ static bool event_is_known(struct iio_event_data *event)
>   	case IIO_MOD_LIGHT_IR:
>   	case IIO_MOD_ROOT_SUM_SQUARED_X_Y:
>   	case IIO_MOD_SUM_SQUARED_X_Y_Z:
> -	case IIO_MOD_LIGHT_BOTH:
> -	case IIO_MOD_LIGHT_IR:
>   	case IIO_MOD_LIGHT_CLEAR:
>   	case IIO_MOD_LIGHT_RED:
>   	case IIO_MOD_LIGHT_GREEN:
>

