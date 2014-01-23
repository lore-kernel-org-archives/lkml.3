Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaAWOBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:01:24 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:61590 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaAWOBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:01:23 -0500
Date: Thu, 23 Jan 2014 15:01:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lei Wen <adrian.wenl@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
Message-ID: <20140123140118.GC13345@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
 <CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
 <CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
 <20140120154058.GA9436@localhost.localdomain>
 <CAKohpon=VagQfYauMfb-UH7MQCHATO5i0xDL1_3r=zzpJ4w9zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpon=VagQfYauMfb-UH7MQCHATO5i0xDL1_3r=zzpJ4w9zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:19:36PM +0530, Viresh Kumar wrote:
> On 20 January 2014 21:11, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > But for workqueues having a global affinity, I think they can be rescheduled later
> > on the old CPUs. Although I'm not sure about that, I'm Cc'ing Tejun.
> 
> Works queued on workqueues with WQ_UNBOUND flag set are run on any cpu
> and is decided by scheduler, whereas works queued on workqueues with this
> flag not set and without a cpu number mentioned while queuing work,
> runs on local
> CPU always.

Ok, so it is fine to migrate the latter kind I guess?

> 
> > Also, one of the plan is to extend the sysfs interface of workqueues to override
> > their affinity. If any of you guys want to try something there, that would be welcome.
> > Also we want to work on the timer affinity. Perhaps we don't need a user interface
> > for that, or maybe something on top of full dynticks to outline that we want the unbound
> > timers to run on housekeeping CPUs only.
> 
> What about a quiesce option as mentioned by PeterZ? With that we can move
> all UNBOUND timers and workqueues away. But to guarantee that we don't get
> them queued again later we need to make similar updates in workqueue/timer
> subsystem to disallow queuing any such stuff on such cpusets.

I haven't checked the details but then this quiesce option would involve
a dependency on cpuset for any workload involving workqueues affinity. I'm
not sure we really want this. Besides, workqueues have an existing sysfs interface
that can be easily extended.

Now indeed we may also want to enforce some policy to make sure that further
created and queued workqueues are affine to a specific subset of CPUs. And then
cpuset sounds like a good idea :)
