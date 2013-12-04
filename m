Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3LDK0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:26:12 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62695 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3LDK0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:26:10 -0500
Message-ID: <529F033E.9020608@gmail.com>
Date: Wed, 04 Dec 2013 11:26:06 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: pxa: Remove unused variables
References: <1386152565-26524-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1386152565-26524-1-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 11:22 AM, Thierry Reding wrote:
> The conf and of_id variables are assigned but never used, so they may as
> well just be removed.
> 
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>

Acked-by: Daniel Mack <zonque@gmail.com>

> ---
>  arch/arm/mach-pxa/irq.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
> index b6cc1816463e..0eecd83c624e 100644
> --- a/arch/arm/mach-pxa/irq.c
> +++ b/arch/arm/mach-pxa/irq.c
> @@ -235,8 +235,6 @@ static const struct of_device_id intc_ids[] __initconst = {
>  void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
>  {
>  	struct device_node *node;
> -	const struct of_device_id *of_id;
> -	struct pxa_intc_conf *conf;
>  	struct resource res;
>  	int n, ret;
>  
> @@ -245,8 +243,6 @@ void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
>  		pr_err("Failed to find interrupt controller in arch-pxa\n");
>  		return;
>  	}
> -	of_id = of_match_node(intc_ids, node);
> -	conf = of_id->data;
>  
>  	ret = of_property_read_u32(node, "marvell,intc-nr-irqs",
>  				   &pxa_internal_irq_nr);
> 

