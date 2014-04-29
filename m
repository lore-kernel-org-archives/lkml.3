Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaD2Iwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:52:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaD2Iwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:52:53 -0400
Date: Tue, 29 Apr 2014 10:52:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140429085236.GO27561@twins.programming.kicks-ass.net>
References: <20140417142213.GA29338@gmail.com>
 <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
 <20140417145418.GM11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
 <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net>
 <20140418171516.GR13658@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:21:34AM -0400, Vince Weaver wrote:
> so it's looking more and more like this issue is with a
> 	PERF_COUNT_SW_TASK_CLOCK
> event.

But they don't actually use the hlist thing..

> It's being deallocated in a different process than it was started (due to 
> fork).
> 
> And it really looks like the problem is even though the event is free'd, 
> there's still an active hrtimer associated with it somehow.

So this is a different problem from the hlist corruption?

> I can't seem to find *why* there's an associated hrtimer though, as the 
> event as far as I can tell was created with sample_period=0 and the 
> various
> 	perf_swevent_init_hrtimer()
> calls seem to guard with is_sampling()

That is indeed, decidedly odd. 

> This is made all the more confusing because the PERF_COUNT_SW_TASK_CLOCK 
> events are handled by their own PMU even though it's faked up so they look 
> like regular software events.  Is there a reason for that?

This was the easiest route when we introduced the mulitple pmu thing or
so, its been on the todo list for a cleanup ever since :-/

