Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab3BXMj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 07:39:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49164 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab3BXMj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 07:39:56 -0500
Date: Sun, 24 Feb 2013 12:38:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: question about arch/arm/mach-s3c24xx/irq.c
Message-ID: <20130224123849.GH17833@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1302241241440.1943@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1302241241440.1943@hadrien>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 12:45:11PM +0100, Julia Lawall wrote:
> The function s3c24xx_irq_map in arch/arm/mach-s3c24xx/irq.c contains the
> code:
> 
>                 parent_irq_data = &parent_intc->irqs[irq_data->parent_irq];
> 		if (!irq_data) {
>                         pr_err("irq-s3c24xx: no irq data found for hwirq %lu\n",
>                                hw);
>                         goto err;
> 		}
> 
> At this point irq_data has already been tested, so the null test on
> irq_data does not look correct.  But I wonder if parent_irq_data could
> ever be null here?

That would be really obscure - because that would require parent_intc to
be a "negative" pointer (to counter-act the indexing by
irq_data->parent_irq).  So it looks to me like the above is redundant.
