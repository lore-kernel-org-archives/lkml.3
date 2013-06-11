Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3FKRdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:33:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57451 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab3FKRdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:33:08 -0400
Date: Tue, 11 Jun 2013 10:30:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lai Jiangshan <eag0628@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611173047.GO5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <CACvQF51K80e3CbTqqwb=WyTVUqndVKP_-fGNnpoh9Gfoyzv5ig@mail.gmail.com>
 <CACvQF50+b4LS2Zgu2uJBpDc_NGUW942XtB7ymfQdmkQc1MwZ9Q@mail.gmail.com>
 <20130611164807.GJ5146@linux.vnet.ibm.com>
 <CA+55aFyteA526MZHpzYTo1XoMx772FrRoqc_keODx1TfxDx6Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyteA526MZHpzYTo1XoMx772FrRoqc_keODx1TfxDx6Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061117-7282-0000-0000-0000182C0F57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:17:52AM -0700, Linus Torvalds wrote:
> On Tue, Jun 11, 2013 at 9:48 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Another approach is to permanently associate queues with each lock,
> > but that increases the size of the lock -- something that has raised
> > concerns in the past.  But if adding 32 bytes to each ticketlock was OK,
> > this simplifies things quite a bit.
> 
> Yeah, no. The spinlocks need to be small.  We have them in
> size-conscious data structures like "struct dentry" and "struct page",
> and they really must not be bigger than an "int" in the non-debug
> case.
> 
> In fact, I've occasionally thought about combining a spinlock with a
> refcounter if that could make things fit in 32 bits on smaller
> machines, because we also have ops like "atomic_dec_and_lock()" that
> could possibly be optimized if they fit in one word. That is probably
> not worth it, but spinlocks do need to remain small.

I was afraid of that.  On the other hand, I guess that this means that
I sent out the correct patch of the two that I prepared.  ;-)

							Thanx, Paul

