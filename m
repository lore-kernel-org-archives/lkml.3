Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3C1Ppp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:45:45 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49078 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3C1Ppk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:45:40 -0400
Message-ID: <5154650A.1060406@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 21:13:06 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [patch 30/34] tile: Enter idle with preemption disabled
References: <20130321214930.752934102@linutronix.de> <20130321215235.280451779@linutronix.de>
In-Reply-To: <20130321215235.280451779@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032815-5816-0000-0000-0000075300C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:23 AM, Thomas Gleixner wrote:
> cpu_idle() needs to be called with preemption disabled.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/kernel/smpboot.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux-2.6/arch/tile/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/arch/tile/kernel/smpboot.c
> +++ linux-2.6/arch/tile/kernel/smpboot.c
> @@ -207,8 +207,6 @@ void __cpuinit online_secondary(void)
>  	/* Set up tile-timer clock-event device on this cpu */
>  	setup_tile_timer();
> 
> -	preempt_enable();
> -

Hmm, so shouldn't we call preempt_disabled() here?

I see that start_secondary() calls preempt_disabled(), but I didn't quite
understand as to which of the *_secondary() functions have to call
it... especially since its the online_secondary() function which calls
cpu_idle().

>  	cpu_idle();
>  }
> 
> 
> 
 
Regards,
Srivatsa S. Bhat

