Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FZNHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:07:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3FZNHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:07:24 -0400
Date: Wed, 26 Jun 2013 08:06:41 -0500
From: Nishanth Menon <nm@ti.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <anton@enomsg.org>, <dwmw2@infradead.org>, <khilman@linaro.org>,
        <andrii.tseglytskyi@ti.com>, <jean.pihet@newoldbits.com>,
        <tony@atomide.com>, <yongjun_wei@trendmicro.com.cn>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH -next] PM / AVS: SmartReflex: remove redundant dev_err
 call in omap_sr_probe()
Message-ID: <20130626130641.GA26920@kahuna>
References: <CAPgLHd_K37Uf420FRiEkiCZQiL9bAdiE2_qG4dp7WmQRaCnDqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_K37Uf420FRiEkiCZQiL9bAdiE2_qG4dp7WmQRaCnDqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:57-20130626, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
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
> 
Acked-by: Nishanth Menon <nm@ti.com>
-- 
Regards,
Nishanth Menon
