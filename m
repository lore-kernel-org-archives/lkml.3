Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaAUXUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:20:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:4175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaAUXUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:20:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="470397520"
Message-ID: <1390346420.23634.5.camel@yhuang-dev>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 22 Jan 2014 07:20:20 +0800
In-Reply-To: <20140121145105.GE3694@twins.programming.kicks-ass.net>
References: <52DE6FCE.2050708@siemens.com>
	 <20140121140113.GL30183@twins.programming.kicks-ass.net>
	 <20140121145105.GE3694@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 15:51 +0100, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 03:01:13PM +0100, Peter Zijlstra wrote:
> > On Tue, Jan 21, 2014 at 02:02:06PM +0100, Jan Kiszka wrote:
> > > Hi all,
> > > 
> > > while trying to plug a race in the CPU hotplug code on xAPIC systems, I
> > > was analyzing IPI transmission patterns. The handlers in
> > > arch/x86/include/asm/ipi.h first wait for ICR, then send. In contrast,
> > > arch_irq_work_raise sends the self-IPI directly and then waits. This
> > > looks inconsistent. Is it intended?
> > > 
> > > BTW, the races are in wakeup_secondary_cpu_via_init and
> > > wakeup_secondary_cpu_via_nmi (lacking IRQ disable around ICR accesses).
> > > There we also send first, then wait for completion. But I guess that is
> > > due to the code originally only being used during boot. Will send fixes
> > > for those once the sync pattern is clear to me.
> > 
> > Could be I had no clue what I was doing and copy/pasted the code until
> > it compiled and ran.
> > 
> > In fact, I've got no clue what an ICR is.
> 
> I dug about a bit, I borrowed that code from:
> 
> lkml.kernel.org/r/1277348698-17311-3-git-send-email-ying.huang@intel.com
> 
> Huang Ying, can you explain to Jan why you do the wait afterwards?

I borrow the code from the original MCE report event code.

Andi, could you help us to explain it?

Best Regards,
Huang Ying


