Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3JXSRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 14:17:17 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:63364 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3JXSRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 14:17:16 -0400
Date: Thu, 24 Oct 2013 14:25:06 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: perf/ftrace lockup on 3.12-rc6 with trigger code
In-Reply-To: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1310241422460.6573@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct 2013, Vince Weaver wrote:
> after a month of trying I finally got a small test-case out of my 
> perf_fuzzer suite that triggers a system lockup with just one syscall.
> 
> Attached is the code that triggers it.

And it turns out you can only trigger this specific problem if advanced 
ftrace options are enabled.

CONFIG_KPROBES_ON_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y

Urgh, I had turned those on to try to debug something and forgot to 
disable.  I feel like I saw this problem before I had those enabled so I 
guess I have to start from scratch fuzzing to see if I can get a more
generally reproducible trace.

Vince
