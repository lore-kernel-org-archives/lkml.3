Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3JYKPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:15:17 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:62349 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JYKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:15:15 -0400
Date: Fri, 25 Oct 2013 12:15:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: ktap inclusion in drivers/staging/?
Message-ID: <20131025101511.GB3439@gmail.com>
References: <20131024075813.GA26929@gmail.com>
 <CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> Hi Ingo,
> 
> On Thu, Oct 24, 2013 at 3:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Greg,
> >
> > I was surprised to see 'ktap' appear in the staging tree silently,
> > via these commits that are visible in today's staging-next:
> >
> >  2c856b9e3e06 staging: ktap: remove unused <asm/syscall.h> header file
> >  687b63a3bfd5 staging: ktap: update email name in MAINTAINERS
> >  c63a164271f8 staging: ktap: add to the kernel tree
> >
> > ktap is pretty fresh instrumentation code, announced on lkml a
> > couple of months ago, and so far I haven't seen much technical
> > discussion of integrating ktap upstream, mostly I suspect because
> > not a _single_ patch was sent to linux-kernel for review. (!)
> >
> I accept Greg revert this in staging-next tree, It's entirely my fault, sorry.

Thanks!

> > An announcement of a Git tree was made (which Git tree is not very
> > structured), and some very minimal discussion ensued, but no actual
> > patches were sent with an intent to merge, no technical arguments
> > were made in favor of merging and nothing conclusive was achieved.
> >
> > A couple of very quick (and incomplete) technical objections:
> >
> >  - The Git commits in staging an absolutely unstructured,
> >    unreviewable mess, due to a single commit adding 16 KLOCs (!) of
> >    code:
> >
> >       80 files changed, 16376 insertions(+)
> >
> >    (I looked at the ktap Git tree as well, it's not much better.)
> >
> >  - Most of the kernel code comes with near zero explanations in the
> >    code itself. I looked at the kernel code in
> >    drivers/staging/ktap/interpreter/.  I have not found a _single_
> >    substantial in-code comment about design details and
> >    implementational considerations. (!!)
> >
> I will add more comments for it, also will draft a design detail in
> doc/ directory.
> 
> >  - From the little I've been able to decode I get the impression
> >    that the design should be much more integrated into the rest of
> >    instrumentation: the in-kernel Lua bytecode interpreter looks
> >    interesting, it could be an intelligent upgrade (or even outright
> >    replacement) for the current 'filter' interpreter concept we have
> >    for tracepoints - instead of putting a parallel interpreter
> >    implementation into the kernel.
> >
> >  - In a similar fashion, it would be nice to see it integrated with
> >    'perf probe' or 'perf ktap', so that users can create probes from
> >    a single place, with coherent syntax and integrated analysis
> >    capabilities. I.e. there's no reason to not make this a
> >    relatively pain-less yet very useful transition.
>
> Yes, I also mentioned this in my RFC email post before, that's the 
> reason why I use perf-like interface in ktap as much as I can, 
> like perf-tracepoints and perf-probe, also ktap can reuse perf 
> debuginfo handling code in future, we are on the same page at this 
> technical point.

Okay, cool! I've also Cc:-ed Masami, who was also very receptive in 
person of the idea to merge this kind of scripting into perf probe.

(or perf ktap, whichever structure makes most sense from the end 
user POV.)

> >   Nacked-by: Ingo Molnar <mingo@kernel.org>
>
> Accept, really sorry about this mistake action, entirely my fault.

Don't worry about it - your plans look very promising IMO.

Thanks,

	Ingo
