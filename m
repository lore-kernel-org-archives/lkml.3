Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3EINNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:13:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:8850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab3EINNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:13:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,641,1363158000"; 
   d="scan'208";a="334289502"
Message-ID: <518BA108.8070802@intel.com>
Date: Thu, 09 May 2013 21:13:44 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com> <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com> <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com> <20130507095715.GE4068@e103034-lin> <5188DFEF.6010403@intel.com> <CAPM31R+x3h0b_r4uFkg_SMnkp0AWA6QRAQuDRducycHnFdG5Xw@mail.gmail.com> <20130508113442.GB6803@dyad.programming.kicks-ass.net> <518B5CC8.6070601@intel.com> <CAPM31RKQ0dXTWK6qgMPd6u_0nsQ3jodSo6QdUNEc4T0S9dCu_Q@mail.gmail.com>
In-Reply-To: <CAPM31RKQ0dXTWK6qgMPd6u_0nsQ3jodSo6QdUNEc4T0S9dCu_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 05:24 PM, Paul Turner wrote:
>> >
>> > +#ifdef CONFIG_SMP
>> > +void set_task_runnable_avg(struct task_struct *p)
>> > +{
>> > +       u64 slice;
>> > +
>> > +       slice = sched_slice(task_cfs_rq(p), &p->se);
>> > +       p->se.avg.runnable_avg_sum = slice;
>> > +       p->se.avg.runnable_avg_period = slice;
> This needs to be >> 10 right?  sched_slice is in ns.

Yes, I omitted this.
> 
> We also still want to set load_avg_contrib right?

yes, and seem set it here seems better. :)
> 


-- 
Thanks
    Alex
