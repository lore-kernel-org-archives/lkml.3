Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaDNLrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:47:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaDNLru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:47:50 -0400
Date: Mon, 14 Apr 2014 13:47:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140414114744.GI11096@twins.programming.kicks-ass.net>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
 <CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
 <20140410143857.GA27654@localhost.localdomain>
 <CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
 <20140411145333.GC3438@localhost.localdomain>
 <20140411151825.GX11096@twins.programming.kicks-ass.net>
 <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
 <20140414110245.GG11096@twins.programming.kicks-ass.net>
 <CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 05:12:08PM +0530, Viresh Kumar wrote:
> On 14 April 2014 16:32, Peter Zijlstra <peterz@infradead.org> wrote:
> > I'm still not sure _what_ you're trying to solve here. What are you
> > doing and why?
> 
> Hi Peter,
> 
> We are working building ARM Networking machines. Networking Data
> plane is handled completely at user space. At run time we may fix
> any number of CPUs for data plane activities. There will be a single
> user space thread per CPU for these data plane packet processing.
> Due to timing constraints these cores can't allow any interruption
> from kernel. These include interruption from:
> 
> - other tasks: Fixed with cpusets
> - timers/hrtimers: Implemented cpuset.quiesce as you suggested:
> Waiting for reviews
> - workqueues: Probably would be fixed by Frederic's work.

Ok.

> - Tick: Even with NO_HZ_FULL we get a tick every second. This is
> what I am trying to address here. Frederic earlier suggested to
> offload this accounting to other CPUs and so was my initial proposal.

What causes this tick? I was under the impression that once there's a
single task (not doing any syscalls) and the above issues are sorted, no
more tick would happen.



