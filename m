Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3CTS21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:28:27 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58388 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab3CTS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:28:26 -0400
Message-ID: <5149FFC5.3040504@kernel.org>
Date: Wed, 20 Mar 2013 18:28:21 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging/iio: iio_hwmon: Use device tree node name for
 hwmon name attribute
References: <1363794751-31977-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1363794751-31977-1-git-send-email-linux@roeck-us.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 03:52 PM, Guenter Roeck wrote:
> So far, all instances of iio_hwmon set their hwmon name attribute
> to "iio_hwmon", which is not very descriptive. Set it to the device tree
> node name if available, and only revert to iio_hwmon otherwise.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> 
> Jonathan, can we move this driver out of staging ?
> I would like to see it in 3.10 if possible.

Certainly. Now you've cleaned it up nicely it's ready
to go as far as I am concerned.  I'll put together a patch
on top of this sometime in the next couple of days and
post to the relevant lists etc and if no one shouts I'll
send it in a pull request to Greg around next weekend....

Thanks for all your hard work!

Jonathan

(This patch is fine, I'll apply it to iio.git shortly.)

> 
>  drivers/staging/iio/iio_hwmon.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/iio_hwmon.c b/drivers/staging/iio/iio_hwmon.c
> index 93af756..aafa453 100644
> --- a/drivers/staging/iio/iio_hwmon.c
> +++ b/drivers/staging/iio/iio_hwmon.c
> @@ -13,6 +13,7 @@
>  #include <linux/err.h>
>  #include <linux/platform_device.h>
>  #include <linux/hwmon.h>
> +#include <linux/of.h>
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/iio/consumer.h>
>  #include <linux/iio/types.h>
> @@ -58,7 +59,12 @@ static ssize_t iio_hwmon_read_val(struct device *dev,
>  static ssize_t show_name(struct device *dev, struct device_attribute *attr,
>  			 char *buf)
>  {
> -	return sprintf(buf, "iio_hwmon\n");
> +	const char *name = "iio_hwmon";
> +
> +	if (dev->of_node && dev->of_node->name)
> +		name = dev->of_node->name;
> +
> +	return sprintf(buf, "%s\n", name);
>  }
>  
>  static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
> 
