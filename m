Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaG2Vzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:55:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63839 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaG2Vzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:55:46 -0400
Date: Tue, 29 Jul 2014 23:55:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 05/10] smp: Fast path check on IPI list
Message-ID: <20140729215536.GC14520@localhost.localdomain>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-6-git-send-email-fweisbec@gmail.com>
 <20140729120739.GX3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729120739.GX3935@laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 02:07:39PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 07:37:31PM +0200, Frederic Weisbecker wrote:
> > When we enqueue a remote irq work, we trigger the same IPI as those
> > raised by smp_call_function_*() family.
> > 
> > So when we receive such IPI, we check both irq_work and smp_call_function
> > queues. Thus if we trigger a remote irq work, we'll likely find the
> > smp_call_function queue empty unless we collide with concurrent enqueuers
> > but the probability is low.
> > 
> > Meanwhile, checking the smp_call_function queue can be costly because
> > we use llist_del_all() which relies on cmpxchg().
> 
> xchg()

It's still costly though as it's an atomic read/write with full barrier. I'll
update the comment meanwhile.
