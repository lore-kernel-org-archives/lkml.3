Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3LJHMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:12:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3LJHMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:12:03 -0500
Date: Tue, 10 Dec 2013 02:11:24 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386659484-8nauy0i4-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386483293-15354-11-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386483293-15354-11-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 11/12] sched/numa: drop unnecessary variable in
 task_weight
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386483293-15354-11-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 02:14:52PM +0800, Wanpeng Li wrote:
> Drop unnecessary total_faults variable in function task_weight to unify
> task_weight and group_weight.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  kernel/sched/fair.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 942e67b..df8b677 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -947,17 +947,10 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
>   */
>  static inline unsigned long task_weight(struct task_struct *p, int nid)
>  {
> -	unsigned long total_faults;
> -
> -	if (!p->numa_faults)
> -		return 0;
> -
> -	total_faults = p->total_numa_faults;
> -
> -	if (!total_faults)
> +	if (!p->numa_faults || !p->total_numa_faults)
>  		return 0;
>  
> -	return 1000 * task_faults(p, nid) / total_faults;
> +	return 1000 * task_faults(p, nid) / p->total_numa_faults;
>  }
>  
>  static inline unsigned long group_weight(struct task_struct *p, int nid)
> -- 
> 1.7.5.4
> 
