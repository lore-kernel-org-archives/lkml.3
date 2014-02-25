Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBYQUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:20:39 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55805 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaBYQUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:20:38 -0500
Date: Tue, 25 Feb 2014 17:20:56 +0100
From: Juri Lelli <juri.lelli@gmail.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <peterz@infradead.org>, <mingo@redhat.com>
Subject: Re: [PATCH] sched/deadline: Cleanup RT leftovers from
 {inc/dec}_dl_migration
Message-Id: <20140225172056.27f2091bcb0cb077281dcc45@gmail.com>
In-Reply-To: <1393343543.4089.5.camel@tkhai>
References: <1393343543.4089.5.camel@tkhai>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014 19:52:23 +0400
Kirill Tkhai <ktkhai@parallels.com> wrote:

> 
> In deadline class we do not have group scheduling.
> 
> So, let's remove unnecessary
> 
> 	X = X;
> 
> equations.
> 

Thanks!

- Juri

> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Juri Lelli <juri.lelli@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/sched/deadline.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index ef96edc..2c28437 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -135,7 +135,6 @@ static void update_dl_migration(struct dl_rq *dl_rq)
>  static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
>  {
>  	struct task_struct *p = dl_task_of(dl_se);
> -	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
>  
>  	if (p->nr_cpus_allowed > 1)
>  		dl_rq->dl_nr_migratory++;
> @@ -146,7 +145,6 @@ static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
>  static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
>  {
>  	struct task_struct *p = dl_task_of(dl_se);
> -	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
>  
>  	if (p->nr_cpus_allowed > 1)
>  		dl_rq->dl_nr_migratory--;
> 
> 
> 
