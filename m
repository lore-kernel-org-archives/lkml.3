Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3D2RzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:55:09 -0400
Received: from nm15-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.164]:37611
	"EHLO nm15-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758478Ab3D2RzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:55:07 -0400
X-Yahoo-Newman-Id: 347603.27894.bm@smtp112.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bZ2BegMVM1lNvDaizvh.QfVVC.6enUYyj1EtlcFOeLAwkHG
 Zt0ziXsTbINGF_0pg8UeNZ6wqY5X1Q.AwdUVtwR0gD6P_sVwv6xnLIarqdu_
 f5G_kVK0.gX.mFXdAUi3EcaleCL4uNY21aaAP87e5WJXUnflf0holxPnqc8p
 DsSW02_a2Nu2OHiXuUlTGzW4XtFgtwUnUFE3x7r_Yb0iBHL2DEHPULVsC6ml
 Djrn0SNVpjn75IP58CMh3sbg51B3uByRmLus0d.32dWMoYHegEAtoFyOFxt4
 yT1LaINYUj3boNooAPCTx638QNybVJNgX_MsseQ14ntMRPZWCZFOAtysDnBj
 opIOMSTdeSbslW_.6jQJfMMTqjZAZQokoOqen47yCWO850AB3ERyQcMRT8aL
 USgKckfvv2kbJGLtb2IUyxQcCe4J09fWDL5zALQT_EuP4F2W_RO79gmfBLbK
 Q_1wuwW9azu5ShDKDvAZke9Tiksim9rPe
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp112.sbc.mail.gq1.yahoo.com with SMTP; 29 Apr 2013 10:55:06 -0700 PDT
Date: Mon, 29 Apr 2013 10:55:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 3/7] watchdog: mv64x60_wdt: use devm_ioremap()
Message-ID: <20130429175507.GC5183@roeck-us.net>
References: <000d01ce44bc$da891380$8f9b3a80$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000d01ce44bc$da891380$8f9b3a80$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:35:15PM +0900, Jingoo Han wrote:
> Use devm_ioremap() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

This patch also addresses the missing call to iounmap() if the call
to misc_register fails.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/mv64x60_wdt.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
> index c7fb878..e4cf980 100644
> --- a/drivers/watchdog/mv64x60_wdt.c
> +++ b/drivers/watchdog/mv64x60_wdt.c
> @@ -276,7 +276,7 @@ static int mv64x60_wdt_probe(struct platform_device *dev)
>  	if (!r)
>  		return -ENODEV;
>  
> -	mv64x60_wdt_regs = ioremap(r->start, resource_size(r));
> +	mv64x60_wdt_regs = devm_ioremap(&dev->dev, r->start, resource_size(r));
>  	if (mv64x60_wdt_regs == NULL)
>  		return -ENOMEM;
>  
> @@ -293,8 +293,6 @@ static int mv64x60_wdt_remove(struct platform_device *dev)
>  
>  	mv64x60_wdt_handler_disable();
>  
> -	iounmap(mv64x60_wdt_regs);
> -
>  	return 0;
>  }
>  
> -- 
> 1.7.2.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
