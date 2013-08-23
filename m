Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3HWEvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:51:45 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65201 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3HWEvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:51:44 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-c5-5216ea5ea92e
Date: Fri, 23 Aug 2013 13:51:54 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 02/10] sched: Factor out code to should_we_balance()
Message-ID: <20130823045154.GB22605@lge.com>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.157603641@infradead.org>
 <CAPM31RJcao-Gx0Ts_ZRPm+ASGBiqRkLm2EFNYJUMHM8PQF=EUQ@mail.gmail.com>
 <20130822104257.GH31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822104257.GH31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 12:42:57PM +0200, Peter Zijlstra wrote:
> > >
> > > +redo:
> > 
> > One behavioral change worth noting here is that in the redo case if a
> > CPU has become idle we'll continue trying to load-balance in the
> > !new-idle case.
> > 
> > This could be unpleasant in the case where a package has a pinned busy
> > core allowing this and a newly idle cpu to start dueling for load.
> > 
> > While more deterministically bad in this case now, it could racily do
> > this before anyway so perhaps not worth worrying about immediately.
> 
> Ah, because the old code would effectively redo the check and find the
> idle cpu and thereby our cpu would no longer be the balance_cpu.
> 
> Indeed. And I don't think this was an intentional change. I'll go put
> the redo back before should_we_balance().

Ah, yes.
It isn't my intention. Please fix it.

Thanks.
