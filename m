Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3CYLbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:31:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:47162 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3CYLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:31:23 -0400
Date: Mon, 25 Mar 2013 12:31:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [patch 08/34] arm: Use generic idle loop
In-Reply-To: <87zjxv9lga.fsf@linaro.org>
Message-ID: <alpine.LFD.2.02.1303251230440.22263@ionos>
References: <20130321214930.752934102@linutronix.de> <20130321215233.826238797@linutronix.de> <87zjxv9lga.fsf@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Kevin Hilman wrote:

> Hi Thomas,
> 
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > Use the generic idle loop and replace enable/disable_hlt with the
> > respective core functions.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Russell King <linux@arm.linux.org.uk>
> 
> I gave patches 1-5 + this a quick spin on ARM (specifially some OMAP3 and
> OMAP4 platforms, with and without CPUidle enabled.)
> 
> The OMAP stuff needed a couple minor compile fixes (below), but
> otherwise it passes the quick "seems to work" test.

Yeah, that's needed for the other arch/arm conversions as well.

Thanks,

	tglx

 
> So at least for ARM/OMAP:
> 
> Tested-by: Kevin Hilman <khilman@linaro.org>
> 
> Kevin
> 
> 
> diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
> index 23c653a..db37f49 100644
> --- a/arch/arm/mach-omap1/pm.c
> +++ b/arch/arm/mach-omap1/pm.c
> @@ -43,6 +43,7 @@
>  #include <linux/module.h>
>  #include <linux/io.h>
>  #include <linux/atomic.h>
> +#include <linux/cpu.h>
>  
>  #include <asm/fncpy.h>
>  #include <asm/system_misc.h>
> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
> index 3a6c6b8..2f17f95 100644
> --- a/arch/arm/mach-omap2/omap_hwmod.c
> +++ b/arch/arm/mach-omap2/omap_hwmod.c
> @@ -138,6 +138,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/bootmem.h>
> +#include <linux/cpu.h>
>  
>  #include <asm/system_misc.h>
> 
