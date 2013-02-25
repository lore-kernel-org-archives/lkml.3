Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab3BYE4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 23:56:25 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54177 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567Ab3BYE4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 23:56:24 -0500
X-AuditID: 9c93016f-b7b46ae000007f43-26-512aeef6d343
Date: Mon, 25 Feb 2013 13:56:59 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] correct load_balance()
Message-ID: <20130225045659.GB12158@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:48:33PM +0900, Joonsoo Kim wrote:
> Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> But, there are some missing parts for this feature to work properly.
> This patchset correct these things and make load_balance() robust.
> 
> Others are related to LBF_ALL_PINNED. This is fallback functionality
> when all tasks can't be moved as cpu affinity. But, currently,
> if imbalance is not large enough to task's load, we leave LBF_ALL_PINNED
> flag and 'redo' is triggered. This is not our intention, so correct it.
> 
> These are based on v3.8-rc7.
> 
> Joonsoo Kim (8):
>   sched: change position of resched_cpu() in load_balance()
>   sched: explicitly cpu_idle_type checking in rebalance_domains()
>   sched: don't consider other cpus in our group in case of NEWLY_IDLE
>   sched: clean up move_task() and move_one_task()
>   sched: move up affinity check to mitigate useless redoing overhead
>   sched: rename load_balance_tmpmask to load_balance_cpu_active
>   sched: prevent to re-select dst-cpu in load_balance()
>   sched: reset lb_env when redo in load_balance()
> 
>  kernel/sched/core.c |    9 +++--
>  kernel/sched/fair.c |  107 +++++++++++++++++++++++++++++----------------------
>  2 files changed, 67 insertions(+), 49 deletions(-)

Hello, Ingo and Peter.

Could you review this patch set?
Please let me know what I should do for merging this?

Thanks.

> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
