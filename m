Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3FEWlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:41:52 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42417 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab3FEWlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:41:51 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] kernel/irq/irqdomain.c: before use 'irq_data', need check it whether valid.
To: Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <519219D5.6010907@asianux.com>
References: <519219D5.6010907@asianux.com>
Date: Wed, 05 Jun 2013 23:41:47 +0100
Message-Id: <20130605224147.584263E10E4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013 19:02:45 +0800, Chen Gang <gang.chen@asianux.com> wrote:
> 
> Since irq_data may be NULL, if so, we WARN_ON(), and continue, 'hwirq'
> which related with 'irq_data' has to initialize later, or it will cause
> issue.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied, thanks.

g.

> ---
>  kernel/irq/irqdomain.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index af804b5..61abbfa 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -400,11 +400,12 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
>  	while (count--) {
>  		int irq = irq_base + count;
>  		struct irq_data *irq_data = irq_get_irq_data(irq);
> -		irq_hw_number_t hwirq = irq_data->hwirq;
> +		irq_hw_number_t hwirq;
>  
>  		if (WARN_ON(!irq_data || irq_data->domain != domain))
>  			continue;
>  
> +		hwirq = irq_data->hwirq;
>  		irq_set_status_flags(irq, IRQ_NOREQUEST);
>  
>  		/* remove chip and handler */
> -- 
> 1.7.7.6

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
