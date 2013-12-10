Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3LJHBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:01:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab3LJHBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:01:44 -0500
Date: Tue, 10 Dec 2013 02:01:09 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386658869-2gttr64d-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386483293-15354-10-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386483293-15354-10-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 10/12] sched/numa: fix record hinting faults check
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 02:14:51PM +0800, Wanpeng Li wrote:
> Adjust numa_scan_period in task_numa_placement, depending on how much useful
> work the numa code can do. The local faults and remote faults should be used
> to check if there is record hinting faults instead of local faults and shared
> faults. This patch fix it.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Looks good to me.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  kernel/sched/fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b077f1b3..942e67b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1322,7 +1322,7 @@ static void update_task_scan_period(struct task_struct *p,
>  	 * completely idle or all activity is areas that are not of interest
>  	 * to automatic numa balancing. Scan slower
>  	 */
> -	if (local + shared == 0) {
> +	if (local + remote == 0) {
>  		p->numa_scan_period = min(p->numa_scan_period_max,
>  			p->numa_scan_period << 1);
>  
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
