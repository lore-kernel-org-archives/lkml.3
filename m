Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaAWMcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:32:53 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17995 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751681AbaAWMcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:32:51 -0500
Date: Thu, 23 Jan 2014 12:32:52 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Mike Galbraith <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
Message-ID: <20140123123252.GC19029@e103034-lin>
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
 <1390282399-17091-2-git-send-email-alex.shi@linaro.org>
 <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com>
 <52DF802D.4030608@linaro.org>
 <20140122160901.GW13532@twins.programming.kicks-ass.net>
 <1390414208.2866.11.camel@j-VirtualBox>
 <52E0BB75.2080102@linaro.org>
 <20140123095443.GQ30183@twins.programming.kicks-ass.net>
 <52E0F3BF.5020904@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E0F3BF.5020904@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 10:49:35AM +0000, Alex Shi wrote:
> On 01/23/2014 05:54 PM, Peter Zijlstra wrote:
> > On Thu, Jan 23, 2014 at 02:49:25PM +0800, Alex Shi wrote:
> >> On 01/23/2014 02:10 AM, Jason Low wrote:
> >>>>>>>  	P64(avg_idle);
> >>>>>>> +	P64(max_idle_balance_cost);
> >>>>>>>  #endif
> >>>>>>>   	P(ttwu_count);
> >>>>>
> >>>>> Not also the per-sd value in sd_alloc_ctl_domain_table() ?
> >>> Yeah, tracking the sd->max_newidle_lb_cost can also be useful.
> >>>
> >>>
> >>
> >> Thanks for suggestion!
> >>
> >> I thought the sd->max_newidle_lb_cost keep changing. But yes, it's
> >> still meaningful. 
> >> BTW, in the pandaboard ES, sd balance cost is about 1~2ms.
> > 
> > That's an insane amount of time for only 2 cpus.
> 
> maybe, :(
> 
> but it is the data.
> $ cat /proc/sys/kernel/sched_domain/cpu0/domain0/max_newidle_lb_cost
> 1873393

What sort of workload are you running? It seems rather extreme.

I did a quick test on TC2 and got max_newidle_lb_cost in the range
~7000-80000 when having a constantly running task on each cpu for a few
seconds.

I also traced curr_cost just to get an idea of the cost of idle_balance.
I get an average cost across all five cpus of around 7000.

Morten
