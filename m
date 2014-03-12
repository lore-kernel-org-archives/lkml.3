Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaCLJna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:43:30 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60615 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaCLJn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:43:27 -0400
Date: Wed, 12 Mar 2014 09:43:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, sbkim73@samsung.com
Subject: Re: [PATCH v2] drivers: mfd: silence compiler warning in sec-core.c
Message-ID: <20140312094322.GG5672@lee--X1>
References: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
 <1394606261-4659-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394606261-4659-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Pankaj Dubey wrote:

> When used 64bit compiler GCC warns as
> drivers/mfd/sec-core.c:199:10: warning:
> cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  drivers/mfd/sec-core.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index e467108..3c9fd5d 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -210,17 +210,17 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
>  }
>  #endif
>  
> -static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
> +static inline unsigned long sec_i2c_get_driver_data(struct i2c_client *i2c,
>  						const struct i2c_device_id *id)
>  {
>  #ifdef CONFIG_OF
>  	if (i2c->dev.of_node) {
>  		const struct of_device_id *match;
>  		match = of_match_node(sec_dt_match, i2c->dev.of_node);
> -		return (int)match->data;
> +		return (unsigned long)match->data;
>  	}
>  #endif
> -	return (int)id->driver_data;
> +	return id->driver_data;
>  }
>  
>  static int sec_pmic_probe(struct i2c_client *i2c,

You also need to change the 'type' attribute in 'struct
sec_pmic_dev'.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
