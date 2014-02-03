Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBCJzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:55:11 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:35905 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBCJzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:55:09 -0500
Date: Mon, 3 Feb 2014 10:53:02 +0100
From: Henrik Austad <henrik@austad.us>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/core: fix sched_rt_global_validate
Message-ID: <20140203095302.GA13242@austad.us>
References: <1391186607-11247-1-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391186607-11247-1-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 05:43:27PM +0100, Juri Lelli wrote:
> Don't compare sysctl_sched_rt_runtime against sysctl_sched_rt_period if
> the former is equal to RUNTIME_INF, otherwise disabling -rt bandwidth
> management always fails.
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
>  kernel/sched/core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 210a12a..5c0a304 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7477,7 +7477,8 @@ static int sched_rt_global_validate(void)
>  	if (sysctl_sched_rt_period <= 0)
>  		return -EINVAL;
>  
> -	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
> +	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
> +		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
>  		return -EINVAL;

Won't this be caught by the test above?

#define RUNTIME_INF ((u64)~0ULL)

which means that if sysctl_sched_rt_runtime is set to RUNTIME_INF, it will 
trigger on the previous test, and the first part of this test will always 
be true.

Or have I suffered catastrophic monday-morning braindamage?

-- 
Henrik Austad
