Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197Ab3DSLrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:47:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52187
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968126Ab3DSLrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:47:39 -0400
Message-ID: <1366372036.24945.1.camel@laptop>
Subject: Re: [PATCH Resend v6] sched: fix wrong rq's runnable_avg update
 with rt tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, pjt@google.com, rostedt@goodmis.org,
        fweisbec@gmail.com, efault@gmx.de
Date: Fri, 19 Apr 2013 13:47:16 +0200
In-Reply-To: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
References: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 18:34 +0200, Vincent Guittot wrote:
> The current update of the rq's load can be erroneous when RT tasks are
> involved
> 
> The update of the load of a rq that becomes idle, is done only if the avg_idle
> is less than sysctl_sched_migration_cost. If RT tasks and short idle duration
> alternate, the runnable_avg will not be updated correctly and the time will be
> accounted as idle time when a CFS task wakes up.
> 
> A new idle_enter function is called when the next task is the idle function
> so the elapsed time will be accounted as run time in the load of the rq,
> whatever the average idle time is. The function update_rq_runnable_avg is
> removed from idle_balance.
> 
> When a RT task is scheduled on an idle CPU, the update of the rq's load is
> not done when the rq exit idle state because CFS's functions are not
> called. Then, the idle_balance, which is called just before entering the
> idle function, updates the rq's load and makes the assumption that the
> elapsed time since the last update, was only running time.
> 
> As a consequence, the rq's load of a CPU that only runs a periodic RT task,
> is close to LOAD_AVG_MAX whatever the running duration of the RT task is.
> 
> A new idle_exit function is called when the prev task is the idle function
> so the elapsed time will be accounted as idle time in the rq's load.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks Vince!

