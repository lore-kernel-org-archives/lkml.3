Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaIPDJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:09:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaIPDJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:09:17 -0400
Date: Mon, 15 Sep 2014 22:01:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v5 11/12] sched: replace capacity_factor by utilization
Message-ID: <20140915200159.GE2840@worktop.localdomain>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-12-git-send-email-vincent.guittot@linaro.org>
 <20140911161517.GA3190@worktop.ger.corp.intel.com>
 <CAKfTPtDFuzxzGBKi_n6v_F8FUkQ84MW+dQBX4WNXo-o54mksGA@mail.gmail.com>
 <20140914194156.GC2832@worktop.localdomain>
 <20140915114229.GB3037@worktop.localdomain>
 <alpine.LFD.2.11.1409151451540.8647@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1409151451540.8647@knanqh.ubzr>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:07:44PM -0400, Nicolas Pitre wrote:
> On Mon, 15 Sep 2014, Peter Zijlstra wrote:

> Let's suppose a task running on a 1GHz CPU producing a load of 100.
> 
> The same task on a 100MHz CPU would produce a load of 1000 because that 
> CPU is 10x slower.  So to properly evaluate the load of a task when 
> moving it around, we want to normalize its load based on the CPU 
> performance.  In this case the correction factor would be 0.1.
> 
> Given those normalized loads, we need to scale CPU capacity as well.  If 
> the 1GHz CPU can handle 50 of those tasks it has a capacity of 5000.
> 
> In theory the 100MHz CPU could handle only 5 of those tasks, meaning it 
> has a normalized capacity of 500, but only if the load metric is already 
> normalized as well.
> 
> Or am I completely missing the point here?

So I was thinking of the usage as per the next patch; where we decide if
a cpu is 'full' or not based on the utilization measure. For this
measure we're not interested in inter CPU relations at all, and any use
of capacity scaling simply doesn't make sense.

But I think you asking this question shows a 'bigger' problem in that
the Changelogs are entirely failing at describing the actual problem and
proposed solution. Because if that were clear, I don't think we would be
having this particular discussion.
