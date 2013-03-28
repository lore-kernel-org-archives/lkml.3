Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3C1Wwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:52:53 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:40859 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3C1Www (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:52:52 -0400
Message-ID: <5154C9C0.3030306@gmail.com>
Date: Thu, 28 Mar 2013 17:52:48 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function
 is specified
References: <1364503606-10597-1-git-send-email-maxime.ripard@free-electrons.com> <1364503606-10597-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364503606-10597-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 03:46 PM, Maxime Ripard wrote:
> More and more sub-architectures are using only the irqchip_init
> function. Make the core code call this function if no init_irq field is
> provided in the machine description to remove some boilerplate code.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  arch/arm/kernel/irq.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index 8e4ef4c..9723d17 100644
> --- a/arch/arm/kernel/irq.c
> +++ b/arch/arm/kernel/irq.c
> @@ -26,6 +26,7 @@
>  #include <linux/ioport.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
> +#include <linux/irqchip.h>
>  #include <linux/random.h>
>  #include <linux/smp.h>
>  #include <linux/init.h>
> @@ -114,7 +115,10 @@ EXPORT_SYMBOL_GPL(set_irq_flags);
>  
>  void __init init_IRQ(void)
>  {
> -	machine_desc->init_irq();
> +	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
> +		irqchip_init();
> +	else
> +		machine_desc->init_irq();
>  }
>  
>  #ifdef CONFIG_MULTI_IRQ_HANDLER
> 

