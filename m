Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3AZAp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:45:27 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56431 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3AZApZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:45:25 -0500
MIME-Version: 1.0
In-Reply-To: <1353057890-24234-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1353057890-24234-1-git-send-email-lig.fnst@cn.fujitsu.com>
Date: Sat, 26 Jan 2013 01:45:23 +0100
Message-ID: <CAFTL4hzLu5RN-PSuP6NRwx2sMKXh5OZ7gNqLnUQQvKTK4n9i1Q@mail.gmail.com>
Subject: Re: [PATCH]cputime: make bool type for steal ticks
From: Frederic Weisbecker <fweisbec@gmail.com>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/16 liguang <lig.fnst@cn.fujitsu.com>:
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  kernel/sched/cputime.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 81b763b..d2c24c1 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -282,7 +282,7 @@ static __always_inline bool steal_account_process_tick(void)
>                 this_rq()->prev_steal_time += st * TICK_NSEC;
>
>                 account_steal_time(st);
> -               return st;
> +               return !!st;

I would expect gcc to perform the semantic "!!" cast implicitly. I
just did some basic tests locally and it does.
I prefer to be paranoid and not do any assumption though, unless I'm
told gcc always guarantees this correct implicit cast. I'm queuing
this patch and will send it to Ingo.

Thanks!

>         }
>  #endif
>         return false;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
