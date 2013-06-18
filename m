Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3FRR2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:28:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50966 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3FRR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:28:09 -0400
Date: Tue, 18 Jun 2013 19:28:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] sched: Add schedule_(raw_)spin_unlock and
 schedule_(raw_)spin_unlock_irq
Message-ID: <20130618172805.GC16094@twins.programming.kicks-ass.net>
References: <1981131371569812@web20h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1981131371569812@web20h.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 07:36:52PM +0400, Kirill Tkhai wrote:
> Helpers for replacement repeating patterns:
> 
> 1)spin_unlock(lock);
>   schedule();
> 2)spin_unlock_irq(lock);
>   schedule();
> 

I just noticed this; the existing schedule_preempt_disabled() is
equivalent to:

  preempt_enable()
  schedule()
  preempt_disable()

So I somewhat expected these new primitives to be:

  spin_unlock()
  schedule()
  spin_lock()

Now I haven't actually looked at the usage patch to see what the
converted sites look like (thanks for adding that one though!).

My OCD just triggered on the preemption and locked schedule calls having
different semantics.
