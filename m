Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaAMNWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:22:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaAMNWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:22:01 -0500
Date: Mon, 13 Jan 2014 14:23:30 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: Re: [PATCH RFC v2 0/4] perf: IRQ-bound performance events
Message-ID: <20140113132330.GA2833@dhcp-26-207.brq.redhat.com>
References: <cover.1388858996.git.agordeev@redhat.com>
 <20140105175949.GC27909@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140105175949.GC27909@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 09:59:49AM -0800, Andi Kleen wrote:
> > This is version 2 of RFC "perf: IRQ-bound performance events". That is an
> > introduction of IRQ-bound performance events - ones that only count in a
> > context of a hardware interrupt handler. Ingo suggested to extend this
> > functionality to softirq and threaded handlers as well:
> 
> Did you measure the overhead in workloads that do a lot of interrupts?
> I assume two WRMSR could be a significant part of the cost of small interrupts.

No, that would be the next step. I hoped first to ensure the way I am
intruding into the current perf design is correct.

> For counting at least it would be likely a lot cheaper to just RDPMC
> and subtract manually.

Sigh, that seems as quite a rework for Intel PMU.

> The cache miss example below is certainly misleading, as cache misses
> by interrupts are often a "debt", that is they are forced on whoever
> is interrupted. I don't think that is a good use of this.

May be useless rather than misleading? :) Actually, cache and power use
are exactly the data I thought are useful if one wants to check the
dependency from the interrupt affinity mask. There was some discussion
on this topic some year ago:

On Mon, May 21, 2012 at 08:36:09AM -0700, Linus Torvalds wrote:
"So it may well make perfect sense to allow a mask of CPU's for
interrupt delivery, but just make sure that the mask all points to
CPU's on the same socket. That would give the hardware some leeway in
choosing the actual core - it's very possible that hardware could
avoid cores that are running with irq's disabled (possibly improving
latecy) or even more likely - avoid cores that are in deeper
powersaving modes."

So this RFC is kind of follow-up to come up with necessary tooling.

> I guess it can be useful for cycles.
> 
> -Andi

Thanks, Andi!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
