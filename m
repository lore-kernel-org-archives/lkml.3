Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaDZOul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 10:50:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:46342 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaDZOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 10:50:40 -0400
Date: Sat, 26 Apr 2014 16:50:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
Message-ID: <20140426145034.GL26782@laptop.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398455654.2102.29.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:54:14PM -0700, Jason Low wrote:
> Preeti mentioned that sd->balance_interval is changed during load_balance().
> Should we also consider updating the interval in rebalance_domains() after
> calling load_balance(),

Yeah, that might make sense.

> and also taking max_load_balance_interval into account
> in the updates for next_balance in idle_balance()?

I was thinking that max_load_balance_interval thing was mostly about the
*busy_factor thing, but sure, can't hurt to be consistent and always do
it.

> If so, how about the something like the below change which also introduces
> get_sd_balance_interval() to obtain the sd's balance interval, and have both
> update_next_balance() and rebalance_domains() use that function.

Yes, that looks good.

Can you send it with a proper changelog?
