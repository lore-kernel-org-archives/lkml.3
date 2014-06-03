Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaFDHvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:51:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:34532 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbaFDHvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,971,1392192000"; 
   d="scan'208";a="440675393"
Date: Wed, 4 Jun 2014 07:46:59 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, bsegall@google.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com
Subject: Re: [RFC PATCH 13/16 v3] Intercept wakeup/fork/exec load balancing
Message-ID: <20140603234659.GA24315@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-14-git-send-email-yuyang.du@intel.com>
 <20140603122702.GM30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603122702.GM30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 02:27:02PM +0200, Peter Zijlstra wrote:
> On Fri, May 30, 2014 at 02:36:09PM +0800, Yuyang Du wrote:
> > We intercept load balancing to contain the load and load balancing in
> > the consolidated CPUs according to our consolidating mechanism.
> > 
> > In wakeup/fork/exec load balaning, when to find the idlest sched_group,
> > we first try to find the consolidated group
> 
> Anything with intercept in is a complete non-starter. You still fully
> duplicate the logic.
> 
> You really didn't get anything I said, did you?
> 
> Please as to go back to square 1 and read again.
> 
> So take a step back and try and explain what and why you're doing
> things, also try and look at what other people are doing. If I see
> another patch from you within two weeks I'll simply delete it, there's
> no way you can read up and fix everything in such a short time.

Hi Peter,

Thanks for your reply, it hurts though, :(

I was concerned about what you said back, which should be this one:

PeterZ: Fourthly, I'm _never_ going to merge anything that hijacks the load balancer
and does some random other thing. There's going to be a single load-balancer
full stop.

But some explanation to this interception/hijack. It is driven by a sched
policy (SD_WORKLOAD_CONSOLIDATION) and the resulting effect of that policy if
enabled, or still part of the load balancer. Can't do/call it that way?

Thanks,
Yuyang
