Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaI3M2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:28:21 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36059 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaI3M2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:28:20 -0400
Message-ID: <542AA1DE.4020606@gmail.com>
Date: Tue, 30 Sep 2014 14:28:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
To: Jisheng Zhang <jszhang@marvell.com>, tglx@linutronix.de,
        jason@lakedaemon.net
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] irqchip: dw-apb-ictl: enable IRQ_GC_MASK_CACHE_PER_TYPE
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com> <1411454100-6814-3-git-send-email-jszhang@marvell.com>
In-Reply-To: <1411454100-6814-3-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 08:34 AM, Jisheng Zhang wrote:
> The irq_chip_type instances have separate mask registers, so we need to
> enable IRQ_GC_MASK_CACHE_PER_TYPE to actually handle separate mask registers.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> ---
>   drivers/irqchip/irq-dw-apb-ictl.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
> index fcc3385..c136b67 100644
> --- a/drivers/irqchip/irq-dw-apb-ictl.c
> +++ b/drivers/irqchip/irq-dw-apb-ictl.c
> @@ -115,6 +115,7 @@ static int __init dw_apb_ictl_init(struct device_node *np,
>
>   	ret = irq_alloc_domain_generic_chips(domain, 32, (nrirqs > 32) ? 2 : 1,
>   					     np->name, handle_level_irq, clr, 0,
> +					     IRQ_GC_MASK_CACHE_PER_TYPE |
>   					     IRQ_GC_INIT_MASK_CACHE);
>   	if (ret) {
>   		pr_err("%s: unable to alloc irq domain gc\n", np->full_name);
>
