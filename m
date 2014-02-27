Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaB0Cnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:43:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:60695 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753950AbaB0Cnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:43:45 -0500
Date: Wed, 26 Feb 2014 21:43:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint
 code
Message-ID: <20140226214342.6859d1f9@gandalf.local.home>
In-Reply-To: <1534483926.31265.1393467676451.JavaMail.zimbra@efficios.com>
References: <20140226190140.590029589@goodmis.org>
	<1677033958.31194.1393450578584.JavaMail.zimbra@efficios.com>
	<20140226203853.09b7d843@gandalf.local.home>
	<1534483926.31265.1393467676451.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 02:21:16 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> That is not the question. We don't care about how many times module.h is
> included in the kernel, but rather what module.h itself includes and could
> include in the future, throughout generic and arch-specific headers. If
> someone want to add a tracepoint in a static inline function located within
> a header file, they will need to include tracepoint.h. If tracepoint.h
> happens to have a circular dependency on this header, there comes include
> hell.

Actually, we've been telling people not to do that. That is, we don't
allow for tracepoints to be in headers anymore. We've removed all of
the offenders.

> 
> Arguing that it's OK to include headers within core instrumentation code
> because they are themselves included pretty much everywhere is a paved way
> to said include hell IMHO.

I find tracepoint.h far from a core instrumentation code. It's for
static tracepoints only. It's not like rcu or spinlock. It's about as
core as module.h is. I would argue that module.h is an even more core
header than tracepoint.h.


> > 
> > But as a compromise, I can move it to ftrace_event.h instead.
> 
> Since it will be used in tracepoint.c as well, which is a foundation of
> ftrace_event, it would be bad coupling to make tracepoint.c include
> ftrace_event.h (abstraction inversion). So I still think tracepoint.h
> is the right place to put this, only not with the module.h dependency.
> 
> But perhaps I'm missing something. Why is it so important to you to make
> this a static inline rather than a regular function call ?

As it is a one liner check, it just seemed to fit as a static inline.
As this isn't in any fast path, I guess I could make it a normal
function call.

Fine, I'll do that instead. Then the module header change can go into
linux-next instead of mainline/stable.

-- Steve
