Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbaCTPXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:23:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:57873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaCTPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:23:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [patch 08/26] arm: Replace various irq_desc accesses
Date: Thu, 20 Mar 2014 16:22:27 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        omap <linux-omap@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Shawn Guo <shawn.guo@linaro.org>
References: <20140223212703.511977310@linutronix.de> <20140223212737.099151500@linutronix.de>
In-Reply-To: <20140223212737.099151500@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403201622.27725.arnd@arndb.de>
X-Provags-ID: V02:K0:pIYNtCmO0vlBeyjiKOKBi00NJMv8RHxMqUHTSl6fO0d
 jPTk42tcZfbR5dAENqWRPmT9pd159vGcodDqQ83u3N5BdkATdV
 FvADsyXALexz2tMLVU+CdyBdW9+97zHJsKDDNVxNutwRk9G06k
 AaV4nkBDySCCWlSSsxuc7gJIsPw+YA2rvaYy+iV0L1sRpwtNKV
 e1I1w6/FGaPssfnZo+VCxhRnrNCC2cT07dQ27AYW4BOtw79E2y
 FwogHzepwHc/ECswv1jrC/lVGEA3ma9HG+6MKMCYWue5xjN5PV
 ld/WrT9EiOLk16pQCoBsSoKGrhkWUY5qPgzM9jqkisdlj8DGSK
 BnrJ8C9JXA8Hly18P57Aq2R93khUtGNs+SxKPhHPu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 February 2014, Thomas Gleixner wrote:
> --- tip.orig/arch/arm/mach-omap1/ams-delta-fiq.c
> +++ tip/arch/arm/mach-omap1/ams-delta-fiq.c
> @@ -44,13 +44,10 @@ static unsigned int irq_counter[16];
>  
>  static irqreturn_t deferred_fiq(int irq, void *dev_id)
>  {
> -       struct irq_desc *irq_desc;
> -       struct irq_chip *irq_chip = NULL;
>         int gpio, irq_num, fiq_count;
> +       struct irq_chip *irq_chip;
>  
> -       irq_desc = irq_to_desc(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
> -       if (irq_desc)
> -               irq_chip = irq_desc->irq_data.chip;
> +       irq_chip = irq_get_irq_chip(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));

I got a compile error because irq_get_irq_chip() doesn't exist. I suppose
you meant irq_get_chip.

	Arnd
