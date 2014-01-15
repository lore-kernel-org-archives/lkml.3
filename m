Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaAOUx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:53:59 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59948 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaAOUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:53:57 -0500
Date: Wed, 15 Jan 2014 12:53:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>, Matt Turner <mattst88@gmail.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140115205346.GF10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <52D353C8.4000000@numascale.com>
 <52D4172E.6030706@hp.com>
 <52D4A0C7.5070601@numascale.com>
 <20140114110307.GW7572@laptop.programming.kicks-ass.net>
 <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
 <52D57B60.9020209@twiddle.net>
 <20140114234443.GY10038@linux.vnet.ibm.com>
 <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
 <20140115023958.GA10038@linux.vnet.ibm.com>
 <20140115080753.GW31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115080753.GW31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011520-0928-0000-0000-000005AB2031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 09:07:53AM +0100, Peter Zijlstra wrote:
> On Tue, Jan 14, 2014 at 06:39:58PM -0800, Paul E. McKenney wrote:
> > > If you just want to do a store release, on alpha you'd want to
> > > implement that as a full memory barrier followed by a store. It
> > > doesn't get the advantage of a real release consistency model, but at
> > > least it's not doing an external bus access. But you can only do that
> > > store as a 4-byte or 8-byte store.on the older alphas (byte and word
> > > stores work on newer ones).
> > > 
> > > Of course, it's entirely possible that nobody cares..
> > 
> > That would be my hope.  ;-)
> > 
> > If nobody cares about Alpha period, it is easy.  However, the last time
> > that I tried that approach, they sent me a URL of a wiki showing Alpha
> > systems still running mainline.  But a slow-but-working approach for
> > Alpha does seem reasonable, even for those still running Linux on Alpha.
> 
> Well, if they're all EV56 or later we're still good as they can actually
> do what we need.
> 
> But I don't think a ll/sc implementation of the store_release can even
> work, because in that case all users of the other bytes also need a
> ll/sc around them but how are we to know about them?
> 
> So the only real way to allow store_release on 8/16 bit values is by
> removing all Alpha support _pre_ EV56 :/

Fair point...  We could demand Alpha-specific alignment, but that would
get really ugly really quickly.

But we did drop support for SMP i386 quite some time ago, so perhaps
it is time to drop support for SMP Alpha pre-EV56.

							Thanx, Paul

