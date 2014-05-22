Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaEVKhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:37:00 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32994 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaEVKg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:36:59 -0400
Message-ID: <537DD33B.6070401@gmail.com>
Date: Thu, 22 May 2014 16:06:43 +0530
From: Jay Aurabind <jay.aurabind@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: abx500-core: Remove unused function abx500_dump_all_banks()
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 02:48 PM, Lee Jones wrote:
> abx500_dump_all_banks() has no callers in the kernel, so it's probably
> safe to remove it.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/abx500-core.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
> index d6d0ec4..fe41899 100644
> --- a/drivers/mfd/abx500-core.c
> +++ b/drivers/mfd/abx500-core.c
> @@ -151,26 +151,6 @@ int abx500_startup_irq_enabled(struct device *dev, unsigned int irq)
>  }
>  EXPORT_SYMBOL(abx500_startup_irq_enabled);
>  
> -int abx500_dump_all_banks(void)
> -{
> -	struct abx500_ops *ops;
> -	struct device *dummy_child;
> -	struct abx500_device_entry *dev_entry;
> -
> -	dummy_child = kzalloc(sizeof(struct device), GFP_KERNEL);
> -	if (!dummy_child)
> -		return -ENOMEM;
> -	list_for_each_entry(dev_entry, &abx500_list, list) {
> -		dummy_child->parent = dev_entry->dev;
> -		ops = &dev_entry->ops;
> -
> -		if ((ops != NULL) && (ops->dump_all_banks != NULL))
> -			ops->dump_all_banks(dummy_child);
> -	}
> -	kfree(dummy_child);
> -}
> -EXPORT_SYMBOL(abx500_dump_all_banks);
> -
>  MODULE_AUTHOR("Mattias Wallin <mattias.wallin@stericsson.com>");
>  MODULE_DESCRIPTION("ABX500 core driver");
>  MODULE_LICENSE("GPL");
> 
Sorry for top posting previously, I was using gmail web interface. Looks
like you forgot to remove this function's declaration from
include/linux/mfd/abx500.h
