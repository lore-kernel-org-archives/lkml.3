Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaAOCkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:40:09 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:50309 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOCkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:40:04 -0500
Date: Tue, 14 Jan 2014 18:39:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Matt Turner <mattst88@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140115023958.GA10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <52D353C8.4000000@numascale.com>
 <52D4172E.6030706@hp.com>
 <52D4A0C7.5070601@numascale.com>
 <20140114110307.GW7572@laptop.programming.kicks-ass.net>
 <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
 <52D57B60.9020209@twiddle.net>
 <20140114234443.GY10038@linux.vnet.ibm.com>
 <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011502-9332-0000-0000-000002C3615D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:25:04AM +0700, Linus Torvalds wrote:
> On Wed, Jan 15, 2014 at 6:44 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Which means that Alpha should be able to similarly emulate 1-byte and
> > 2-byte atomics, correct?
> 
> Not reasonably, no.
> 
> The ldl/stc implementation on early alpha was so broken as to be
> unusable. It's not actually done in the cache, it WENT OUT ON THE BUS.
> We're talking 70's style "external lock signal" kind of things like
> the 8086 did for locked cycles before the advent of caches, the kind
> that nobody sane has done for a long long time.
> 
> So realistically, you absolutely do not want to use those things to
> emulate atomic byte/word accesses. The whole point of "load_acquire()"
> and "store_release()" is that it's supposed to be cheaper than a
> locked access, and can be done with just a barrier instruction or a
> special instruction flag.
> 
> If you just want to do a store release, on alpha you'd want to
> implement that as a full memory barrier followed by a store. It
> doesn't get the advantage of a real release consistency model, but at
> least it's not doing an external bus access. But you can only do that
> store as a 4-byte or 8-byte store.on the older alphas (byte and word
> stores work on newer ones).
> 
> Of course, it's entirely possible that nobody cares..

That would be my hope.  ;-)

If nobody cares about Alpha period, it is easy.  However, the last time
that I tried that approach, they sent me a URL of a wiki showing Alpha
systems still running mainline.  But a slow-but-working approach for
Alpha does seem reasonable, even for those still running Linux on Alpha.

							Thanx, Paul

