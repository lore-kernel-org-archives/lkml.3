Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbaEKIgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:36:25 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52880 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaEKIgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:36:18 -0400
Date: Sun, 11 May 2014 09:53:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 24/32] sh: intc: Remove pointless irq_reserve_irqs()
 invocation
Message-ID: <20140511005310.GY31760@verge.net.au>
References: <20140507153622.703412101@linutronix.de>
 <20140507154339.189047829@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507154339.189047829@linutronix.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 03:44:18PM -0000, Thomas Gleixner wrote:
> The preceding call to irq_create_identity_mapping() marks the
> interrupt as allocated already. Remove the leftover.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-sh@vger.kernel.org
> Cc: Simon Horman <horms@verge.net.au>

This duplicates a similar patch, "[PATCH v3 2/8] sh, irq: Remove
irq_reserve_irq calling", by Yinghai Lu. But perhaps you already know that.

Regardless, I am fine with the contents.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  drivers/sh/intc/core.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> Index: tip/drivers/sh/intc/core.c
> ===================================================================
> --- tip.orig/drivers/sh/intc/core.c
> +++ tip/drivers/sh/intc/core.c
> @@ -80,12 +80,6 @@ static void __init intc_register_irq(str
>  	unsigned int data[2], primary;
>  	unsigned long flags;
>  
> -	/*
> -	 * Register the IRQ position with the global IRQ map, then insert
> -	 * it in to the radix tree.
> -	 */
> -	irq_reserve_irq(irq);
> -
>  	raw_spin_lock_irqsave(&intc_big_lock, flags);
>  	radix_tree_insert(&d->tree, enum_id, intc_irq_xlate_get(irq));
>  	raw_spin_unlock_irqrestore(&intc_big_lock, flags);
> 
> 
