Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3GOVNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:13:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49771 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3GOVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:13:30 -0400
Date: Mon, 15 Jul 2013 23:12:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130715211230.GG23818@dyad.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <51E166C8.3000902@linux.intel.com>
 <20130715195914.GC23818@dyad.programming.kicks-ass.net>
 <51E45E8B.705@linux.intel.com>
 <20130715210650.GF23818@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715210650.GF23818@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:06:50PM +0200, Peter Zijlstra wrote:
> OK, but isn't that part of why the micro controller might not make you go
> faster even if you do program a higher P state?
> 
> But yes, I understand this issue in the 'traditional' cpufreq sense. There's no
> point in ramping the speed if all you do is stall more.
> 
> But I was under the impression the 'hardware' was doing this. If not then we
> need the whole go-faster and go-slower thing and places to call them and means
> to determine to call them etc.


So with the scheduler measuring cpu utilization we could say to go-faster when
u>0.8 and go-slower when u<0.75 or so. Lacking any better metrics like the
stall stuff etc.

So I understand that ondemand spends quite a lot of time 'sampling' what the
system does while the scheduler mostly already knows this. It also has problems
because of the whole sampling thing, either it samples too often and becomes
too expensive/disruptive or it samples too little and misses world+dog.

I was hoping we could do better.


