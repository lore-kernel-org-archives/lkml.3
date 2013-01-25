Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3AYQCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:02:11 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39017 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3AYQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:02:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359123276-15833-7-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-7-git-send-email-arnd@arndb.de>
From: Paul Turner <pjt@google.com>
Date: Fri, 25 Jan 2013 08:01:33 -0800
Message-ID: <CAPM31RJxuWDQ7Y0FPCjYKbNFmUG6dad1ZPQ+hS53dcGWUkWGBw@mail.gmail.com>
Subject: Re: [PATCH 06/19] sched/debug: fix format string for 32 bit platforms
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 6:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The type returned from atomic64_t can be either unsigned
> long or unsigned long long, depending on the architecture.
> Using a cast to unsigned long long lets us use the same
> format string for all architectures.
>
> Without this patch, building with scheduler debugging
> enabled results in:
>
> kernel/sched/debug.c: In function 'print_cfs_rq':
> kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'long long int' [-Wformat]
> kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Turner <pjt@google.com>
> ---
>  kernel/sched/debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 2cd3c1b..7ae4c4c 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -222,8 +222,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>                         cfs_rq->runnable_load_avg);
>         SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
>                         cfs_rq->blocked_load_avg);
> -       SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
> -                       atomic64_read(&cfs_rq->tg->load_avg));
> +       SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
> +                       (unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
>         SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
>                         cfs_rq->tg_load_contrib);
>         SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
> --
> 1.8.0
>

Looks good.

Reviewed-by: Paul Turner <pjt@google.com>
