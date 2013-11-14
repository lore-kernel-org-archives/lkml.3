Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3KNPgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:36:09 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37130 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3KNPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:35:59 -0500
Date: Thu, 14 Nov 2013 16:35:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, masami.hiramatsu.pt@hitachi.com
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131114153553.GA4399@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
 <20131114153301.GD5364@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114153301.GD5364@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 04:33:01PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 14, 2013 at 04:23:04PM +0100, Peter Zijlstra wrote:
> >  /*
> > + * We must dis-allow sampling irq_work_exit() because perf event sampling
> > + * itself can cause irq_work, which would lead to an infinite loop;
> > + *
> > + *  1) irq_work_exit happens
> > + *  2) generates perf sample
> > + *  3) generates irq_work
> > + *  4) goto 1
> > + */
> > +TRACE_EVENT_PERF_PERM(irq_work_exit, is_sampling_event(p_event) ? -EPERM : 0);
> 
> And the only reason this doesn't feed fwd itself into oblivion for
> irq_work_enter() is because the irq_work_list must not be empty when the
> interrupt is raised, and queueing further work does not re-raise the
> IPI.

Right.

> 
> 
> Also, we should probably do something 'smart' for kprobes, as all of
> irq_work.c and plenty of perf itself is not __kprobe marked so you're
> all free to insert kprobes in the middle of perf and then attach perf to
> such a thing.
> 

True, ok I'm going to comment about that on your patch.
