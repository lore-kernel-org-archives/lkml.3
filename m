Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaAGNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:16:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57773 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAGNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:16:21 -0500
Date: Tue, 7 Jan 2014 14:15:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Alex Shi <alex.shi@linaro.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
Message-ID: <20140107131523.GX3694@twins.programming.kicks-ass.net>
References: <1386061556-28233-5-git-send-email-alex.shi@linaro.org>
 <20131217141012.GG10134@e103034-lin>
 <20131217153809.GP21999@twins.programming.kicks-ass.net>
 <52B2F5D0.2050707@linaro.org>
 <20131220111926.GA11605@e103034-lin>
 <52BAF292.1070404@linaro.org>
 <20140102160404.GA3000@e103034-lin>
 <52CAB12B.4090701@linaro.org>
 <20140107125518.GE2936@e103034-lin>
 <20140107125930.GW31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107125930.GW31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:59:30PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 12:55:18PM +0000, Morten Rasmussen wrote:
> > My understanding is that should_we_balance() decides which cpu is
> > eligible for doing the load balancing for a given domain (and the
> > domains above). That is, only one cpu in a group is allowed to load
> > balance between the local group and other groups. That cpu would
> > therefore be reponsible for pulling enough load that the groups are
> > balanced even if it means temporarily overloading itself. The other cpus
> > in the group will take care of load balancing the extra load within the
> > local group later.
> 
> Correct.

On that; one of the things I wanted to (and previously did attempt but
failed) is trying to rotate this cpu. Currently its always the first cpu
(of the group) and that gives a noticeable bias.

If we could slowly rotate the cpu that does this that would alleviate
both the load and cost bias.

One thing I was thinking of is keeping a global counter maybe:
 'x := jiffies >> n'
might be good enough and using the 'x % nr_cpus_in_group'-th cpu
instead.

Then again, these are micro issue and not a lot of people complain
about this.
