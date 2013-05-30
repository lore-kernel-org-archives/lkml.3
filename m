Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3E3S30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:29:26 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:57516 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab3E3S3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:29:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
References: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
Date: Thu, 30 May 2013 21:29:16 +0300
Message-ID: <CAHp75Vf+ifmn62vRNZbqpVX1hnqeUkenzvY81gZLenFkEJ9pFA@mail.gmail.com>
Subject: Re: [PATCH -next v2] dmaengine: ste_dma40: fix error return code in d40_probe()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: srinidhi.kasagar@stericsson.com, Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, yongjun_wei@trendmicro.com.cn,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 7:32 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> In many of the error handling case, the return value 'ret' not set
> and 0 will be return from d40_probe() even if error, but we should
> return a negative error code instead in those error handling case.
> This patch fixed them, and also removed useless variable 'err'.

Hold on, please.

> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c

> @@ -3619,6 +3618,7 @@ static int __init d40_probe(struct platform_device *pdev)
>                 if (IS_ERR(base->lcpa_regulator)) {
>                         d40_err(&pdev->dev, "Failed to get lcpa_regulator\n");
>                         base->lcpa_regulator = NULL;
> +                       ret = PTR_ERR(base->lcpa_regulator);

Is it really what we want?

I thixh you may remove that NULL assignment.


>                         goto failure;
>                 }
>

> @@ -3647,8 +3647,8 @@ static int __init d40_probe(struct platform_device *pdev)
>         d40_hw_init(base);
>
>         if (np) {
> -               err = of_dma_controller_register(np, d40_xlate, NULL);
> -               if (err && err != -ENODEV)
> +               ret = of_dma_controller_register(np, d40_xlate, NULL);
> +               if (ret && ret != -ENODEV)

>From the discussion of dw_dmac I remember we decide that ENODEV check
is redundant.

--
With Best Regards,
Andy Shevchenko
