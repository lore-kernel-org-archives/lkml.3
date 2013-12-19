Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3LSUQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:16:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36149 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LSUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:16:42 -0500
Date: Thu, 19 Dec 2013 21:16:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        rui.zhang@intel.com, bitbucket@online.de, rafael.j.wysocki@intel.com,
        lenb@kernel.org, tglx@linutronix.de, jacob.jun.pan@linux.intel.com,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/idle] x86, acpi, idle: Restructure the mwait idle
 routines
Message-ID: <20131219201634.GR16438@laptop.programming.kicks-ass.net>
References: <20131212141654.616820819@infradead.org>
 <tip-16824255394f55adf31b9a96a9965d8c15bdac4c@git.kernel.org>
 <52B35369.6070208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B35369.6070208@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 12:13:29PM -0800, H. Peter Anvin wrote:
> On 12/19/2013 12:09 PM, tip-bot for Peter Zijlstra wrote:
> > diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
> > index 8f181b3..e8275f2 100644
> > --- a/drivers/thermal/intel_powerclamp.c
> > +++ b/drivers/thermal/intel_powerclamp.c
> > @@ -438,9 +438,7 @@ static int clamp_thread(void *arg)
> >  			 */
> >  			local_touch_nmi();
> >  			stop_critical_timings();
> > -			__monitor((void *)&current_thread_info()->flags, 0, 0);
> > -			cpu_relax(); /* allow HT sibling to run */
> > -			__mwait(eax, ecx);
> > +			mwait_idle_with_hints(eax, ecx);
> >  			start_critical_timings();
> >  			atomic_inc(&idle_wakeup_counter);
> >  		}
> > 
> 
> Should this cpu_relax() be in the common code as well?

I don't think so; it seems weird to allow a sibling some time between
monitor and wait because the moment wait stalls the cpu the sibling gets
all the time it wants.
