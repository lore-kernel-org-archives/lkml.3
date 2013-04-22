Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3DVXYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:24:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3DVXYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:24:10 -0400
Date: Mon, 22 Apr 2013 16:24:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Cc: tglx@linutronix.de, zonque@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: use irq_mask as fallback for irq_disable.
Message-Id: <20130422162409.e66b1e6ac3111bd3995c5fd6@linux-foundation.org>
In-Reply-To: <1366378862-22359-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <1366378862-22359-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013 15:41:02 +0200 Andreas Fenkart <andreas.fenkart@streamunlimited.com> wrote:

> This is in line with irq_enable that uses the same fallback.
> When masked, interrupts are still latched into the status register
> so when unmasked there is an interrupt straight away.
> 
> ...
>
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -216,10 +216,11 @@ void irq_enable(struct irq_desc *desc)
>  void irq_disable(struct irq_desc *desc)
>  {
>  	irq_state_set_disabled(desc);
> -	if (desc->irq_data.chip->irq_disable) {
> +	if (desc->irq_data.chip->irq_disable)
>  		desc->irq_data.chip->irq_disable(&desc->irq_data);
> -		irq_state_set_masked(desc);
> -	}
> +	else
> +		desc->irq_data.chip->irq_mask(&desc->irq_data);
> +	irq_state_set_masked(desc);
>  }
>  
>  void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu)

Well I hope Thomas knows what this patch does, because I sure don't.

Does it fix a bug?  Does it add a bug?  Does it have any
runtime-observable effects at all?  If so, what are they?
