Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3J2PEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:04:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:56539 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab3J2PEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:04:41 -0400
Date: Tue, 29 Oct 2013 16:04:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vincent Donnefort <vdonnefort@gmail.com>
cc: linux-kernel@vger.kernel.org, gregory.clement@free-electrons.com
Subject: Re: [PATCH] irqchip: aramda370-xp: fix compilation warning
In-Reply-To: <1383057885-10101-1-git-send-email-vdonnefort@lacie.com>
Message-ID: <alpine.DEB.2.02.1310291601230.8257@ionos.tec.linutronix.de>
References: <1383057885-10101-1-git-send-email-vdonnefort@lacie.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent,

On Tue, 29 Oct 2013, Vincent Donnefort wrote:

Subject line : irqchip: aramda370-xp: fix compilation warning

We are not fixing compilation warnings. We modify the code so the
compiler does not longer issue a warning.

> From: Vincent Donnefort <vdonnefort@gmail.com>
> 
> Fix the following compilation warning:
>   drivers/irqchip/irq-armada-370-xp.c:55:23: warning: 'irq_controller_lock' defined but not used [-Wunused-variable]
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
> 
> diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
> index bb328a3..75c3141 100644
> --- a/drivers/irqchip/irq-armada-370-xp.c
> +++ b/drivers/irqchip/irq-armada-370-xp.c
> @@ -52,7 +52,9 @@
>  #define IPI_DOORBELL_END                        (8)
>  #define IPI_DOORBELL_MASK                       0xFF
>  
> +#ifdef CONFIG_SMP
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> +#endif

Instead of adding a new ifdeffery you should just move it into the
existing #ifdef CONFIG_SMP section, which also contains the only usage
site of irq_controller_lock

Thanks,

	tglx
