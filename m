Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbaJ2Qzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:55:35 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54130 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaJ2Qzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:55:31 -0400
Message-ID: <54511BE8.6020905@gmail.com>
Date: Wed, 29 Oct 2014 09:55:04 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 08/11] irqchip: bcm7120-l2: Fix missing nibble in gc->unused
 mask
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-8-git-send-email-cernekee@gmail.com>
In-Reply-To: <1414555138-6500-8-git-send-email-cernekee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:58 PM, Kevin Cernekee wrote:
> This mask should have been 0xffff_ffff, not 0x0fff_ffff.
> 
> The change should not have an effect on current users (STB) because bits
> 31:27 are unused.

Nice catch!

> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  drivers/irqchip/irq-bcm7120-l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
> index f041992..e9331f8 100644
> --- a/drivers/irqchip/irq-bcm7120-l2.c
> +++ b/drivers/irqchip/irq-bcm7120-l2.c
> @@ -171,7 +171,7 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
>  	}
>  
>  	gc = irq_get_domain_generic_chip(data->domain, 0);
> -	gc->unused = 0xfffffff & ~data->irq_map_mask;
> +	gc->unused = 0xffffffff & ~data->irq_map_mask;
>  	gc->reg_base = data->base;
>  	gc->private = data;
>  	ct = gc->chip_types;
> 

