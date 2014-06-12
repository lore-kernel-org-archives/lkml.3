Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbaFLNOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:14:49 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60051 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbaFLNOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:14:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+AitErYSiEIvMCy7dQKWOWNn/J/TF4U7Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0EC6D58DD70
Date: Thu, 12 Jun 2014 09:14:34 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 09/19] irqchip: crossbar: fix kerneldoc warning
Message-ID: <20140612131434.GV8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-10-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402574007-13987-10-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:23:17PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> kernel doc style is wrong in code. fix it to squelch
> kerneldoc warnings:

I would re-word the above to mention that we need to add missing
properties for kerneldoc (@write, @safemap), and we're doing some
cleanup of harmless warnings while we are here.

> Warning(drivers/irqchip/irq-crossbar.c:27): missing initial short description on line:
>  * struct crossbar_device: crossbar device description
> Info(drivers/irqchip/irq-crossbar.c:27): Scanning doc for struct
> Warning(drivers/irqchip/irq-crossbar.c:39): No description found for parameter 'write'
> Warning(drivers/irqchip/irq-crossbar.c:42): missing initial short description on line:
>  * struct crossbar_data: Platform specific data
> Info(drivers/irqchip/irq-crossbar.c:42): Scanning doc for struct
> Warning(drivers/irqchip/irq-crossbar.c:50): No description found for parameter 'safe_map'
> 4 warnings
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/irqchip/irq-crossbar.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index 58790d4..7d4db07 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -23,11 +23,13 @@
>  #define IRQ_SKIP	-3
>  #define GIC_IRQ_START	32
>  
> -/*
> +/**
> + * struct crossbar_device - crossbar device descriptio

s/descriptio/description/

thx,

Jason.

>   * @int_max: maximum number of supported interrupts
>   * @irq_map: array of interrupts to crossbar number mapping
>   * @crossbar_base: crossbar base address
>   * @register_offsets: offsets for each irq number
> + * @write: register write function pointer
>   */
>  struct crossbar_device {
>  	uint int_max;
> @@ -39,9 +41,10 @@ struct crossbar_device {
>  };
>  
>  /**
> - * struct crossbar_data: Platform specific data
> + * struct crossbar_data - Platform specific data
>   * @irqs_unused: array of irqs that cannot be used because of hw erratas
>   * @size: size of the irqs_unused array
> + * @safe_map: safe value to write to crossbar register
>   */
>  struct crossbar_data {
>  	const uint *irqs_unused;
> -- 
> 1.7.9.5
> 
