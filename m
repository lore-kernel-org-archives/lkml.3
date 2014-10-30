Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbaJ3InL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:43:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:32768 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbaJ3InI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:43:08 -0400
Date: Thu, 30 Oct 2014 09:43:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Cernekee <cernekee@gmail.com>
cc: arnd@arndb.de, f.fainelli@gmail.com, jason@lakedaemon.net,
        ralf@linux-mips.org, lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V2 03/15] genirq: Generic chip: Move irq_reg_{readl,writel}
 accessors into generic-chip.c
In-Reply-To: <1414635488-14137-4-git-send-email-cernekee@gmail.com>
Message-ID: <alpine.DEB.2.11.1410300941290.5308@nanos>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-4-git-send-email-cernekee@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Kevin Cernekee wrote:

> This allows us to implement per-irqchip behavior when necessary, instead
> of hardcoding the behavior for all irqchip drivers at compile time.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  include/linux/irq.h       |  7 -------
>  kernel/irq/generic-chip.c | 10 ++++++++++
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 03f48d9..8049e93 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -639,13 +639,6 @@ void arch_teardown_hwirq(unsigned int irq);
>  void irq_init_desc(unsigned int irq);
>  #endif
>  
> -#ifndef irq_reg_writel
> -# define irq_reg_writel(val, addr)	writel(val, addr)
> -#endif
> -#ifndef irq_reg_readl
> -# define irq_reg_readl(addr)		readl(addr)
> -#endif
> -

Brilliant patch that.

# git grep -l irq_reg_readl drivers/irqchip/
drivers/irqchip/irq-atmel-aic.c
drivers/irqchip/irq-atmel-aic5.c
drivers/irqchip/irq-sunxi-nmi.c
drivers/irqchip/irq-tb10x.c

Thanks,

	tglx

