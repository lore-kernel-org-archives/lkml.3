Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3GEVuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:50:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:46708 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3GEVuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:50:08 -0400
Date: Fri, 5 Jul 2013 23:50:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Alex Shi <alex.shi@intel.com>,
        hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
In-Reply-To: <20130705212235.GU23916@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1307052345330.32106@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <20130704075840.GH18898@dyad.programming.kicks-ass.net> <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com> <20130705143833.GT23916@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1307051718430.32106@ionos.tec.linutronix.de> <20130705212235.GU23916@twins.programming.kicks-ass.net>
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
> On Fri, Jul 05, 2013 at 05:24:09PM +0200, Thomas Gleixner wrote:
> > See arch/x86/kernel/tsc.c
> > 
> > We disable the watchdog for the TSC when tsc_clocksource_reliable is
> > set.
> > 
> > tsc_clocksource_reliable is set when:
> > 
> >  - you add tsc=reliable to the kernel command line
> 
> Ah, I didn't know about that one, useful.
> 
> >  - boot_cpu_has(X86_FEATURE_TSC_RELIABLE)
> >  
> >    X86_FEATURE_TSC_RELIABLE is a software flag, set by vmware and
> >    moorsetown. So all other machines keep the watchdog enabled.
> 
> Right.. I knew it was enabled on my machines even though they normally
> have usable TSC.

Yeah, but our well justified paranoia still prevents us from trusting
these CPU flags. Maybe some day BIOS is going to be replaced by
something useful. You know: Hope springs eternal....




