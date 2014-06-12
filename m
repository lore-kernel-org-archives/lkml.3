Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaFLNK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:10:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51009 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752781AbaFLNKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:10:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CVmiiHRdLioxJ3JQOl7zdlSvagvTiZU0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 56FA658DD5A
Date: Thu, 12 Jun 2014 09:10:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
Message-ID: <20140612131042.GU8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-9-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402574007-13987-9-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:23:16PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> remove un-necessary space in function pointer.
> 
> Fixes checkpatch warning:
> WARNING: Unnecessary space before function pointer arguments
>  #37: FILE: drivers/irqchip/irq-crossbar.c:37:
>  +	void (*write) (int, int);
> 
> WARNING: Missing a blank line after declarations
> +	int *register_offsets;
> +	void (*write)(int, int);
> 
> WARNING: Prefer kcalloc over kzalloc with multiply
> +	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
> 
> WARNING: Prefer kcalloc over kzalloc with multiply
> +	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/irqchip/irq-crossbar.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index 5da9d36..58790d4 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -34,7 +34,8 @@ struct crossbar_device {
>  	uint *irq_map;
>  	void __iomem *crossbar_base;
>  	int *register_offsets;
> -	void (*write) (int, int);
> +
> +	void (*write)(int, int);

The empty line here looks bogus to me.  Did you re-run checkpatch after
fixing the unnecessary space to see if it still complained about having
a 'blank line after declarations'?

>  };
>  
>  /**
> @@ -150,7 +151,7 @@ static int __init crossbar_of_init(struct device_node *node,
>  		goto err1;
>  
>  	of_property_read_u32(node, "ti,max-irqs", &max);
> -	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
> +	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
>  	if (!cb->irq_map)
>  		goto err2;
>  
> @@ -176,7 +177,7 @@ static int __init crossbar_of_init(struct device_node *node,
>  		}
>  	}
>  
> -	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
> +	cb->register_offsets = kcalloc(max, sizeof(int), GFP_KERNEL);
>  	if (!cb->register_offsets)
>  		goto err3;

I'm generally opposed to these sorts of checkpatch patches, especially
when they are just warnings.  It's great for a new driver in the staging
tree, but it makes backporting future bugfixes that much harder when
drivers have been live in mainline.

If, in the future, you're changing code in this area, go ahead and
convert to kcalloc(), but I wouldn't do a separate patch for this kind
of thing.

Honestly, I would just drop this patch and not worry about it.

thx,

Jason.
