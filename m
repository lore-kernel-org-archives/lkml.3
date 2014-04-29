Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971AbaD2SHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:07:44 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52931 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064AbaD2SHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:07:40 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 29 Apr 2014 14:11:09 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140429085236.GO27561@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404291407180.22490@vincent-weaver-1.umelst.maine.edu>
References: <20140417142213.GA29338@gmail.com> <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
 <20140418152314.GY11182@twins.programming.kicks-ass.net> <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <20140429085236.GO27561@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Peter Zijlstra wrote:

> On Mon, Apr 28, 2014 at 10:21:34AM -0400, Vince Weaver wrote:
> > so it's looking more and more like this issue is with a
> > 	PERF_COUNT_SW_TASK_CLOCK
> > event.
> 
> But they don't actually use the hlist thing..

yes.

This turns out into another issue that I think is just use-after-free 
memory corruption exhibiting itself a different way.

I've documented at least 8 different types of error message that I think 
are all due to this issue.

> So this is a different problem from the hlist corruption?

Who knows.  That's why I'm trying to get this issue fixed so I can figure 
out which of the 10+ other bugs I'm tracking are the same or different.

> > This is made all the more confusing because the PERF_COUNT_SW_TASK_CLOCK 
> > events are handled by their own PMU even though it's faked up so they look 
> > like regular software events.  Is there a reason for that?
> 
> This was the easiest route when we introduced the mulitple pmu thing or
> so, its been on the todo list for a cleanup ever since :-/

It was very confusing and poorly documented, as is much of the perf_event 
files.  And yes, I know, I should do something about it rather than 
complain.

I've actually given up on source code inspection to figure out what's 
going on in kernel/events/core.c.  What I do now is write simple test
cases and do an ftrace function trace.  The results are often surprising.

Vince
