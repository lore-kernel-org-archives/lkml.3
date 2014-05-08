Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaEHQ7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:59:31 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58554 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:59:30 -0400
Message-ID: <1399568364.2030.9.camel@j-VirtualBox>
Subject: Re: [PATCH 2/2] sched: Fix next_balance logic in
 rebalance_domains() and idle_balance()
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, jason.low2@hp.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com
Date: Thu, 08 May 2014 09:59:24 -0700
In-Reply-To: <1398725155-7591-3-git-send-email-jason.low2@hp.com>
References: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
	 <1398725155-7591-3-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 15:45 -0700, Jason Low wrote:
> Currently, in idle_balance(), we update rq->next_balance when we pull_tasks. 
> However, it is also important to update this in the !pulled_tasks case too.
> 
> When the CPU is "busy" (the CPU isn't idle), rq->next_balance gets computed
> using sd->busy_factor (so we increase the balance interval when the CPU is
> busy). However, when the CPU goes idle, rq->next_balance could still be set
> to a large value that was computed with the sd->busy_factor.
> 
> Thus, we need to also update rq->next_balance in idle_balance() in the cases
> where !pulled_tasks too, so that rq->next_balance gets updated without taking
> the busy_factor into account when the CPU is about to go idle.
> 
> This patch makes rq->next_balance get updated independently of whether or
> not we pulled_task. Also, we add logic to ensure that we always traverse
> at least 1 of the sched domains to get a proper next_balance value for
> updating rq->next_balance.
> 
> Additionally, since load_balance() modifies the sd->balance_interval, we
> need to re-obtain the sched domain's interval after the call to
> load_balance() in rebalance_domains() before we update rq->next_balance.
> 
> This patch adds and uses 2 new helper functions, update_next_balance() and
> get_sd_balance_interval() to update next_balance and obtain the sched
> domain's balance_interval. 


Hi Peter,

I noticed that patch 1 is in tip, but not this patch 2. I was wondering
what the current status with this [PATCH 2/2] is at the moment.


