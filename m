Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaAWKSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:18:47 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54396 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWKSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:18:45 -0500
MIME-Version: 1.0
In-Reply-To: <1389777472-15294-1-git-send-email-ch.naveen@samsung.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com> <1389777472-15294-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 23 Jan 2014 15:48:24 +0530
Message-ID: <CAHfPSqCHGbVX3iMC-LNnFYkdutRYFuk07RCeYLU4KAaTpgyQ0w@mail.gmail.com>
Subject: Re: [PATCH 8/8 v4] crypto:s5p-sss: Use clk_prepare/clk_unprepare
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 15 January 2014 14:47, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch set adds use of clk_prepare/clk_unprepare as
> required by generic clock framework.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
> Changes since v3:
> None
>
>  drivers/crypto/s5p-sss.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index f7c66c7..870e794 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -648,7 +648,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>                 return -ENOENT;
>         }
>
> -       clk_enable(pdata->clk);
> +       clk_prepare_enable(pdata->clk);
>
>         spin_lock_init(&pdata->lock);
>         pdata->ioaddr = devm_ioremap(dev, res->start,
> @@ -711,7 +711,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>         tasklet_kill(&pdata->tasklet);
>
>   err_irq:
> -       clk_disable(pdata->clk);
> +       clk_disable_unprepare(pdata->clk);
>
>         s5p_dev = NULL;
>
> @@ -731,7 +731,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
>
>         tasklet_kill(&pdata->tasklet);
>
> -       clk_disable(pdata->clk);
> +       clk_disable_unprepare(pdata->clk);
>
>         s5p_dev = NULL;
>
> --
> 1.7.9.5
Any update on this patch, Please
>



-- 
Shine bright,
(: Nav :)
