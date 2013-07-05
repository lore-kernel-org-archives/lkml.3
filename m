Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab3GEPYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:24:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:45716 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab3GEPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:24:11 -0400
Date: Fri, 5 Jul 2013 17:24:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Alex Shi <alex.shi@intel.com>,
        hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
In-Reply-To: <20130705143833.GT23916@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1307051718430.32106@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <20130704075840.GH18898@dyad.programming.kicks-ass.net> <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com> <20130705143833.GT23916@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Peter Zijlstra wrote:

> On Fri, Jul 05, 2013 at 04:23:33PM +0200, Frederic Weisbecker wrote:
> > Nope, I haven't touched that. I prefer not to fiddle with unstable
> > clocksource for now :)
> > 
> > As for unstable TSCs, if sched_clock_tick() needs to be fed, we simply
> > don't stop the tick.
> 
> Not entirely the same thing; I thought the clocksource watchdog was ran
> even when we have a 'stable' TSC, just to make sure it stays stable.
> There's known cases where the BIOS f*cks us over and wrecks TSC sync.

See arch/x86/kernel/tsc.c

We disable the watchdog for the TSC when tsc_clocksource_reliable is
set.

tsc_clocksource_reliable is set when:

 - you add tsc=reliable to the kernel command line

 - boot_cpu_has(X86_FEATURE_TSC_RELIABLE)
 
   X86_FEATURE_TSC_RELIABLE is a software flag, set by vmware and
   moorsetown. So all other machines keep the watchdog enabled.

 - On Geode LX (OLPC)

Thanks,

	tglx
