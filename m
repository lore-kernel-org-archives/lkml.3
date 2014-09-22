Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaIVGyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:54:19 -0400
Received: from forward2l.mail.yandex.net ([84.201.143.145]:46535 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaIVGyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:54:18 -0400
X-Yandex-Uniq: 9ff62807-ea51-47cb-8f77-ea4906c97c6f
Authentication-Results: smtp14.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1411368845.4942.2.camel@localhost.localdomain>
Subject: Re: [PATCH 1/3] sched: fix the task-group check in tg_has_rt_tasks()
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Sep 2014 10:54:05 +0400
In-Reply-To: <20140921193336.GA28618@redhat.com>
References: <20140921193336.GA28618@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вс, 21/09/2014 в 21:33 +0200, Oleg Nesterov пишет:
> tg_has_rt_tasks() wants to find an RT task in this task_group, but
> task_rq(p)->rt.tg wrongly checks the root rt_rq.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Kirill Tkhai <ktkhai@parallels.com>

> ---
>  kernel/sched/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index eee12b3..9023f56 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7354,7 +7354,7 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
>  	struct task_struct *g, *p;
>  
>  	for_each_process_thread(g, p) {
> -		if (rt_task(p) && task_rq(p)->rt.tg == tg)
> +		if (rt_task(p) && task_group(p) == tg)
>  			return 1;
>  	}
>  


