Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3DKTOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:14:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46986 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3DKTOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:14:18 -0400
Date: Thu, 11 Apr 2013 12:13:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
Message-ID: <20130411191355.GO29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130411160524.GA30384@linux.vnet.ibm.com>
 <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130411182502.GA31684@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411182502.GA31684@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041119-7182-0000-0000-000006324E44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:25:02PM +0200, Borislav Petkov wrote:
> Ok,
> 
> here's some more Savel fun, feel free to take whatever you like. :)

;-) ;-) ;-)

> On Thu, Apr 11, 2013 at 09:05:58AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Christoph Lameter <cl@linux.com>
> > ---
> >  Documentation/timers/NO_HZ.txt | 245 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 245 insertions(+)
> >  create mode 100644 Documentation/timers/NO_HZ.txt
> > 
> > diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
> > new file mode 100644
> > index 0000000..6b33f6b
> > --- /dev/null
> > +++ b/Documentation/timers/NO_HZ.txt
> > @@ -0,0 +1,245 @@
> > +		NO_HZ: Reducing Scheduling-Clock Ticks
> > +
> > +
> > +This document describes Kconfig options and boot parameters that can
> > +reduce the number of scheduling-clock interrupts, thereby improving energy
> > +efficiency and reducing OS jitter.  Reducing OS jitter is important for
> > +some types of computationally intensive high-performance computing (HPC)
> > +applications and for real-time applications.
> > +
> > +There are two major aspects of scheduling-clock interrupt reduction:
> 
> I'd simplify this:
> 
> There are two main reasons for reducing the amount of scheduling-clock
> interrupts:

How about "There are two main contexts in which the number of
scheduling-clock interrupts can be reduced:"?

> > +
> > +1.	Idle CPUs.
> > +
> > +2.	CPUs having only one runnable task.
> > +
> > +These two cases are described in the following sections.
> 
> Not really needed this sentence is, huh, since the two aspects simply
> follow.

Good point.  How about if I also mention the two additional sections
following this:

	These two cases are described in the following two sections,
	followed by a third section on RCU issues and a fourth and final
	section listing known issues.

> > +
> > +
> > +IDLE CPUs
> > +
> > +If a CPU is idle, there is little point in sending it a scheduling-clock
> > +interrupt.  After all, the primary purpose of a scheduling-clock interrupt
> > +is to force a busy CPU to shift its attention among multiple duties,
> > +but an idle CPU by definition has no duties to shift its attention among.
> 
> simplify:
> 
> "... but an idle CPU has, by definition, no duties."

I feel the need to close the loop back to shifting attention, but the
"by definition" could be dropped.  How about the following?

	If a CPU is idle, there is little point in sending it a
	scheduling-clock interrupt.  After all, the primary purpose of a
	scheduling-clock interrupt is to force a busy CPU to shift its
	attention among multiple duties, and an idle CPU has no duties
	to shift its attention among.

> > +
> > +The CONFIG_NO_HZ=y Kconfig option causes the kernel to avoid sending
> 
> I'm guessing you're keeping those CONFIG_* options in sync with
> Frederic's Kconfig changes...

I am trying to, but probably failing.  But that is OK, as I suspect
that there are more changes on the way.  ;-)

> > +scheduling-clock interrupts to idle CPUs, which is critically important
> > +both to battery-powered devices and to highly virtualized mainframes.
> > +A battery-powered device running a CONFIG_NO_HZ=n kernel would drain
> > +its battery very quickly, easily 2-3x as fast as would the same device
> 
> let's write it out:
> 			 " ... easily 2-3 times as fast..."

OK, done.

> > +running a CONFIG_NO_HZ=y kernel.  A mainframe running 1,500 OS instances
> > +might find that half of its CPU time was consumed by scheduling-clock
> > +interrupts.  In these situations, there is strong motivation to avoid
> > +sending scheduling-clock interrupts to idle CPUs.  That said, dyntick-idle
> 
> I hate "that said" :-)

Interesting.  What don't you like about it?

> 						      However, dyntick-idle mode
> 						      doesn't come for free:
> 
> > +mode is not free:
> > +
> > +1.	It increases the number of instructions executed on the path
> > +	to and from the idle loop.
> > +
> > +2.	Many architectures will place dyntick-idle CPUs into deep sleep
> > +	states, which further degrades from-idle transition latencies.
> 
> Above you say "to and from the idle loop", now it is from-idle. Simply say:
> 
> "... which further degrades idle transision latencies" which means both :).

If people speak for this item, I will update it.  Arjan suggested removing
it entirely.

> > +
> > +Therefore, systems with aggressive real-time response constraints
> > +often run CONFIG_NO_HZ=n kernels in order to avoid degrading from-idle
> > +transition latencies.
> > +
> > +An idle CPU that is not receiving scheduling-clock interrupts is said to
> > +be "dyntick-idle", "in dyntick-idle mode", "in nohz mode", or "running
> > +tickless".  The remainder of this document will use "dyntick-idle mode".
> 
> Very good terminology sort-out. :)

Glad you like it.  ;-)

> > +
> > +There is also a boot parameter "nohz=" that can be used to disable
> > +dyntick-idle mode in CONFIG_NO_HZ=y kernels by specifying "nohz=off".
> > +By default, CONFIG_NO_HZ=y kernels boot with "nohz=on", enabling
> > +dyntick-idle mode.
> > +
> > +
> > +CPUs WITH ONLY ONE RUNNABLE TASK
> > +
> > +If a CPU has only one runnable task, there is again little point in
> > +sending it a scheduling-clock interrupt because there is nowhere else
> > +for a CPU with but one runnable task to shift its attention to.
> 
> Simplify:
> 
> "For a very similar reason, there's little point in sending
> scheduling-clock interrupts to a CPU with a single runnable task because
> there's no other task to switch to."

The original was a bit contorted.  How about the following?

	If a CPU has only one runnable task, there is little point in
	sending it a scheduling-clock interrupt because there is no
	other task to switch to.

> > +
> > +The CONFIG_NO_HZ_EXTENDED=y Kconfig option causes the kernel to avoid
> > +sending scheduling-clock interrupts to CPUs with a single runnable task,
> > +and such CPUs are said to be "adaptive-ticks CPUs".  This is important
> > +for applications with aggressive real-time response constraints because
> > +it allows them to improve their worst-case response times by the maximum
> > +duration of a scheduling-clock interrupt.  It is also important for
> > +computationally intensive iterative workloads with short iterations:  If
> 
> "iterative" twice. Maybe:
> 
> "computationally-intensive, short-iteration workloads"?

Good point, updated as suggested.

> Also, s/If/if/

No, the word following colon is capitalized.

> > +any CPU is delayed during a given iteration, all the other CPUs will be
> > +forced to wait idle while the delayed CPU finished.  Thus, the delay is
> > +multiplied by one less than the number of CPUs.  In these situations,
> > +there is again strong motivation to avoid sending scheduling-clock
> > +interrupts.
> > +
> > +The "nohz_extended=" boot parameter specifies which CPUs are to be
> > +adaptive-ticks CPUs.  For example, "nohz_extended=1,6-8" says that CPUs
> > +1, 6, 7, and 8 are to be adaptive-ticks CPUs.  By default, no CPUs will
> > +be adaptive-ticks CPUs.
> 
> Let's put that last sentence above at the beginning of the paragraph.

Good point, done.

> > Note that you are prohibited from marking all
> > +of the CPUs as adaptive-tick CPUs:  At least one non-adaptive-tick CPU
> > +must remain online to handle timekeeping tasks in order to ensure that
> > +gettimeofday() returns sane values on adaptive-tick CPUs.
> 
> "... gettimeofday(), for example, ..."

How about "system calls like gettimeofday()"?

> > +
> > +Transitioning to kernel mode does not automatically force that CPU out
> > +of adaptive-ticks mode.  The CPU will exit adaptive-ticks mode only if
> > +needed, for example, if that CPU enqueues an RCU callback.
> 
> This paragraph sounds funny, let's flip it:
> 
> Normally, a CPU remains in adaptive-ticks mode as long as possible.
> Transitioning into the kernel doesn't automatically force it out of
> said mode. One possible exit, though, is when this CPU enqueues an RCU
> callback.

Good point -- how about the following?

	Normally, a CPU remains in adaptive-ticks mode as long as
	possible.  In particular, transitioning to kernel mode does
	not automatically change the mode.  Instead, the CPU will exit
	adaptive-ticks mode only if needed, for example, if that CPU
	enqueues an RCU callback.

> > +
> > +Just as with dyntick-idle mode, the benefits of adaptive-tick mode do
> > +not come for free:
> > +
> > +1.	CONFIG_NO_HZ_EXTENDED depends on CONFIG_NO_HZ, so you cannot run
> > +	adaptive ticks without also running dyntick idle.  This dependency
> > +	of CONFIG_NO_HZ_EXTENDED on CONFIG_NO_HZ extends down into the
> > +	implementation.  Therefore, all of the costs of CONFIG_NO_HZ
> > +	are also incurred by CONFIG_NO_HZ_EXTENDED.
> 
> "... are also transitively incurred by CONFIG_NO_HZ_EXTENDED."

Not sure that adding "transitively" helps here.

> Q: are we talking the same costs here or magnified costs due to the
> NO_HZ_EXTENDED addition?

The same costs, from what I can see.

> > +2.	The user/kernel transitions are slightly more expensive due
> > +	to the need to inform kernel subsystems (such as RCU) about
> > +	the change in mode.
> 
> Ah, here it is, NO_HZ_EXTENDED is more expensive than NO_HZ?

In theory, yes.  In practice, it might or might not be measurable.

> > +3.	POSIX CPU timers on adaptive-tick CPUs may fire late (or even
> 
> 					 "... may miss their deadline..."?

Good point, changed.  (And I will need to update this list as well.)

> > +	not at all) because they currently rely on scheduling-tick
> > +	interrupts.  This will likely be fixed in one of two ways: (1)
> > +	Prevent CPUs with POSIX CPU timers from entering adaptive-tick
> > +	mode, or (2) Use hrtimers or other adaptive-ticks-immune mechanism
> > +	to cause the POSIX CPU timer to fire properly.
> > +
> > +4.	If there are more perf events pending than the hardware can
> > +	accommodate, they are normally round-robined so as to collect
> > +	all of them over time.  Adaptive-tick mode may prevent this
> > +	round-robining from happening.  This will likely be fixed by
> > +	preventing CPUs with large numbers of perf events pending from
> > +	entering adaptive-tick mode.
> > +
> > +5.	Scheduler statistics for adaptive-idle CPUs may be computed
> 
> "adaptive-idle"? new term huh?

Good catch!  Changed to "adaptive-tick".

> > +	slightly differently than those for non-adaptive-idle CPUs.
> > +	This may in turn perturb load-balancing of real-time tasks.
> > +
> > +6.	The LB_BIAS scheduler feature is disabled by adaptive ticks.
> > +
> > +Although improvements are expected over time, adaptive ticks is quite
> > +useful for many types of real-time and compute-intensive applications.
> > +However, the drawbacks listed above mean that adaptive ticks should not
> > +(yet) be enabled by default.
> > +
> > +
> > +RCU IMPLICATIONS
> > +
> > +There are situations in which idle CPUs cannot be permitted to
> > +enter either dyntick-idle mode or adaptive-tick mode, the most
> > +familiar being the case where that CPU has RCU callbacks pending.
> 
> "... the common cause being where..."

Good point, I changed "familiar" to "common".

> > +
> > +The CONFIG_RCU_FAST_NO_HZ=y Kconfig option may be used to cause such
> > +CPUs to enter dyntick-idle mode or adaptive-tick mode anyway, though a
> > +timer will awaken these CPUs every four jiffies in order to ensure that
> > +the RCU callbacks are processed in a timely fashion.
> > +
> > +Another approach is to offload RCU callback processing to "rcuo" kthreads
> > +using the CONFIG_RCU_NOCB_CPU=y.  The specific CPUs to offload may be
> 
> 				" ... option."

Good catch, fixed.

> > +selected via several methods:
> > +
> > +1.	One of three mutually exclusive Kconfig options specify a
> > +	build-time default for the CPUs to offload:
> > +
> > +	a.	The RCU_NOCB_CPU_NONE=y Kconfig option results in
> > +		no CPUs being offloaded.
> > +
> > +	b.	The RCU_NOCB_CPU_ZERO=y Kconfig option causes CPU 0 to
> > +		be offloaded.
> > +
> > +	c.	The RCU_NOCB_CPU_ALL=y Kconfig option causes all CPUs
> > +		to be offloaded.  Note that the callbacks will be
> > +		offloaded to "rcuo" kthreads, and that those kthreads
> > +		will in fact run on some CPU.  However, this approach
> > +		gives fine-grained control on exactly which CPUs the
> > +		callbacks run on, the priority that they run at (including
> 
> simpler:
> 
> "... the callbacks will run along with their priority (including..."

Good point.  I reworded as follows:

	 c.	The RCU_NOCB_CPU_ALL=y Kconfig option causes all CPUs
		to be offloaded.  Note that the callbacks will be
		offloaded to "rcuo" kthreads, and that those kthreads
		will in fact run on some CPU.  However, this approach
		gives fine-grained control on exactly which CPUs the
		callbacks run on, along with their scheduling priority
		(including the default of SCHED_OTHER), and it further
		allows this control to be varied dynamically at runtime.

> > +		the default of SCHED_OTHER), and it further allows
> > +		this control to be varied dynamically at runtime.
> > +
> > +2.	The "rcu_nocbs=" kernel boot parameter, which takes a comma-separated
> > +	list of CPUs and CPU ranges, for example, "1,3-5" selects CPUs 1,
> > +	3, 4, and 5.  The specified CPUs will be offloaded in addition
> > +	to any CPUs specified as offloaded by RCU_NOCB_CPU_ZERO or
> > +	RCU_NOCB_CPU_ALL.
> > +
> > +The offloaded CPUs never have RCU callbacks queued, and therefore RCU
> 
> "The offloaded CPUs then do not queue RCU callbacks, ..."

How about this?

	The offloaded CPUs will never queue RCU callbacks, and
	therefore RCU never prevents offloaded CPUs from entering either
	dyntick-idle mode or adaptive-tick mode.  That said, note that
	it is up to userspace to pin the "rcuo" kthreads to specific
	CPUs if desired.  Otherwise, the scheduler will decide where to
	run them, which might or might not be where you want them to run.

> > +never prevents offloaded CPUs from entering either dyntick-idle mode or
> > +adaptive-tick mode.  That said, note that it is up to userspace to
> > +pin the "rcuo" kthreads to specific CPUs if desired.  Otherwise, the
> > +scheduler will decide where to run them, which might or might not be
> > +where you want them to run.
> > +
> > +
> > +KNOWN ISSUES
> > +
> > +o	Dyntick-idle slows transitions to and from idle slightly.
> > +	In practice, this has not been a problem except for the most
> > +	aggressive real-time workloads, which have the option of disabling
> > +	dyntick-idle mode, an option that most of them take.  However,
> > +	some workloads will no doubt want to use adaptive ticks to
> 
> 			   undoubtedly

I like the connotations of "no doubt" in this case.  ;-)

> > +	eliminate scheduling-clock-tick latencies.  Here are some
> 
> scheduling-clock interrupt latencies?

Good, updated.

> > +	options for these workloads:
> > +
> > +	a.	Use PMQOS from userspace to inform the kernel of your
> > +		latency requirements (preferred).
> > +
> > +	b.	On x86 systems, use the "idle=mwait" boot parameter.
> > +
> > +	c.	On x86 systems, use the "intel_idle.max_cstate=" to limit
> > +	`	the maximum depth C-state depth.
> 
> remove first "depth"

Good catch, I must have been out of my depth.

> > +
> > +	d.	On x86 systems, use the "idle=poll" boot parameter.
> > +		However, please note that use of this parameter can cause
> > +		your CPU to overheat, which may cause thermal throttling
> > +		to degrade your latencies -- and that this degradation can
> > +		be even worse than that of dyntick-idle.  Furthermore,
> > +		this parameter effectively disables Turbo Mode on Intel
> > +		CPUs, which can significantly reduce maximum performance.
> > +
> > +o	Adaptive-ticks slows user/kernel transitions slightly.
> > +	This is not expected to be a problem for computational-intensive
> 
> computationally intensive

Good catch, fixed.

> > +	workloads, which have few such transitions.  Careful benchmarking
> > +	will be required to determine whether or not other workloads
> > +	are significantly affected by this effect.
> > +
> > +o	Adaptive-ticks does not do anything unless there is only one
> > +	runnable task for a given CPU, even though there are a number
> > +	of other situations where the scheduling-clock tick is not
> > +	needed.  To give but one example, consider a CPU that has one
> > +	runnable high-priority SCHED_FIFO task and an arbitrary number
> > +	of low-priority SCHED_OTHER tasks.  In this case, the CPU is
> > +	required to run the SCHED_FIFO task until either it blocks or
> 
> 					    until it either blocks

Good, fixed.

> > +	some other higher-priority task awakens on (or is assigned to)
> > +	this CPU, so there is no point in sending a scheduling-clock
> > +	interrupt to this CPU.	However, the current implementation
> > +	prohibits CPU with a single runnable SCHED_FIFO task and multiple
> > +	runnable SCHED_OTHER tasks from entering adaptive-ticks mode,
> > +	even though it would be correct to allow it to do so.
> > +
> > +	Better handling of these sorts of situations is future work.
> > +
> > +o	A reboot is required to reconfigure both adaptive idle and RCU
> > +	callback offloading.  Runtime reconfiguration could be provided
> > +	if needed, however, due to the complexity of reconfiguring RCU
> > +	at runtime, there would need to be an earthshakingly good reason.
> > +	Especially given the option of simply offloading RCU callbacks
> > +	from all CPUs.
> > +
> > +o	Additional configuration is required to deal with other sources
> > +	of OS jitter, including interrupts and system-utility tasks
> > +	and processes.  This configuration normally involves binding
> > +	interrupts and tasks to particular CPUs.
> > +
> > +o	Some sources of OS jitter can currently be eliminated only by
> > +	constraining the workload.  For example, the only way to eliminate
> > +	OS jitter due to global TLB shootdowns is to avoid the unmapping
> > +	operations (such as kernel module unload operations) that result
> > +	in these shootdowns.  For another example, page faults and TLB
> > +	misses can be reduced (and in some cases eliminated) by using
> > +	huge pages and by constraining the amount of memory used by the
> > +	application.
> 
> Good. What about prefaulting the working set of each piece of work?

Fair point.  I added the following sentence:

	Pre-faulting the working set can also be helpful, as can the
	mlock() and mlockall() system calls.

Thank you for the careful review and helpful comments!

							Thanx, Paul

> > +
> > +o	Unless all CPUs are idle, at least one CPU must keep the
> > +	scheduling-clock interrupt going in order to support accurate
> > +	timekeeping.
> > -- 
> > 1.8.1.5
> > 
> > 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

