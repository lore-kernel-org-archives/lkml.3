Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3C1OsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:48:24 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:37423 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3C1OsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:48:20 -0400
Message-ID: <51545832.1050504@gmail.com>
Date: Thu, 28 Mar 2013 09:48:18 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function
 is specified
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <1364463704-13692-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364463704-13692-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 04:41 AM, Maxime Ripard wrote:
> More and more sub-architectures are using only the irqchip_init
> function. Make the core code call this function if no init_irq field is
> provided in the machine description to remove some boilerplate code.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/kernel/irq.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index 8e4ef4c..df6f9a1 100644
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
> +	if (machine_desc->init_irq)
> +		machine_desc->init_irq();
> +	else
> +		irqchip_init();

There needs to be an empty version defined for !OF.

Rob

>  }
>  
>  #ifdef CONFIG_MULTI_IRQ_HANDLER
> 

