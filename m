Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaAPSjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:39:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:61751 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750937AbaAPSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:39:08 -0500
Date: Thu, 16 Jan 2014 13:39:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH 0/2] preempt: Track unmatched preempt_enable() to
 preempt_disable()
Message-ID: <20140116133906.50bcbc93@gandalf.local.home>
In-Reply-To: <20140116174536.GB9655@laptop.programming.kicks-ass.net>
References: <20140116171824.748919700@goodmis.org>
	<20140116174536.GB9655@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 18:45:36 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jan 16, 2014 at 12:18:24PM -0500, Steven Rostedt wrote:
> 
> Didn't see anything horrible in there, so fine with me.
> 
> Another thing I recently ran into was:
> 
>   local_irq_disable();
>   preempt_disable();
>   local_irq_enable();
> 
>   local_irq_disable();
>   preempt_enable();
>   local_irq_enable();
> 
> I'm not sure any of our debugging catches that, I meant to extend
> lockdep, but maybe it could also be hooked into something else.

Hmm, what's wrong with the above?

Note, the preemptirqsoff tracer will trace that as not being
preemptible between that first local_irq_disable() to the
local_irq_enable(). In fact, that's basically what the preemptirqsoff
tracer was made for ;-)

-- Steve
