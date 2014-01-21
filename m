Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaAUOvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:51:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaAUOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:51:30 -0500
Date: Tue, 21 Jan 2014 15:51:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
Message-ID: <20140121145105.GE3694@twins.programming.kicks-ass.net>
References: <52DE6FCE.2050708@siemens.com>
 <20140121140113.GL30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121140113.GL30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:01:13PM +0100, Peter Zijlstra wrote:
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

I dug about a bit, I borrowed that code from:

lkml.kernel.org/r/1277348698-17311-3-git-send-email-ying.huang@intel.com

Huang Ying, can you explain to Jan why you do the wait afterwards?
