Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaI3M0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:26:09 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:64680 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaI3M0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:26:07 -0400
Message-ID: <542AA157.8080908@gmail.com>
Date: Tue, 30 Sep 2014 14:25:59 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
To: Jisheng Zhang <jszhang@marvell.com>, tglx@linutronix.de,
        jason@lakedaemon.net
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] irqchip: dw-apb-ictl: always use use {readl|writel}_relaxed
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com> <1411454100-6814-2-git-send-email-jszhang@marvell.com>
In-Reply-To: <1411454100-6814-2-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 08:34 AM, Jisheng Zhang wrote:
> relaxed version and non-relaxed version are mixed, this patch always
> use the relaxed version to unify the memory access usage.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

While I don't agree with the above reason (unification) for this
change, I agree with the patch because it _can_ be changed, so

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> ---
>   drivers/irqchip/irq-dw-apb-ictl.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
> index 31e231e..fcc3385 100644
> --- a/drivers/irqchip/irq-dw-apb-ictl.c
> +++ b/drivers/irqchip/irq-dw-apb-ictl.c
> @@ -94,16 +94,16 @@ static int __init dw_apb_ictl_init(struct device_node *np,
>   	 */
>
>   	/* mask and enable all interrupts */
> -	writel(~0, iobase + APB_INT_MASK_L);
> -	writel(~0, iobase + APB_INT_MASK_H);
> -	writel(~0, iobase + APB_INT_ENABLE_L);
> -	writel(~0, iobase + APB_INT_ENABLE_H);
> +	writel_relaxed(~0, iobase + APB_INT_MASK_L);
> +	writel_relaxed(~0, iobase + APB_INT_MASK_H);
> +	writel_relaxed(~0, iobase + APB_INT_ENABLE_L);
> +	writel_relaxed(~0, iobase + APB_INT_ENABLE_H);
>
> -	reg = readl(iobase + APB_INT_ENABLE_H);
> +	reg = readl_relaxed(iobase + APB_INT_ENABLE_H);
>   	if (reg)
>   		nrirqs = 32 + fls(reg);
>   	else
> -		nrirqs = fls(readl(iobase + APB_INT_ENABLE_L));
> +		nrirqs = fls(readl_relaxed(iobase + APB_INT_ENABLE_L));
>
>   	domain = irq_domain_add_linear(np, nrirqs,
>   				       &irq_generic_chip_ops, NULL);
>
