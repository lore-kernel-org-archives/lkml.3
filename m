Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaEBPT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:19:56 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50207 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaEBPTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:19:54 -0400
Message-ID: <5363B795.4090908@cogentembedded.com>
Date: Fri, 02 May 2014 19:19:49 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/8] sh, irq: Remove irq_reserve_irq calling
References: <1398986302-30455-1-git-send-email-yinghai@kernel.org> <1398986302-30455-3-git-send-email-yinghai@kernel.org>
In-Reply-To: <1398986302-30455-3-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/02/2014 03:18 AM, Yinghai Lu wrote:

> in sh calling path:
> 	register_intc_controller
> 		==> irq_create_identity_mapping/irq_create_strict_mappins
> 			==>irq_alloc_desc: it will set bits on allocate_irq
> 		==> intc_register_irq
> 			==> irq_reserve_irq: set bits again

> so we can kill this irq_reserve_irq calling.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: linux-sh@vger.kernel.org
> ---
>   drivers/sh/intc/core.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)

> diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
> index 8f32a13..05118f92 100644
> --- a/drivers/sh/intc/core.c
> +++ b/drivers/sh/intc/core.c
> @@ -81,11 +81,8 @@ static void __init intc_register_irq(struct intc_desc *desc,
>   	unsigned long flags;
>
>   	/*
> -	 * Register the IRQ position with the global IRQ map, then insert
> -	 * it in to the radix tree.
> +	 * insert it in to the radix tree.

    It makes sense to convert this comment to one-liner now. I'd also have 
started it with a capital letter.

>   	 */
> -	irq_reserve_irq(irq);
> -
>   	raw_spin_lock_irqsave(&intc_big_lock, flags);
>   	radix_tree_insert(&d->tree, enum_id, intc_irq_xlate_get(irq));
>   	raw_spin_unlock_irqrestore(&intc_big_lock, flags);

WBR, Sergei

