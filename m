Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaBZXhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:37:54 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52338 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752607AbaBZXhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:37:52 -0500
Date: Wed, 26 Feb 2014 23:37:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Robin Holt <robin.m.holt@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v4 1/2] ARM: avoid tracers in soft_restart
Message-ID: <20140226233744.GG21483@n2100.arm.linux.org.uk>
References: <1393441857-15472-1-git-send-email-sebastian.capella@linaro.org> <1393441857-15472-2-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393441857-15472-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 11:10:56AM -0800, Sebastian Capella wrote:
> Use of tracers in local_irq_disable is causes recursive aborts when
> called with irqs disabled and using a temporary stack (hibernation).
> Replace local_irq_disable with raw_local_irq_disable instead to
> avoid tracers.
> 
> Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Robin Holt <robin.m.holt@gmail.com>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
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

Great, I'm happy with this now.  I assume that the plan is to submit this
to my patch system when everyone's given their fill of acks?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
