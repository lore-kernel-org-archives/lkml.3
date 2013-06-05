Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3FESUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:20:45 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:37761 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3FESUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:20:44 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: irq: Pass trigger type in IRQ resource flags
Date: Wed, 05 Jun 2013 20:20:39 +0200
Message-ID: <54821523.hBKS2L2vLj@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.4-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1368917790-23770-1-git-send-email-tomasz.figa@gmail.com>
References: <1368917790-23770-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 19 of May 2013 00:56:30 Tomasz Figa wrote:
> Some drivers might rely on availability of trigger flags in IRQ
> resource, for example to configure the hardware for particular interrupt
> type. However current code creating IRQ resources from data in device
> tree does not configure trigger flags in resulting resources.
> 
> This patch solves the problem, based on the fact that
> irq_of_parse_and_map() configures the trigger based on DT interrupt
> specifier, IRQD_TRIGGER_* flags are consistent with IORESOURCE_IRQ_*,
> and we can get trigger type by calling irqd_get_trigger_type() after
> mapping the interrupt.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  drivers/of/irq.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index a3c1c5a..79a7a26 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -355,6 +355,16 @@ int of_irq_to_resource(struct device_node *dev, int
> index, struct resource *r) r->start = r->end = irq;
>  		r->flags = IORESOURCE_IRQ;
>  		r->name = name ? name : dev->full_name;
> +
> +		/*
> +		 * Some drivers might rely on availability of trigger 
flags
> +		 * in IRQ resource. Since irq_of_parse_and_map() 
configures the
> +		 * trigger based on interrupt specifier and IRQD_TRIGGER_*
> +		 * flags are consistent with IORESOURCE_IRQ_*, we can get
> +		 * trigger type that was just set and pass it through 
resource
> +		 * flags as well.
> +		 */
> +		r->flags |= irqd_get_trigger_type(irq_get_irq_data(irq));
>  	}
> 
>  	return irq;

Any comments on this patch?

Best regards,
Tomasz

