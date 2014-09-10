Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094AbaIJNMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:12:40 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:57795 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaIJNMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:12:38 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 10 Sep 2014 09:18:35 -0400 (EDT)
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <20140910083136.GP6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Peter Zijlstra wrote:
> 
> Sasha reported something from his KVM based fuzzing, maybe that's the
> same. But that x86_exceptions thing is interesting, lemme go look at
> that first.

that's what got me looking at things again, the trinity reports.  Though I 
think those involve CPU hotplugging which my fuzzer shouldn't trigger.

I do think this is the same memory corruption/reboot bug that I reported 
back in February (the thread is "perf_fuzzer compiled for x32 causes 
reboot" but I wasn't able to isolate the problem then either.

Somehow something is stomping over memory with a forking workload (likely 
an improper free with RCU like we've seen before) but the fact that it 
causes a reboot immediately makes it *really* hard to debug this.


I'm not sure about the tracing issue, possibly it's just a side effect of 
memory being corrupted by the same bug.  In case it's relevant here's the 
trace-cmd I was trying to use:

   trace-cmd record -e raw_syscalls -p function -l '*perf*' -n 'perf_event_task_tick' -l 'x86*' -l 'intel*' -P 2807

Vince
