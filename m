Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3KNTJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:09:47 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:60905 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3KNTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:09:38 -0500
Date: Thu, 14 Nov 2013 14:18:01 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
In-Reply-To: <20131114171405.GA2965@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1311141416110.8746@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu> <20131108200244.GB14606@localhost.localdomain> <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain> <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu> <20131108223657.GF14606@localhost.localdomain> <20131109151014.GN16117@laptop.programming.kicks-ass.net> <20131114152304.GC5364@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1311141217470.8746@vincent-weaver-1.um.maine.edu> <20131114171405.GA2965@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013, Peter Zijlstra wrote:

> On Thu, Nov 14, 2013 at 12:20:35PM -0500, Vince Weaver wrote:
> > 
> > possibly not an issue with your patch, but found in nearby code:
> > 
> > in perf_trace_init:
> > 
> >         int event_id = p_event->attr.config;
> > 
> > 	...
> > 
> >                 if (tp_event->event.type == event_id &&
> > 
> > 
> > note that "attr.config" is 64-bit but "event_id" is only 32-bit,
> > so things like 0xffffffff00000018 will map to irq_work_exit.
>
> I will have a look.

Assuming this is a real issue, I'll submit a patch to fix this if I'm not
beaten to it by someone else.

> > I'm not sure if your PERM code properly handles this case, I don't have 
> > time to work through the macro-magic in your patch.
> 
> Can't blame you; took me a fair chunk of the day to come up with this.
> That trace event stuff is horrid.

I did some tests both with the high bits set and non-set and wasn't able 
to trigger the bug.  Also ran the fuzzer for a while and while it keeps 
finding other bugs, it hasn't tripped over any that were overtly 
tracepoint related. So you can add my

Tested-by: Vince Weaver <vincent.weaver@maine.edu>

Vince
