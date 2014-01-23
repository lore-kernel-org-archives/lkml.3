Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaAWKT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:19:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50614 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAWKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:19:55 -0500
MIME-Version: 1.0
In-Reply-To: <1389777262-14978-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com> <1389777262-14978-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 23 Jan 2014 15:49:35 +0530
Message-ID: <CAHfPSqBv6rr73AP-0h41gv3-4E+Gn3fn7NBcfZVsYvVUj-bq6g@mail.gmail.com>
Subject: Re: [PATCH 1/8 v4] crypto:s5p-sss: Use platform_get_irq() instead of _byname()
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

On 15 January 2014 14:44, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch uses the platform_get_irq() instead of the
> platform_get_irq_byname(). Making feeder control interrupt
> as resource "0" and hash interrupt as "1".
>
> reasons for this change.
> 1. Cannot find any Arch which is currently using this driver
> 2. Samsung Exynos4 and 5 SoCs only use the feeder control interrupt
> 3. Patches adding support for DT and H/W version are in pipeline
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v3:
> None
>
>  drivers/crypto/s5p-sss.c |   24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index cf149b1..93cddeb 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -592,29 +592,29 @@ static int s5p_aes_probe(struct platform_device *pdev)
>         pdata->ioaddr = devm_ioremap(dev, res->start,
>                                      resource_size(res));
>
> -       pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
> -       if (pdata->irq_hash < 0) {
> -               err = pdata->irq_hash;
> -               dev_warn(dev, "hash interrupt is not available.\n");
> +       pdata->irq_fc = platform_get_irq(pdev, 0);
> +       if (pdata->irq_fc < 0) {
> +               err = pdata->irq_fc;
> +               dev_warn(dev, "feed control interrupt is not available.\n");
>                 goto err_irq;
>         }
> -       err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
> +       err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
>                                IRQF_SHARED, pdev->name, pdev);
>         if (err < 0) {
> -               dev_warn(dev, "hash interrupt is not available.\n");
> +               dev_warn(dev, "feed control interrupt is not available.\n");
>                 goto err_irq;
>         }
>
> -       pdata->irq_fc = platform_get_irq_byname(pdev, "feed control");
> -       if (pdata->irq_fc < 0) {
> -               err = pdata->irq_fc;
> -               dev_warn(dev, "feed control interrupt is not available.\n");
> +       pdata->irq_hash = platform_get_irq(pdev, 1);
> +       if (pdata->irq_hash < 0) {
> +               err = pdata->irq_hash;
> +               dev_warn(dev, "hash interrupt is not available.\n");
>                 goto err_irq;
>         }
> -       err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
> +       err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
>                                IRQF_SHARED, pdev->name, pdev);
>         if (err < 0) {
> -               dev_warn(dev, "feed control interrupt is not available.\n");
> +               dev_warn(dev, "hash interrupt is not available.\n");
>                 goto err_irq;
>         }
>
> --
> 1.7.9.5
Any update on this patch, Please
>



-- 
Shine bright,
(: Nav :)
