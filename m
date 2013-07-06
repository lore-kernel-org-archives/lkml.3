Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3GFKu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 06:50:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40779 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3GFKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 06:50:57 -0400
Date: Sat, 6 Jul 2013 12:50:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Alex Shi <alex.shi@intel.com>,
        hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
Message-ID: <20130706105010.GV18898@dyad.programming.kicks-ass.net>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
 <20130704075840.GH18898@dyad.programming.kicks-ass.net>
 <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com>
 <20130705143833.GT23916@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1307051718430.32106@ionos.tec.linutronix.de>
 <20130705212235.GU23916@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1307052345330.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307052345330.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:50:05PM +0200, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, Peter Zijlstra wrote:
> > On Fri, Jul 05, 2013 at 05:24:09PM +0200, Thomas Gleixner wrote:
> > > See arch/x86/kernel/tsc.c
> > > 
> > > We disable the watchdog for the TSC when tsc_clocksource_reliable is
> > > set.
> > > 
> > > tsc_clocksource_reliable is set when:
> > > 
> > >  - you add tsc=reliable to the kernel command line
> > 
> > Ah, I didn't know about that one, useful.
> > 
> > >  - boot_cpu_has(X86_FEATURE_TSC_RELIABLE)
> > >  
> > >    X86_FEATURE_TSC_RELIABLE is a software flag, set by vmware and
> > >    moorsetown. So all other machines keep the watchdog enabled.
> > 
> > Right.. I knew it was enabled on my machines even though they normally
> > have usable TSC.
> 
> Yeah, but our well justified paranoia still prevents us from trusting
> these CPU flags. Maybe some day BIOS is going to be replaced by
> something useful. You know: Hope springs eternal....

Oh quite agreed. Its just that at several times I've wanted to disable the
thing. Now I know you can do using the kernel cmdline. Previously I had to
wreck code -- not that much harder really :-)
