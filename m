Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3F2BrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 21:47:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60439 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3F2BrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 21:47:20 -0400
Date: Fri, 28 Jun 2013 18:42:53 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, khilman@linaro.org, andrii.tseglytskyi@ti.com,
        nm@ti.com, jean.pihet@newoldbits.com, tony@atomide.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] PM / AVS: SmartReflex: remove redundant dev_err
 call in omap_sr_probe()
Message-ID: <20130629014252.GC20924@lizard>
References: <CAPgLHd_K37Uf420FRiEkiCZQiL9bAdiE2_qG4dp7WmQRaCnDqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPgLHd_K37Uf420FRiEkiCZQiL9bAdiE2_qG4dp7WmQRaCnDqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:57:14AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

The patch does not apply to the battery-2.6.git tree... :-/

(In the patch I see "sr_info", but in the current driver there is just
"sr".)

>  drivers/power/avs/smartreflex.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> index db9973b..c26acfc 100644
> --- a/drivers/power/avs/smartreflex.c
> +++ b/drivers/power/avs/smartreflex.c
> @@ -871,10 +871,8 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	sr_info->base = devm_ioremap_resource(&pdev->dev, mem);
> -	if (IS_ERR(sr_info->base)) {
> -		dev_err(&pdev->dev, "%s: ioremap fail\n", __func__);
> +	if (IS_ERR(sr_info->base))
>  		return PTR_ERR(sr_info->base);
> -	}
>  
>  	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>  
> 
