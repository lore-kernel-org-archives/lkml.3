Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaATJ3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:29:37 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39062 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaATJ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:29:35 -0500
Date: Mon, 20 Jan 2014 10:29:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140120092931.GA3836@gmail.com>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
 <20140116121955.GQ31570@twins.programming.kicks-ass.net>
 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
 <CAJvTdKnoNh2YAvtXraYxTct+8e6e_8Om9cAZGSTpy8UO=t=W4w@mail.gmail.com>
 <20140120082620.GB30183@twins.programming.kicks-ass.net>
 <52DCE4CF.2060605@zytor.com>
 <20140120091600.GW31570@twins.programming.kicks-ass.net>
 <52DCEAF4.3040902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DCEAF4.3040902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/20/2014 01:16 AM, Peter Zijlstra wrote:
> >>
> >> The difference is the STI!
> > 
> > So do the local_irq_enable(); mwait_idle_with_hints(0,0); thing.
> > 
> 
> No, that doesn't work.  The point of __sti_mwait() is that the STI 
> is the instruction immediately before the MWAIT, just like the 
> combination STI;HLT.  Since the execution of STI is always delayed 
> by one instruction, these two instructions form an atomic unit, 
> which means interrupts are enabled "after" we have entered MWAIT or 
> HLT.
> 
> > But that's entirely different from saying that core2 doesn't 
> > support mwait_idle_with_hints because its a different instruction.
> 
> If you think of STI;MWAIT as a "compound instruction" it kind of is. 
> Newer CPUs don't have to play that trick anymore, because there is a 
> flag to MWAIT which breaks us out of MWAIT on a pending interrupt 
> without having to actually enable interrupts at the point of the 
> MWAIT.

As a side note, at minimum the semantic and compatibility difference 
needs to be _very_ clearly present in the naming. Something like 
mwait_old_() or mwait_core2_(). That way such dependencies and 
assumptions don't get lost in code restructuring, etc.

Thanks,

	Ingo
