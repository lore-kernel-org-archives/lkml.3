Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3HAPv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:51:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab3HAPv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:51:56 -0400
Date: Thu, 1 Aug 2013 16:51:51 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/18] Basic scheduler support for automatic NUMA
 balancing V5
Message-ID: <20130801155151.GH2296@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <20130725103620.GM27075@twins.programming.kicks-ass.net>
 <20130731103052.GR2296@suse.de>
 <20130731104814.GA3008@twins.programming.kicks-ass.net>
 <20130731115719.GT2296@suse.de>
 <20130731153018.GD3008@twins.programming.kicks-ass.net>
 <20130731161141.GX2296@suse.de>
 <20130731163903.GG3008@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130731163903.GG3008@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 06:39:03PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 31, 2013 at 05:11:41PM +0100, Mel Gorman wrote:
> > RSS was another option it felt as arbitrary as a plain delay.
> 
> Right, it would avoid 'small' programs getting scanning done with the
> rationale that their cost isn't that large since they don't have much
> memory to begin with.
> 

Yeah, but it's not necessarily true. Whatever value we pick there can be
an openmp process that fits in there.

> The same can be said for tasks that don't run much -- irrespective of
> how much absolute runtime they've gathered.
> 
> Is there any other group of tasks that we do not want to scan?
> 

strcmp(p->comm, ....)


> Maybe if we can list all the various exclusions we can get to a proper
> quantifier that way.
> 
> So far we've got:
> 
>  - doesn't run long
>  - doesn't run much
>  - doesn't have much memory
> 

- does not have sysV shm sections

> > Should I revert 5bca23035391928c4c7301835accca3551b96cc2 with an
> > explanation that it potentially is completely useless in the purely
> > multi-process shared case?
> 
> Yeah I suppose so..

Will do.

-- 
Mel Gorman
SUSE Labs
