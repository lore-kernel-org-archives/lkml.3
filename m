Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3DVIAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:00:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43303 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3DVIAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:00:10 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-2c-5174ee065191
Date: Mon, 22 Apr 2013 17:01:35 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/6] correct load_balance()
Message-ID: <20130422080135.GA19454@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 03:01:34PM +0900, Joonsoo Kim wrote:
> Commit 88b8dac0 makes load_balance() consider other cpus in its group.
> But, there are some missing parts for this feature to work properly.
> This patchset correct these things and make load_balance() robust.
> 
> Others are related to LBF_ALL_PINNED. This is fallback functionality
> when all tasks can't be moved as cpu affinity. But, currently,
> if imbalance is not large enough to task's load, we leave LBF_ALL_PINNED
> flag and 'redo' is triggered. This is not our intention, so correct it.
> 
> These are based on v3.9-rc4.
> 
> Changelog
> v1->v2: Changes from Peter's suggestion
>  [4/6]: don't include a code to evaluate load value in can_migrate_task()
>  [5/6]: rename load_balance_tmpmask to load_balance_mask
>  [6/6]: not use one more cpumasks, use env's cpus for prevent to re-select
> 
> Joonsoo Kim (6):
>   sched: change position of resched_cpu() in load_balance()
>   sched: explicitly cpu_idle_type checking in rebalance_domains()
>   sched: don't consider other cpus in our group in case of NEWLY_IDLE
>   sched: move up affinity check to mitigate useless redoing overhead
>   sched: rename load_balance_tmpmask to load_balance_mask
>   sched: prevent to re-select dst-cpu in load_balance()
> 
>  kernel/sched/core.c |    4 +--
>  kernel/sched/fair.c |   67 +++++++++++++++++++++++++++------------------------
>  2 files changed, 38 insertions(+), 33 deletions(-)

Hello, Ingo and Peter.

Just ping for this patchset.
Please let me know what I have to do for merging this patchset.

Thanks.

> 
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
