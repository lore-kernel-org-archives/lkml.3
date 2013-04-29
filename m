Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab3D2QjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:39:05 -0400
Received: from nm25.access.bullet.mail.mud.yahoo.com ([66.94.237.90]:48565
	"EHLO nm25.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123Ab3D2QjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:39:04 -0400
X-Yahoo-Newman-Id: 106417.90248.bm@smtp112.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5LK3.Y0VM1kzUK9Wkt5SwPeuo8zIVNVPxIVb6nu1PUlD0PT
 UkcblCrPP1z12B.m2mqF_RfGmDus_mQ6sAMxvkO7IMqrX4RMaEjsr81UBrW4
 NQJ2i.vognnxk2z2i5GM5n_o5C58nPg.H8KcxcX80sBXUwzQWzh.2sXjDjDW
 bvLX3npsg1dyKtTUk5KRul_oeWKja8NhTndoKQqeGze1zXoi6lDro77gnicm
 PUM8JZeOCdgKml0X5Xehu787IJSOACvAilttka6x6dWVPvkN9So.okETGt1Z
 YL8EHsSDd_MJ_71X7fBPDZ5PnLRwq26emJnbHX3_fe9D7fAN8UMUn7MKEsyk
 9hst0pSx9Frds4CeeDfSzFfZqWO1OyhAsRgny3uTlyQL3k5EwrG4qda1Nnba
 r0cljy0Bl5.f2tjF4Xe.jUsoXkRJIEmYrpjO.nw.4x.73RU6.qJn7ijo74vA
 ULWxw.RrGIIcQ4iiT76KGyTh_UuWGBRAF
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp112.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 09:33:38 -0700 PDT
Date: Mon, 29 Apr 2013 09:33:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 3/5] watchdog: pnx4008_wdt: use devm_clk_get()
Message-ID: <20130429163338.GE23799@roeck-us.net>
References: <000401ce44ba$326e7a70$974b6f50$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401ce44ba$326e7a70$974b6f50$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:16:14PM +0900, Jingoo Han wrote:
> Use devm_clk_get() to make cleanup paths more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/pnx4008_wdt.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
> index a3684a3..b30bd43 100644
> --- a/drivers/watchdog/pnx4008_wdt.c
> +++ b/drivers/watchdog/pnx4008_wdt.c
> @@ -159,13 +159,13 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
>  	if (IS_ERR(wdt_base))
>  		return PTR_ERR(wdt_base);
>  
> -	wdt_clk = clk_get(&pdev->dev, NULL);
> +	wdt_clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(wdt_clk))
>  		return PTR_ERR(wdt_clk);
>  
>  	ret = clk_enable(wdt_clk);
>  	if (ret)
> -		goto out;
> +		return ret;
>  
>  	pnx4008_wdd.bootstatus = (readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
>  			WDIOF_CARDRESET : 0;
> @@ -186,8 +186,6 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
>  
>  disable_clk:
>  	clk_disable(wdt_clk);
> -out:
> -	clk_put(wdt_clk);
>  	return ret;
>  }
>  
> @@ -196,7 +194,6 @@ static int pnx4008_wdt_remove(struct platform_device *pdev)
>  	watchdog_unregister_device(&pnx4008_wdd);
>  
>  	clk_disable(wdt_clk);
> -	clk_put(wdt_clk);
>  
>  	return 0;
>  }
> -- 
> 1.7.2.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
