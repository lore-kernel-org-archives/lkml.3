Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaHKGSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 02:18:11 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:56058 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaHKGSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 02:18:10 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2014 02:18:09 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "lkp@01.org" <lkp@01.org>
In-Reply-To: <20140810152914.GA11947@redhat.com>
References: <20140809143034.GA28345@localhost> <20140809184616.GQ9918@twins.programming.kicks-ass.net> <20140810152914.GA11947@redhat.com>
Subject: Re: [sched] Out of memory: Kill process 2999 (rc) score 9 or sacrifice child
MIME-Version: 1.0
Message-Id: <3568281407737493@web29j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 11 Aug 2014 10:11:33 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



10.08.2014, 19:31, "Oleg Nesterov" <oleg@redhat.com>:
> On 08/09, Peter Zijlstra wrote:
>> šThat would suggest we're failing to do the TASK_DEAD thing properly, and
>> šARGH! bloody obvious why, see the this_rq() comment right before the
>> šfinish_task_switch() call in context_switch().
>
> Off-topic, but perhaps we can make this a bit more clear?
>
> Hmm. But after I actually did this change I can't understand if it makes
> this more clean or uglifies the code. See the patch below.
>
> OTOH, "int cpu" in __schedule() looks pointless and should die? Both
> rcu_note_context_switch() and wq_worker_sleeping() can use
> raw_smp_processor_id() ? In fact I think wq_worker_sleeping() doesn't
> need the "task" argument too.
>
> And... Doesn't schedule_tail() need preempt_enable() before
> finish_task_switch() ? IOW, shouldn't it do
>
> šššššššš#ifndef __ARCH_WANT_UNLOCKED_CTXSW
> ššššššššššššššššpreempt_disable();
> šššššššš#endif
> ššššššššššššššššfinish_task_switch();
> ššššššššššššššššpost_schedule(rq);
>
> ššššššššššššššššpreempt_enable();
>
> or I am totally confused?

You're sure, this was discussed here:

https://lkml.org/lkml/2014/2/14/243
