Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbaFLNUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:20:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28004 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbaFLNUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:20:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/MhQ9YSVG/kM+cyBP8+hrtoaKOr3D050U=
X-DKIM: OpenDKIM Filter v2.0.1 titan CC0EB58DDAA
Date: Thu, 12 Jun 2014 09:20:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 11/19] irqchip: crossbar: fix memory leak incase of
 invalid entry
Message-ID: <20140612132023.GX8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-12-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402574007-13987-12-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:23:19PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> When the provided unused skip list entry is greater than max irqs
> possible, we go to err3, but we fail to free register_offsets,
> should have returned to err4 instead which ensures that allocated

s/returned/jumped/

> register_offsets are freed as well.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/irqchip/irq-crossbar.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index 42a2e62..fea3e5d 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -225,7 +225,7 @@ static int __init crossbar_of_init(struct device_node *node,
>  
>  			if (entry > max) {
>  				pr_err("Invalid skip entry\n");
> -				goto err3;
> +				goto err4;

This would be a good opportunity to reduce the possibility of future
errors.  Please consider renaming err{1,2,3,4} to something more
recognizable while you are here.

thx,

Jason.

>  			}
>  			cb->irq_map[entry] = IRQ_SKIP;
>  		}
> -- 
> 1.7.9.5
> 
