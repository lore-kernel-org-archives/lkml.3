Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaJYTVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:21:04 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49929 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaJYTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:21:03 -0400
Message-ID: <544B7290.1030102@kernel.org>
Date: Sat, 25 Oct 2014 10:51:12 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>, pmeerw@pmeerw.net
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: tsl4531: Fix compiler error when CONFIG_PM_OPS is
 not defined
References: <1413834722-7500-1-git-send-email-dmurphy@ti.com>
In-Reply-To: <1413834722-7500-1-git-send-email-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/10/14 20:52, Dan Murphy wrote:
> Fix the compiler error when the CONFIG_PM_OPS flag is not set.
> 
> drivers/iio/light/tsl4531.c:235:8: error: ‘tsl4531_suspend’ undeclared here (not in a function)
> drivers/iio/light/tsl4531.c:235:8: error: ‘tsl4531_resume’ undeclared here (not in a function)
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
Applied to the fixes-togreg branch of iio.git

Thanks,

Jonathan
> ---
>  drivers/iio/light/tsl4531.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/light/tsl4531.c b/drivers/iio/light/tsl4531.c
> index a15006e..0763b86 100644
> --- a/drivers/iio/light/tsl4531.c
> +++ b/drivers/iio/light/tsl4531.c
> @@ -230,9 +230,12 @@ static int tsl4531_resume(struct device *dev)
>  	return i2c_smbus_write_byte_data(to_i2c_client(dev), TSL4531_CONTROL,
>  		TSL4531_MODE_NORMAL);
>  }
> -#endif
>  
>  static SIMPLE_DEV_PM_OPS(tsl4531_pm_ops, tsl4531_suspend, tsl4531_resume);
> +#define TSL4531_PM_OPS (&tsl4531_pm_ops)
> +#else
> +#define TSL4531_PM_OPS NULL
> +#endif
>  
>  static const struct i2c_device_id tsl4531_id[] = {
>  	{ "tsl4531", 0 },
> @@ -243,7 +246,7 @@ MODULE_DEVICE_TABLE(i2c, tsl4531_id);
>  static struct i2c_driver tsl4531_driver = {
>  	.driver = {
>  		.name   = TSL4531_DRV_NAME,
> -		.pm	= &tsl4531_pm_ops,
> +		.pm	= TSL4531_PM_OPS,
>  		.owner  = THIS_MODULE,
>  	},
>  	.probe  = tsl4531_probe,
> 
