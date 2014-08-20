Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHTITw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:19:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35783 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751656AbaHTITu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:19:50 -0400
Date: Wed, 20 Aug 2014 10:19:46 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?B?R2HDq2w=?= PORTAY <gael.portay@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/3] ARM: at91/tclib: prefer using of devm_* functions
Message-ID: <20140820101946.3c894130@bbrezillon>
In-Reply-To: <1408486072-19268-2-git-send-email-gael.portay@gmail.com>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
	<1408486072-19268-2-git-send-email-gael.portay@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014 00:07:50 +0200
Gaël PORTAY <gael.portay@gmail.com> wrote:

> Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/misc/atmel_tclib.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
> index c8d8e38..b514a2d 100644
> --- a/drivers/misc/atmel_tclib.c
> +++ b/drivers/misc/atmel_tclib.c
> @@ -150,17 +150,15 @@ static int __init tc_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return -EINVAL;
>  
> -	tc = kzalloc(sizeof(struct atmel_tc), GFP_KERNEL);
> +	tc = devm_kzalloc(&pdev->dev, sizeof(struct atmel_tc), GFP_KERNEL);
>  	if (!tc)
>  		return -ENOMEM;
>  
>  	tc->pdev = pdev;
>  
> -	clk = clk_get(&pdev->dev, "t0_clk");
> -	if (IS_ERR(clk)) {
> -		kfree(tc);
> -		return -EINVAL;
> -	}
> +	clk = devm_clk_get(&pdev->dev, "t0_clk");
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
>  
>  	/* Now take SoC information if available */
>  	if (pdev->dev.of_node) {
> @@ -171,10 +169,10 @@ static int __init tc_probe(struct platform_device *pdev)
>  	}
>  
>  	tc->clk[0] = clk;
> -	tc->clk[1] = clk_get(&pdev->dev, "t1_clk");
> +	tc->clk[1] = devm_clk_get(&pdev->dev, "t1_clk");
>  	if (IS_ERR(tc->clk[1]))
>  		tc->clk[1] = clk;
> -	tc->clk[2] = clk_get(&pdev->dev, "t2_clk");
> +	tc->clk[2] = devm_clk_get(&pdev->dev, "t2_clk");
>  	if (IS_ERR(tc->clk[2]))
>  		tc->clk[2] = clk;
>  



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
