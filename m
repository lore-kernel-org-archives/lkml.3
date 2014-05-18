Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaESDVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 23:21:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:46876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaESDVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 23:21:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,864,1392192000"; 
   d="scan'208";a="513681329"
Date: Mon, 19 May 2014 03:16:56 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com
Subject: Re: [RFC PATCH 00/12 v1] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
Message-ID: <20140518191656.GB18818@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
 <20140505093744.GO17778@laptop.programming.kicks-ass.net>
 <20140506184637.GA17884@intel.com>
 <20140515145042.GO30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515145042.GO30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I should have just deleted all patches, for none of them has a
> changelog.
> 

It is my bad to not make changelogs in patches. The v2 has them, but I should
have made them since always.

> So all this cc crap only hooks into and modifies fair.c behaviour. There
> is absolutely no reason it should live anywhere else except fair.c
> 
> Secondly, the very last thing we need is more CONFIG_ goo, and you
> sprinkle #ifdef around like it was gold dust.
> 

Aggreed. I will change these.

> Thirdly, wth is wrong with the current per-task runtime accounting and
> why can't you extend/adapt that instead of duplicating the lot.
> 

Sure. As you and Vincent said, CC will take a ride of current tracking codes
instead of duplicating.

> Fourthly, I'm _never_ going to merge anything that hijacks the load
> balancer and does some random other thing. There's going to be a single
> load-balancer full stop.
> 
> Many people have expressed interest in a packing balancer (vs the
> spreading we currently default to). Some have even done patches.
> At the same time it seems very difficult to agree on _when_ packing
> makes sense. That said, when we do packing we should do it driven by the
> topology and policy, not by some compile time option.
>

I will make "Workload Consolidation" driven by topology and policy,
essentially it is already so, but sure the codes are not completely clean in
that regard.

> Lastly, if you'd done your homework and actually read some of the
> threads on the subject from say the past two years, you'd know pretty
> much all that already.
> 
> I'm not here to endlessly repeat myself and waste time staring at
> unchangelogged patches.
> 

This will not happen again.

> Anyway, there might or might not be useful ideas in there.. but its very
> hard to tell one way or another.

I think the above is mostly about "amenability" to scheduler codes.
Apparently, I am not doing it right. Will send another version to
make it less hard. Thanks for your time.

Yuyang
