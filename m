Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaFDNmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:42:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:37289 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaFDNmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:42:10 -0400
Date: Wed, 4 Jun 2014 15:42:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Jason Cooper <jason@lakedaemon.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] irqchip: nvic: Use the generic noop function
In-Reply-To: <1401885425-12378-1-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.10.1406041540530.3319@nanos>
References: <1401885425-12378-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Daniel Thompson wrote:

> Using the generic function saves looking up this custom one in a source
> navigator.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> ---
>  drivers/irqchip/irq-nvic.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
> index 70bdf6e..c935c61 100644
> --- a/drivers/irqchip/irq-nvic.c
> +++ b/drivers/irqchip/irq-nvic.c
> @@ -49,14 +49,6 @@ nvic_handle_irq(irq_hw_number_t hwirq, struct pt_regs *regs)
>  	handle_IRQ(irq, regs);
>  }
>  
> -static void nvic_eoi(struct irq_data *d)
> -{
> -	/*
> -	 * This is a no-op as end of interrupt is signaled by the exception
> -	 * return sequence.
> -	 */

You shred that information. Please move the comment above the
irq_gc_noop assignment.

Thanks,

	tglx
