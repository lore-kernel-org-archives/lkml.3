Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaFLM41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:56:27 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17491 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755888AbaFLM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:56:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/UWMtGxl7Fyx216KMVyybTL3JPIt/mRUA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2383D58DD19
Date: Thu, 12 Jun 2014 08:56:15 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 05/19] irqchip: crossbar: Change allocation logic by
 reversing search for free irqs
Message-ID: <20140612125615.GT8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-6-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402574007-13987-6-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:23:13PM +0530, Sricharan R wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> Reverse the search algorithm to ensure that address mapping and IRQ
> allocation logics are proper. This can open up new bugs which are
> easily fixable rather than wait till allocation logic approaches
> the limit to find new bugs.

Could you expand on this logic some more?  What class of bugs are you
hoping to discover more easily?

thx,

Jason.

> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  drivers/irqchip/irq-crossbar.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index 287d3ce..de021638 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -68,7 +68,7 @@ static inline int get_prev_map_irq(int cb_no)
>  {
>  	int i;
>  
> -	for (i = 0; i < cb->int_max; i++)
> +	for (i = cb->int_max - 1; i >= 0; i--)
>  		if (cb->irq_map[i] == cb_no)
>  			return i;
>  
> @@ -79,7 +79,7 @@ static inline int allocate_free_irq(int cb_no)
>  {
>  	int i;
>  
> -	for (i = 0; i < cb->int_max; i++) {
> +	for (i = cb->int_max - 1; i >= 0; i--) {
>  		if (cb->irq_map[i] == IRQ_FREE) {
>  			cb->irq_map[i] = cb_no;
>  			return i;
> -- 
> 1.7.9.5
> 
