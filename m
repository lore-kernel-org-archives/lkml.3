Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaK0Opr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:45:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaK0Opp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:45:45 -0500
Date: Thu, 27 Nov 2014 12:45:28 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Do not fail on processing out of order event
Message-ID: <20141127144528.GL3808@redhat.com>
References: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
 <20141126154459.GD3808@redhat.com>
 <20141127105603.GA1987@gmail.com>
 <20141127135259.GI3808@redhat.com>
 <20141127140707.GB25752@krava.brq.redhat.com>
 <20141127141626.GK3808@redhat.com>
 <20141127142321.GC25752@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127142321.GC25752@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 27, 2014 at 03:23:21PM +0100, Jiri Olsa escreveu:
> On Thu, Nov 27, 2014 at 12:16:26PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Nov 27, 2014 at 03:07:07PM +0100, Jiri Olsa escreveu:
> > > On Thu, Nov 27, 2014 at 11:53:00AM -0200, Arnaldo Carvalho de Melo wrote:
> > > > Em Thu, Nov 27, 2014 at 11:56:03AM +0100, Ingo Molnar escreveu:
> > > > > Arnaldo, I suppose the fix will go upstream via your tree, as a 
> > > > > pull request for v3.18 fixes?
> > 
> > > > Right, I can do that.
> > 
> > > > And I agree with the "expected" for events that are out of the current
> > > > reordering window, i.e. we can't insert something into previous windows,
> > > > so those are, humm, what would be a good name:
> > > > stats->out_of_reordering_window, while stats->reordered, would be for
> > > > events that were found out of order, but were successfully sorted as
> > > > part of a flush operation, right?
> >  
> > > the forced flush is when we find out we crossed the allowed allocation
> > > space for the samples queue.. so we take the half of the sorted queue
> > > and flush it.. for this case we break the flushing logic and we might
> > 
> > Well, we make it more likely than without a forced flush to find out of
> > order events, because the window suddenly became smaller, its like we
> > found a FLUSH event right there, no?
 
> yep, still I dont see the need to count those 2 cases separately,
> both these types (of out of order event) have same implications
> for the report

Ok, I misundertood it when thinking it was about reordered events inside
a flush window versus events for a previous, closed flush window.

Yeah, if we detect events for a previous flush window in a forced flush
or in a normal flush, its all the same: events we can't consider anymore
because they are for a closed (old) flush window.

- Arnaldo
 
> jirka
> 
> > 
> > > (probably just in theory) get out of order events
> >  
> > > but IMO both cases of out of order event are equal.. we dont do
> > > anything special for forced flushed AFAIK
> > 
> > - Arnaldo
