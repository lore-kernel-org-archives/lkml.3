Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaLRPKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:10:40 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLRPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:10:38 -0500
Date: Thu, 18 Dec 2014 16:10:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] perf ftrace: Factor regs retrieval for function tracer
Message-ID: <20141218151020.GF30905@twins.programming.kicks-ass.net>
References: <20141216115041.GW3337@twins.programming.kicks-ass.net>
 <20141217143105.GG18257@krava.brq.redhat.com>
 <20141217153508.GC30905@twins.programming.kicks-ass.net>
 <20141217154507.GA20471@krava.brq.redhat.com>
 <20141218140847.GA18898@krava.brq.redhat.com>
 <20141218142027.GE30905@twins.programming.kicks-ass.net>
 <20141218142827.GB18898@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218142827.GB18898@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 03:28:27PM +0100, Jiri Olsa wrote:
> > Would not something like:
> > 
> > 	struct pt_regs *regs;
> > 
> > 	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, &regs, &rctx);
> > 	if (!pt_regs) {
> > 		perf_fetch_caller_regs(regs);
> > 		pt_regs = regs;
> > 	}
> > 
> > Be simpler?
> 
> well, I wanted to omit touching the '__perf_regs' var
> in perf_trace_buf_prepare:
> 
>         if (regs)
>                 *regs = this_cpu_ptr(&__perf_regs[*rctxp]);

OK, fair enough I suppose. Thanks!
