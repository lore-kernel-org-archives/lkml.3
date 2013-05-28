Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808Ab3E1QSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:18:54 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:38386 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934674Ab3E1QSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-Mw4MQwS8=p9+ZBHHehH7B-Hs49BqiUMrq-aV_5M4pQQ@mail.gmail.com>
References: <CAPgLHd-Mw4MQwS8=p9+ZBHHehH7B-Hs49BqiUMrq-aV_5M4pQQ@mail.gmail.com>
Date: Tue, 28 May 2013 19:18:51 +0300
Message-ID: <CAHp75VfQwv1gCNX2iactEEMJxLgdcbnivebB5f-hSKYHcN8fOw@mail.gmail.com>
Subject: Re: [PATCH -next] dmaengine: ste_dma40: fix error return code in d40_probe()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: srinidhi.kasagar@stericsson.com, Linus Walleij <linus.walleij@linaro.org>,
        Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        yongjun_wei@trendmicro.com.cn,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you check the ux500-dma40 branch?

https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-stericsson.git/log/?h=ux500-dma40

On Tue, May 28, 2013 at 12:06 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In many of the error handling case, the return value 'ret' not set
> and 0 will be return from d40_probe() even if error, but we should
> return a negative error code instead in those error handling case.
> This patch fixed them, and also removed useless variable 'err'.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/dma/ste_dma40.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 71bf4ec..cbf9c62 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -3474,7 +3474,6 @@ failure:
>
>  static int __init d40_probe(struct platform_device *pdev)
>  {
> -       int err;
>         int ret = -ENOENT;
>         struct d40_base *base;
>         struct resource *res = NULL;
> @@ -3576,6 +3575,7 @@ static int __init d40_probe(struct platform_device *pdev)
>                 if (IS_ERR(base->lcpa_regulator)) {
>                         d40_err(&pdev->dev, "Failed to get lcpa_regulator\n");
>                         base->lcpa_regulator = NULL;
> +                       ret = PTR_ERR(base->lcpa_regulator);
>                         goto failure;
>                 }
>
> @@ -3590,13 +3590,13 @@ static int __init d40_probe(struct platform_device *pdev)
>         }
>
>         base->initialized = true;
> -       err = d40_dmaengine_init(base, num_reserved_chans);
> -       if (err)
> +       ret = d40_dmaengine_init(base, num_reserved_chans);
> +       if (ret)
>                 goto failure;
>
>         base->dev->dma_parms = &base->dma_parms;
> -       err = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
> -       if (err) {
> +       ret = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
> +       if (ret) {
>                 d40_err(&pdev->dev, "Failed to set dma max seg size\n");
>                 goto failure;
>         }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
