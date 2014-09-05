Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaIETyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:54:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaIETyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:54:46 -0400
Date: Fri, 5 Sep 2014 21:54:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140905195439.GU4783@worktop.ger.corp.intel.com>
References: <20140901181808.GA6427@leverpostej>
 <20140901190534.GC5806@worktop.ger.corp.intel.com>
 <20140902185807.GA7434@leverpostej>
 <20140903115013.GA3127@leverpostej>
 <20140904104402.GS4783@worktop.ger.corp.intel.com>
 <20140904110740.GB32228@leverpostej>
 <20140905151640.GN19379@twins.programming.kicks-ass.net>
 <CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
 <20140905165956.GA28623@leverpostej>
 <CA+55aFwqhPLjTyiwVs2F9p8BPxMV=FOTgLpcHcV2rUPvTt71ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwqhPLjTyiwVs2F9p8BPxMV=FOTgLpcHcV2rUPvTt71ow@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:31:49AM -0700, Linus Torvalds wrote:
> So quite frankly, the whole perf_pmu_migrate_context() thing looks
> completely and fundamentally broken.

Yes, agreed. We can go play very nasty games, but fundamentally agreed.

> Or even just say: "if somebody takes down a CPU with existing uncore
> events, those events are now effectively dead". Don't try to migrate
> them, don't try to create new events on another CPU, just let it go.
> The CPU is down, the events are inactive.
> 
> Keep it simple. Not the current completely broken thing that clearly
> doesn't honor the actual real rules for "event->ctx". Because the
> current rules are effectively that event->ctx is a constant over the
> whole lifetime of the event. Agreed?

I like this best, I've never really been a supporter of hotplug games. 
