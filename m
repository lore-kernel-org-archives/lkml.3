Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3EFIt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:49:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:21591 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab3EFIt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:49:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,620,1363158000"; 
   d="scan'208";a="308831333"
Message-ID: <51876E92.3010300@intel.com>
Date: Mon, 06 May 2013 16:49:22 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
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
Subject: Re: [PATCH v5 1/7] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-2-git-send-email-alex.shi@intel.com> <CAPM31R+4Ar5FFGSgfts76qNiQ5GMpPk7wkuj1fwsFrugVwnLfQ@mail.gmail.com>
In-Reply-To: <CAPM31R+4Ar5FFGSgfts76qNiQ5GMpPk7wkuj1fwsFrugVwnLfQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:24 PM, Paul Turner wrote:
>> >         /*
>> >          * CFS Load tracking
>> >          * Under CFS, load is tracked on a per-entity basis and aggregated up.
>> > @@ -242,8 +236,7 @@ struct cfs_rq {
>> >         u64 runnable_load_avg, blocked_load_avg;
>> >         atomic64_t decay_counter, removed_load;
>> >         u64 last_decay;
>> > -#endif /* CONFIG_FAIR_GROUP_SCHED */
>> > -/* These always depend on CONFIG_FAIR_GROUP_SCHED */
> We should perhaps replace this with a comment that these are only
> needed to aggregate the point-wise representation in the
> FAIR_GROUP_SCHED case.
> 

Is the comments ok? :)

/* runnable related variables only used in FAIR_GROUP_SCHED */

-- 
Thanks
    Alex
