Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3EWIiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:38:00 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:54854 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3EWIh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:37:56 -0400
Date: Thu, 23 May 2013 09:37:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Leon Romanovsky <leon@leon.nu>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
Message-ID: <20130523083751.GC22683@gmail.com>
References: <1368609586-20905-1-git-send-email-leon@leon.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368609586-20905-1-git-send-email-leon@leon.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, Leon Romanovsky wrote:

> There is no need to call kfree while using devm_kzalloc,
> remove it from *_device_init function.
> 
> Signed-off-by: Leon Romanovsky <leon@leon.nu>
> ---
>  drivers/mfd/tps65912-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
> index aeb8e40..f25e552 100644
> --- a/drivers/mfd/tps65912-core.c
> +++ b/drivers/mfd/tps65912-core.c
> @@ -127,7 +127,8 @@ int tps65912_device_init(struct tps65912 *tps65912)
>  	struct tps65912_platform_data *init_data;
>  	int ret, dcdc_avs, value;
>  
> -	init_data = kzalloc(sizeof(struct tps65912_platform_data), GFP_KERNEL);
> +	init_data = devm_kzalloc(&tps65912->dev,
> +			sizeof(struct tps65912_platform_data), GFP_KERNEL);

On second thoughts, have you actually built this?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
