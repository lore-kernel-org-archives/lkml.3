Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934965AbaGYAEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:04:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:39942 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934753AbaGYAEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:04:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,727,1400050800"; 
   d="scan'208";a="578625421"
Subject: Re: [PATCH 4/5] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        tkhai@yandex.ru
In-Reply-To: <1406028628.3526.22.camel@tkhai>
References: <20140722102425.29682.24086.stgit@tkhai>
	 <1406028628.3526.22.camel@tkhai>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jul 2014 17:04:11 -0700
Message-ID: <1406246651.2970.841.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 15:30 +0400, Kirill Tkhai wrote:
> Bad situation:
> 
> double_lock_balance() drops busiest_rq lock. The busiest_rq is *busiest*,
> and a lot of tasks and context switches there. We are dropping the lock
> and waiting for it again.
> 
> Let's just detach the task and once finally unlock it!
> 
> Warning: this admits unlocked using of can_migrate_task(), throttled_lb_pair(),
> and task_hot(). I added comments about that.
> 

Wonder if we should also consider removing double_lock_balance usage
from rt.c and deadline.c? Then those two schedulers will also not
lock both the source and destination queues at the same time
for load balancing.

Tim

