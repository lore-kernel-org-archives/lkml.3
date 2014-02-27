Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaB0Bi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:38:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:46008 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751989AbaB0Biz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:38:55 -0500
Date: Wed, 26 Feb 2014 20:38:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint
 code
Message-ID: <20140226203853.09b7d843@gandalf.local.home>
In-Reply-To: <1677033958.31194.1393450578584.JavaMail.zimbra@efficios.com>
References: <20140226190140.590029589@goodmis.org>
	<1677033958.31194.1393450578584.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 21:36:18 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: linux-kernel@vger.kernel.org
> > Cc: "Ingo Molnar" <mingo@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Peter Zijlstra"
> > <peterz@infradead.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Mathieu Desnoyers"
> > <mathieu.desnoyers@efficios.com>
> > Sent: Wednesday, February 26, 2014 2:01:40 PM
> > Subject: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint code
> > 
> > [ Request for Acks ]
> > 
> > Due to module tainting, we have tracepoints that silently do not work.
> > That will be solved another way. But the trace event infrastructure should
> > not be created for tainted modules. That is, the debugfs files should
> > not exist for them.
> > 
> > By moving the tracepoint module taint test into tracepoint.h, we can
> > reuse that same test when creating the module tracepoint events.
> > 
> > Note, I had to remove the tracepoint.h include from module.h as there
> > was nothing in module.h that required tracepoint.h, but this broke
> > a couple of event files (migrate.h and writeback.h) because they did
> > not include tracepoint.h, and were just lucky that it was included
> > by module.h.
> 
> When designing tracepoint.h, a lot of care went into making sure it did
> not have needless dependency on other headers, since this header is
> expected to be included into many other files and headers, thus posing
> a clear risk of becoming yet another root of an include dependency hell.

Well, module.h is included in many more.

> 
> While I agree on adding the API you propose, why made it a static inline ?
> This adds this dependency from tracepoint.h on module.h. Instead, we could
> just declare a symbol, and implement a tracepoint_module_has_bad_taint()
> within kernel/tracepoint.c. It should not be a fast path anyway, so I don't
> see the point it making it a static inline.
> 
> I also recommend sticking to the tracepoint_*() API (rather than trace_*).

Well, as this is now not just for tracepoints, but also used by the
trace_events, and because the name is already too big (but
descriptive), I rather not change it.

But as a compromise, I can move it to ftrace_event.h instead.

-- Steve
