Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaDYB1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:27:08 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:35663 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaDYB1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:27:07 -0400
Message-ID: <1398389099.8470.37.camel@j-VirtualBox>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Date: Thu, 24 Apr 2014 18:24:59 -0700
In-Reply-To: <20140424165219.GX11096@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
	 <20140424071541.GZ26782@laptop.programming.kicks-ass.net>
	 <1398357789.3509.6.camel@j-VirtualBox>
	 <20140424165219.GX11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 18:52 +0200, Peter Zijlstra wrote:
> On Thu, Apr 24, 2014 at 09:43:09AM -0700, Jason Low wrote:
> > If the below patch is what you were referring to, I believe this
> > can help too. This was also something that I was testing out before
> > we went with those patches which compares avg_idle with idle balance
> > cost. I recall seeing somewhere around a +7% performance improvement
> > in at least least 1 of the AIM7 workloads. I can do some more testing
> > with this.
> 
> Yes, exactly that.
> 
> I can't remember the details, but I suspect we feared the less agressive
> idle balance due to that patch (it will only pull a single task, instead
> of multiple) would cause more idle_balance invocations and thereby
> decrease throughput.
> 
> So I suppose something with _many_ bursty threads which leads to severe
> inequalities would be the workload to trigger that.
> 
> Not sure we've ever seen that.. maybe Mike remembers, he seems to have a
> head for such details.

Okay, so running the AIM7 fserver workload, I didn't see any noticeable
performance gains with having move_tasks() pull at most one task. The
+7% performance improvement that I saw was without the idle balance cost
patches. I think that with those idle balance cost patches, there aren't
as much benefits with this patch, and allowing more than 1 task to be
pulled in move_task(), like we have now, may be the best option.


