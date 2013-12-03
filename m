Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3LCL1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:27:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45039 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761Ab3LCL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:27:47 -0500
Date: Tue, 3 Dec 2013 11:27:01 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Chris Smith <chris.smith@st.com>
Subject: Re: [PATCH V6 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
Message-ID: <20131203112701.GD1169@mudshark.cambridge.arm.com>
References: <1385976843-13280-1-git-send-email-vkale@apm.com>
 <1385976843-13280-2-git-send-email-vkale@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385976843-13280-2-git-send-email-vkale@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:34:02AM +0000, Vinayak Kale wrote:
> This patch adds an accessor function for IRQ_PER_CPU flag.
> The accessor function is useful to determine whether an IRQ is percpu or not.
> 
> This patch is based on an older patch posted by Chris Smith here [1].
> There is a minor change w.r.t. Chris's original patch: The accessor function
> is renamed as 'irq_is_percpu' instead of 'irq_is_per_cpu'.
> 
> [1]: http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/02955.html
> 
> Signed-off-by: Chris Smith <chris.smith@st.com>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> ---
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

Acked-by: Will Deacon <will.deacon@arm.com>

Will
