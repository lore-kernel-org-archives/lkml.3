Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab3GPKgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:36:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab3GPKgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:36:41 -0400
Date: Tue, 16 Jul 2013 12:35:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] sched: Avoid overloading CPUs on a preferred NUMA
 node
Message-ID: <20130716103536.GI23818@dyad.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-17-git-send-email-mgorman@suse.de>
 <20130715200321.GN17211@twins.programming.kicks-ass.net>
 <20130716082342.GF5055@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716082342.GF5055@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:23:42AM +0100, Mel Gorman wrote:
> On Mon, Jul 15, 2013 at 10:03:21PM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 15, 2013 at 04:20:18PM +0100, Mel Gorman wrote:
> > > ---
> > > +	src_eff_load = 100 + (imbalance_pct - 100) / 2;
> > > +	src_eff_load *= power_of(src_cpu);
> > > +	src_eff_load *= src_load + effective_load(tg, src_cpu, -weight, -weight);
> > 
> > So did you try with this effective_load() term 'missing'?
> > 
> 
> Yes, it performed worse in tests. Looking at it, I figured that it would
> have to perform worse unless effective_load regularly returns negative
> values.

In this case it would return negative, seeing as we put a negative in.
