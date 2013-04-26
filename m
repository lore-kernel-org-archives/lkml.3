Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab3DZAuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 20:50:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47204 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316Ab3DZAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 20:50:14 -0400
Date: Fri, 26 Apr 2013 09:50:12 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH 11/21] irqdomain: export irq_domain_add_simple
Message-ID: <20130426005012.GB20070@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-12-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910944-3033663-12-git-send-email-arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:28:54PM +0200, Arnd Bergmann wrote:
> All other irq_domain_add_* functions are exported already, and apparently
> this one got left out by mistake, which causes build errors for ARM
> allmodconfig kernels:
> 
> ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-rcar.ko] undefined!
> ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-em.ko] undefined!
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Simon Horman <horms+renesas@verge.net.au>
> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Cc: Magnus Damm <damm@opensource.se>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Grant, could consider taking this one?

> ---
>  kernel/irq/irqdomain.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 059a280..c532c15 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -194,6 +194,7 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
>  	/* A linear domain is the default */
>  	return irq_domain_add_linear(of_node, size, ops, host_data);
>  }
> +EXPORT_SYMBOL_GPL(irq_domain_add_simple);
>  
>  /**
>   * irq_domain_add_legacy() - Allocate and register a legacy revmap irq_domain.
> -- 
> 1.8.1.2
> 
