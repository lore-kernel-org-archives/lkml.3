Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3ARUrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:47:49 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55436 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3ARUrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <1354727440-20157-1-git-send-email-dinggnu@gmail.com>
References: <1354727440-20157-1-git-send-email-dinggnu@gmail.com>
Date: Fri, 18 Jan 2013 21:47:47 +0100
X-Google-Sender-Auth: -5kfdDWzn4PWOXQQ9gvbqYEEN4E
Message-ID: <CAM3j68rOMRdrovAkWdwfB477W+efMC1uGkbHNjz+kRz4LMaXag@mail.gmail.com>
Subject: Re: [PATCH] sched: fix compilation warning
From: Cong Ding <dinggnu@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Cong Ding <dinggnu@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this patch still queued or...?

- cong

On Wed, Dec 5, 2012 at 6:10 PM, Cong Ding <dinggnu@gmail.com> wrote:
> the following compilation warning is caused by Commit-ID:
> c566e8e9e44b72b53091da20e2dedefc730f2ee2
>
> kernel/sched/debug.c: In function ‘print_cfs_rq’:
> kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
> ‘long int’, but argument 4 has type ‘long long int’ [-Wformat]
> kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
> ‘long int’, but argument 3 has type ‘long long int’ [-Wformat]
>
> where function atomic64_read returns long long int, but %ld was used in the
> printf
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  kernel/sched/debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 2cd3c1b..83ec463 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -222,7 +222,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>                         cfs_rq->runnable_load_avg);
>         SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
>                         cfs_rq->blocked_load_avg);
> -       SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
> +       SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
>                         atomic64_read(&cfs_rq->tg->load_avg));
>         SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
>                         cfs_rq->tg_load_contrib);
> --
> 1.7.4.5
>
