Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab3LFVKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:10:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab3LFVKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:10:10 -0500
Date: Fri, 06 Dec 2013 16:09:36 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386364176-it8qfec-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386321136-27538-4-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386321136-27538-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386321136-27538-4-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 4/6] sched/numa: use wrapper function task_node to get
 node which task is on
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386321136-27538-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:12:14PM +0800, Wanpeng Li wrote:
> Use wrapper function task_node to get node which task is on.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Maybe we have another line to apply the same fix:

./kernel/sched/debug.c:142:     SEQ_printf(m, " %d", cpu_to_node(task_cpu(p)));

But anyway,

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya Horiguchi

> ---
>  kernel/sched/fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 56bcc0c..e0b1063 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1216,7 +1216,7 @@ static int task_numa_migrate(struct task_struct *p)
>  	 * elsewhere, so there is no point in (re)trying.
>  	 */
>  	if (unlikely(!sd)) {
> -		p->numa_preferred_nid = cpu_to_node(task_cpu(p));
> +		p->numa_preferred_nid = task_node(p);
>  		return -EINVAL;
>  	}
>  
> @@ -1283,7 +1283,7 @@ static void numa_migrate_preferred(struct task_struct *p)
>  	p->numa_migrate_retry = jiffies + HZ;
>  
>  	/* Success if task is already running on preferred CPU */
> -	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
> +	if (task_node(p) == p->numa_preferred_nid)
>  		return;
>  
>  	/* Otherwise, try migrate to a CPU on the preferred node */
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
