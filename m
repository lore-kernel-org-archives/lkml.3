Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaIJOYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:24:32 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63820 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaIJOYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:24:31 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 10 Sep 2014 10:30:31 -0400 (EDT)
To: Sasha Levin <sasha.levin@oracle.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <541059C9.1040200@oracle.com>
Message-ID: <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu> <541059C9.1040200@oracle.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Sasha Levin wrote:

> On 09/10/2014 09:18 AM, Vince Weaver wrote:
> > that's what got me looking at things again, the trinity reports.  Though I 
> > think those involve CPU hotplugging which my fuzzer shouldn't trigger.
> > 
> > I do think this is the same memory corruption/reboot bug that I reported 
> > back in February (the thread is "perf_fuzzer compiled for x32 causes 
> > reboot" but I wasn't able to isolate the problem then either.
> > 
> > Somehow something is stomping over memory with a forking workload (likely 
> > an improper free with RCU like we've seen before) but the fact that it 
> > causes a reboot immediately makes it *really* hard to debug this.
> 
> Could this be http://permalink.gmane.org/gmane.linux.kernel/1779436 which
> I saw couple days ago?

It could be.

I have about 10 open bugs with similar symptoms found with my perf_fuzzer 
here (and a few more that are possibly the same memory corruption bug that 
"fixes" went into the kernel but it's unclear if it actually fixed things
or just altered the locking enough to make it harder to hit).

	http://web.eece.maine.edu/~vweaver/projects/perf_events/fuzzer/bugs_found.html

I've been trying for months now to make progress on these but this type of 
bug is really hard to debug.

Vince
