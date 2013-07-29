Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3G2P20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:28:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39039 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab3G2P2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:28:25 -0400
Date: Mon, 29 Jul 2013 08:28:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 1/7] nohz_full: Add Kconfig parameter for
 scalable detection of all-idle state
Message-ID: <20130729152813.GO26694@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <51F5E31C.30000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F5E31C.30000@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072915-5806-0000-0000-00002239328B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 11:35:56AM +0800, Lai Jiangshan wrote:
> On 07/27/2013 07:19 AM, Paul E. McKenney wrote:
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
> > +	 in adaptive-idle mode.  Because the underlying adaptive-tick
> > +	 support cannot distinguish between all CPUs being idle and
> > +	 all CPUs each running a single task in adaptive-idle mode,
> > +	 the underlying support simply ensures that there is always
> > +	 a CPU handling the scheduling-clock tick, whether or not all
> > +	 CPUs are idle.  This Kconfig option enables scalable detection
> > +	 of the all-CPUs-idle state, thus allowing the scheduling-clock
> > +	 tick to be disabled when all CPUs are idle.  Note that scalable
> > +	 detection of the all-CPUs-idle state means that larger systems
> > +	 will be slower to declare the all-CPUs-idle state.
> > +
> > +	 Say Y if you would like to help debug all-CPUs-idle detection.
> 
> The code is needed only for debug?
> I guess not.

The code is not used only for debug, but if you enable it now, you will
likely be helping to debug it.  ;-)

							Thanx, Paul

> > +
> > +	 Say N if you are unsure.
> > +
> >  config NO_HZ
> >  	bool "Old Idle dynticks config"
> >  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
> 

