Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3H3Uos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:44:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:8500 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab3H3Uor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:44:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,993,1367996400"; 
   d="scan'208";a="289059092"
Date: Fri, 30 Aug 2013 13:44:45 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, acme@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts v4
Message-ID: <20130830204445.GF16724@tassilo.jf.intel.com>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
 <1377128846-977-2-git-send-email-andi@firstfloor.org>
 <20130830160215.GU31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830160215.GU31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 06:02:15PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 21, 2013 at 04:47:23PM -0700, Andi Kleen wrote:
> > @@ -1224,6 +1240,15 @@ again:
> >  		x86_pmu.drain_pebs(regs);
> >  	}
> >  
> > +	/*
> > +	 * To avoid spurious interrupts with perf stat always reset checkpointed
> > +	 * counters.
> > +	 *
> > +	 * XXX move somewhere else.
> > +	 */
> > +	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
> > +		status |= (1ULL << 2);
> > +
> >  	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
> >  		struct perf_event *event = cpuc->events[bit];
> >  
> 
> I'm sure I commented on that XXX thing.. 
> 
> Yep, right here:

Ok.

> 
>   http://marc.info/?l=linux-kernel&m=137638980210140
> 
> Sup?

I originally thought about precomputing the mask somewhere,
but it's not really that bad a place.

So can just drop the XXX comment. Ok?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
