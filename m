Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3ENIiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:38:00 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:57073 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab3ENIh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:37:57 -0400
Date: Tue, 14 May 2013 10:37:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130514083752.GA651@gmail.com>
References: <20130510101823.GA18427@gmail.com>
 <20130510102245.GA31235@dyad.programming.kicks-ass.net>
 <20130510103112.GA18755@gmail.com>
 <20130510103436.GC31235@dyad.programming.kicks-ass.net>
 <20130510105536.GA18805@gmail.com>
 <20130510112756.GH31235@dyad.programming.kicks-ass.net>
 <20130511075008.GC24435@gmail.com>
 <20130513093624.GC3708@dyad.programming.kicks-ass.net>
 <20130513194313.GA30998@gmail.com>
 <20130514072239.GC15942@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514072239.GC15942@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, May 13, 2013 at 09:43:13PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Sat, May 11, 2013 at 09:50:08AM +0200, Ingo Molnar wrote:
> > > > That's really a red herring: there's absolutely no reason why the 
> > > > kernel could not pass back the level of precision it provided.
> > > 
> > > All I've been saying is that doing random precision without feedback is 
> > > confusing.
> > 
> > I agree with that.
> > 
> > > We also don't really have a good feedback channel for this kind of 
> > > thing. The best I can come up with is tagging each and every sample with 
> > > the quality it represents. I think we can do with only one extra 
> > > PERF_RECORD_MISC bit, but it looks like we're quickly running out of 
> > > those things.
> > 
> > Hm, how about passing precision back to user-space at creation time, in 
> > the perf_attr data structure? There's no need to pass it back in every 
> > sample, precision will not really change during the life-time of an event.
> 
> Ah indeed, we talked about modifying the attr structure before (error details
> or so). Did something like that ever make it in, or would this be the first
> use now?

That remained on the level of talk AFAICT.

> > The vast majority of code gets measured by cycles:pp more accurately 
> > than cycles.
> > 
> > We could try and see how many people complain. It's not like it's hard 
> > to undo such a change of the default event?
> 
> I suppose so.. Alternatively we can have the PEBS event read a 'real' 
> cycles counter and weight the sample based on that. Bit cumbersome, esp 
> if you want to implement it kernel side, but it could possibly work 
> around this issue.

Looks a bit cumbersome indeed. Lets try the simpler approach and see?

Thanks,

	Ingo
