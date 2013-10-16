Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167Ab3JPMOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:14:22 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:51183 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3JPMOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:14:21 -0400
Date: Wed, 16 Oct 2013 14:14:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        linux-arm-kernel@lists.infradead.org, rmk@arm.linux.org.uk,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, khilman@linaro.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] ARM: Kconfig: allow full nohz CPU accounting
Message-ID: <20131016121416.GD12773@localhost.localdomain>
References: <tip-31c1fc8187158cb80ccd57c19e024c55af901797@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-31c1fc8187158cb80ccd57c19e024c55af901797@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:58:03AM -0700, tip-bot for Kevin Hilman wrote:
> Commit-ID:  31c1fc8187158cb80ccd57c19e024c55af901797
> Gitweb:     http://git.kernel.org/tip/31c1fc8187158cb80ccd57c19e024c55af901797
> Author:     Kevin Hilman <khilman@linaro.org>
> AuthorDate: Mon, 16 Sep 2013 15:28:22 -0700
> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> CommitDate: Mon, 30 Sep 2013 15:37:05 +0200
> 
> ARM: Kconfig: allow full nohz CPU accounting
> 
> With the 64-bit requirement removed from VIRT_CPU_ACCOUNTING_GEN,
> allow ARM platforms to enable it.  Since VIRT_CPU_ACCOUNTING_GEN is a
> dependency for full NO_HZ, this allows ARM platforms to enable full
> NO_HZ as well.

I realize that arm doesn't implement irq work raise. It hooks on the
timer to execute pending irq work. You'll need to implement arch_irq_work_raise()
and implement some sort of self IPI to trigger irq work. The full dynticks subsystem
relies on that to work correctly. It often use that to re-evaluate and possibly restart
the tick after scheduler, posix timer updates, etc...

That notwithstanding that if you have no tick, tick based irq work can't
work.

Thanks.

> 
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Arm Linux <linux-arm-kernel@lists.infradead.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1ad6fb6..323baf0 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -54,6 +54,7 @@ config ARM
>  	select HAVE_REGS_AND_STACK_ACCESS_API
>  	select HAVE_SYSCALL_TRACEPOINTS
>  	select HAVE_UID16
> +	select HAVE_VIRT_CPU_ACCOUNTING_GEN
>  	select IRQ_FORCED_THREADING
>  	select KTIME_SCALAR
>  	select MODULES_USE_ELF_REL
