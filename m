Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab3CYRDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:03:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:32823 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab3CYRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:03:38 -0400
Date: Mon, 25 Mar 2013 10:02:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: Full dynticks base interface
Message-ID: <20130325170257.GA24554@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
 <20130324081701.GA13328@gmail.com>
 <CAFTL4hx4FLaRR6i9ap9UrCZY4ikhVtLfUqWSsjTpsO3dvShUjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hx4FLaRR6i9ap9UrCZY4ikhVtLfUqWSsjTpsO3dvShUjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032517-7408-0000-0000-00000E28C9AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 03:46:40PM +0100, Frederic Weisbecker wrote:
> 2013/3/24 Ingo Molnar <mingo@kernel.org>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> Hi Ingo,
> >>
> >> This settles the initial ground to start a special full dynticks tree in -tip
> >> that we can iterate incrementally to accelerate the development.
> >> It is based on tip:sched/core.
> >>
> >> I tried to rearrange a bit the naming. We are probably not yet done with
> >> that but I guess we can fix it along with the rest.
> >>
> >> Please pull from:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> >>       full-dynticks-for-mingo
> >>
> >> Changes on these commits since they were part of 3.9-rc1-nohz1:
> >>
> >> * Force a timekeeping CPU over the full dynticks range
> >> * Rename CONFIG_NO_HZ_FULL to CONFIG_NO_HZ_EXTENDED
> >> * Following *_nohz_extended_* APIs renames
> >> * Handle CPU hotplug for timekeeping
> >> * Rename full_nohz= kernel parameter to nohz_extended=
> >
> > Note that boot parameters suck for pretty much any purpose but quirks -
> > please also add a (default off!) Kconfig option to easily enable
> > nohz_extended for all CPUs.
> >
> > That way I will be able to test it automatically via randconfig and such.
> 
> Sure, I'm adding such an option.

Hmmm...  This would be an option to make all but one CPU an adaptive-ticks
CPU, right?  If so, this leads to the question of whether I should add a
matching no-CBs Kconfig option.  My guess is "no", because the existing
CONFIG_RCU_NOCB_CPU_ALL should work just fine -- there would be a CPU that
was not an adaptive-ticks CPU, but does have its RCU callbacks offloaded.

Or am I missing something here?

							Thanx, Paul

> > My next question/request after that would be: could we make sure that
> > enabling this option does not break any applications or kernel
> > functionality, ASAP? Once that is offered, it becomes pushable to v3.10 I
> > think.
> 
> So that's already the case. I'm careful that, as we iterate, the
> changes aren't supposed to break something in the middle. the final
> code that eventually shuts the tick down should be the last one in the
> series: once we know it is safe to do so.
> 
> >
> > Meanwhile I have pulled your tree into tip:sched/nohz to stage and test
> > it, in the hope that it becomes mergable quickly! :-)
> 
> Thanks! :)
> 

