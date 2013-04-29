Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab3D2QdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:33:24 -0400
Received: from nm29-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.192]:23412
	"EHLO nm29-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576Ab3D2QdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:33:16 -0400
X-Yahoo-Newman-Id: 245532.72143.bm@smtp104.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zAMJz1wVM1m0.O_xDDGxWiLObVBH0p_glXcPCDR9fo1yXL0
 122oi4MSP4lfU3ZDOhGC9zfC75T3D6Stq5p1H4x37Tss3ysUU62reML2Xf8O
 5c5w0yIjJumR2BYPZxTg9drsbhcIAoMk9Mnp8N2nySTrP0HzTBRT7mpb0sRM
 M.wzded49.NZBUQ5dUXtrHkfcROa7lhO3CdABUyY7xgvVgT79Gq3WxmAKVa9
 cZYbTlQZsCPv6O58ZUYENaWNiy_hmxYYpD2NoVWA.jCAUG6JIgH_mTquKn0q
 7dJCDCwSkBGzFJ.6OpikrhSMVCnI05HdhdtPRN2hdXqkgIPW8MuLzehwK7Ip
 PXrilrvmIZAnAnp5mtyKIgdCuyS_M6rps2rnzr1vIkWMoXSXOaPElBXzY_2y
 w_fr6FRhai6LTttCdVOQGxEF0p9_PK1SZOBWOXvdxlJzQ5_pjOOpA3sQy7jR
 Fza71q1jkhO2P2oI9GZh8gnCv4Lqx7nNz
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp104.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 16:33:16 +0000 UTC
Date: Mon, 29 Apr 2013 09:33:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 2/5] watchdog: imx2_wdt: use devm_clk_get()
Message-ID: <20130429163316.GD23799@roeck-us.net>
References: <000301ce44ba$266397b0$732ac710$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301ce44ba$266397b0$732ac710$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:15:53PM +0900, Jingoo Han wrote:
> Use devm_clk_get() to make cleanup paths more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/imx2_wdt.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index ff90882..0c2b075 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -266,7 +266,7 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
>  	if (IS_ERR(imx2_wdt.base))
>  		return PTR_ERR(imx2_wdt.base);
>  
> -	imx2_wdt.clk = clk_get(&pdev->dev, NULL);
> +	imx2_wdt.clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(imx2_wdt.clk)) {
>  		dev_err(&pdev->dev, "can't get Watchdog clock\n");
>  		return PTR_ERR(imx2_wdt.clk);
> @@ -291,7 +291,6 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
>  
>  fail:
>  	imx2_wdt_miscdev.parent = NULL;
> -	clk_put(imx2_wdt.clk);
>  	return ret;
>  }
>  
> @@ -304,8 +303,7 @@ static int __exit imx2_wdt_remove(struct platform_device *pdev)
>  
>  		dev_crit(imx2_wdt_miscdev.parent,
>  			"Device removed: Expect reboot!\n");
> -	} else
> -		clk_put(imx2_wdt.clk);
> +	}
>  
>  	imx2_wdt_miscdev.parent = NULL;
>  	return 0;
> -- 
> 1.7.2.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
