Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3FSIH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:07:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab3FSIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:07:16 -0400
Date: Wed, 19 Jun 2013 10:06:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislav Meduna <stano@meduna.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
Message-ID: <20130619080656.GF16094@twins.programming.kicks-ass.net>
References: <519D118B.6010306@zytor.com>
 <519D11BF.5000604@redhat.com>
 <519DCE2A.4010801@meduna.org>
 <519E095A.4000105@redhat.com>
 <519F24DD.5060700@meduna.org>
 <519F65DB.2020305@redhat.com>
 <51BE2F5C.8070408@meduna.org>
 <51C0B177.2000006@meduna.org>
 <CA+55aFwm-a0O-jvznYpXM4Ctf_jex+gcgELq_pqXL38Y6X-JPg@mail.gmail.com>
 <51C15F87.20100@meduna.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C15F87.20100@meduna.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 09:36:39AM +0200, Stanislav Meduna wrote:
> On 19.06.2013 07:20, Linus Torvalds wrote:
> 
> >> No crash in 2 days running with preempt none...
> > 
> > Is this UP?
> 
> Yes it is.
> 
> > There's the fast_tlb race that Peter fixed in commit 29eb77825cc7
> > ("arch, mm: Remove tlb_fast_mode()"). I'm not seeing how it would
> > cause infinite TLB faults, but it definitely causes potentially
> > incoherent TLB contents. And afaik it only happens with
> > CONFIG_PREEMPT, and on UP systems. Which sounds like it might match
> > your setup...
> 
> Oh, thank you for the pointer, this indeed looks interesting.
> 
> Unfortunately the patch massively does not apply to 3.4 which
> I am using and I know too little what all is involved here
> to backport it. I will test it when (if) it gets to the 3.4(-rt)
> (or when I find some spare time to play with the newer kernel
> on that system).

The easiest way to test for your system is to ensure tlb_fast_mode()
return an unconditional 0.
