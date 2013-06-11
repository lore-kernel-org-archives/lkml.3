Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3FKRuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:50:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36213 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:50:09 -0400
Date: Tue, 11 Jun 2013 10:49:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?utf-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
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
        Silas Boyd-Wickizer <sbw@mit.edu>,
        Michel Lespinasse <walken@google.com>,
        Waiman Long <waiman.long@hp.com>
Subject: Re: [PATCH RFC ticketlock] v2 Auto-queued ticketlock
Message-ID: <20130611174951.GQ5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <20130611170249.GA1091@linux.vnet.ibm.com>
 <CA+55aFw5d7X0YrgbnQ3Z3iUPir6AvEF0KsAL2T2dQL4V+LnnXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw5d7X0YrgbnQ3Z3iUPir6AvEF0KsAL2T2dQL4V+LnnXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061117-7282-0000-0000-0000182C3A99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:35:53AM -0700, Linus Torvalds wrote:
> Hmm. Something just struck me when reading this patch..
> 
> Our memory ordering semantics in our *current* locks are very very
> subtle. We have just a "barrier()" between the
> 
>     inc.head = ACCESS_ONCE(lock->tickets.head);
>     if (inc.head == inc.tail)
>         break; /* success */
> 
> and the inside of the locked region.
> 
> I think it's safe because of the new memory ordering semantics (loads
> are in-order, and stores only move *down*), but there's not even a
> comment about it.
> 
> So let's at least comment the current locks before making them even
> more complex and subtle..

Would it make sense to have something like an smp_tso() that was a
compiler barrier for TSO systems (x86, s390, sparc, etc.) but that
emitted the needed memory-barrier instruction for weakly ordered systems?

Seems to me to be easy to do, and helps describe the intent better.

							Thanx, Paul

