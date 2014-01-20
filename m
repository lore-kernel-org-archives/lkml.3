Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaATPlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:41:13 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43944 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:41:10 -0500
Date: Mon, 20 Jan 2014 16:41:01 +0100
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
Message-ID: <20140120154058.GA9436@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
 <CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
 <CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 08:30:10PM +0530, Viresh Kumar wrote:
> On 20 January 2014 19:29, Lei Wen <adrian.wenl@gmail.com> wrote:
> > Hi Viresh,
> 
> Hi Lei,
> 
> > I have one question regarding unbounded workqueue migration in your case.
> > You use hotplug to migrate the unbounded work to other cpus, but its cpu mask
> > would still be 0xf, since cannot be changed by cpuset.
> >
> > My question is how you could prevent this unbounded work migrate back
> > to your isolated cpu?
> > Seems to me there is no such mechanism in kernel, am I understand wrong?
> 
> These workqueues are normally queued back from workqueue handler. And we
> normally queue them on the local cpu, that's the default behavior of workqueue
> subsystem. And so they land up on the same CPU again and again.

But for workqueues having a global affinity, I think they can be rescheduled later
on the old CPUs. Although I'm not sure about that, I'm Cc'ing Tejun.

Also, one of the plan is to extend the sysfs interface of workqueues to override
their affinity. If any of you guys want to try something there, that would be welcome.
Also we want to work on the timer affinity. Perhaps we don't need a user interface
for that, or maybe something on top of full dynticks to outline that we want the unbound
timers to run on housekeeping CPUs only.
