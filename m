Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3FSH5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:57:42 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:61247 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab3FSH5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:57:41 -0400
Date: Wed, 19 Jun 2013 08:57:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: sameo@linux.intel.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mfd: htc-egpio: use devm_ioremap_nocache() instead
 of ioremap_nocache()
Message-ID: <20130619075735.GE31320@laptop>
References: <CAPgLHd-k_HkBa+oKU+7gPZfY3vT4u-xzsKZTqjkw_GdyK1rGcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd-k_HkBa+oKU+7gPZfY3vT4u-xzsKZTqjkw_GdyK1rGcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Replace probe-time ioremap_nocache() call with devm_ioremap_nocache()
> to avoid iounmap() missing and get rid of the corresponding iounmap()
> call on remove.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mfd/htc-egpio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
> index f2e0ad4..26aca54 100644
> --- a/drivers/mfd/htc-egpio.c
> +++ b/drivers/mfd/htc-egpio.c
> @@ -286,7 +286,8 @@ static int __init egpio_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res)
>  		goto fail;
> -	ei->base_addr = ioremap_nocache(res->start, resource_size(res));
> +	ei->base_addr = devm_ioremap_nocache(&pdev->dev, res->start,
> +					     resource_size(res));
>  	if (!ei->base_addr)
>  		goto fail;
>  	pr_debug("EGPIO phys=%08x virt=%p\n", (u32)res->start, ei->base_addr);
> @@ -380,7 +381,6 @@ static int __exit egpio_remove(struct platform_device *pdev)
>  		irq_set_chained_handler(ei->chained_irq, NULL);
>  		device_init_wakeup(&pdev->dev, 0);
>  	}
> -	iounmap(ei->base_addr);
>  
>  	return 0;
>  }

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
