Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3KTSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:16:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58510 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3KTSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:16:25 -0500
Message-ID: <528CFC77.5050200@codeaurora.org>
Date: Wed, 20 Nov 2013 10:16:23 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vinayak Kale <vkale@apm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: patches@apm.com, tglx@linutronix.de, will.deacon@arm.com, jcm@redhat.com
Subject: Re: [PATCH V4 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
References: <1384946021-22100-1-git-send-email-vkale@apm.com> <1384946021-22100-2-git-send-email-vkale@apm.com>
In-Reply-To: <1384946021-22100-2-git-send-email-vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 03:13, Vinayak Kale wrote:
> This patch adds an accessor function for IRQ_PER_CPU flag.
> The accessor function is useful to dertermine whether an IRQ is percpu or not.
>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> ---

This looks like a copy of Chris Smith's patch. Shouldn't Chris be the
author and the commit text be whatever Chris sent?

>  include/linux/irqdesc.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
> index 56fb646..26e2661 100644
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -152,6 +152,14 @@ static inline int irq_balancing_disabled(unsigned int irq)
>  	return desc->status_use_accessors & IRQ_NO_BALANCING_MASK;
>  }
>  
> +static inline int irq_is_percpu(unsigned int irq)
> +{
> +	struct irq_desc *desc;
> +
> +	desc = irq_to_desc(irq);
> +	return desc->status_use_accessors & IRQ_PER_CPU;
> +}
> +
>  static inline void
>  irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
>  {

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

