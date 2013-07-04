Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab3GDScG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 14:32:06 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51935 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3GDScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 14:32:04 -0400
Message-ID: <51D5BFC9.6090703@prisktech.co.nz>
Date: Fri, 05 Jul 2013 06:32:41 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: vt8500: Staticize local symbols
References: <1372918293.25529.2.camel@phoenix>
In-Reply-To: <1372918293.25529.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/13 18:11, Axel Lin wrote:
> This driver is converted to use IRQCHIP_DECLARE and irqchip_init.
> vt8500_handle_irq() and vt8500_irq_init() are only referenced in this file now,
> make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/irqchip/irq-vt8500.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
> index d970595..1846e7d 100644
> --- a/drivers/irqchip/irq-vt8500.c
> +++ b/drivers/irqchip/irq-vt8500.c
> @@ -178,7 +178,8 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
>   	.xlate = irq_domain_xlate_onecell,
>   };
>   
> -asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
> +static asmlinkage
> +void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
>   {
>   	u32 stat, i;
>   	int irqnr, virq;
> @@ -203,7 +204,8 @@ asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
>   	}
>   }
>   
> -int __init vt8500_irq_init(struct device_node *node, struct device_node *parent)
> +static int __init vt8500_irq_init(struct device_node *node,
> +				  struct device_node *parent)
I prefer that the function variables are lined up, rather than aligning 
with the (. Can you move the 'struct device_node *parent' across one 
more space?

Otherwise:

Acked-by: Tony Prisk <linux@prisktech.co.nz>
>   {
>   	int irq, i;
>   	struct device_node *np = node;

Regards
Tony P
