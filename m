Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaLSLUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:20:44 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaLSLUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:20:37 -0500
Date: Fri, 19 Dec 2014 12:20:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141219112019.GI30905@twins.programming.kicks-ass.net>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
 <20141215121227.GZ29390@twins.programming.kicks-ass.net>
 <548FBA62.5090603@oracle.com>
 <20141216020948.GA6399@intel.com>
 <20141219002956.GA25405@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141219002956.GA25405@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 08:29:56AM +0800, Yuyang Du wrote:
> Subject: [PATCH] sched: Fix long and unsigned long multiplication error in effective_load
> 
> In effective_load, we have (long w * unsigned long tg->shares) / long W,
> when w is negative, it is cast to unsigned long and hence the product is
> insanely large. Fix this by casting tg->shares to long.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Yuyang Du <yuyang.du@intel.com>
> ---
>  kernel/sched/fair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index df2cdf7..6b99659 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4424,7 +4424,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>  		 * wl = S * s'_i; see (2)
>  		 */
>  		if (W > 0 && w < W)
> -			wl = (w * tg->shares) / W;
> +			wl = (w * (long)tg->shares) / W;
>  		else
>  			wl = tg->shares;


Oh, nice! thanks!
