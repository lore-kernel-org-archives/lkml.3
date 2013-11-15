Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab3KOMDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:03:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50673 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3KOMDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:03:46 -0500
Date: Fri, 15 Nov 2013 13:03:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
Message-ID: <20131115120329.GH2965@twins.programming.kicks-ass.net>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
 <1384460715-23198-11-git-send-email-acme@infradead.org>
 <20131115060643.GA9237@gmail.com>
 <5285FECE.7020802@intel.com>
 <20131115111032.GA18647@gmail.com>
 <52860529.50200@intel.com>
 <20131115115629.GB19004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115115629.GB19004@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:56:29PM +0100, Ingo Molnar wrote:
> So, here's the current status quo, there's 4 basic types of profiling 
> that 99% of the people are using, in order of popularity:
> 
> 	perf record <cmd>
> 	perf record -a sleep N
> 	perf record -p <PID>
> 	perf record -t <TID>
> 
> The first two (which I'd guess comprise about 95% of real-world usage) 
> have inheritance enabled.
> 
> The last two (-p/-t) have inheritance disabled by default.

Yes, and I would expect it to be disabled for the TID option as you
explicitly select a single threads.

For the process wide thing it would make sense to enable inheritance by
default though.

So the big trade-off is that for single threaded processes which do not
fork you now have a single buffer, whereas with the inheritance option
you'll end up with nr_cpus buffers by default.

I suppose for most normal people that's not really an issue; and I
suppose all people with silly large machines already pay extra attention
-- but at least make it explicit and very clear that this is so.


