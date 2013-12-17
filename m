Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3LQPi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:38:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47259 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3LQPi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:38:27 -0500
Date: Tue, 17 Dec 2013 16:38:09 +0100
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
Message-ID: <20131217153809.GP21999@twins.programming.kicks-ass.net>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
 <1386061556-28233-5-git-send-email-alex.shi@linaro.org>
 <20131217141012.GG10134@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217141012.GG10134@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 02:10:12PM +0000, Morten Rasmussen wrote:
> > @@ -4135,7 +4141,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
> >  			if (local_group)
> >  				load = source_load(i);
> >  			else
> > -				load = target_load(i);
> > +				load = target_load(i, sd->imbalance_pct);
> 
> Don't you apply imbalance_pct twice here? Later on in
> find_idlest_group() you have:
> 
> 	if (!idlest || 100*this_load < imbalance*min_load)
> 		return NULL;
> 
> where min_load comes from target_load().

Yes! exactly! this doesn't make any sense.
