Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3IKCAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:00:01 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37519 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3IKCAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:00:00 -0400
Message-ID: <522FCE9D.4010707@amacapital.net>
Date: Tue, 10 Sep 2013 18:59:57 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/7] sched: Add NEED_RESCHED to the preempt_count
References: <20130910130811.507933095@infradead.org> <20130910132011.116593485@infradead.org>
In-Reply-To: <20130910132011.116593485@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 06:08 AM, Peter Zijlstra wrote:
> In order to combine the preemption and need_resched test we need to
> fold the need_resched information into the preempt_count value.
> 
> We keep the existing TIF_NEED_RESCHED infrastructure in place but at 3
> sites test it and fold its value into preempt_count; namely:
> 
>  - resched_task() when setting TIF_NEED_RESCHED on the current task
>  - scheduler_ipi() when resched_task() sets TIF_NEED_RESCHED on a
>                    remote task it follows it up with a reschedule IPI
>                    and we can modify the cpu local preempt_count from
>                    there.
>  - cpu_idle_loop() for when resched_task() found tsk_is_polling().


It looks like the intel_idle code can get confused if TIF_NEED_RESCHED
is set but the preempt resched bit is not -- the need_resched call
between monitor and mwait won't notice TIF_NEED_RESCHED.

Is this condition possible?

--Andy

