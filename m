Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3KKTrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:47:08 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57286 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3KKTrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:47:02 -0500
From: bsegall@google.com
To: Michal Nazarewicz <mpn@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH] sched: fair: avoid integer overflow
References: <1384112521-25177-1-git-send-email-mpn@google.com>
Date: Mon, 11 Nov 2013 11:46:59 -0800
In-Reply-To: <1384112521-25177-1-git-send-email-mpn@google.com> (Michal
	Nazarewicz's message of "Sun, 10 Nov 2013 20:42:01 +0100")
Message-ID: <xm26fvr2souk.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Nazarewicz <mpn@google.com> writes:

> From: Michal Nazarewicz <mina86@mina86.com>
>
> sa->runnable_avg_sum is of type u32 but after shifting it by NICE_0_SHIFT
> bits it is promoted to u64.  This of course makes no sense, since the
> result will never be more then 32-bit long.  Casting sa->runnable_avg_sum
> to u64 before it is shifted, fixes this problem.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Ben Segall <bsegall@google.com>

> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index df77c60..50f1e170 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2153,7 +2153,7 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
>  	long contrib;
>  
>  	/* The fraction of a cpu used by this cfs_rq */
> -	contrib = div_u64(sa->runnable_avg_sum << NICE_0_SHIFT,
> +	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
>  			  sa->runnable_avg_period + 1);
>  	contrib -= cfs_rq->tg_runnable_contrib;
