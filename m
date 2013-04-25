Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3DYPw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:52:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42720 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286Ab3DYPw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:52:28 -0400
Date: Thu, 25 Apr 2013 08:52:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sbw@mit.edu,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Olivier Baetz <olivier.baetz@novasparks.com>
Subject: Re: [PATCH documentation 2/2] kthread: Document ways of reducing OS
 jitter due to per-CPU kthreads
Message-ID: <20130425155215.GK3427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130416164036.GA27246@linux.vnet.ibm.com>
 <1366130490-27584-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1366130490-27584-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130421193705.GB5807@pd.tnic>
 <20130423040329.GP3509@linux.vnet.ibm.com>
 <20130425102311.GA32607@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130425102311.GA32607@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042515-7182-0000-0000-0000066647C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 12:23:12PM +0200, Borislav Petkov wrote:
> On Mon, Apr 22, 2013 at 09:03:29PM -0700, Paul E. McKenney wrote:
> > > > +This document lists per-CPU kthreads in the Linux kernel and presents
> > > > +options to control OS jitter due to these kthreads.  Note that kthreads
> > > 
> > > s/due to/which can be caused by/
> > 
> > Same meaning, but "due to" is probably a bit more arcane.
> 
> Yeah, "due to" kinda didn't read right in the context, arcane could be
> one way to put it.
> 
> > But how about "and presents options to control these kthreads' OS
> > jitter"?
> 
> Yep.
> 
> > > > +that are not per-CPU are not listed here -- to reduce OS jitter from
> > > 
> > > one too many "that"s:
> > > 
> > > s/that/which/
> > 
> > Fair point, but I can shorten it as follows:
> > 
> > 	Note that non-per-CPU kthreads CPU are not listed here --
> 
> that second "CPU" is kinda superfluous...?
> 
> > 	to reduce OS jitter from non-per-CPU kthreads, bind them to a
> > 	"housekeeping" CPU that is dedicated to such work.
> 
> Yep, reads ok, except "that is" but you've removed it in the final
> version below.
> 
> > > > +non-per-CPU kthreads, bind them to a "housekeeping" CPU that is dedicated
> > > 
> > > s/that/which/
> > 
> > Good catch -- I chose s/that is//.
> 
> Yep.
> 
> > > > +Name: ehca_comp/%u
> > > > +Purpose: Periodically process Infiniband-related work.
> > > > +To reduce corresponding OS jitter, do any of the following:
> > > > +1.	Don't use EHCA Infiniband hardware.  This will prevent these
> > > 
> > > Sounds like this particular hardware is slow and its IRQ handler/softirq
> > > needs a lot of time. Yes, no?
> > > 
> > > Can we have a reason why people shouldn't use that hw.
> > 
> > Because it has per-CPU kthreads that can cause OS jitter.  ;-)
> 
> Yeah, I stumbled over this specific brand of Infiniband hw. It looks
> like this particular Infiniband driver uses per-CPU kthreads and the
> others in drivers/infiniband/hw/ don't?
> 
> I hope this explains my head-scratching moment here...

Ah!  I rewrote the first sentence to read:

	Don't use eHCA Infiniband hardware, instead choosing hardware
	that does not require per-CPU kthreads.

> > > This sentence keeps repeating; maybe explain the purpose of this doc in
> > > the beginning once and drop this sentence in the later sections.
> > 
> > There are "any of" and "all of" qualifiers.  Also, I cannot count on
> > someone reading the document beginning to end.  I would instead expect
> > many of them to search for the name of the kthread that is bothering
> > them and read only that part.
> 
> Ha! Very good point. :-)
> 
> > > > +2.	Build with CONFIG_HOTPLUG_CPU=y.  After boot completes, force
> > > > +	the CPU offline, then bring it back online.  This forces
> > > > +	recurring timers to migrate elsewhere.	If you are concerned
> > > 
> > > We don't migrate them back to that CPU when we online it again, do we?
> > 
> > Not unless the CPU it migrated to later is taken offline.  Good point,
> > added words to that effect.
> 
> Yep, good.
> 
> > > > +	to be de-jittered is marked as an adaptive-ticks CPU using the
> > > > +	"nohz_full=" boot parameter.  This reduces the number of
> > > > +	scheduler-clock interrupts that the de-jittered CPU receives,
> > > > +	minimizing its chances of being selected to do load balancing,
> > > 
> > > I don't think there's a "," if the "which... " part refers to the
> > > previous "load balancing" and not to the whole sentence.
> > 
> > Good point -- I can reword to:
> > 
> > 	This reduces the number of scheduler-clock interrupts that the
> > 	de-jittered CPU receives, minimizing its chances of being selected
> > 	to do the load balancing work that runs in SCHED_SOFTIRQ context.
> 
> Yep.
> 
> > > > +	This further reduces the number of scheduler-clock interrupts
> > > > +	that the de-jittered CPU receives.
> > > 
> > > s/that/which/ would suit better here IMHO.
> > 
> > Fair point, but how about this?
> > 
> > 	This further reduces the number of scheduler-clock interrupts
> > 	received by the de-jittered CPU.
> 
> Even better.
> 
> > > > +	b.	To the extent possible, keep the CPU out of the kernel
> > > > +		when it is non-idle, for example, by avoiding system
> > > > +		calls and by forcing both kernel threads and interrupts
> > > > +		to execute elsewhere.
> > > > +2.	Enable RCU to do its processing remotely via dyntick-idle by
> > > > +	doing all of the following:
> > > > +	a.	Build with CONFIG_NO_HZ=y and CONFIG_RCU_FAST_NO_HZ=y.
> > > > +	b.	Ensure that the CPU goes idle frequently, allowing other
> > > 
> > > I'm ensuring that by selecting the proper workload which has idle
> > > breathers?
> > 
> > Yep!  Or, equivalently, by adding enough CPUs so that the workload
> > has idle breathers.
> 
> Yeah, this sentence could be in the text, since we're explaining
> everything! :-)
> 
> > Thank you for the thorough review and comments!  Please see below for
> > an update.
> 
> Sure, thank you for writing this up for others to read.
> 
> Reviewed-by: Borislav Petkov <bp@suse.de>

Thank you, added!

> > ------------------------------------------------------------------------
> > 
> > REDUCING OS JITTER DUE TO PER-CPU KTHREADS
> > 
> > This document lists per-CPU kthreads in the Linux kernel and presents
> > options to control these kthreads' OS jitter.  Note that non-per-CPU
> 
> s /these kthreads'/their/
> 
> Sorry, I can't help it :) I promise I won't read too much in the rest so
> as not to beat it to death again :-)

Good change, though, applied.

> > kthreads CPU are not listed here.  To reduce OS jitter from non-per-CPU
> 
> s/CPU //
> 
> see above.

Good point, fixed

> > kthreads, bind them to a "housekeeping" CPU dedicated to such work.
> 
> [ … ]
> 
> Ok, it looks good, ship it.
> 
> :-)

Will do!  ;-)

							Thanx, Paul

