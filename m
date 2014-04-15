Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaDOJaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:30:12 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35335 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaDOJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:30:07 -0400
Date: Tue, 15 Apr 2014 11:30:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140415093002.GL1877@localhost.localdomain>
References: <20140410143857.GA27654@localhost.localdomain>
 <CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
 <20140411145333.GC3438@localhost.localdomain>
 <20140411151825.GX11096@twins.programming.kicks-ass.net>
 <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
 <20140414110245.GG11096@twins.programming.kicks-ass.net>
 <CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
 <20140414114744.GI11096@twins.programming.kicks-ass.net>
 <CAKohpon=_ZR+QbfacGT+G_atgcc21KMYG3YxPf0nkSDLBH8Q2A@mail.gmail.com>
 <20140414120600.GJ11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414120600.GJ11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 02:06:00PM +0200, Peter Zijlstra wrote:
> On Mon, Apr 14, 2014 at 05:22:30PM +0530, Viresh Kumar wrote:
> > On 14 April 2014 17:17, Peter Zijlstra <peterz@infradead.org> wrote:
> > > What causes this tick? I was under the impression that once there's a
> > > single task (not doing any syscalls) and the above issues are sorted, no
> > > more tick would happen.
> > 
> > This is what Frederic told me earlier:
> > 
> > https://lkml.org/lkml/2014/2/13/238
> 
> That's a bit of a non-answer. I'm fairly sure its not a gazillion
> issues, since the actual scheduler tick doesn't actually do that much.
> 
> So start by enumerating what is actually required.

Ok, I'm a bit buzy with a conference right now but I'm going to summarize that
soonish.

> 
> The 2), which I suppose you're now trying to implement is I think
> entirely the wrong way. The tick really assumes it runs local, moving it
> to another CPU is insane.

There is probably a few things that assume local calls but last time
I checked I had the impression that it was fairly possible to call sched_class::task_tick()
remotely. rq is locked, no reference to "current", use rq accessors...

OTOH scheduler_tick() itself definetly requires local calls.
