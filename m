Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaBZKB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:01:26 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:52754 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaBZKBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:01:21 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>
Cc: Juri Lelli <juri.lelli@gmail.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <341791393407342@web8h.yandex.ru>
References: <1393344328-16653-1-git-send-email-juri.lelli@gmail.com>
 <1393361805.12438.6.camel@HP-250-G1-Notebook-PC>
 <1393382258.5142.4.camel@marge.simpson.net> <20140226090700.GG18404@twins.programming.kicks-ass.net> <341791393407342@web8h.yandex.ru>
Subject: Re: [PATCH] sched/rt: fix rt timer activation/deactivation
MIME-Version: 1.0
Message-Id: <71821393408874@web8h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 26 Feb 2014 14:01:14 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



26.02.2014, 13:35, "Kirill Tkhai" <tkhai@yandex.ru>:
> 26.02.2014, 13:07, "Peter Zijlstra" <peterz@infradead.org>:
>
>> šOn Wed, Feb 26, 2014 at 03:37:38AM +0100, Mike Galbraith wrote:
>>> ššBTW, I noticed you can no longer turn the turn the noisy thing off since
>>> ššwe grew DL. šI added an old SGI boot parameter to tell it to go away.
>> šYou're talking about the rt badnwidth timer, right?
>>
>> šš1) why won't it go away with DL added?
>
> We know nothing about rt_time and rt_runtime values, when we are doing
> update_curr_dl().
>
> rt_time maybe not zero, so we increment rt_time.
>
> rt_rq->rt_runtime maybe less than maximum available for RT(and for dl too),
> because someone could borrow a part of rt_runtime during previous
> balance_runtime().
>
> If dl task uses all available runtime, we always will have "idle = 0"
>
> ššššššššif (rt_rq->rt_time || rt_rq->rt_nr_running)
> ššššššššššššššššidle = 0;
>
> in do_sched_rt_period_timer(). Timer will be restarted.
>
> This is boundary case, of course.

I wrote this in assumtion, that patch like Juri's is applied
[https://lkml.org/lkml/2014/2/25/307].

In current tip.git state above is always.


>> šš2) it should never appear when !rt_bandwidth_enabled(), so if you set
>> ššsysctl_sched_rt_runtime to -1 all this should go away already, no extra
>> ššpatches required.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
