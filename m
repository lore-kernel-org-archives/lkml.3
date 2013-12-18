Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3LRO4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:56:21 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:36119 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3LRO4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:56:20 -0500
Date: Wed, 18 Dec 2013 15:56:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Message-ID: <20131218145610.GE18464@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
 <20131217232100.GC19211@linux.vnet.ibm.com>
 <20131218141348.GA18464@localhost.localdomain>
 <20131218142240.GP19211@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218142240.GP19211@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 06:22:40AM -0800, Paul E. McKenney wrote:
> > 
> > Exactly, the interrupt alone is sufficient and the tick is reevaluated
> > on irq_exit().
> 
> But if that is the case, why do you need the change to scheduler_ipi()
> in patch 07/13?  Just having received any sort of IPI should suffice.

Because scheduler_ipi() conditionally calls irq_enter() and irq_exit()
(I wonder if that's a good idea btw, is that here to deal with spurious
scheduler IPIs of some sort?)

And it's convenient because it can be called anywhere, even when irqs
are disabled, unlike kernel/smp.c IPIs.

But I agree it's kind of an abuse of scheduler_ipi() here. Well I'm going
to develop that in my answers to Peter as he has concerns precisely about that.

Thanks.
