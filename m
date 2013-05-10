Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3EJN6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:58:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:5677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3EJN6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:58:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334870215"
Message-ID: <518CFCE9.60105@intel.com>
Date: Fri, 10 May 2013 21:58:01 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
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
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-7-git-send-email-alex.shi@intel.com> <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com> <20130506150428.GD15446@dyad.programming.kicks-ass.net> <CAPM31RKqMGAvFh1JmUjCjBo4EJWqA39i8=YPiUw8GUkG9dj7Fw@mail.gmail.com> <51888E87.2090506@intel.com> <5189ACD2.1080105@intel.com> <518AFAC6.5010906@intel.com>
In-Reply-To: <518AFAC6.5010906@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 09:24 AM, Alex Shi wrote:
> Paul,
> 
> I am wondering if the following patch needed.
> The wakeuped migrated task will __synchronize_entity_decay(se); in migrate_task_fair,
> then it needs to set `se->avg.last_runnable_update -= (-se->avg.decay_count) << 20'
> before update_entity_load_avg, in order to avoid slept time is updated twice for 
> se.avg.load_avg_contrib in both __syncchronize and update_entity_load_avg.
> 
> but if the slept task is waked up from self cpu, it miss the last_runnable_update before
>  update_entity_load_avg(se, 0, 1), so the slept time was used twice in both functions.
> Is that right?

Would you like to give some comments on this, Paul?

-- 
Thanks
    Alex
