Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3JYKIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:08:22 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:53247 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753003Ab3JYKIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:08:19 -0400
Message-ID: <1382695687.12254.4.camel@pippen.local.home>
Subject: Re: perf/ftrace lockup on 3.12-rc6 with trigger code
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 25 Oct 2013 06:08:07 -0400
In-Reply-To: <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu>
	 <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 14:25 -0400, Vince Weaver wrote:
> On Thu, 24 Oct 2013, Vince Weaver wrote:
> > after a month of trying I finally got a small test-case out of my 
> > perf_fuzzer suite that triggers a system lockup with just one syscall.
> > 
> > Attached is the code that triggers it.
> 
> And it turns out you can only trigger this specific problem if advanced 
> ftrace options are enabled.
> 
> CONFIG_KPROBES_ON_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> CONFIG_STACK_TRACER=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_FUNCTION_PROFILER=y
> CONFIG_FTRACE_MCOUNT_RECORD=y

The above STACK_TRACER, FTRACE_WITH_REGS and FUNCTION_PROFILER probably
don't need to be set, as they are pretty much stand alone, and don't
look to be involved in the stack traces that you (and Dave) posted.

> 
> Urgh, I had turned those on to try to debug something and forgot to 
> disable.  I feel like I saw this problem before I had those enabled so I 
> guess I have to start from scratch fuzzing to see if I can get a more
> generally reproducible trace.

Looks like something is incorrectly enabling function tracer within
perf. Peter told me that there's some ref count bug that may use data
after being freed on exit.

I tried the program that you attached in you previous email, and was not
able to hit the bug. Are you able to hit the bug with that code each
time?

-- Steve


