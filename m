Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3KGOFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:05:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:51520 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750964Ab3KGOFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:05:04 -0500
Date: Thu, 7 Nov 2013 09:04:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is there a notification mechanism for enabled/disabled trace
 events?
Message-ID: <20131107090459.3be09ee4@gandalf.local.home>
In-Reply-To: <CAAVeFuJWKwAQ338R86O3WMarFDP2ZJDayLddGio9uXiXPsuyFA@mail.gmail.com>
References: <CAAVeFuJWKwAQ338R86O3WMarFDP2ZJDayLddGio9uXiXPsuyFA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013 17:42:54 +0900
Alexandre Courbot <gnurou@gmail.com> wrote:

> Hi everyone,
> 
> Trace events can be enabled through debugfs by e.g. writing '1' into
> their enable node. This is a very useful feature as some tracing
> functions can introduce overhead and we only want them active when
> needed.
> 
> There is one additional thing that I would need though, which is to be
> notified when a given trace event is enabled or disabled.
> 
> Here is why: I have a power monitoring hardware that can report how
> much power is currently used by the system. Having this information
> correlated with other traces (cpufreq, cpuidle, ...) is very useful ;
> it can be done by repeatedly scheduling a work that probes the power
> usage and traces it. The job should only be running when the power
> monitoring trace event is enabled, but AFAIK there is no way to be
> notified when it is enabled or disabled. So here are a few questions:

I'm a little confused by this. Your power monitoring is only enabled
when someone enables the power tracepoints? Why not have the user start
monitoring and have it enable the tracepoints itself?

> 
> 1) Is there such a notification mechanism for trace events that I have missed?

That you missed? Can you elaborate here.

> 
> 2) If not, is there any objection to having one? I'd say my use-case
> is not so uncommon and others would certainly benefit from it.
> 
> 3) What would be the right place to have it? ftrace_event_reg() looks
> like a good place to call a notifier chain, however I'm not sure where
> the notifier head should be stored, due to my poor understanding of
> ftrace.

There is a way to hard code a notifier for tracepoints, look at how
TRACE_EVENT_FN() is used (include/trace/events/syscalls.h)

But having a generic notifier may not be too hard or invasive to
implement.

-- Steve

> 
> Any answer/comments greatly appreciated!
> 
> Thanks,
> Alex.

