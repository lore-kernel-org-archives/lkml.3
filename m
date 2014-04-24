Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbaDXR3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:29:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbaDXR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:29:42 -0400
Date: Thu, 24 Apr 2014 19:29:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
Message-ID: <20140424172933.GU13658@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
 <5358E417.8090503@linux.vnet.ibm.com>
 <20140424120415.GS11096@twins.programming.kicks-ass.net>
 <20140424124438.GT13658@twins.programming.kicks-ass.net>
 <1398358417.3509.11.camel@j-VirtualBox>
 <20140424171453.GZ11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424171453.GZ11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 07:14:53PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 24, 2014 at 09:53:37AM -0700, Jason Low wrote:
> > 
> > So I thought that the original rationale (commit 1bd77f2d) behind
> > updating rq->next_balance in idle_balance() is that, if we are going
> > idle (!pulled_task), we want to ensure that the next_balance gets
> > calculated without the busy_factor.
> > 
> > If the rq is busy, then rq->next_balance gets updated based on
> > sd->interval * busy_factor. However, when the rq goes from "busy"
> > to idle, rq->next_balance might still have been calculated under
> > the assumption that the rq is busy. Thus, if we are going idle, we
> > would then properly update next_balance without the busy factor
> > if we update when !pulled_task.
> > 
> 
> Its late here and I'm confused!
> 
> So the for_each_domain() loop calculates a new next_balance based on
> ->balance_interval (which has that busy_factor on, right).

Not right, ->balance_interval is the base interval. rebalance_domains()
doesn't update it.

