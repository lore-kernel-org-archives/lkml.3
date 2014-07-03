Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbaGCOwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:52:18 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39243 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897AbaGCOwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:52:13 -0400
Date: Thu, 3 Jul 2014 16:52:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
Message-ID: <20140703145201.GB9520@localhost.localdomain>
References: <20140625051234.GD6758@twins.programming.kicks-ass.net>
 <20140625051721.GG3588@twins.programming.kicks-ass.net>
 <53AA6E11.1000404@linux.vnet.ibm.com>
 <20140625093657.GN19860@laptop.programming.kicks-ass.net>
 <20140625093944.GV16155@laptop.programming.kicks-ass.net>
 <53AA9B68.4050104@linux.vnet.ibm.com>
 <53AA9C43.3020903@linux.vnet.ibm.com>
 <20140625101915.GO19860@laptop.programming.kicks-ass.net>
 <53AAF779.8060006@wwwdotorg.org>
 <20140625163820.GC3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625163820.GC3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:38:20PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 25, 2014 at 10:23:21AM -0600, Stephen Warren wrote:
> > On 06/25/2014 04:19 AM, Peter Zijlstra wrote:
> > > On Wed, Jun 25, 2014 at 03:24:11PM +0530, Srivatsa S. Bhat wrote:
> > >> Wait, that was a stupid idea. hotplug_cfd() already invokes irq_work_run
> > >> indirectly via flush_smp_call_function_queue(). So irq_work_cpu_notify()
> > >> doesn't need to invoke it again, AFAIU. So perhaps we can get rid of
> > >> irq_work_cpu_notify() altogether?
> > > 
> > > Just so...
> > > 
> > > getting up at 6am and sitting in an airport terminal doesn't seem to
> > > agree with me; any more silly fail here?
> > > 
> > > ---
> > > Subject: irq_work: Remove BUG_ON in irq_work_run()
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > Date: Wed Jun 25 07:13:07 CEST 2014
> > > 
> > > Because of a collision with 8d056c48e486 ("CPU hotplug, smp: flush any
> > > pending IPI callbacks before CPU offline"), which ends up calling
> > > hotplug_cfd()->flush_smp_call_function_queue()->irq_work_run(), which
> > > is not from IRQ context.
> > > 
> > > And since that already calls irq_work_run() from the hotplug path,
> > > remove our entire hotplug handling.
> > 
> > Tested-by: Stephen Warren <swarren@nvidia.com>
> > 
> > [with the s/static// already mentioned in this thread, obviously:-)]
> 
> Right; I pushed out a fixed version right before loosing my tubes at the
> airport :-)
> 
> https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/commit/?h=timers/nohz&id=921d8b81281ecdca686369f52165d04fa3505bd7
> 
> I've not gotten wu build bot spam on it so it must be good ;-)
> 
> In any case, I'll add your tested-by and update later this evening.

Ack! Thanks for fixing this.

In case you're AFK, do you need any help for pushing the patch or so?
