Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3J3OVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:21:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3J3OVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:21:19 -0400
Date: Wed, 30 Oct 2013 16:20:13 +0200
From: Gleb Natapov <gleb@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        yoshihiro.yunomae.ez@hitachi.com
Subject: Re: RFC: paravirtualizing perf_clock
Message-ID: <20131030142013.GH4651@redhat.com>
References: <526DBD7F.1010807@gmail.com>
 <20131028131556.GN19466@laptop.lan>
 <526F2440.9030607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F2440.9030607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 08:58:08PM -0600, David Ahern wrote:
> On 10/28/13 7:15 AM, Peter Zijlstra wrote:
> >>Any suggestions on how to do this and without impacting performance. I
> >>noticed the MSR path seems to take about twice as long as the current
> >>implementation (which I believe results in rdtsc in the VM for x86 with
> >>stable TSC).
> >
> >So assuming all the TSCs are in fact stable; you could implement this by
> >syncing up the guest TSC to the host TSC on guest boot. I don't think
> >anything _should_ rely on the absolute TSC value.
> >
> >Of course you then also need to make sure the host and guest tsc
> >multipliers (cyc2ns) are identical, you can play games with
> >cyc2ns_offset if you're brave.
> >
> 
> This and the method Gleb mentioned both are going to be complex and
> fragile -- based assumptions on how the perf_clock timestamps are
> generated. For example, 489223e assumes you have the tracepoint
> enabled at VM start with some means of capturing the data (e.g., a
> perf-session active).
We can think of other ways to provide tsc offset to perf.

>                        In both cases the end result requires piecing
> together and re-generating the VM's timestamp on the events. For
> perf this means either modifying the tool to take parameters and an
> algorithm on how to modify the timestamp or a homegrown tool to
> regenerate the file with updated timestamps.
> 
> To back out a bit, my end goal is to be able to create and merge
> perf-events from any context on a KVM-based host -- guest userspace,
> guest kernel space, host userspace and host kernel space (userspace
> events with a perf-clock timestamp is another topic ;-)). Having the
> events generated with the proper timestamp is the simpler approach
> than trying to collect various tidbits of data, massage timestamps
> (and hoping the clock source hasn't changed) and then merge events.
> 
So can you explain a little bit more about how this will work? You run
perf on a host and get both host and guest events? How do you pass
events from guest to host in this case?

> And then for the cherry on top a design that works across
> architectures (e.g., x86 now, but arm later).
> 
MSR is x86 thing.

--
			Gleb.
