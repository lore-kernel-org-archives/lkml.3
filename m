Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaG3IFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:05:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:49831 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaG3IFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:05:02 -0400
Message-ID: <1406707485.3600.32.camel@tkhai>
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <tkhai@yandex.ru>,
        <linux-kernel@vger.kernel.org>, <nicolas.pitre@linaro.org>,
        <pjt@google.com>, <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>
Date: Wed, 30 Jul 2014 12:04:45 +0400
In-Reply-To: <20140729161928.GA31298@redhat.com>
References: <20140726145508.6308.69121.stgit@localhost>
	 <20140726145912.6308.32554.stgit@localhost>
	 <20140728080122.GL6758@twins.programming.kicks-ass.net>
	 <1406538338.23175.12.camel@tkhai> <1406627582.3600.9.camel@tkhai>
	 <20140729161928.GA31298@redhat.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 29/07/2014 в 18:19 +0200, Oleg Nesterov пишет:
> On 07/29, Kirill Tkhai wrote:
> >
> > How about this? Everything is inside task_rq_lock() now. The patch
> > became much less.
> 
> And with this change task_migrating() is not possible under
> task_rq_lock() or __task_rq_lock(). This means that 1/5 can be simplified
> too.

It seems to me it won't be useless anyway. In every place we underline
that a task is exactly queued or dequeued, so it's not necessary to remember
whether it is migrating or not. This is a cleanup, though it's big.

> __migrate_swap_task() is probably the notable exception...
> 
> Off-topic, but it takes 2 ->pi_lock's. This means it can deadlock with
> try_to_wake_up_local() (if a 3rd process does ttwu() and waits for
> ->on_cpu == 0). But I guess __migrate_swap_task() should not play with
> PF_WQ_WORKER threads.

Hmm.. I'm surprised, PF_WQ_WORKER threads may be unbound. But it seems
we still can't pass them to try_to_wake_up_local.

Regards,
Kirill

