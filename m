Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaFLTON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:14:13 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:51014 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaFLTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <1402337102-19428-1-git-send-email-f.fainelli@gmail.com>
References: <1402337102-19428-1-git-send-email-f.fainelli@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 12 Jun 2014 12:13:29 -0700
Message-ID: <CAGVrzcZmakEpNW=vGtsb+OmzU_J4hJNoM1sUAoYNsaju_YzGwQ@mail.gmail.com>
Subject: Re: [PATCH] irqchip: brcmstb-l2: Level-2 interrupts are edge sensitive
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-09 11:05 GMT-07:00 Florian Fainelli <f.fainelli@gmail.com>:
> The driver was configuring the interrupt handler for the Level-2
> interrupts to be "level" triggered while they are in fact "edge"
> triggered. Fix this by using the correct handler.
>
> Reported-by: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Jason, Thomas, this driver just got merged into 3.16-rc0, can you
carry this fix such that it gets into a future 3.16-rc? Thanks!

> ---
>  drivers/irqchip/irq-brcmstb-l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
> index 8ee2a36d5840..c15c840987d2 100644
> --- a/drivers/irqchip/irq-brcmstb-l2.c
> +++ b/drivers/irqchip/irq-brcmstb-l2.c
> @@ -150,7 +150,7 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
>
>         /* Allocate a single Generic IRQ chip for this node */
>         ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
> -                               np->full_name, handle_level_irq, clr, 0, 0);
> +                               np->full_name, handle_edge_irq, clr, 0, 0);
>         if (ret) {
>                 pr_err("failed to allocate generic irq chip\n");
>                 goto out_free_domain;
> --
> 1.9.1
>



-- 
Florian
