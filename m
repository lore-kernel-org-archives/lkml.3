Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaAOJcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:32:46 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48708 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAOJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:32:43 -0500
Message-ID: <52D65423.2070706@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 17:25:55 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, raistlin@linux.it,
        juri.lelli@gmail.com
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org>
In-Reply-To: <52D64676.4040000@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011509-1618-0000-0000-000005439BC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Daniel

On 01/15/2014 04:27 PM, Daniel Lezcano wrote:
[snip]
> commit d50dde5a10f305253cbc3855307f608f8a3c5f73
> Author: Dario Faggioli <raistlin@linux.it>
> Date:   Thu Nov 7 14:43:36 2013 +0100
> 
>     sched: Add new scheduler syscalls to support an extended scheduling
> parameters ABI
> 
>     Add the syscalls needed for supporting scheduling algorithms
>     with extended scheduling parameters (e.g., SCHED_DEADLINE).

Will this do any helps?

Regards,
Michael Wang

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0326c06..bf4a6ed 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3464,6 +3464,10 @@ int sched_setscheduler(struct task_struct *p, int
policy,
                .sched_policy   = policy,
                .sched_priority = param->sched_priority
        };
+
+       if (fair_policy(policy))
+               attr.sched_nice = PRIO_TO_NICE(attr.sched_priority);
+
        return __sched_setscheduler(p, &attr, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
@@ -3494,6 +3498,10 @@ int sched_setscheduler_nocheck(struct task_struct
*p, int policy,
                .sched_policy   = policy,
                .sched_priority = param->sched_priority
        };
+
+       if (fair_policy(policy))
+               attr.sched_nice = PRIO_TO_NICE(attr.sched_priority);
+
        return __sched_setscheduler(p, &attr, false);
 }



> 
> 
> [ ... ]
> 
> 
>     Signed-off-by: Dario Faggioli <raistlin@linux.it>
>     [ Rewrote to use sched_attr. ]
>     Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
>     [ Removed sched_setscheduler2() for now. ]
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Link:
> http://lkml.kernel.org/r/1383831828-15501-3-git-send-email-juri.lelli@gmail.com
> 
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 

