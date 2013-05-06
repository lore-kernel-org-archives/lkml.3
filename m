Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3EFPHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:07:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:24029 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3EFPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="308991780"
Message-ID: <5187C740.9010202@intel.com>
Date: Mon, 06 May 2013 23:07:44 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 6/7] sched: consider runnable load average in move_tasks
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-7-git-send-email-alex.shi@intel.com> <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com>
In-Reply-To: <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:53 PM, Paul Turner wrote:
>> > +static unsigned long task_h_load_avg(struct task_struct *p)
>> > +{
>> > +       return div_u64(task_h_load(p) * (u64)p->se.avg.runnable_avg_sum,
>> > +                       p->se.avg.runnable_avg_period + 1);
> Similarly, I think you also want to at least include blocked_load_avg here.
> 
> More fundamentally:
> I suspect the instability from comparing these to an average taken on
> them will not give a representative imbalance weight.  While we should
> be no worse off than the present situation; we could be doing much
> better.
> 
> Consider that by not consuming {runnable, blocked}_load_avg directly
> you are "hiding" the movement from one load-balancer to the next.

Sure, sounds reasonable, I will try it.

-- 
Thanks
    Alex
