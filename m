Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936799Ab3DIDEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:04:00 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47792 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190Ab3DIDD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <1363165944-7480-1-git-send-email-sachin.kamat@linaro.org>
References: <1363165944-7480-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 9 Apr 2013 08:33:59 +0530
Message-ID: <CAK9yfHzvJ+5voHuJLCNb55yB0x5R8LS=FqoCu9tn5bSXZ_BNsQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] irqchip: exynos-combiner: Fix checkpatch warnings
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, sachin.kamat@linaro.org, patches@linaro.org,
        chanho61.park@samsung.com, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 13 March 2013 14:42, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Fixes the following warnings:
> WARNING: line over 80 characters
> WARNING: Prefer pr_warn(... to pr_warning(...
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/irqchip/exynos-combiner.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
> index e8501db..66b1bf5 100644
> --- a/drivers/irqchip/exynos-combiner.c
> +++ b/drivers/irqchip/exynos-combiner.c
> @@ -229,13 +229,15 @@ void __init combiner_init(void __iomem *combiner_base,
>         irq_base = irq_alloc_descs(COMBINER_IRQ(0, 0), 1, nr_irq, 0);
>         if (IS_ERR_VALUE(irq_base)) {
>                 irq_base = COMBINER_IRQ(0, 0);
> -               pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
> +               pr_warn("%s: irq desc alloc failed. "
> +                       "Continuing with %d as linux irq base\n",
> +                       __func__, irq_base);
>         }
>
>         combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
>                                 &combiner_irq_domain_ops, &combiner_data);
>         if (WARN_ON(!combiner_irq_domain)) {
> -               pr_warning("%s: irq domain init failed\n", __func__);
> +               pr_warn("%s: irq domain init failed\n", __func__);
>                 return;
>         }
>
> --
> 1.7.4.1
>

ChanHo said you would be picking this patch. Please check.

-- 
With warm regards,
Sachin
