Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbaDXQw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:52:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712AbaDXQw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:52:27 -0400
Date: Thu, 24 Apr 2014 18:52:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
Message-ID: <20140424165219.GX11096@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
 <20140424071541.GZ26782@laptop.programming.kicks-ass.net>
 <1398357789.3509.6.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398357789.3509.6.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 09:43:09AM -0700, Jason Low wrote:
> If the below patch is what you were referring to, I believe this
> can help too. This was also something that I was testing out before
> we went with those patches which compares avg_idle with idle balance
> cost. I recall seeing somewhere around a +7% performance improvement
> in at least least 1 of the AIM7 workloads. I can do some more testing
> with this.

Yes, exactly that.

I can't remember the details, but I suspect we feared the less agressive
idle balance due to that patch (it will only pull a single task, instead
of multiple) would cause more idle_balance invocations and thereby
decrease throughput.

So I suppose something with _many_ bursty threads which leads to severe
inequalities would be the workload to trigger that.

Not sure we've ever seen that.. maybe Mike remembers, he seems to have a
head for such details.
