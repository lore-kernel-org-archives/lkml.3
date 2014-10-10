Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaJJOCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:02:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:46659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbaJJOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:02:32 -0400
Date: Fri, 10 Oct 2014 16:02:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 10/11] perf/x86/intel: Support task events with Intel CQM
Message-ID: <20141010140223.GB3343@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-11-git-send-email-matt@console-pimps.org>
 <20141008110743.GF4750@worktop.programming.kicks-ass.net>
 <20141008121044.GS14343@console-pimps.org>
 <20141008144957.GK10832@worktop.programming.kicks-ass.net>
 <20141010120202.GY14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010120202.GY14343@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:02:02PM +0100, Matt Fleming wrote:
> On Wed, 08 Oct, at 04:49:57PM, Peter Zijlstra wrote:
> > 
> > The thing is, with multiplexing you cannot fail at event creation time
> > anyhow. The only time where you can 'fail' is when programming the PMU,
> > when its full its full.
> > 
> > Those that don't fit, get to wait their turn.
> 
> For CQM it's not about "fitting" everything in the PMU but more about
> monitoring the same thing (task, cgroup) with different events, i.e. one
> thing with two RMIDs. We have the RMID recycling algorithm to make
> things fit, but that doesn't help us out here.
> 
> An example scenario that isn't supported by this patch series is
> monitoring a cgroup while simultaneously monitoring a task that's part
> of that cgroup. Whichever event is created second will fail at event
> init time.

That was what I had that conflict thing for, ISTR seeing some parts of
that here.

> And that seemed like a fair approach to me. But the more I think about
> it, the more I begin to agree that maybe we should allow users the
> flexibility to create conflicting events, particularly because there
> appears to be precedent in other parts of perf.

Yeah, although typically its not this hard. CQM is 'interesting' because
its so different.

> Hmm... "rotation" is starting to become my least favourite word.

:-)
