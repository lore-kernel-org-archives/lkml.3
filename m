Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3ENAv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:51:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:60139 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab3ENAv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,666,1363158000"; 
   d="scan'208";a="336659484"
Message-ID: <51918A9C.1010002@intel.com>
Date: Tue, 14 May 2013 08:51:40 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [patch v6 6/8] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-7-git-send-email-alex.shi@intel.com> <20130513140625.GA15136@twins.programming.kicks-ass.net>
In-Reply-To: <20130513140625.GA15136@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 10:06 PM, Peter Zijlstra wrote:
>> >  static void update_cpu_load_active(struct rq *this_rq)
>> >  {
>> > +	unsigned long load;
>> > +
>> > +#ifdef CONFIG_SMP
>> > +	load = this_rq->cfs.runnable_load_avg;
>> > +#else
>> > +	load = this_rq->load.weight;
>> > +#endif
>> >  	/*
>> >  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
> This just smells like you want a helper function... :-)

Yes, thanks for point out this!
> 
> Also it doesn't apply anymore due to Paul Gortemaker moving some of this
> stuff about.

Will rebase on this. Thanks again! :)

-- 
Thanks
    Alex
