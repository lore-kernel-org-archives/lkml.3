Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3GQVxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:53:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46550 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3GQVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:53:14 -0400
Message-ID: <51E71249.4050200@codeaurora.org>
Date: Wed, 17 Jul 2013 14:53:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Javi Merino <javi.merino@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if
 UP system
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org> <20130712111322.GC3213@e102654-lin.cambridge.arm.com> <20130712121023.GB27430@codeaurora.org>
In-Reply-To: <20130712121023.GB27430@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/13 05:10, Stephen Boyd wrote:
> On 07/12, Javi Merino wrote:
>> I agree, we should drop the check.  It's annoying in uniprocessors and
>> unlikely to be found in the real world unless your gic entry in the dt
>> is wrong.
>>
> Ok. How about this?

Any comments?

>
> ----8<-----
> Subject: [PATCH v2] irqchip: gic: Don't complain in gic_get_cpumask()
>
> In a uniprocessor implementation the interrupt processor targets
> registers are read-as-zero/write-ignored (RAZ/WI). Unfortunately
> gic_get_cpumask() will print a critical message saying
>
>  GIC CPU mask not found - kernel will fail to boot.
>
> if these registers all read as zero, but there won't actually be
> a problem on uniprocessor systems and the kernel will boot just
> fine. Remove this check because if you're on a multiprocessor
> system it's unlikely to be printed unless your DT is wrong or
> your hardware is broken.
>
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Javi Merino <javi.merino@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/irqchip/irq-gic.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 19ceaa60..4fbcea9 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -368,9 +368,6 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
>  			break;
>  	}
>  
> -	if (!mask)
> -		pr_crit("GIC CPU mask not found - kernel will fail to boot.\n");
> -
>  	return mask;
>  }
>  


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

