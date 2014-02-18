Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaBRLC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:02:28 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55901 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaBRLC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:02:26 -0500
Message-ID: <53033DBB.107@gmail.com>
Date: Tue, 18 Feb 2014 12:02:19 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]sched/deadline: Remove useless dl_nr_total
References: <368631392675853@web20h.yandex.ru>
In-Reply-To: <368631392675853@web20h.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/17/2014 11:24 PM, Kirill Tkhai wrote:
> In deadline class we do not have group scheduling like in RT.
> 
> dl_nr_total is the same as dl_nr_running. So, one of them should
> be removed.
> 

Thanks!

- Juri

> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Juri Lelli <juri.lelli@gmail.com> 
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/sched/deadline.c | 4 +---
>  kernel/sched/sched.h    | 1 -
>  2 files changed, 1 insertion(+), 4 deletions(-)
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index ed31ef6..7a0db95 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -121,7 +121,7 @@ static inline void dl_clear_overload(struct rq *rq)
>  
>  static void update_dl_migration(struct dl_rq *dl_rq)
>  {
> -	if (dl_rq->dl_nr_migratory && dl_rq->dl_nr_total > 1) {
> +	if (dl_rq->dl_nr_migratory && dl_rq->dl_nr_running > 1) {
>  		if (!dl_rq->overloaded) {
>  			dl_set_overload(rq_of_dl_rq(dl_rq));
>  			dl_rq->overloaded = 1;
> @@ -137,7 +137,6 @@ static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
>  	struct task_struct *p = dl_task_of(dl_se);
>  	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
>  
> -	dl_rq->dl_nr_total++;
>  	if (p->nr_cpus_allowed > 1)
>  		dl_rq->dl_nr_migratory++;
>  
> @@ -149,7 +148,6 @@ static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
>  	struct task_struct *p = dl_task_of(dl_se);
>  	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
>  
> -	dl_rq->dl_nr_total--;
>  	if (p->nr_cpus_allowed > 1)
>  		dl_rq->dl_nr_migratory--;
>  
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 1bf34c2..6a00804 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -444,7 +444,6 @@ struct dl_rq {
>  	} earliest_dl;
>  
>  	unsigned long dl_nr_migratory;
> -	unsigned long dl_nr_total;
>  	int overloaded;
>  
>  	/*
> 
