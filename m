Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3JXH6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:58:18 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46180 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3JXH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:58:17 -0400
Date: Thu, 24 Oct 2013 09:58:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: jovi.zhangwei@huawei.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: ktap inclusion in drivers/staging/?
Message-ID: <20131024075813.GA26929@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg,

I was surprised to see 'ktap' appear in the staging tree silently, 
via these commits that are visible in today's staging-next:

 2c856b9e3e06 staging: ktap: remove unused <asm/syscall.h> header file
 687b63a3bfd5 staging: ktap: update email name in MAINTAINERS
 c63a164271f8 staging: ktap: add to the kernel tree

ktap is pretty fresh instrumentation code, announced on lkml a 
couple of months ago, and so far I haven't seen much technical 
discussion of integrating ktap upstream, mostly I suspect because 
not a _single_ patch was sent to linux-kernel for review. (!)

An announcement of a Git tree was made (which Git tree is not very 
structured), and some very minimal discussion ensued, but no actual 
patches were sent with an intent to merge, no technical arguments 
were made in favor of merging and nothing conclusive was achieved.

A couple of very quick (and incomplete) technical objections:

 - The Git commits in staging an absolutely unstructured, 
   unreviewable mess, due to a single commit adding 16 KLOCs (!) of 
   code:

      80 files changed, 16376 insertions(+)

   (I looked at the ktap Git tree as well, it's not much better.)

 - Most of the kernel code comes with near zero explanations in the 
   code itself. I looked at the kernel code in 
   drivers/staging/ktap/interpreter/.  I have not found a _single_ 
   substantial in-code comment about design details and 
   implementational considerations. (!!)

 - From the little I've been able to decode I get the impression 
   that the design should be much more integrated into the rest of 
   instrumentation: the in-kernel Lua bytecode interpreter looks
   interesting, it could be an intelligent upgrade (or even outright
   replacement) for the current 'filter' interpreter concept we have
   for tracepoints - instead of putting a parallel interpreter
   implementation into the kernel.

 - In a similar fashion, it would be nice to see it integrated with 
   'perf probe' or 'perf ktap', so that users can create probes from 
   a single place, with coherent syntax and integrated analysis
   capabilities. I.e. there's no reason to not make this a
   relatively pain-less yet very useful transition.

 - In a similar vein, it creates Yet Another Debugfs ABI, instead of 
   trying to extend existing instrumentation.

Despite my criticism, I'm actually a big proponent of safe kernel 
probing concepts and this code does have many of the qualities that 
I always wanted the tracepoint filter code to have in the long run.

So it does look potentially useful, but _please_ don't merge ktap 
via the staging tree yet, until the code becomes reviewable, until 
it gets a proper review and until the instrumentation guys (I tried 
to Cc: folks who might be interested in it) ack it.

Kernel instrumentation code should follow established procedures to 
gain Acks from interested kernel maintainers.

Just because we've made it easy to create instrumentation callbacks 
and made it possible to hide it all in a separate driver doesn't 
mean the whole thing should explode into zillions of disjunct, 
incoherent approaches. It's not like kernel instrumentation is an 
under-maintained subsystem!

So until it's all cleared up:

  Nacked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
