Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaJCNFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:05:39 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:52416 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaJCNFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:05:36 -0400
Message-ID: <1412341531.5128.16.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched,idle: teach select_idle_sibling about idle
 states
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Date: Fri, 03 Oct 2014 15:05:31 +0200
In-Reply-To: <20141003075012.GF10583@worktop.programming.kicks-ass.net>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
	 <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
	 <542B277D.7050103@redhat.com>
	 <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr>
	 <20141002131548.6cd377d5@cuia.bos.redhat.com>
	 <1412317384.5149.19.camel@marge.simpson.net>
	 <20141003075012.GF10583@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 09:50 +0200, Peter Zijlstra wrote: 
> On Fri, Oct 03, 2014 at 08:23:04AM +0200, Mike Galbraith wrote:

> > A generic boo hiss aimed in the general direction of all of this let's
> > go look at every possibility on every wakeup stuff.  Less is more.
> 
> I hear you, can you see actual slowdown with the patch? While the worst
> case doesn't change, it does make the average case equal to the worst
> case iteration -- where we previously would average out at inspecting
> half the CPUs before finding an idle one, we'd now always inspect all of
> them in order to compare all idle ones on their properties.
> 
> Also, with the latest generation of Haswell Xeons having 18 cores (36
> threads) this is one massively painful loop for sure.

Yeah, the things are getting too damn big.  I didn't try the patch and
measure anything, my gut instantly said "nope, not worth it".
  
> I'm just not sure what to do about it.. I suppose we can artificially
> split it into smaller groups, but I bet that'll hurt some, but if we can
> show it gains more we might still be able to do it. The only real
> problem is actual numbers/workloads (isn't it always) :/
> 
> One thing I suppose we could try is keeping a 'busy' flag at the
> llc domain which is set when all CPUs are busy (we'll clear it from
> new_idle) that way we can avoid the entire iteration if we know its
> pointless.

On one of those huge packages, heck, even on a 8 core that could save a
substantial number of busy box cycles.

-Mike

