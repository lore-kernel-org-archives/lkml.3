Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3HPQwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:52:44 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:53430 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3HPQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:52:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130815111959.GQ24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
	<20130815111959.GQ24092@twins.programming.kicks-ass.net>
Date: Sat, 17 Aug 2013 01:52:43 +0900
Message-ID: <CAAmzW4Nxt0=teMQ425ps6WAPP6gaVzihn_iUL3r8T4-tP4tXXQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] sched: factor out code to should_we_balance()
From: JoonSoo Kim <js1304@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

2013/8/15 Peter Zijlstra <peterz@infradead.org>:
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5120,11 +5120,8 @@ static int load_balance(int this_cpu, st
>
>         schedstat_inc(sd, lb_count[idle]);
>
> -       if (!should_we_balance(&env)) {
> -               *should_balance = 0;
> +       if (!(*should_balance = should_we_balance(&env)))
>                 goto out_balanced;
> -       } else
> -               *should_balance = 1;
>
>  redo:
>         group = find_busiest_group(&env);
>

Looks better!

Thanks!
