Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaBTRny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:43:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:62896 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752111AbaBTRnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:43:53 -0500
Date: Thu, 20 Feb 2014 12:43:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220124351.7f920c08@gandalf.local.home>
In-Reply-To: <20140220170018.GJ9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
	<20140217152859.GF15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
	<20140219101949.GG15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
	<20140220100830.GN6835@laptop.programming.kicks-ass.net>
	<20140220112600.2f44874d@gandalf.local.home>
	<20140220170018.GJ9987@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 18:00:18 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Feb 20, 2014 at 11:26:00AM -0500, Steven Rostedt wrote:
> > On Thu, 20 Feb 2014 11:08:30 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > @rostedt: WTF is disable_trace_on_warning a boot option only?
> > 
> > Laziness.
> > 
> > 
> > I'll add a sysctl for it in 3.15.
> 
> /debug/tracing/options/ was where I was looking first.
> 
> Its a bit weird to have half the options in options/ and the other half
> as sysctl in /proc/sys/kernel/

Yeah, that is somewhat strange.  The /proc/sys/kernel/ ftrace options
is somewhat historical. Things that were more about how ftrace works
outside of the tracing word exists there. For example,
ftrace_dump_on_oops is there, because it is about modifying the way the
kernel works on crash and not how ftrace works.

This is something similar, it's about how the kernel works, not how
ftrace works. I try to have the debugfs options be ways to modify how
ftrace works, like formatting, what it prints, etc. But things that
modify the way the kernel work, I like to keep in /proc/sys/kernel.
That is, ftrace_dump_on_oops is what happens on kernel crash,
stack_tracer_enabled is something on the boarder. That is, it should
probably have been in the tracing facility, as it is similar to
something like the irqsoff tracer. But as it wasn't to be a tracer in
itself, it was added to proc.

The ftrace_enabled, is a big on off switch to enable or disable ALL
function tracing. Even for perf and friends. I added a trace option
"function-trace" that will just disable function tracing for ftrace and
not affect other users of function tracing.

As a disable_trace_on_warning is more of a modification to the kernel,
I'm leaning to adding a /proc/sys/kernel/ftrace_disable_on_warning
file. This keeps it in line with ftrace_dump_on_oops, which is the most
similar feature.

-- Steve


