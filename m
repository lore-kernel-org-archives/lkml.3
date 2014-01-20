Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaATNSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:18:10 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36778 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaATNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:18:07 -0500
Date: Mon, 20 Jan 2014 14:16:17 +0100
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com, rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140120131616.GB8907@austad.us>
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
 <20140120112442.GA8907@austad.us>
 <52DD1377.5090201@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <52DD1377.5090201@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2014 at 01:15:51PM +0100, Juri Lelli wrote:
> On 01/20/2014 12:24 PM, Henrik Austad wrote:
> > On Mon, Jan 20, 2014 at 11:40:40AM +0100, Juri Lelli wrote:
> >> From: Dario Faggioli <raistlin@linux.it>
> >>
> >> Add in Documentation/scheduler/ some hints about the design
> >> choices, the usage and the future possible developments of the
> >> sched_dl scheduling class and of the SCHED_DEADLINE policy.
> >>
> >> Cc: bruce.ashfield@windriver.com
> >> Cc: claudio@evidence.eu.com
> >> Cc: darren@dvhart.com
> >> Cc: dhaval.giani@gmail.com
> >> Cc: fchecconi@gmail.com
> >> Cc: fweisbec@gmail.com
> >> Cc: harald.gustafsson@ericsson.com
> >> Cc: hgu1972@gmail.com
> >> Cc: insop.song@gmail.com
> >> Cc: jkacur@redhat.com
> >> Cc: johan.eker@ericsson.com
> >> Cc: liming.wang@windriver.com
> >> Cc: luca.abeni@unitn.it
> >> Cc: michael@amarulasolutions.com
> >> Cc: mingo@redhat.com
> >> Cc: nicola.manica@disi.unitn.it
> >> Cc: oleg@redhat.com
> >> Cc: paulmck@linux.vnet.ibm.com
> >> Cc: p.faure@akatech.ch
> >> Cc: rob@landley.net
> >> Cc: rostedt@goodmis.org
> >> Cc: tglx@linutronix.de
> >> Cc: tommaso.cucinotta@sssup.it
> >> Cc: vincent.guittot@linaro.org
> >> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> >> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> >> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >> ---
> >>  Documentation/scheduler/00-INDEX           |    2 +
> >>  Documentation/scheduler/sched-deadline.txt |  189 +++++++++++++++++++=
+++++++++
> >>  kernel/sched/deadline.c                    |    3 +-
> >>  3 files changed, 193 insertions(+), 1 deletion(-)
> >>  create mode 100644 Documentation/scheduler/sched-deadline.txt
> >>
> >> diff --git a/Documentation/scheduler/00-INDEX b/Documentation/schedule=
r/00-INDEX
> >> index d2651c4..46702e4 100644
> >> --- a/Documentation/scheduler/00-INDEX
> >> +++ b/Documentation/scheduler/00-INDEX
> >> @@ -10,5 +10,7 @@ sched-nice-design.txt
> >>  	- How and why the scheduler's nice levels are implemented.
> >>  sched-rt-group.txt
> >>  	- real-time group scheduling.
> >> +sched-deadline.txt
> >> +	- deadline scheduling.
> >>  sched-stats.txt
> >>  	- information on schedstats (Linux Scheduler Statistics).
> >> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentatio=
n/scheduler/sched-deadline.txt
> >> new file mode 100644
> >> index 0000000..8980de1
> >> --- /dev/null
> >> +++ b/Documentation/scheduler/sched-deadline.txt
> >> @@ -0,0 +1,189 @@
> >> +			  Deadline Task Scheduling
> >> +			  ------------------------
> >> +
> >> +CONTENTS
> >> +=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> + 0. WARNING
> >> + 1. Overview
> >> + 2. Task scheduling
> >> + 2. The Interface
> >> + 3. Bandwidth management
> >> +   3.1 System-wide settings
> >> +   3.2 Task interface
> >> +   3.4 Default behavior
> >> + 4. Tasks CPU affinity
> >> +   4.1 SCHED_DEADLINE and cpusets HOWTO
> >> + 5. Future plans
> >> +
> >> +
> >> +0. WARNING
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> + Fiddling with these settings can result in an unpredictable or even =
unstable
> >> + system behavior. As for -rt (group) scheduling, it is assumed that r=
oot users
> >> + know what they're doing.
> >> +
> >> +
> >> +1. Overview
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> + The SCHED_DEADLINE policy contained inside the sched_dl scheduling c=
lass is
> >> + basically an implementation of the Earliest Deadline First (EDF) sch=
eduling
> >> + algorithm, augmented with a mechanism (called Constant Bandwidth Ser=
ver, CBS)
> >> + that makes it possible to isolate the behavior of tasks between each=
 other.
> >=20
> >=20
> > Why not something along the lines of giving a task a guaranteed slice o=
f=20
> > the CPU as well as making sure that a task takes no more than a given=
=20
> > slice? I.e. making the point of a lower as well as an upper limit of CP=
U=20
> > usage.
> >=20
>=20
> I'd keep the term "isolate" in, as is one of the strong points on having =
all
> this merged in. But, we could add something along the lines you suggested:
>=20
> "that makes it possible to isolate the behavior of tasks between each oth=
er.
> IOW, isolation means that we can reserve a task a guaranteed percentage o=
f the
> CPU and, at the same time, we ensure that the task takes no more than the
> percentage reserved."

+1 from me!

> >> +2. Task scheduling
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> + The typical -deadline task is composed of a computation phase (insta=
nce)
> >> + which is activated on a periodic or sporadic fashion. The expected (=
maximum)
> >> + duration of such computation is called the task's runtime; the time =
interval
> >> + by which each instance needs to be completed is called the task's re=
lative
> >> + deadline. The task's absolute deadline is dynamically calculated as =
the
> >> + time instant a task (or, more properly) activates plus the relative
> >> + deadline.
> >=20
> > activates - released?
> >=20
>=20
> I'd keep (modifying a bit):
>=20
> "time instant a task activates plus the relative deadline."
>=20
> This is probably the nearest thing to what is implemented that we can say
> (without entering into the theory too much), a task that "activates" can =
mean
> that it is first released, enqueued, woken-up, etc.

So, if we look at release (yes, I'm avoiding activates for a little while)=
=20
as the time at the *beginning* of a new period, then, and only then should=
=20
the *absolute* deadline be computed.

If you den move on to use 'activate' as a term for when a task becomes=20
eligble to run, then 'release' becomes a subset of 'activate', and you=20
should only compute the absolute deadline at that time. Did that make=20
sense?

> > Since real-time papers from different rt-campus around the academia ins=
ist=20
> > on using *slightly* different terminology, perhaps add a short dictiona=
ry=20
> > for some of the more common terms?
> >=20
> > D: relative deadline, typically N ms after release
> > d: absolute deadline, the physical time when a given instance of a job=
=20
> >    needs to be completed
> > R: relative release time, for periodic tasks, this is typically 'every =
N=20
> >    ms'
> > r: absolute release time
> > C: Worst-case execution time
> >=20
> >    ...you get the idea.
> >=20
> > Perhaps too academic?
> >=20
>=20
> Mmm.. we don't go too deep in theory (we just refer to papers below), cou=
ld
> adding a dictionary only complicate things? I mean, if you add a term you=
 have
> to explain its meaning related to the task-model you are using. And this =
means
> you have to also define the task model and so on. Who wants more details
> already finds them in the papers below.

Honestly, how many readers of sched_deadline.txt are going to read those=20
papers to have the terms defined?

Either way, having a *short* list of terms we use _in_ sched_deadline would=
=20
help avoiding confusion. For instance, what 'activate' actually means.

> >> + The EDF[1] algorithm selects the task with the smallest absolute dea=
dline as
> >> + the one to be executed first, while the CBS[2,3] ensures that each t=
ask runs
> >> + for at most its runtime every period, avoiding any interference betw=
een
> >> + different tasks (bandwidth isolation).
> >> + Thanks to this feature, also tasks that do not strictly comply with =
the
> >> + computational model described above can effectively use the new poli=
cy.
> >> + IOW, there are no limitations on what kind of task can exploit this =
new
> >> + scheduling discipline, even if it must be said that it is particular=
ly
> >> + suited for periodic or sporadic tasks that need guarantees on their
> >> + timing behavior, e.g., multimedia, streaming, control applications, =
etc.
> >=20
> > I assume that ties are broken arbitrarily and that a running task is no=
t=20
> > preempted for another task with equal deadline. Correct?
> >=20
>=20
> Yes.
>=20
> > This would be a nice point to include in this doc methinks.

how about adding something like that?

"""
Whenever 2 (or more) tasks happen to have the exact same absolute deadine,=
=20
ties are broken arbitrarily. One notable exception occur when one of the=20
tasks are already running, in which case no preemption occurs.
"""

> >> + References:
> >> +  1 - C. L. Liu and J. W. Layland. Scheduling algorithms for multipro=
gram-
> >> +      ming in a hard-real-time environment. Journal of the Associatio=
n for
> >> +      Computing Machinery, 20(1), 1973.
> >> +  2 - L. Abeni , G. Buttazzo. Integrating Multimedia Applications in =
Hard
> >> +      Real-Time Systems. Proceedings of the 19th IEEE Real-time Syste=
ms
> >> +      Symposium, 1998. http://retis.sssup.it/~giorgio/paps/1998/rtss9=
8-cbs.pdf
> >> +  3 - L. Abeni. Server Mechanisms for Multimedia Applications. ReTiS =
Lab
> >> +      Technical Report. http://xoomer.virgilio.it/lucabe72/pubs/tr-98=
-01.ps
> >> +
> >> +3. Bandwidth management
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> + In order for the -deadline scheduling to be effective and useful, it=
 is
> >> + important to have some method to keep the allocation of the availabl=
e CPU
> >> + bandwidth to the tasks under control.
> >> + This is usually called "admission control" and if it is not performe=
d at all,
> >> + no guarantee can be given on the actual scheduling of the -deadline =
tasks.
> >> +
> >> + Since when RT-throttling has been introduced each task group has a b=
andwidth
> >> + associated, calculated as a certain amount of runtime over a period.
> >> + Moreover, to make it possible to manipulate such bandwidth, readable=
/writable
> >> + controls have been added to both procfs (for system wide settings) a=
nd cgroupfs
> >> + (for per-group settings).
> >> + Therefore, the same interface is being used for controlling the band=
width
> >> + distrubution to -deadline tasks.
> >> +
> >> + However, more discussion is needed in order to figure out how we wan=
t to manage
> >> + SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_D=
EADLINE
> >> + uses (for now) a less sophisticated, but actually very sensible, mec=
hanism to
> >> + ensure that a certain utilization cap is not overcome per each root_=
domain.
> >> +
> >> + Another main difference between deadline bandwidth management and RT=
-throttling
> >> + is that -deadline tasks have bandwidth on their own (while -rt ones =
don't!),
> >> + and thus we don't need an higher level throttling mechanism to enfor=
ce the
> >> + desired bandwidth.
> >> +
> >> +3.1 System wide settings
> >> +------------------------
> >> +
> >> + The system wide settings are configured under the /proc virtual file=
 system.
> >> +
> >> + For now the -rt knobs are used for dl admission control and the -dea=
dline
> >> + runtime is accounted against the -rt runtime. We realise that this i=
sn't
> >> + entirely desirable; however, it is better to have a small interface =
for now,
> >> + and be able to change it easily later. The ideal situation (see 5.) =
is to run
> >> + -rt tasks from a -deadline server; in which case the -rt bandwidth i=
s a direct
> >> + subset of dl_bw.
> >> +
> >> + This means that, for a root_domain comprising M CPUs, -deadline tasks
> >> + can be created while the sum of their bandwidths stays below:
> >> +
> >> +   M * (sched_rt_runtime_us / sched_rt_period_us)
> >> +
> >> + It is also possible to disable this bandwidth management logic, and
> >> + be thus free of oversubscribing the system up to any arbitrary level.
> >> + This is done by writing -1 in /proc/sys/kernel/sched_rt_runtime_us.
> >> +
> >> +
> >> +3.2 Task interface
> >> +------------------
> >> +
> >> + Specifying a periodic/sporadic task that executes for a given amount=
 of
> >> + runtime at each instance, and that is scheduled according to the urg=
ency of
> >> + its own timing constraints needs, in general, a way of declaring:
> >> +  - a (maximum/typical) instance execution time,
> >> +  - a minimum interval between consecutive instances,
> >> +  - a time constraint by which each instance must be completed.
> >> +
> >> + Therefore:
> >> +  * a new struct sched_attr, containing all the necessary fields is
> >> +    provided;
> >> +  * the new scheduling related syscalls that manipulate it, i.e.,
> >> +    sched_setattr() and sched_getattr() are implemented.
> >> +
> >> +
> >> +3.3 Default behavior
> >> +---------------------
> >> +
> >> + The default value for SCHED_DEADLINE bandwidth is to have rt_runtime=
 equal to
> >> + 95000. With rt_period equal to 1000000, by default, it means that -d=
eadline
> >     ^^^^
> >     This seems to be 9.5% to me ;)
> >=20
>=20
> Argh! s/95000/950000/
>=20
> >> + tasks can use at most 95%, multiplied by the number of CPUs that com=
pose the
> >> + root_domain, for each root_domain.
> >> +
> >> + A -deadline task cannot fork.
> >> +
> >> +4. Tasks CPU affinity
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> + -deadline tasks cannot have an affinity mask smaller that the entire
> >> + root_domain they are created on. However, affinities can be specified
> >> + through the cpuset facility (Documentation/cgroups/cpusets.txt).
> >=20
> > Does this mean that sched_deadline is a somewhat global implementation?=
 Or=20
> > rather, at what point in time will sched_deadline take all cpus in a se=
t=20
> > into consideration and when will it only look at the current CPU? Where=
 is=20
> > the line drawn between global and fully partitioned?
> >=20
> > Also, how do you account the budget when a resource holder is boosted i=
n=20
> > order to release a resource? (IIRC, you use BWI, right?)
> >=20
>=20
> Peter already replied about this.
>=20
> Thanks,
>=20
> - Juri

Feel free to add a reviewed-by from me on this one :)

--=20
Henrik Austad

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLdIaAACgkQ6k5VT6v45lk5bACgp/pYVja9drnKilSXV6KmnnUP
TngAn2CwlI5t/8foUmIE5VnD0A4U343n
=xMdI
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
