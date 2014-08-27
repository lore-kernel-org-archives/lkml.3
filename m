Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935709AbaH0SoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:44:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:35258 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbaH0SoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:44:15 -0400
Date: Wed, 27 Aug 2014 20:44:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@kernel.org>
cc: Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] irq: Export handle_fasteoi_irq() to modules
In-Reply-To: <1409160402-30783-1-git-send-email-broonie@kernel.org>
Message-ID: <alpine.DEB.2.10.1408272043100.3323@nanos>
References: <1409160402-30783-1-git-send-email-broonie@kernel.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Currently handle_fasteoi_irq() is not exported which is causing build
> failures in -next for ARM allmodconfig due to gpio-zynq using it. Since
> it seems like a reasonable thing to use from a driver add an export for
> the function.

The export is already pending in tip/irq/urgent and scheduled for
Linus tree.
 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  kernel/irq/chip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index a2b28a2fd7b1..9ce0c5dd4489 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -517,6 +517,7 @@ out:
>  		chip->irq_eoi(&desc->irq_data);
>  	raw_spin_unlock(&desc->lock);
>  }
> +EXPORT_SYMBOL(handle_fasteoi_irq);
>  
>  /**
>   *	handle_edge_irq - edge type IRQ handler
> -- 
> 2.1.0
> 
> 
