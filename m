Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaEEPGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:06:11 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46520 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbaEEPGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:06:09 -0400
Date: Mon, 5 May 2014 17:06:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        khilman@linaro.org, tglx@linutronix.de, axboe@fb.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140505150558.GC2099@localhost.localdomain>
References: <tip-72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61@git.kernel.org>
 <20140505123706.GP17778@laptop.programming.kicks-ass.net>
 <20140505145256.GA2099@localhost.localdomain>
 <20140505145815.GQ26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505145815.GQ26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 04:58:15PM +0200, Peter Zijlstra wrote:
> On Mon, May 05, 2014 at 04:52:59PM +0200, Frederic Weisbecker wrote:
> > > Should we instead do irq_work_queue_on() ?
> > 
> > I would really much prefer that yeah. But if we do that, expect some added overhead on the local
> > irq_work_queue() path though. irq_work_raise can't use local cmpxchg ops anymore.
> > 
> > Or we can have a different pending raise system for remote irq work.
> > 
> > I can try something.
> 
> Loosing that local cmpxchg shouldn't be a problem, I don't  thnk this is
> a particularly hot path.

Then the conversion is easy since most of the irq work code should
already work for remote queuing.

I'll come up with a patch soon.

Thanks.
