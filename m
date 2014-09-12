Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaILSGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:06:01 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56596 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaILSF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:05:58 -0400
Date: Fri, 12 Sep 2014 20:05:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 0/8] nohz: Fix nohz kick irq work on tick v2
Message-ID: <20140912180547.GB5824@lerouge>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
 <20140911082812.GU6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911082812.GU6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:28:12AM +0200, Peter Zijlstra wrote:
> On Wed, Sep 10, 2014 at 11:33:20PM +0200, Frederic Weisbecker wrote:
> 
> > Frederic Weisbecker (7):
> >       nohz: Move nohz full init call to tick init
> >       irq_work: Force raised irq work to run on irq work interrupt
> >       x86: Tell irq work about self IPI support
> >       arm: Tell irq work about self IPI support
> >       arm64: Tell irq work about self IPI support
> >       nohz: Consolidate nohz full init code
> >       nohz: nohz full depends on irq work self IPI support
> > 
> > Peter Zijlstra (1):
> >       irq_work: Introduce arch_irq_work_has_interrupt()
> 
> Looks ok to me.
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Intel? :-) Wow.

Thanks a lot!

Note, I fear I'll have to turn the static_cpu_has into cpu_has. The
alternatives code which initialize all static_cpu_has() things
is called from check_bugs() in start_kernel() which is way after
IRQs are enabled for the 1st time. irq_work_tick() has many opportunities
to run in between.
