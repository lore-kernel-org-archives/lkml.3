Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3HQXi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 19:38:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60864 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3HQXiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 19:38:25 -0400
Date: Sat, 17 Aug 2013 16:38:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 1/7] nohz_full: Add Kconfig parameter for
 scalable detection of all-idle state
Message-ID: <20130817233817.GA14768@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130805010453.GB6894@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805010453.GB6894@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081723-5518-0000-0000-00001149696B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:04:55AM +0200, Frederic Weisbecker wrote:
> On Fri, Jul 26, 2013 at 04:19:18PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > At least one CPU must keep the scheduling-clock tick running for
> > timekeeping purposes whenever there is a non-idle CPU.  However, with
> > the new nohz_full adaptive-idle machinery, it is difficult to distinguish
> > between all CPUs really being idle as opposed to all non-idle CPUs being
> > in adaptive-ticks mode.  This commit therefore adds a Kconfig parameter
> > as a first step towards enabling a scalable detection of full-system
> > idle state.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/time/Kconfig | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> > index 70f27e8..a613c2a 100644
> > --- a/kernel/time/Kconfig
> > +++ b/kernel/time/Kconfig
> > @@ -134,6 +134,29 @@ config NO_HZ_FULL_ALL
> >  	 Note the boot CPU will still be kept outside the range to
> >  	 handle the timekeeping duty.
> >  
> > +config NO_HZ_FULL_SYSIDLE
> > +	bool "Detect full-system idle state for full dynticks system"
> > +	depends on NO_HZ_FULL
> > +	default n
> > +	help
> > +	 At least one CPU must keep the scheduling-clock tick running
> > +	 for timekeeping purposes whenever there is a non-idle CPU,
> > +	 where "non-idle" includes CPUs with a single runnable task
> > +	 in adaptive-idle mode.
> 
> "adaptive-idle" is particularly confusing here. How about this:
> 
>     'where "non-idle" also includes dynticks CPUs as long they are
>     running non-idle tasks.' 
> 
>           Because the underlying adaptive-tick
> > +	 support cannot distinguish between all CPUs being idle and
> > +	 all CPUs each running a single task in adaptive-idle mode,
> 
> s/adaptive-idle/dynticks
> 
> Thanks.

Good point, fixed.

							Thanx, Paul

> > +	 the underlying support simply ensures that there is always
> > +	 a CPU handling the scheduling-clock tick, whether or not all
> > +	 CPUs are idle.  This Kconfig option enables scalable detection
> > +	 of the all-CPUs-idle state, thus allowing the scheduling-clock
> > +	 tick to be disabled when all CPUs are idle.  Note that scalable
> > +	 detection of the all-CPUs-idle state means that larger systems
> > +	 will be slower to declare the all-CPUs-idle state.
> > +
> > +	 Say Y if you would like to help debug all-CPUs-idle detection.
> > +
> > +	 Say N if you are unsure.
> > +
> >  config NO_HZ
> >  	bool "Old Idle dynticks config"
> >  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
> > -- 
> > 1.8.1.5
> > 
> 

