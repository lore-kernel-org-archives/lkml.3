Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaCOOot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 10:44:49 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60011 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaCOOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 10:44:47 -0400
Message-ID: <53246799.8080600@kernel.org>
Date: Sat, 15 Mar 2014 14:45:45 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: linux-iio@vger.kernel.org
Subject: Re: [PATCH] iio: force snprintf for PAGE_SIZE bufs
References: <20140313164643.GA19171@www.outflux.net>
In-Reply-To: <20140313164643.GA19171@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/14 16:46, Kees Cook wrote:
> This is a tiny preventative measure to make sure we can't write beyond
> PAGE_SIZE on the buffers being used in sysfs for iio. There is currently
> no way for this to happen, but the change makes this code more robust
> for the future.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
A sensible enough change I guess.

Applied to the togreg branch of iio.git

Jonathan
> ---
>   drivers/iio/industrialio-core.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index acc911a836ca..64bb64f35af8 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -340,7 +340,7 @@ ssize_t iio_enum_read(struct iio_dev *indio_dev,
>   	else if (i >= e->num_items)
>   		return -EINVAL;
>
> -	return sprintf(buf, "%s\n", e->items[i]);
> +	return snprintf(buf, PAGE_SIZE, "%s\n", e->items[i]);
>   }
>   EXPORT_SYMBOL_GPL(iio_enum_read);
>
> @@ -836,7 +836,7 @@ static ssize_t iio_show_dev_name(struct device *dev,
>   				 char *buf)
>   {
>   	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
> -	return sprintf(buf, "%s\n", indio_dev->name);
> +	return snprintf(buf, PAGE_SIZE, "%s\n", indio_dev->name);
>   }
>
>   static DEVICE_ATTR(name, S_IRUGO, iio_show_dev_name, NULL);
>

