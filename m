Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3BYHMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:12:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:25265 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab3BYHMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 02:12:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,732,1355126400"; 
   d="scan'208";a="267111498"
Message-ID: <512B0EFA.3030903@intel.com>
Date: Mon, 25 Feb 2013 15:12:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 02/15] sched: set initial load avg of new forked task
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-3-git-send-email-alex.shi@intel.com> <51246B1A.8040100@intel.com> <5129F200.6080309@linux.vnet.ibm.com>
In-Reply-To: <5129F200.6080309@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 06:57 PM, Preeti U Murthy wrote:
>> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> > index 26058d0..1452e14 100644
>> > --- a/kernel/sched/core.c
>> > +++ b/kernel/sched/core.c
>> > @@ -1559,6 +1559,7 @@ static void __sched_fork(struct task_struct *p)
>> >  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>> >  	p->se.avg.runnable_avg_period = 0;
>> >  	p->se.avg.runnable_avg_sum = 0;
>> > +	p->se.avg.decay_count = 0;
>> >  #endif
>> >  #ifdef CONFIG_SCHEDSTATS
>> >  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>> > @@ -1646,6 +1647,8 @@ void sched_fork(struct task_struct *p)
>> >  		p->sched_reset_on_fork = 0;
>> >  	}
>> > 
> I think the following comment will help here.
> /* All forked tasks are assumed to have full utilization to begin with */


looks fine.

-- 
Thanks Alex
