Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaAUOLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:11:17 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64050 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaAUOLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:11:01 -0500
Date: Tue, 21 Jan 2014 15:10:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
Message-ID: <20140121141058.GA4559@gmail.com>
References: <52DE6FCE.2050708@siemens.com>
 <20140121140113.GL30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121140113.GL30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jan 21, 2014 at 02:02:06PM +0100, Jan Kiszka wrote:
> > Hi all,
> > 
> > while trying to plug a race in the CPU hotplug code on xAPIC systems, I
> > was analyzing IPI transmission patterns. The handlers in
> > arch/x86/include/asm/ipi.h first wait for ICR, then send. In contrast,
> > arch_irq_work_raise sends the self-IPI directly and then waits. This
> > looks inconsistent. Is it intended?
> > 
> > BTW, the races are in wakeup_secondary_cpu_via_init and
> > wakeup_secondary_cpu_via_nmi (lacking IRQ disable around ICR accesses).
> > There we also send first, then wait for completion. But I guess that is
> > due to the code originally only being used during boot. Will send fixes
> > for those once the sync pattern is clear to me.
> 
> Could be I had no clue what I was doing and copy/pasted the code until
> it compiled and ran.
> 
> In fact, I've got no clue what an ICR is.

APIC ICR = Interrupt Command Register - this is the MMIO-mapped 
register of the local APIC that (when written to) triggers the sending 
of IPIs and (when read from) shows the status how the IPI is going or 
whether a new IPI can be sent.

( Not to be confused with the APIC timer ICR, which is 'Initial Count
  Register' and does something entirely different. )

Thanks,

	Ingo
