Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaBZRxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:53:13 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54902 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaBZRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:53:11 -0500
From: bsegall@google.com
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED
References: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com>
	<20140225205253.GB18404@twins.programming.kicks-ass.net>
	<530DCDC5.1060406@arm.com>
Date: Wed, 26 Feb 2014 09:53:09 -0800
In-Reply-To: <530DCDC5.1060406@arm.com> (Dietmar Eggemann's message of "Wed,
	26 Feb 2014 11:19:33 +0000")
Message-ID: <xm26a9ddiwvu.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dietmar Eggemann <dietmar.eggemann@arm.com> writes:

> On 25/02/14 20:52, Peter Zijlstra wrote:
>> On Tue, Feb 25, 2014 at 11:47:42AM +0000, Dietmar Eggemann wrote:
>>> +++ b/kernel/sched/sched.h
>>> @@ -630,7 +630,9 @@ struct rq {
>>>  	struct llist_head wake_list;
>>>  #endif
>>>  
>>> +#ifdef CONFIG_FAIR_GROUP_SCHED
>>>  	struct sched_avg avg;
>>> +#endif
>>>  };
>> 
>> There is already a CONFIG_FAIR_GROUP_SCHED #ifdef in that structure;
>> does it make sense to move this variable in there instead of adding yet
>> another #ifdef?
>> 
>
> I changed the patch accordingly.
>
> -- >8 --
> Subject: [PATCH] sched: put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED
>
> The struct sched_avg of struct rq is only used in case group
> scheduling is enabled inside __update_tg_runnable_avg() to update
> per-cpu representation of a task group.  I.e. that there is no need to
> maintain the runnable avg of a rq in the !CONFIG_FAIR_GROUP_SCHED case.
>
> This patch guards struct sched_avg of struct rq and
> update_rq_runnable_avg() with CONFIG_FAIR_GROUP_SCHED.
>
> There is an extra empty definition for update_rq_runnable_avg()
> necessary for the !CONFIG_FAIR_GROUP_SCHED && CONFIG_SMP case.
>
> The function print_cfs_group_stats() which prints out struct sched_avg
> of struct rq is already guarded with CONFIG_FAIR_GROUP_SCHED.
>
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Ben Segall <bsegall@google.com>
