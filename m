Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaASIER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 03:04:17 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34366 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaASIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 03:04:15 -0500
Date: Sun, 19 Jan 2014 00:04:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Matt Turner <mattst88@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140119080405.GB10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115205346.GF10038@linux.vnet.ibm.com>
 <20140115232134.GM31570@twins.programming.kicks-ass.net>
 <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
 <20140116103659.GO7572@laptop.programming.kicks-ass.net>
 <20140118100105.GV10038@linux.vnet.ibm.com>
 <20140118113406.GY30183@twins.programming.kicks-ass.net>
 <20140118122548.GX10038@linux.vnet.ibm.com>
 <20140118124136.GZ30183@twins.programming.kicks-ass.net>
 <20140118212227.GA10038@linux.vnet.ibm.com>
 <CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011908-6688-0000-0000-000005AE1A2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 04:57:05PM -0800, Linus Torvalds wrote:
> On Sat, Jan 18, 2014 at 1:22 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Yes, this requires that -all- updates to the fields in the machine word
> > in question use atomic rmw.  Which would not be pretty from a core-code
> > perspective.  Hence my suggestion of ceasing Linux-kernel support for
> > DEC Alpha CPUs that don't support byte operations.  Also need 16-bit
> > operations as well, of course...
> 
> I'm not seeing this.
> 
> Why the hell would you have byte- or halfword-sized versions of the
> store_release or load_acquire things on alpha anyway?
> 
> What it means is that data structures that do locking or atomics need
> to be "int" or "long" on alpha.  That has always been true. What do
> you claim has changed?

OK, another approach would be to never add "select ARCH_USE_QUEUE_RWLOCK"
on Alpha, at least if the queued rwlocks really do want to atomically
manipulate bytes.  After all, the Alpha systems that I know about don't
have enough CPUs to make queued rwlocks necessary anyway.

Much simpler solution!

Is this what you were getting at, or am I missing your point?

							Thanx, Paul

