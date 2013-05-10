Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3EJSL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:11:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:39347 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3EJSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:11:28 -0400
Message-ID: <518D3828.9060000@infradead.org>
Date: Fri, 10 May 2013 11:10:48 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 1/1] genirq: outline lazy disable in kerneldoc of irq_disable
 function.
References: <1368181290-1583-1-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1368181290-1583-1-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/13 03:21, Andreas Fenkart wrote:
> comment based on changelog of d209a699a0b975ad
> 
> Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
> ---
>  kernel/irq/chip.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index cbd97ce..4e3c439 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -213,6 +213,19 @@ void irq_enable(struct irq_desc *desc)
>  	irq_state_clr_masked(desc);
>  }
>  
> +/**
> + * irq_disable - mask interupt disabled

                  - mark interrupt disabled

> + * @desc:		irq descriptor which should be disabled
> + *
> + * If the chip does not implement the irq_disable callback, we
> + * use a lazy disable approach. That means we mark the interrupt
> + * disabled, but leave the hardware unmasked. That's an
> + * optimization because we avoid the hardware access for the
> + * common case where no interrupt happens after we marked it
> + * disabled. If an interrupt happens, then the interrupt flow
> + * handler masks the line at the hardware level and marks it
> + * pending.
> + */
>  void irq_disable(struct irq_desc *desc)
>  {
>  	irq_state_set_disabled(desc);
> 


-- 
~Randy
