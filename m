Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaCFXqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:46:03 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47273 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaCFXqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:46:00 -0500
Message-ID: <531908b6.44f8440a.03ab.0cce@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        "Thomas Gleixner" <tglx@linutronix.de>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <1394016605-24120-2-git-send-email-sebastian.capella@linaro.org>
Cc: "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Will Deacon" <will.deacon@arm.com>,
        "Robin Holt" <robin.m.holt@gmail.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        "Konstantin Khlebnikov" <k.khlebnikov@samsung.com>,
        "Steven Capper" <steve.capper@linaro.org>,
        "Stephen Warren" <swarren@nvidia.com>, "Tejun Heo" <tj@kernel.org>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
 <1394016605-24120-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v7 1/2] ARM: avoid tracers in soft_restart
Date: Thu, 06 Mar 2014 15:45:53 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Capella (2014-03-05 02:50:04)
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
>         u64 *stack = soft_restart_stack + ARRAY_SIZE(soft_restart_stack);
>  
>         /* Disable interrupts first */
> -       local_irq_disable();
> +       raw_local_irq_disable();
>         local_fiq_disable();
>  
>         /* Disable the L2 if we're the last man standing. */
> -- 
> 1.7.9.5
Hi,

I have not heard any feedback on this change, since V3 of the
patchset.

Is everyone ok with this as it is?

Thomas, thanks for proposing this, is this looking ok to you?

Thanks!

Sebastian
