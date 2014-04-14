Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaDNLDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:03:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34237 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbaDNLDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:03:05 -0400
Date: Mon, 14 Apr 2014 11:53:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Steven Capper <steve.capper@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 1/2] ARM: avoid tracers in soft_restart
Message-ID: <20140414105314.GB3530@arm.com>
References: <1395178858-27343-1-git-send-email-sebastian.capella@linaro.org>
 <1395178858-27343-2-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395178858-27343-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, Mar 18, 2014 at 09:40:57PM +0000, Sebastian Capella wrote:
> Use of tracers in local_irq_disable is causes abort loops when called
> with irqs disabled using a temporary stack.  Replace local_irq_disable
> with raw_local_irq_disable instead to avoid tracers.

Do you have any more information about these aborts? At the time we call
local_irq_disable, the stack is still intact, so if the issue is simply
related to having any tracers active at the call_with_stack invocation, we'd
be better off disabling tracing here altogether.

Will

> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Robin Holt <holt@sgi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Cc: Steven Capper <steve.capper@linaro.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  arch/arm/kernel/process.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 92f7b15..f58b723 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -100,7 +100,7 @@ void soft_restart(unsigned long addr)
>  	u64 *stack = soft_restart_stack + ARRAY_SIZE(soft_restart_stack);
>  
>  	/* Disable interrupts first */
> -	local_irq_disable();
> +	raw_local_irq_disable();
>  	local_fiq_disable();
>  
>  	/* Disable the L2 if we're the last man standing. */
> -- 
> 1.7.9.5
> 
> 
