Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab3CYRS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:18:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39348 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3CYRSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:18:55 -0400
Date: Mon, 25 Mar 2013 10:18:44 -0700
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
Message-ID: <20130325171844.GA3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
 <20130324081701.GA13328@gmail.com>
 <CAFTL4hx4FLaRR6i9ap9UrCZY4ikhVtLfUqWSsjTpsO3dvShUjQ@mail.gmail.com>
 <20130325170257.GA24554@linux.vnet.ibm.com>
 <CAFTL4hwRoMGpS823ZD51sw=+AX7_GfroPqz=EspNAtkA86YZ_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hwRoMGpS823ZD51sw=+AX7_GfroPqz=EspNAtkA86YZ_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032517-7408-0000-0000-00000E28FC9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 06:12:12PM +0100, Frederic Weisbecker wrote:
> 2013/3/25 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Sun, Mar 24, 2013 at 03:46:40PM +0100, Frederic Weisbecker wrote:
> >> 2013/3/24 Ingo Molnar <mingo@kernel.org>:
> >> >
> >> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> >
> >> >> Hi Ingo,
> >> >>
> >> >> This settles the initial ground to start a special full dynticks tree in -tip
> >> >> that we can iterate incrementally to accelerate the development.
> >> >> It is based on tip:sched/core.
> >> >>
> >> >> I tried to rearrange a bit the naming. We are probably not yet done with
> >> >> that but I guess we can fix it along with the rest.
> >> >>
> >> >> Please pull from:
> >> >>
> >> >> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> >> >>       full-dynticks-for-mingo
> >> >>
> >> >> Changes on these commits since they were part of 3.9-rc1-nohz1:
> >> >>
> >> >> * Force a timekeeping CPU over the full dynticks range
> >> >> * Rename CONFIG_NO_HZ_FULL to CONFIG_NO_HZ_EXTENDED
> >> >> * Following *_nohz_extended_* APIs renames
> >> >> * Handle CPU hotplug for timekeeping
> >> >> * Rename full_nohz= kernel parameter to nohz_extended=
> >> >
> >> > Note that boot parameters suck for pretty much any purpose but quirks -
> >> > please also add a (default off!) Kconfig option to easily enable
> >> > nohz_extended for all CPUs.
> >> >
> >> > That way I will be able to test it automatically via randconfig and such.
> >>
> >> Sure, I'm adding such an option.
> >
> > Hmmm...  This would be an option to make all but one CPU an adaptive-ticks
> > CPU, right?  If so, this leads to the question of whether I should add a
> > matching no-CBs Kconfig option.  My guess is "no", because the existing
> > CONFIG_RCU_NOCB_CPU_ALL should work just fine -- there would be a CPU that
> > was not an adaptive-ticks CPU, but does have its RCU callbacks offloaded.
> >
> > Or am I missing something here?
> 
> No that looks right. Now I wonder if I should select
> CONFIG_RCU_NOCB_CPU_ALL at the same time. Probably.

Sounds like a good initial position to me.  If it somehow causes problems,
we can always change it later.

							Thanx, Paul

