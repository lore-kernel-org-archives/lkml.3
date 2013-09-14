Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3INSxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 14:53:24 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:56639 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab3INSxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 14:53:23 -0400
MIME-Version: 1.0
In-Reply-To: <1379173186-11944-1-git-send-email-vdavydov@parallels.com>
References: <1379173186-11944-1-git-send-email-vdavydov@parallels.com>
From: Paul Turner <pjt@google.com>
Date: Sat, 14 Sep 2013 11:52:51 -0700
Message-ID: <CAPM31RLygqU-Ck4Rru1ZQid+Hu9AY0Ag9wkTaA50f7yo0udVYQ@mail.gmail.com>
Subject: Re: [PATCH] sched: Fix task_h_load calculation
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 8:39 AM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> Patch a003a2 (sched: Consider runnable load average in move_tasks())
> sets all top-level cfs_rqs' h_load to rq->avg.load_avg_contrib, which is
> always 0. This mistype leads to all tasks having weight 0 when load
> balancing in a cpu-cgroup enabled setup. There obviously should be sum
> of weights of all runnable tasks there instead. Fix it.
>

load_avg_contrib is the weight that
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  kernel/sched/fair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9b3fe1c..13abc29 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4242,7 +4242,7 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
>         } Once we'v Once we've made it that e made it that
>
>         if (!se) {
> -               cfs_rq->h_load = rq->avg.load_avg_contrib;
> +               cfs_rq->h_load = cfs_rq->runnable_load_avg;

Looks good.

Reviewed-by: Paul Turner <pjt@google.com>

>                 cfs_rq->last_h_load_update = now;
>         }
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
