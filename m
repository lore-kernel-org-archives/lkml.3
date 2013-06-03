Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3FCGok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:44:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:22361 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3FCGog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:44:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249885468"
Message-ID: <51AC3B2C.9050209@intel.com>
Date: Mon, 03 Jun 2013 14:43:56 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: Re: [patch v7 0/8] sched: using runnable load avg in balance
References: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 03:01 PM, Alex Shi wrote:
> Anyway, since using runnable load avg in balance brings much benefit on
> performance and power. and this patch was reviewed for long time. 
> So maybe it's time to let it clobbered in some sub-maintain tree, like tip 
> or linux-next.  Any comments?
> 

Peter,
What's your opinion about this patchset? Are there sth missing? :)


The patchset git tree is here:
git@github.com:alexshi/power-scheduling.git runnablelb

> [patch v7 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [patch v7 2/8] sched: move few runnable tg variables into CONFIG_SMP
> [patch v7 3/8] sched: set initial value of runnable avg for new
> [patch v7 4/8] sched: fix slept time double counting in enqueue
> [patch v7 5/8] sched: update cpu load after task_tick.

Patch 2~5 are the bug fixing.
> [patch v7 6/8] sched: compute runnable load avg in cpu_load and
> [patch v7 7/8] sched: consider runnable load average in move_tasks

Only patch 6th/7th enable the runnable load in load balance.
> [patch v7 8/8] sched: remove blocked_load_avg in tg

According to test, the 8th patch has performance gain.

-- 
Thanks
    Alex
