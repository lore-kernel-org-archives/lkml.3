Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab3FSTGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:06:13 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:44356 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab3FSTGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:06:11 -0400
Date: Wed, 19 Jun 2013 21:06:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched/nohz: fix overflow error in
 scheduler_tick_max_deferment()
Message-ID: <20130619190604.GE21522@somewhere.redhat.com>
References: <1371599913-1232-1-git-send-email-khilman@linaro.org>
 <1371599913-1232-2-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371599913-1232-2-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:58:29PM -0700, Kevin Hilman wrote:
> The conversion of the max deferment from usecs to nsecs can easily
> overflow on platforms where a long is 32-bits.  To fix, cast the usecs
> value to u64 before multiplying by NSECS_PER_USEC.
> 
> This was discovered on 32-bit ARM platform when extending the max
> deferment value.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>

Right, if we make it tunable we need that patch.

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b5d3f99..b506722 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2765,7 +2765,7 @@ u64 scheduler_tick_max_deferment(void)
>  	if (time_before_eq(next, now))
>  		return 0;
>  
> -	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
> +	return (u64)jiffies_to_usecs(next - now) * NSEC_PER_USEC;
>  }
>  #endif
>  
> -- 
> 1.8.3
> 
