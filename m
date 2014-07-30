Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaG3V0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:26:12 -0400
Received: from forward3l.mail.yandex.net ([84.201.143.136]:36589 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaG3V0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:26:11 -0400
X-Yandex-Uniq: 897ce262-59ca-42c7-970d-aa26efae38e7
Authentication-Results: smtp2h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1406755550.18758.12.camel@localhost.localdomain>
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org, pjt@google.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Thu, 31 Jul 2014 01:25:50 +0400
In-Reply-To: <20140730144101.GA19337@redhat.com>
References: <20140726145508.6308.69121.stgit@localhost>
	 <20140726145912.6308.32554.stgit@localhost>
	 <20140728080122.GL6758@twins.programming.kicks-ass.net>
	 <1406538338.23175.12.camel@tkhai> <1406627582.3600.9.camel@tkhai>
	 <20140729161928.GA31298@redhat.com> <1406707485.3600.32.camel@tkhai>
	 <20140730144101.GA19337@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Ср, 30/07/2014 в 16:41 +0200, Oleg Nesterov пишет:
> On 07/30, Kirill Tkhai wrote:
> >
> > В Вт, 29/07/2014 в 18:19 +0200, Oleg Nesterov пишет:
> > > On 07/29, Kirill Tkhai wrote:
> > > >
> > > > How about this? Everything is inside task_rq_lock() now. The patch
> > > > became much less.
> > >
> > > And with this change task_migrating() is not possible under
> > > task_rq_lock() or __task_rq_lock(). This means that 1/5 can be simplified
> > > too.
> >
> > It seems to me it won't be useless anyway. In every place we underline
> > that a task is exactly queued or dequeued, so it's not necessary to remember
> > whether it is migrating or not. This is a cleanup, though it's big.
> 
> But, otoh, when you read the code which does "if (task_queued())" it is not
> clear whether this code knows that task_migrating() is not possible, or we
> should treat the task_migrating() state specially.
> 
> But I agree, this is subjective, I leave this to you and Peter.
> 
> > > __migrate_swap_task() is probably the notable exception...
> > >
> > > Off-topic, but it takes 2 ->pi_lock's. This means it can deadlock with
> > > try_to_wake_up_local() (if a 3rd process does ttwu() and waits for
> > > ->on_cpu == 0). But I guess __migrate_swap_task() should not play with
> > > PF_WQ_WORKER threads.
> >
> > Hmm.. I'm surprised, PF_WQ_WORKER threads may be unbound. But it seems
> > we still can't pass them to try_to_wake_up_local.
> 
> Why? See wq_worker_sleeping/try_to_wake_up_local in __schedule().
> 
> But perhaps I misunderstood you, and probably I was not clear. If
> wq_worker_sleeping() returns !NULL then both task should be local, surely
> we do not want to migrate them.

I mean it was surprising for me that PF_WQ_WORKER threads may be unbound...
I hope wq_worker_sleeping() does not return them.

Nothing important from me about this question.

