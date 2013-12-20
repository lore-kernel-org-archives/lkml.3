Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3LTOp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:45:27 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38959 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3LTOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:45:26 -0500
Message-ID: <52B457EF.9060204@linaro.org>
Date: Fri, 20 Dec 2013 22:45:03 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
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
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org> <1386061556-28233-5-git-send-email-alex.shi@linaro.org> <20131217141012.GG10134@e103034-lin> <20131217153809.GP21999@twins.programming.kicks-ass.net> <52B2F5D0.2050707@linaro.org> <20131220111926.GA11605@e103034-lin>
In-Reply-To: <20131220111926.GA11605@e103034-lin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 07:19 PM, Morten Rasmussen wrote:
>> @@ -4132,10 +4137,10 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
>> >  
>> >  		for_each_cpu(i, sched_group_cpus(group)) {
>> >  			/* Bias balancing toward cpus of our domain */
>> > -			if (local_group)
>> > +			if (i == this_cpu)
> What is the motivation for changing the local_group load calculation?
> Now the load contributions of all cpus in the local group, except
> this_cpu, will contribute more as their contribution (this_load) is
> determined using target_load() instead.
> 
> If I'm not mistaken, that will lead to more frequent load balancing as
> the local_group bias has been reduced. That is the opposite of your
> intentions based on your comment in target_load().

Good catch. will reconsider this again. :)
> 
>> >  				load = source_load(i);
>> >  			else
>> > -				load = target_load(i);
>> > +				load = target_load(i, sd->imbalance_pct);
> You scale by sd->imbalance_pct instead of 100+(sd->imbalance_pct-100)/2
> that you removed above. sd->imbalance_pct may have been arbitrarily
> chosen in the past, but changing it may affect behavior. 
> 


-- 
Thanks
    Alex
