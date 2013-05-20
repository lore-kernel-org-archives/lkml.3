Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3ETNx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:53:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53704 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab3ETNx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:53:57 -0400
Date: Mon, 20 May 2013 14:53:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] ARM: imx: use the core cpu hotplug functions
Message-ID: <20130520135321.GW18614@n2100.arm.linux.org.uk>
References: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org> <1369031608-27347-3-git-send-email-sanjay.rawat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369031608-27347-3-git-send-email-sanjay.rawat@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please read back on this list for my comments about such moves of this
very code.  You're not the first.

On Mon, May 20, 2013 at 12:03:24PM +0530, Sanjay Singh Rawat wrote:
> Generic arm cpu hotplug related functions are moved to core hotplug code,
> remove the functions from the platform code.
> 
> Signed-off-by: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
> ---
>  arch/arm/mach-imx/hotplug.c |   22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/hotplug.c b/arch/arm/mach-imx/hotplug.c
> index 3daf1ed..280c6f3 100644
> --- a/arch/arm/mach-imx/hotplug.c
> +++ b/arch/arm/mach-imx/hotplug.c
> @@ -14,30 +14,10 @@
>  #include <linux/jiffies.h>
>  #include <asm/cp15.h>
>  #include <asm/proc-fns.h>
> +#include <asm/hotplug.h>
>  
>  #include "common.h"
>  
> -static inline void cpu_enter_lowpower(void)
> -{
> -	unsigned int v;
> -
> -	asm volatile(
> -		"mcr	p15, 0, %1, c7, c5, 0\n"
> -	"	mcr	p15, 0, %1, c7, c10, 4\n"
> -	/*
> -	 * Turn off coherency
> -	 */
> -	"	mrc	p15, 0, %0, c1, c0, 1\n"
> -	"	bic	%0, %0, %3\n"
> -	"	mcr	p15, 0, %0, c1, c0, 1\n"
> -	"	mrc	p15, 0, %0, c1, c0, 0\n"
> -	"	bic	%0, %0, %2\n"
> -	"	mcr	p15, 0, %0, c1, c0, 0\n"
> -	  : "=&r" (v)
> -	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
> -	  : "cc");
> -}
> -
>  /*
>   * platform-specific code to shutdown a CPU
>   *
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
