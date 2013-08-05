Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3HEQZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:25:12 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40320 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3HEQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:25:08 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: nm@ti.com, anton@enomsg.org, dwmw2@infradead.org,
        andrii.tseglytskyi@ti.com, jean.pihet@newoldbits.com, tony@atomide.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH RESEND] PM / AVS: SmartReflex: remove redundant dev_err call in omap_sr_probe()
References: <CAPgLHd_K37Uf420FRiEkiCZQiL9bAdiE2_qG4dp7WmQRaCnDqQ@mail.gmail.com>
	<20130626130641.GA26920@kahuna> <877gh8nbpm.fsf@linaro.org>
	<CAPgLHd-toHh8DcooiVz7222kiE-F+xsj1nai2hNEHo95X-3+Ow@mail.gmail.com>
Date: Mon, 05 Aug 2013 09:25:04 -0700
In-Reply-To: <CAPgLHd-toHh8DcooiVz7222kiE-F+xsj1nai2hNEHo95X-3+Ow@mail.gmail.com>
	(Wei Yongjun's message of "Fri, 12 Jul 2013 12:59:40 +0800")
Message-ID: <87r4e8gl5r.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun <weiyj.lk@gmail.com> writes:

> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> Acked-by: Nishanth Menon <nm@ti.com>
> ---
> cc to linux-pm with Nishanth Menon's ACK

Thanks, queued for v3.12.

Kevin

> ---
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
