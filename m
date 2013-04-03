Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab3DCBMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:12:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:60839 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab3DCBMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:12:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,396,1363158000"; 
   d="scan'208";a="279942816"
Message-ID: <515B81D6.6010006@intel.com>
Date: Wed, 03 Apr 2013 09:11:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch v6 10/21] sched: get rq potential maximum utilization
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-11-git-send-email-alex.shi@intel.com> <CAKfTPtAb1byoZRJZPfvGGgQBEVDCNya3tC6NF83v0khiGV9dDw@mail.gmail.com>
In-Reply-To: <CAKfTPtAb1byoZRJZPfvGGgQBEVDCNya3tC6NF83v0khiGV9dDw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 10:38 PM, Vincent Guittot wrote:
>> +static unsigned int max_rq_util(int cpu)
>> > +{
>> > +       struct rq *rq = cpu_rq(cpu);
>> > +       unsigned int rt_util = scale_rt_util(cpu);
>> > +       unsigned int cfs_util;
>> > +       unsigned int nr_running;
>> > +
>> > +       cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
>> > +                       : (FULL_UTIL - rt_util);
> rt_util and rq->util don't use the same computation algorithm so the
> results are hardly comparable or addable. In addition, some RT tasks
> can have impacted the rq->util, so they will be accounted in both
> side.

Thanks Vincent!

Yes, rt_util calculated with different way, but it has very similar
meaning with rq->util. So compare them make sense.

Yes, the rq->util and rt_util have some overlap, so we need to remove
the overlap part, otherwise the total utlization of this cpu will beyond
100%. that's not make sense. And since RT task always has higher
priority than cfs task, here I keep the RT utilization and yield the cfs
utilization.
> 
> Vincent
> 


-- 
Thanks Alex
