Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaDYFrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:47:05 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34510 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaDYFqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:46:50 -0400
Message-ID: <1398404806.7893.18.camel@marge.simpson.net>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Date: Fri, 25 Apr 2014 07:46:46 +0200
In-Reply-To: <1398396806.12047.6.camel@j-VirtualBox>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
	 <20140424071541.GZ26782@laptop.programming.kicks-ass.net>
	 <1398357789.3509.6.camel@j-VirtualBox>
	 <20140424165219.GX11096@twins.programming.kicks-ass.net>
	 <1398393955.5273.4.camel@marge.simpson.net>
	 <1398396806.12047.6.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 20:33 -0700, Jason Low wrote: 
> On Fri, 2014-04-25 at 04:45 +0200, Mike Galbraith wrote:
> > On Thu, 2014-04-24 at 18:52 +0200, Peter Zijlstra wrote: 
> > > On Thu, Apr 24, 2014 at 09:43:09AM -0700, Jason Low wrote:
> > > > If the below patch is what you were referring to, I believe this
> > > > can help too. This was also something that I was testing out before
> > > > we went with those patches which compares avg_idle with idle balance
> > > > cost. I recall seeing somewhere around a +7% performance improvement
> > > > in at least least 1 of the AIM7 workloads. I can do some more testing
> > > > with this.
> > > 
> > > Yes, exactly that.
> > > 
> > > I can't remember the details, but I suspect we feared the less agressive
> > > idle balance due to that patch (it will only pull a single task, instead
> > > of multiple) would cause more idle_balance invocations and thereby
> > > decrease throughput.
> > > 
> > > So I suppose something with _many_ bursty threads which leads to severe
> > > inequalities would be the workload to trigger that.
> > > 
> > > Not sure we've ever seen that.. maybe Mike remembers, he seems to have a
> > > head for such details.
> > 
> > I don't recall ever seeing such.
> 
> Hmmm, could commit: 1b9508f6831e (sched: Rate-limit newidle) be related
> to what Peter's referring to? The patch mentioned that the rate-limit
> benefited "sysbench oltp".

That's the opposite, was to prevent way too much idle balancing, which
was demolishing fast mover loads.

-Mike

