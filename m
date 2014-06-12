Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbaFLNQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:16:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18756 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaFLNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:16:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18k8ZUQLPIKFPtwcq/IITUmKUv+vThAb9U=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6EFC458DD90
Date: Thu, 12 Jun 2014 09:16:00 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 10/19] irqchip: crossbar: DRA7: Fix unused crossbar
 list
Message-ID: <20140612131600.GW8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-11-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402574007-13987-11-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:23:18PM +0530, Sricharan R wrote:
> From: Rajendra Nayak <rnayak@ti.com>
> 
> On DRA7 compatible IRQ crossbar, IRQ 10 default mapped to L3_APP_IRQ,
> IRQ133 is default mapped to NMI pin, 139 and 140 crossbars are
> unused(not routed). Mark these as unused crossbar IRQs.
> 
> Technical Reference Manual documentation update expected
> DRA72x-TRMINC00067 is being used to track the update.
> 
> Reported-by: Nishanth Menon <nm@ti.com>
> Reported-by: Sricharan R <r.sricharan@ti.com>
> Reported-by: Suman Anna <s-anna@ti.com>
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> ---
>  drivers/irqchip/irq-crossbar.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index 7d4db07..42a2e62 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -253,8 +253,8 @@ err1:
>  	return -ENOMEM;
>  }
>  
> -/* irq number 10 cannot be used because of hw bug */
> -static int dra_irqs_unused[] = { 10 };
> +/* irq number 10,133,139 and 140 cannot be used because of hw bug */
> +static int dra_irqs_unused[] = { 10 , 133, 139, 140 };

see my earlier comment regarding a potential dts property.

thx,

Jason.

>  static struct crossbar_data cb_dra_data = { dra_irqs_unused,
>  				     ARRAY_SIZE(dra_irqs_unused), 0 };
>  
> -- 
> 1.7.9.5
> 
