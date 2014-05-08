Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaEHSGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:06:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaEHSGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:06:38 -0400
Date: Thu, 8 May 2014 20:06:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com
Subject: Re: [PATCH 2/2] sched: Fix next_balance logic in rebalance_domains()
 and idle_balance()
Message-ID: <20140508180629.GJ2844@laptop.programming.kicks-ass.net>
References: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
 <1398725155-7591-3-git-send-email-jason.low2@hp.com>
 <1399568364.2030.9.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1399568364.2030.9.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 09:59:24AM -0700, Jason Low wrote:
> On Mon, 2014-04-28 at 15:45 -0700, Jason Low wrote:
> > Currently, in idle_balance(), we update rq->next_balance when we pull_tasks. 
> > However, it is also important to update this in the !pulled_tasks case too.
> > 
> > When the CPU is "busy" (the CPU isn't idle), rq->next_balance gets computed
> > using sd->busy_factor (so we increase the balance interval when the CPU is
> > busy). However, when the CPU goes idle, rq->next_balance could still be set
> > to a large value that was computed with the sd->busy_factor.
> > 
> > Thus, we need to also update rq->next_balance in idle_balance() in the cases
> > where !pulled_tasks too, so that rq->next_balance gets updated without taking
> > the busy_factor into account when the CPU is about to go idle.
> > 
> > This patch makes rq->next_balance get updated independently of whether or
> > not we pulled_task. Also, we add logic to ensure that we always traverse
> > at least 1 of the sched domains to get a proper next_balance value for
> > updating rq->next_balance.
> > 
> > Additionally, since load_balance() modifies the sd->balance_interval, we
> > need to re-obtain the sched domain's interval after the call to
> > load_balance() in rebalance_domains() before we update rq->next_balance.
> > 
> > This patch adds and uses 2 new helper functions, update_next_balance() and
> > get_sd_balance_interval() to update next_balance and obtain the sched
> > domain's balance_interval. 
> 
> 
> Hi Peter,
> 
> I noticed that patch 1 is in tip, but not this patch 2. I was wondering
> what the current status with this [PATCH 2/2] is at the moment.

That made a particular .config explode, need to look at it.
