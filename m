Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaAWNyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:54:37 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45032 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaAWNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:54:35 -0500
Date: Thu, 23 Jan 2014 14:54:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
Message-ID: <20140123135430.GB13345@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
 <CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
 <CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
 <20140120154058.GA9436@localhost.localdomain>
 <CALZhoSTzGH+mAB-Om=3dQTgQJriDmH+is_DEAzWNN7rRpzNFuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSTzGH+mAB-Om=3dQTgQJriDmH+is_DEAzWNN7rRpzNFuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:07:58AM +0800, Lei Wen wrote:
> On Mon, Jan 20, 2014 at 11:41 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > On Mon, Jan 20, 2014 at 08:30:10PM +0530, Viresh Kumar wrote:
> >> On 20 January 2014 19:29, Lei Wen <adrian.wenl@gmail.com> wrote:
> >> > Hi Viresh,
> >>
> >> Hi Lei,
> >>
> >> > I have one question regarding unbounded workqueue migration in your case.
> >> > You use hotplug to migrate the unbounded work to other cpus, but its cpu mask
> >> > would still be 0xf, since cannot be changed by cpuset.
> >> >
> >> > My question is how you could prevent this unbounded work migrate back
> >> > to your isolated cpu?
> >> > Seems to me there is no such mechanism in kernel, am I understand wrong?
> >>
> >> These workqueues are normally queued back from workqueue handler. And we
> >> normally queue them on the local cpu, that's the default behavior of workqueue
> >> subsystem. And so they land up on the same CPU again and again.
> >
> > But for workqueues having a global affinity, I think they can be rescheduled later
> > on the old CPUs. Although I'm not sure about that, I'm Cc'ing Tejun.
> 
> Agree, since worker thread is made as enterring into all cpus, it
> cannot prevent scheduler
> do the migration.
> 
> But here is one point, that I see Viresh alredy set up two cpuset with
> scheduler load balance
> disabled, so it should stop the task migration between those two groups? Since
> the sched_domain changed?
> 
> What is more, I also did  similiar test, and find when I set two such
> cpuset group,
> like core 0-2 to cpuset1, core 3 to cpuset2, while hotunplug the core3
> afterwise.
> I find the cpuset's cpus member becomes NULL even I hotplug the core3
> back again.
> So is it a bug?

Not sure, you may need to check cpuset internals.
