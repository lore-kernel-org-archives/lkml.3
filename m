Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3JXMcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:32:42 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50670 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3JXMck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <20131024075813.GA26929@gmail.com>
References: <20131024075813.GA26929@gmail.com>
Date: Thu, 24 Oct 2013 20:32:38 +0800
Message-ID: <CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com>
Subject: Re: ktap inclusion in drivers/staging/?
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Oct 24, 2013 at 3:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Greg,
>
> I was surprised to see 'ktap' appear in the staging tree silently,
> via these commits that are visible in today's staging-next:
>
>  2c856b9e3e06 staging: ktap: remove unused <asm/syscall.h> header file
>  687b63a3bfd5 staging: ktap: update email name in MAINTAINERS
>  c63a164271f8 staging: ktap: add to the kernel tree
>
> ktap is pretty fresh instrumentation code, announced on lkml a
> couple of months ago, and so far I haven't seen much technical
> discussion of integrating ktap upstream, mostly I suspect because
> not a _single_ patch was sent to linux-kernel for review. (!)
>
I accept Greg revert this in staging-next tree, It's entirely my fault, sorry.

> An announcement of a Git tree was made (which Git tree is not very
> structured), and some very minimal discussion ensued, but no actual
> patches were sent with an intent to merge, no technical arguments
> were made in favor of merging and nothing conclusive was achieved.
>
> A couple of very quick (and incomplete) technical objections:
>
>  - The Git commits in staging an absolutely unstructured,
>    unreviewable mess, due to a single commit adding 16 KLOCs (!) of
>    code:
>
>       80 files changed, 16376 insertions(+)
>
>    (I looked at the ktap Git tree as well, it's not much better.)
>
>  - Most of the kernel code comes with near zero explanations in the
>    code itself. I looked at the kernel code in
>    drivers/staging/ktap/interpreter/.  I have not found a _single_
>    substantial in-code comment about design details and
>    implementational considerations. (!!)
>
I will add more comments for it, also will draft a design detail in
doc/ directory.

>  - From the little I've been able to decode I get the impression
>    that the design should be much more integrated into the rest of
>    instrumentation: the in-kernel Lua bytecode interpreter looks
>    interesting, it could be an intelligent upgrade (or even outright
>    replacement) for the current 'filter' interpreter concept we have
>    for tracepoints - instead of putting a parallel interpreter
>    implementation into the kernel.
>
>  - In a similar fashion, it would be nice to see it integrated with
>    'perf probe' or 'perf ktap', so that users can create probes from
>    a single place, with coherent syntax and integrated analysis
>    capabilities. I.e. there's no reason to not make this a
>    relatively pain-less yet very useful transition.
>
Yes, I also mentioned this in my RFC email post before, that's the
reason why I use perf-like interface in ktap as much as I can, like
perf-tracepoints and perf-probe, also ktap can reuse perf debuginfo
handling code in future, we are on the same page at this technical point.

>  - In a similar vein, it creates Yet Another Debugfs ABI, instead of
>    trying to extend existing instrumentation.
>
Yes.
I tried to create file in /sys/kernel/debug/tracing/ktap or use perf syscall,
that's looks more reasonable, but need some patches for kernel, so
independent debugfs interface was chosen in "initial stage".

> Despite my criticism, I'm actually a big proponent of safe kernel
> probing concepts and this code does have many of the qualities that
> I always wanted the tracepoint filter code to have in the long run.
>
Thanks, I'm glad to hear more and more people says ktap is useful,
of course the code is still need to improve.

> So it does look potentially useful, but _please_ don't merge ktap
> via the staging tree yet, until the code becomes reviewable, until
> it gets a proper review and until the instrumentation guys (I tried
> to Cc: folks who might be interested in it) ack it.
>
> Kernel instrumentation code should follow established procedures to
> gain Acks from interested kernel maintainers.
>
> Just because we've made it easy to create instrumentation callbacks
> and made it possible to hide it all in a separate driver doesn't
> mean the whole thing should explode into zillions of disjunct,
> incoherent approaches. It's not like kernel instrumentation is an
> under-maintained subsystem!
>
> So until it's all cleared up:
>
>   Nacked-by: Ingo Molnar <mingo@kernel.org>
>
Accept, really sorry about this mistake action, entirely my fault.

Jovi
