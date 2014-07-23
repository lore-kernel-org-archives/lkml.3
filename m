Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbaGWPDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:03:05 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54200 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755815AbaGWPDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:03:03 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-kernel@vger.kernel.org, julia.lawall@lip6.fr,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com
Subject: Re: [PATCH] drivers: CCI: Correct use of ! and &
References: <20140707140538.GA4204@himangi-Dell>
Date: Wed, 23 Jul 2014 16:01:56 +0100
In-Reply-To: <20140707140538.GA4204@himangi-Dell> (Himangi Saraogi's message
	of "Mon, 7 Jul 2014 19:35:38 +0530")
Message-ID: <9hhwqb42k63.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding alkml and Will

Hi Himangi,

In future it would help if you send the patch to the the maintainers by
running the get_maintainers.pl script on the patch.

Himangi Saraogi <himangi774@gmail.com> writes:

> In commit ae91d60ba88ef0bdb1b5e9b2363bd52fc45d2af7, a bug was fixed that
> involved converting !x & y to !(x & y).  The code below shows the same
> pattern, and thus should perhaps be fixed in the same way.
>
> The Coccinelle semantic patch that makes this change is as follows:
>
> // <smpl>
> @@ expression E1,E2; @@
> (
>   !E1 & !E2
> |
> - !E1 & E2
> + !(E1 & E2)
> )
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> This is not tested and clearly changes the semantics, so it is only
> something to consider.
>  drivers/bus/arm-cci.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
> index 5a86da9..7af78df 100644
> --- a/drivers/bus/arm-cci.c
> +++ b/drivers/bus/arm-cci.c
> @@ -397,7 +397,8 @@ static irqreturn_t pmu_handle_irq(int irq_num, void *dev)
>  		hw_counter = &event->hw;
>  
>  		/* Did this counter overflow? */
> -		if (!pmu_read_register(idx, CCI_PMU_OVRFLW) & CCI_PMU_OVRFLW_FLAG)
> +		if (!(pmu_read_register(idx, CCI_PMU_OVRFLW) &
> +		      CCI_PMU_OVRFLW_FLAG))
>  			continue;


Going back to the manual, this fix looks correct.

Acked-by: Punit Agrawal <punit.agrawal@arm.com>

Will, would this go via your tree?

>  
>  		pmu_write_register(CCI_PMU_OVRFLW_FLAG, idx, CCI_PMU_OVRFLW);
