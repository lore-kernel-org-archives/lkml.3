Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaD1QnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:43:02 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:44000 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbaD1Qm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:42:57 -0400
Message-ID: <1398703372.2009.8.camel@j-VirtualBox>
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Date: Mon, 28 Apr 2014 09:42:52 -0700
In-Reply-To: <20140426145034.GL26782@laptop.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
	 <5358E417.8090503@linux.vnet.ibm.com>
	 <20140424120415.GS11096@twins.programming.kicks-ass.net>
	 <20140424124438.GT13658@twins.programming.kicks-ass.net>
	 <1398358417.3509.11.camel@j-VirtualBox>
	 <20140424171453.GZ11096@twins.programming.kicks-ass.net>
	 <5359EDDB.4060409@linux.vnet.ibm.com>
	 <20140425094331.GF26782@laptop.programming.kicks-ass.net>
	 <1398455654.2102.29.camel@j-VirtualBox>
	 <20140426145034.GL26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-26 at 16:50 +0200, Peter Zijlstra wrote:
> On Fri, Apr 25, 2014 at 12:54:14PM -0700, Jason Low wrote:
> > Preeti mentioned that sd->balance_interval is changed during load_balance().
> > Should we also consider updating the interval in rebalance_domains() after
> > calling load_balance(),
> 
> Yeah, that might make sense.
> 
> > and also taking max_load_balance_interval into account
> > in the updates for next_balance in idle_balance()?
> 
> I was thinking that max_load_balance_interval thing was mostly about the
> *busy_factor thing, but sure, can't hurt to be consistent and always do
> it.
> 
> > If so, how about the something like the below change which also introduces
> > get_sd_balance_interval() to obtain the sd's balance interval, and have both
> > update_next_balance() and rebalance_domains() use that function.
> 
> Yes, that looks good.
> 
> Can you send it with a proper changelog?

Sure, I'll send a v2 patchset so that this applies with the other
patches. I also think it would be beneficial to split this change into 2
patches (the 1st patch fixes commit e5fc6611, and the 2nd patch changes
how next_balance gets updated).

