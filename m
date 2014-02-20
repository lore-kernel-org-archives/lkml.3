Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaBTSPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:15:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42082 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaBTSPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:15:52 -0500
Date: Thu, 20 Feb 2014 19:15:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220181538.GK9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
 <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
 <20140219101949.GG15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
 <20140220100830.GN6835@laptop.programming.kicks-ass.net>
 <87r46xdbw4.fsf@tassilo.jf.intel.com>
 <20140220155416.GH9987@twins.programming.kicks-ass.net>
 <87mwhld72w.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwhld72w.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 09:31:19AM -0800, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> >
> > It will; trace_printk() works without -pg, I think you didn't read the
> > instructions very well.
> 
> Ok, you enable and disable it again.  I won't guess why you do that.

To grow the trace buffers; it starts with just a few pages per cpu; once
you switch to an actual tracer it allocates a sensible amount.

You can grow it with another interface; but then I'd have to like
remember what that was and how big the normal buffers are. Simply
toggling between tracers is far easier.

> > And there's a very good reason not to apply your patch; you can route
> > the function tracer into perf, guess what happens when perf calls the
> > function tracer again :-)
> 
> How? 

I think by using the /debug/tracing/events/ftrace/function event, but
I'm not actually sure, I've never used it nor did I write the code to do
it. Jolsa did all that IIRC.

All I know is that we had some 'fun' bugs around there sometime back.
