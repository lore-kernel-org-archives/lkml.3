Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3LFTIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:08:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab3LFTIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:08:17 -0500
Date: Fri, 6 Dec 2013 14:07:53 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and fixes crash bugs
Message-ID: <20131206190753.GA3201@redhat.com>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204084551.GA31772@gmail.com> <529FBA71.6070107@hitachi.com> <y0mvbz3pd3z.fsf@fche.csb> <52A16AD7.6040500@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A16AD7.6040500@hitachi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Masami -

masami.hiramatsu.pt wrote:

> [...]
> >> [...]  Then, I'd like to propose this new whitelist feature in
> >> kprobe-tracer (not raw kprobe itself). And a sysctl knob for
> >> disabling the whitelist.  That knob will be
> >> /proc/sys/debug/kprobe-event-whitelist and disabling it will mark
> >> kernel tainted so that we can check it from bug reports.
> > 
> > How would one assemble a reliable whitelist, if we haven't fully
> > characterized the problems that make the blacklist necessary?
> 
> As I said, we can use function graph tracer's list as the whitelist,
> since it doesn't include any functions invoked from ftrace's event
> handler. (Note that I don't mention the Systemtap or other user here)
>
> Whitelist is just for keeping the people away from the quantitative
> issue, who just want to trace their subsystems except for ftrace.
> [...]

Would you plan to limit kprobes (or just the perf-probe frontend) to
only function-entries also?  If not, and if intra-function
statement-granularity kprobes remain allowed within a
function-granularity whitelist, then you might still have those
"quantitative" problems.

Even worse, kprobes robustness problems can bite even with a small
whitelist, unless you can test the countless subset selections
cartesian-product the aggrevating factors (like other tracing
facilities being in use at the same time, limited memory, high irq
rates, debugging sessions, architectures, whatever).


> [...]  For the long term solution, I think we can introduce some
> kind of performance gatekeeper as systemtap does. Counting the
> miss-hit rate per second and if it go over a threshold, disable next
> miss-hit (or most miss-hit) probe (as OOM killer does).

That would make sense, but again it would not help deal with kprobes
robustness (in the kernel-crashing rather than kernel-slowdown sense).


- FChE
