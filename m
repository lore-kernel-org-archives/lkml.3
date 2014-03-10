Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaCJPHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:07:08 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37723 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCJPHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:07:06 -0400
Date: Mon, 10 Mar 2014 15:07:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, sbkim73@samsung.com
Subject: Re: [PATCH] drivers: mfd: silence compiler warning in sec-core.c
Message-ID: <20140310150700.GC13661@lee--X1>
References: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When used 64bit compiler GCC warns as
> drivers/mfd/sec-core.c:199:10: warning:
> cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 
> This patch fixes this by type-casting "match->data" into "long" before
> converting into "int"
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  drivers/mfd/sec-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index a139798..2e7580bd 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -187,7 +187,7 @@ static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
>  	if (i2c->dev.of_node) {
>  		const struct of_device_id *match;
>  		match = of_match_node(sec_dt_match, i2c->dev.of_node);
> -		return (int)match->data;
> +		return (int)(long)match->data;

I think using an unsigned long would be better.

>  	}
>  #endif
>  	return (int)id->driver_data;

Doesn't this give you the same error?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
