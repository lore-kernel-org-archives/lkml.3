Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaIEQod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:44:33 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:51373 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIEQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:44:31 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 5 Sep 2014 12:50:21 -0400 (EDT)
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
In-Reply-To: <CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1409051246100.15128@vincent-weaver-1.umelst.maine.edu>
References: <20140901181808.GA6427@leverpostej> <20140901190534.GC5806@worktop.ger.corp.intel.com> <20140902185807.GA7434@leverpostej> <20140903115013.GA3127@leverpostej> <20140904104402.GS4783@worktop.ger.corp.intel.com> <20140904110740.GB32228@leverpostej>
 <20140905151640.GN19379@twins.programming.kicks-ass.net> <CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Linus Torvalds wrote:


> However, the more fundamental question is "what protects accesses to
> 'events->ctx'". Why is "put_event()" so special that *it* gets locking
> for the reading of "event->ctx", but none of the other cases of
> reading the ctx pointer gets it or needs it?
> 
> I'm getting the feeling that this race is bigger than just put_event().

I've been chasing a bug triggered by my perf_fuzzer program (with a 
forking workload) for the past few months.  It will reliably oops the 
machine or worse (I've had it somehow not only take down the test 
machine, but the whole local network somehow).

Often it seems to come from deep inside the perf_event context locking, in 
conjunction with complex open/fork/close/migrate workloads.

Here's a link to an older bug writeup, I've had it happen more recently 
but I've been too busy to bother writing it up.

	http://web.eece.maine.edu/~vweaver/projects/perf_events/fuzzer/3.15-rc5.get_cpu_context_gpf.html

Is there hope that we've finally found a plausible source for this bug?

Vince
