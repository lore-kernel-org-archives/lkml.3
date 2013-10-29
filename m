Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3J2MyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:54:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:55871 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3J2MyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:54:10 -0400
Date: Tue, 29 Oct 2013 13:54:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] genirq: export percpu irq functions for module
 usage
In-Reply-To: <1383006690-6754-3-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1310291353140.8257@ionos.tec.linutronix.de>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org> <1383006690-6754-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013, Stephen Boyd wrote:

> In the near future we're going to use these percpu irq functions
> in the Krait CPU EDAC driver. Export them so that the EDAC driver
> can be compiled as a module.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Please take it through the tree which will take the EDAC patches.

Thanks,

	tglx

> ---
>  kernel/irq/manage.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 514bcfd..c6009d1 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1623,6 +1623,7 @@ void free_percpu_irq(unsigned int irq, void __percpu *dev_id)
>  	kfree(__free_percpu_irq(irq, dev_id));
>  	chip_bus_sync_unlock(desc);
>  }
> +EXPORT_SYMBOL_GPL(free_percpu_irq);
>  
>  /**
>   *	setup_percpu_irq - setup a per-cpu interrupt
> @@ -1693,3 +1694,4 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  
>  	return retval;
>  }
> +EXPORT_SYMBOL_GPL(request_percpu_irq);
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
