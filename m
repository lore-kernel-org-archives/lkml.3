Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaDOKwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:52:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaDOKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:52:32 -0400
Date: Tue, 15 Apr 2014 12:52:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140415105226.GP11096@twins.programming.kicks-ass.net>
References: <CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
 <20140411145333.GC3438@localhost.localdomain>
 <20140411151825.GX11096@twins.programming.kicks-ass.net>
 <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
 <20140414110245.GG11096@twins.programming.kicks-ass.net>
 <CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
 <20140414114744.GI11096@twins.programming.kicks-ass.net>
 <CAKohpon=_ZR+QbfacGT+G_atgcc21KMYG3YxPf0nkSDLBH8Q2A@mail.gmail.com>
 <20140414120600.GJ11096@twins.programming.kicks-ass.net>
 <20140415093002.GL1877@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415093002.GL1877@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:30:04AM +0200, Frederic Weisbecker wrote:
> There is probably a few things that assume local calls but last time
> I checked I had the impression that it was fairly possible to call sched_class::task_tick()
> remotely. rq is locked, no reference to "current", use rq accessors...
> 
> OTOH scheduler_tick() itself definetly requires local calls.

possible isn't the problem, its completely insane to do that.
