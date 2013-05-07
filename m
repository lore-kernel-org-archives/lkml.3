Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab3EGFIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:08:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:29518 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436Ab3EGFIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:08:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="237859020"
Message-ID: <51888C28.8030401@intel.com>
Date: Tue, 07 May 2013 13:07:52 +0800
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
Subject: Re: [PATCH v5 2/7] sched: remove SMP cover for runnable variables
 in cfs_rq
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-3-git-send-email-alex.shi@intel.com> <CAPM31R+oBDRF4geM451-ySCtkU1NpqFT_R1mtB95jV-pnLBimQ@mail.gmail.com> <5187708A.20103@intel.com> <CAPM31R+-zeuquH7ozjjZEGX03aWoek1xJ5LgsaVP5j1WnxzzRw@mail.gmail.com>
In-Reply-To: <CAPM31R+-zeuquH7ozjjZEGX03aWoek1xJ5LgsaVP5j1WnxzzRw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 05:08 PM, Paul Turner wrote:
>> >
>> >
>> > Do you mean to move the rq->avg and task_group->load_avg into CONFIG_SMP?
> More generally:  Why do we need them in !CONFIG_SMP?
> 
> [ I was suggesting (potentially) using only rq->avg in the !CONFIG_SMP case. ]
> 
> 

Paul,
here is the patch according to your opinions. any comments? :)

---
>From 206957227ed899aa44fabeb9890117428103dd1e Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 6 May 2013 22:20:29 +0800
Subject: [PATCH 2/7] sched: move few runnable tg variables into CONFIG_SMP

The following 2 variables only used under CONFIG_SMP, so better to move
their definiation into CONFIG_SMP too.

        atomic64_t load_avg;
        atomic_t runnable_avg;

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9419764..c6634f1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -114,9 +114,11 @@ struct task_group {
 	unsigned long shares;
 
 	atomic_t load_weight;
+#ifdef	CONFIG_SMP
 	atomic64_t load_avg;
 	atomic_t runnable_avg;
 #endif
+#endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity **rt_se;
-- 
1.7.12

-- 
Thanks
    Alex
