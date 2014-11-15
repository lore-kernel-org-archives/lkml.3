Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaKOTmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 14:42:14 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46188 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaKOTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 14:42:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141114221642.GA37468@dtor-ws>
References: <20141114221642.GA37468@dtor-ws>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sat, 15 Nov 2014 11:41:32 -0800
Message-ID: <CAGVrzcY4+g=78_LGutu-01fYa09qnnf10iNYmSBR6WBGRXoxAA@mail.gmail.com>
Subject: Re: [PATCH] irqchip: brcmstb-l2: fix error handling of irq_of_parse_and_map
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Cernekee <cernekee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-14 14:16 GMT-08:00 Dmitry Torokhov <dtor@chromium.org>:
> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.
>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>


> ---
>
> Not tested, found by casual code inspection.
>
>  drivers/irqchip/irq-brcmstb-l2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
> index 4aa653a..313c2c6 100644
> --- a/drivers/irqchip/irq-brcmstb-l2.c
> +++ b/drivers/irqchip/irq-brcmstb-l2.c
> @@ -139,9 +139,9 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
>         writel(0xffffffff, data->base + CPU_CLEAR);
>
>         data->parent_irq = irq_of_parse_and_map(np, 0);
> -       if (data->parent_irq < 0) {
> +       if (!data->parent_irq) {
>                 pr_err("failed to find parent interrupt\n");
> -               ret = data->parent_irq;
> +               ret = -EINVAL;
>                 goto out_unmap;
>         }
>
> --
> 2.1.0.rc2.206.gedb03e5
>
>
> --
> Dmitry



-- 
Florian
