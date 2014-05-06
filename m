Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbaEFIRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:17:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934235AbaEFIR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:17:29 -0400
Date: Tue, 6 May 2014 10:16:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        linux-man@vger.kernel.org
Subject: Re: sched_{set,get}attr() manpage
Message-ID: <20140506081636.GA4460@twins.programming.kicks-ass.net>
References: <20140214161929.GL27965@twins.programming.kicks-ass.net>
 <53020C9D.1050208@gmail.com>
 <20140428081858.GX13658@twins.programming.kicks-ass.net>
 <535FA467.2070403@gmail.com>
 <20140429160441.GU11096@twins.programming.kicks-ass.net>
 <5360D9E5.9080206@gmail.com>
 <20140430130937.GH30445@twins.programming.kicks-ass.net>
 <20140503124355.5d927080518051ca507bc381@gmail.com>
 <536735E0.7020204@gmail.com>
 <20140505072114.GY11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20140505072114.GY11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 09:21:14AM +0200, Peter Zijlstra wrote:
> On Mon, May 05, 2014 at 08:55:28AM +0200, Michael Kerrisk (man-pages) wro=
te:
> > Hi Peter,
> >=20
> > Looks like a good set of comments from Juri. Could you revise and=20
> > resubmit?
>=20
> Yeah, I'll try and get it done today, but there's a few icky bugs
> waiting for my attention as well, I'll do me bestest :-)

OK, not quite managed it yesterday, but here goes.

So Verbatim license, for the first part to me and whoever I borrowed
sched_setscheduler() bits from.

For the second part to me and Juri.

---

> [1] A page describing the sched_setattr() and sched_getattr() APIs

NAME
	sched_setattr, sched_getattr - set and get scheduling policy/attributes

SYNOPSIS
	#include <sched.h>

	struct sched_attr {
		u32 size;
		u32 sched_policy;
		u64 sched_flags;

		/* SCHED_NORMAL, SCHED_BATCH */
		s32 sched_nice;

		/* SCHED_FIFO, SCHED_RR */
		u32 sched_priority;

		/* SCHED_DEADLINE */
		u64 sched_runtime;
		u64 sched_deadline;
		u64 sched_period;
	};

	int sched_setattr(pid_t pid, const struct sched_attr *attr, unsigned int f=
lags);

	int sched_getattr(pid_t pid, const struct sched_attr *attr, unsigned int s=
ize, unsigned int flags);

DESCRIPTION
	sched_setattr() sets both the scheduling policy and the
	associated attributes for the process whose ID is specified in
	pid.

	sched_setattr() replaces sched_setscheduler(), sched_setparam(),
	nice() and some of setpriority().

	If pid equals zero, the scheduling policy and attributes
	of the calling process will be set.  The interpretation of the
	argument attr depends on the selected policy.  Currently, Linux
	supports the following "normal" (i.e., non-real-time) scheduling
	policies:

	SCHED_OTHER	the standard "fair" time-sharing policy;

	SCHED_BATCH	for "batch" style execution of processes; and

	SCHED_IDLE	for running very low priority background jobs.

	The following "real-time" policies are also supported, for
	special time-critical applications that need precise control
	over the way in which runnable processes are selected for
	execution:

	SCHED_FIFO	a static priority first-in, first-out policy;

	SCHED_RR	a static priority round-robin policy; and

	SCHED_DEADLINE	a dynamic priority deadline policy.

	The semantics of each of these policies are detailed in
	sched(7).

	sched_attr::size must be set to the size of the structure, as in
	sizeof(struct sched_attr), if the provided structure is smaller
	than the kernel structure, any additional fields are assumed
	'0'. If the provided structure is larger than the kernel
	structure, the kernel verifies all additional fields are '0' if
	not the syscall will fail with -E2BIG.

	sched_attr::sched_policy the desired scheduling policy.

	sched_attr::sched_flags additional flags that can influence
	scheduling behaviour. Currently as per Linux kernel 3.14:

		SCHED_FLAG_RESET_ON_FORK - resets the scheduling policy
		to: (struct sched_attr){ .sched_policy =3D SCHED_OTHER, }
		on fork().

	is the only supported flag.

	sched_attr::sched_nice should only be set for SCHED_OTHER,
	SCHED_BATCH, the desired nice value [-20,19], see sched(7).

	sched_attr::sched_priority should only be set for SCHED_FIFO,
	SCHED_RR, the desired static priority [1,99], see sched(7).

	sched_attr::sched_runtime in nanoseconds,
	sched_attr::sched_deadline in nanoseconds,
	sched_attr::sched_period in nanoseconds, should only be set for
	SCHED_DEADLINE and are the traditional sporadic task model
	parameters, see sched(7).

	The flags argument should be 0.

	sched_getattr() queries the scheduling policy currently applied
	to the process identified by pid.

	Similar to sched_setattr(), sched_getattr() replaces
	sched_getscheduler(), sched_getparam() and some of
	getpriority().

	If pid equals zero, the policy of the calling process will be
	retrieved.

	The size argument should reflect the size of struct sched_attr
	as known to userspace. The kernel fills out sched_attr::size to
	the size of its sched_attr structure. If the user provided
	structure is larger, additional fields are not touched. If the
	user provided structure is smaller, but the kernel needs to
	return values outside the provided space, the syscall will fail
	with -E2BIG.

	The flags argument should be 0.

	The other sched_attr fields are filled out as described in
	sched_setattr().

RETURN VALUE
	On success, sched_setattr() and sched_getattr() return 0. On
	error, -1 is returned, and errno is set appropriately.

ERRORS
       EINVAL The scheduling policy is not one  of  the  recognized  polici=
es,
              param is NULL, or param does not make sense for the selected
	      policy.

       EPERM  The calling process does not have appropriate privileges.

       ESRCH  The process whose ID is pid could not be found.

       E2BIG  The provided storage for struct sched_attr is either too
              big, see sched_setattr(), or too small, see sched_getattr().

       EBUSY  SCHED_DEADLINE admission control failure, see sched(7).

NOTES
       While the text above (and in sched_setscheduler(2)) talks about
       processes, in actual fact these system calls are thread specific.

       While the SCHED_DEADLINE parameters are in nanoseconds, current
       kernels truncate the lower 10 bits and we get an effective
       microsecond resolution.

> [2] A piece of text describing the SCHED_DEADLINE policy, which I can
> drop into sched(7).

    SCHED_DEADLINE: Sporadic task model deadline scheduling
       SCHED_DEADLINE is currently implemented using GEDF (Global
       Earliest Deadline First) with additional CBS (Constant Bandwidth
       Server).

       A sporadic task is one that has a sequence of jobs, where each
       job is activated at most once per period. Each job has also a
       relative deadline, before which it should finish execution, and a
       computation time, that is the time necessary for executing the
       job without interruption. The instant of time when a task wakes
       up, because a new job has to be executed, is called arrival time
       (and it is also referred to as request time or release time).
       Start time is instead the time at which a task starts its
       execution. The absolute deadline is thus obtained adding the
       relative deadline to the arrival time.

       The following diagram clarifies these terms:

               arrival/wakeup           absolute deadline
               |        start time          |
               v        v                   v
        -------x--------xoooooooooooo-------x--------x-----
                        |<- comp. ->|
               |<---------- rel. deadline ->|
               |<---------- period ----------------->|

       SCHED_DEADLINE allows the user to specify three parameters (see
       sched_setattr(2)): Runtime [ns], Deadline [ns] and Period [ns].
       Such parameters has not necessarily to correspond to the
       aforementioned terms, while usual practise is to set Runtime to
       something bigger than the average computation time (or worst-case
       execution time for hard real-time tasks), Deadline to the
       relative deadline and Period to the period of the task. With such
       a setting we would have:

               arrival/wakeup           absolute deadline
               |        start time          |
               v        v                   v
        -------x--------xoooooooooooo-------x--------x-----
                        |<- Runtime -->|
               |<---------- Deadline ------>|
               |<---------- Period ----------------->|

       It is checked that: Runtime <=3D Deadline <=3D Period.

       The CBS guarantees non-interference between tasks, by throttling
       tasks that attempt to over-run their specified Runtime.

       In general the set of all SCHED_DEADLINE tasks is not
       feasible/schedulable within the given constraints. To guarantee
       some degree of timeliness we must do an admittance test on
       setting/changing SCHED_DEADLINE policy/attributes.

       This admission test calculates that the task set is
       feasible/schedulable, failing this, sched_setattr() will return
       -EBUSY.

       For example, it is required (but not necessarily sufficient) for
       the total utilization to be less or equal to the total amount of
       CPUs available, where, since each task can maximally run for
       Runtime per Period, that task's utilization is its
       Runtime/Period.

       Because we must be able to calculate admittance SCHED_DEADLINE
       tasks are the highest priority (user controllable) tasks in the
       system, if any SCHED_DEADLINE task is runnable it will preempt
       any FIFO/RR/OTHER/BATCH/IDLE task.

       SCHED_DEADLINE tasks will fail fork(2) with -EAGAIN, except when
       the forking task has SCHED_FLAG_RESET_ON_FORK set.

       A SCHED_DEADLINE task calling sched_yield() will 'yield' the
       current job and wait for a new period to begin.


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaJpdAAoJEHZH4aRLwOS6ydkP/Rj5fYbAf0HdXanpoHk/H5zn
iuoPbhgaS5VX0LV0AnQzUy75jRVZ172slXVgZxVi86XXanMTyu5WVVKdHvy9D8z2
Vu3PmEiOFN6Sefk715CUJpUcD1WaHjuK37weTc4cFIbtSuIeWA7BgmhhPEZwwht5
CYo4YrBsp3hNSJqcAwcrmC8/zfjqHAfBjfHu7n648LAEvI3393M0yr2k5o2njBOv
OzOhe6WAW+xiZMYOvTB9SmeBIawskWN2AdEPu5LagpFCYpYnMWd0vKQXxTR/YwKz
Ym0MM1n2ckrlH7zfISUMXjSxhElenBWBi9z4sjKcEsPV+bRhUHDG6DRsiyJqFHov
8ifTxYAodOlFk+ImW1Rcyb1UeQbmLmYCOtb0R3B+fjd+12vZzu8d3VOsyE9BTHMZ
GDgUGlH4Yb20ht7ILb4+qdky9RQzw1s4BhxbrPKcZsnATbbySpF+3oh7ZU8d7Qwd
zO5zVKo4wEzQFRpL6bKgH2xbBtHi3yyv2RHCFit4RIBDyn8moNnl+30HcVsBkmEo
LWT1cKyZUmnL6OIT1kXyqq+kYb9C0FIUQdCAdderxcm0CK7HM5qlMjk+Mer3j9uO
eqxyo3b4U9czKYb/IY/8eI/dtLE6cmfntfbrxsLt3301lk7h1YVoAomQbE3SSGze
yLLuWr0bs+/XcbzPKp7G
=R87q
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
