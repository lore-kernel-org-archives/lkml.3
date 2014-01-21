Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaAUKr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:47:28 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45472 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaAUKrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:47:25 -0500
Date: Tue, 21 Jan 2014 11:47:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140121104721.GB4105@gmail.com>
References: <20140116121955.GQ31570@twins.programming.kicks-ass.net>
 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
 <CAJvTdKnoNh2YAvtXraYxTct+8e6e_8Om9cAZGSTpy8UO=t=W4w@mail.gmail.com>
 <20140120082620.GB30183@twins.programming.kicks-ass.net>
 <52DCE4CF.2060605@zytor.com>
 <20140120091600.GW31570@twins.programming.kicks-ass.net>
 <52DCEAF4.3040902@zytor.com>
 <20140120092931.GA3836@gmail.com>
 <CAJvTdKmF0Bzo+=VRD=3dZKVZAxAQ=am33fFGR7XH4hYd2=9Mww@mail.gmail.com>
 <20140120215151.GN31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120215151.GN31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Jan 20, 2014 at 04:39:45PM -0500, Len Brown wrote:
> > > As a side note, at minimum the semantic and compatibility difference
> > > needs to be _very_ clearly present in the naming. Something like
> > > mwait_old_() or mwait_core2_(). That way such dependencies and
> > > assumptions don't get lost in code restructuring, etc.
> > 
> > Agreed.
> > We started with mwait_idle() -- which was erroneously removed
> > and is now being restored under it original name.
> > 
> > The "new" function is mwait_idle_with_hints() -- which uses the 
> > additional hints that were not available w/ the original MWAIT 
> > instruction. Where "new" is Core Duo and later -- all the 
> > processor that can use MWAIT for C-states deeper than C1.
> 
> I'm still waiting for someone to explain what's wrong with:
> 
> static inline void mwait_idle(void)
> {
> 	local_irq_enable();
> 	mwait_idle_with_hints(0, 0);
> }

Absolutely agreed, we don't want to carry it on 'just because', the 
compatibility aspect needs to be documented - otherwise we degrade 
into cargo cult programming.

Thanks,

	Ingo
