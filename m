Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3FHUTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 16:19:21 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47728 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3FHUTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 16:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370696686-1666-1-git-send-email-grant.likely@linaro.org>
References: <1370696686-1666-1-git-send-email-grant.likely@linaro.org>
From: Grant Likely <grant.likely@linaro.org>
Date: Sat, 8 Jun 2013 21:18:59 +0100
X-Google-Sender-Auth: rE8z8CH67EgLs6q0sqNaHMiaEG8
Message-ID: <CACxGe6v7H35eA1Ry0VqQaxezaeT=TMQnxe+f_WQmroroombeZQ@mail.gmail.com>
Subject: Re: [PATCH] irqchip: Return -EPERM for reserved IRQs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 2:04 PM, Grant Likely <grant.likely@linaro.org> wrote:
> The irqdomain core will report a log message for any attempted map call
> that fails unless the error code is -EPERM. This patch changes the
> Versatile irq controller drivers to use -EPERM because it is normal for
> a subset of the IRQ inputs to be marked as reserved on the various
> Versatile platforms.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>

I'm going to go ahead and take this one through the irqdomain tree
since it is really an irqdomain bug fix. I'll be sending the pull
request to Linus shortly.

g.

> ---
>  drivers/irqchip/irq-versatile-fpga.c | 2 +-
>  drivers/irqchip/irq-vic.c            | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/irqchip/irq-versatile-fpga.c b/drivers/irqchip/irq-versatile-fpga.c
> index 065b7a3..47a52ab 100644
> --- a/drivers/irqchip/irq-versatile-fpga.c
> +++ b/drivers/irqchip/irq-versatile-fpga.c
> @@ -119,7 +119,7 @@ static int fpga_irqdomain_map(struct irq_domain *d, unsigned int irq,
>
>         /* Skip invalid IRQs, only register handlers for the real ones */
>         if (!(f->valid & BIT(hwirq)))
> -               return -ENOTSUPP;
> +               return -EPERM;
>         irq_set_chip_data(irq, f);
>         irq_set_chip_and_handler(irq, &f->chip,
>                                 handle_level_irq);
> diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
> index 884d11c..2bbb004 100644
> --- a/drivers/irqchip/irq-vic.c
> +++ b/drivers/irqchip/irq-vic.c
> @@ -197,7 +197,7 @@ static int vic_irqdomain_map(struct irq_domain *d, unsigned int irq,
>
>         /* Skip invalid IRQs, only register handlers for the real ones */
>         if (!(v->valid_sources & (1 << hwirq)))
> -               return -ENOTSUPP;
> +               return -EPERM;
>         irq_set_chip_and_handler(irq, &vic_chip, handle_level_irq);
>         irq_set_chip_data(irq, v->base);
>         set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
> --
> 1.8.1.2
>
