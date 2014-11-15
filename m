Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaKOTl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 14:41:58 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:45884 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaKOTl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 14:41:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141114221614.GA37395@dtor-ws>
References: <20141114221614.GA37395@dtor-ws>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sat, 15 Nov 2014 11:41:15 -0800
Message-ID: <CAGVrzcaYF7bdXu2RRSqm=7Qa0_N0es62rN+=VX+_j+ssFNu2rQ@mail.gmail.com>
Subject: Re: [PATCH] irqchip: bcm7120-l2: fix error handling of irq_of_parse_and_map
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Cernekee <cernekee@gmail.com>,
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
>  drivers/irqchip/irq-bcm7120-l2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
> index e7c6155..8eec8e1 100644
> --- a/drivers/irqchip/irq-bcm7120-l2.c
> +++ b/drivers/irqchip/irq-bcm7120-l2.c
> @@ -102,9 +102,9 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
>         unsigned int idx;
>
>         parent_irq = irq_of_parse_and_map(dn, irq);
> -       if (parent_irq < 0) {
> +       if (!parent_irq) {
>                 pr_err("failed to map interrupt %d\n", irq);
> -               return parent_irq;
> +               return -EINVAL;
>         }
>
>         /* For multiple parent IRQs with multiple words, this looks like:
> --
> 2.1.0.rc2.206.gedb03e5
>
>
> --
> Dmitry



-- 
Florian
