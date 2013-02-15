Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161294Ab3BOK0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:26:31 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59350 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932938Ab3BOK03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:26:29 -0500
Date: Fri, 15 Feb 2013 10:26:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/9] ARM: arch_timer: include linux/errno.h
Message-ID: <20130215102618.GJ25537@e106331-lin.cambridge.arm.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360882071-4072668-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As with Stephen Warren's fix [1], this looks right to me. Stephen's has the
added benefit of keeping the includes ordered.

For either version:

Acked-By: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149579.html

On Thu, Feb 14, 2013 at 10:47:43PM +0000, Arnd Bergmann wrote:
> Patch 8a4da6e "arm: arch_timer: move core to drivers/clocksource"
> moved a lot of code out of arch_timer.c, but ended up deleting
> too much, which broke some configurations.
> 
> Obviously, include linux/errno.h is required to return error
> values.
> 
> Without this patch, building allmodconfig results in:
> 
> arch/arm/kernel/arch_timer.c: In function 'arch_timer_sched_clock_init':
> arch/arm/kernel/arch_timer.c:55:11: error: 'ENXIO' undeclared (first use in this function)
> arch/arm/kernel/arch_timer.c:55:11: note: each undeclared identifier is reported only once for each function it appears in
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kernel/arch_timer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
> index 36ebcf4..d957a51 100644
> --- a/arch/arm/kernel/arch_timer.c
> +++ b/arch/arm/kernel/arch_timer.c
> @@ -10,6 +10,7 @@
>   */
>  #include <linux/init.h>
>  #include <linux/types.h>
> +#include <linux/errno.h>
>  
>  #include <asm/delay.h>
>  #include <asm/sched_clock.h>
> -- 
> 1.8.1.2
> 
> 
