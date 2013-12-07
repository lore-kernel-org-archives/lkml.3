Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3LGBdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:33:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab3LGBdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:33:11 -0500
Date: Fri, 6 Dec 2013 20:32:49 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and fixes crash bugs
Message-ID: <20131207013249.GC3201@redhat.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <y0mvbz3pd3z.fsf@fche.csb> <52A16AD7.6040500@hitachi.com> <20131206190753.GA3201@redhat.com> <52A25B71.3090108@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A25B71.3090108@hitachi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Dec 07, 2013 at 08:19:13AM +0900, Masami Hiramatsu wrote:

> [...]
> > Would you plan to limit kprobes (or just the perf-probe frontend) to
> > only function-entries also?

> Exactly, yes :). Currently I have a patch for kprobe-tracer
> implementation (not only for perf-probe, but doesn't limit kprobes
> itself).

Interesting option.  It sounds like a restrictive expedient that could
result in kprobes never being made sufficiently robust.


> > If not, and if intra-function statement-granularity kprobes remain
> > allowed within a function-granularity whitelist, then you might
> > still have those "quantitative" problems.

> Yes, but as far as I've tested, the performance overhead is not
> high, especially as far as putting kprobes at the entry of those
> functions because of ftrace-based optimization.

(Would that also make CONFIG_KPROBE_EVENT require KPROBES_ON_FTRACE?)


> > Even worse, kprobes robustness problems can bite even with a small
> > whitelist, unless you can test the countless subset selections
> > cartesian-product the aggrevating factors (like other tracing
> > facilities being in use at the same time, limited memory, high irq
> > rates, debugging sessions, architectures, whatever).
> 
> And also, what script will run on each probe, right? :)

In the perf-probe world, the closest analogue could be varying the
contextual data that's being extracted (stack traces, parameters, ...).


> >> [...]  For the long term solution, I think we can introduce some
> >> kind of performance gatekeeper as systemtap does. Counting the
> >> miss-hit rate per second and if it go over a threshold, disable next
> >> miss-hit (or most miss-hit) probe (as OOM killer does).
> > 
> > That would make sense, but again it would not help deal with kprobes
> > robustness (in the kernel-crashing rather than kernel-slowdown sense).
> 
> Why would you think so? Is there any hidden path for calling kprobes
> mechanism?? The kernel crash problem just comes from bugs, not the
> quantitative issue.

I don't think we're disagreeing.  A performance-gatekeeper in
perf-probe or nearby would be useful (and manage the kprobe-quantity
problem).  It would not be sufficient to prevent the kernel-crashing
bugs.


- FChE
