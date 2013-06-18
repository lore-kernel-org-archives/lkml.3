Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab3FRRqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:46:20 -0400
Received: from forward1h.mail.yandex.net ([84.201.187.146]:60056 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab3FRRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:46:18 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20130618172805.GC16094@twins.programming.kicks-ass.net>
References: <1981131371569812@web20h.yandex.ru> <20130618172805.GC16094@twins.programming.kicks-ass.net>
Subject: Re: [PATCH 1/2] sched: Add schedule_(raw_)spin_unlock and schedule_(raw_)spin_unlock_irq
MIME-Version: 1.0
Message-Id: <15591371577574@web20h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Jun 2013 21:46:14 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



18.06.2013, 21:28, "Peter Zijlstra" <peterz@infradead.org>:
> On Tue, Jun 18, 2013 at 07:36:52PM +0400, Kirill Tkhai wrote:
>
>> šHelpers for replacement repeating patterns:
>>
>> š1)spin_unlock(lock);
>> šššschedule();
>> š2)spin_unlock_irq(lock);
>> šššschedule();
>
> I just noticed this; the existing schedule_preempt_disabled() is
> equivalent to:
>
> ššpreempt_enable()
> ššschedule()
> ššpreempt_disable()
>
> So I somewhat expected these new primitives to be:
>
> ššspin_unlock()
> ššschedule()
> ššspin_lock()
>
> Now I haven't actually looked at the usage patch to see what the
> converted sites look like (thanks for adding that one though!).
>
> My OCD just triggered on the preemption and locked schedule calls having
> different semantics.

They have different semantic and different ending.

Many places (as you can see from the second patch) need additional actions
between schedule() and next spin_lock(). Several places don't do the second
lock.

Kirill
