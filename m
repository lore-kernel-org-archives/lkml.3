Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaHISTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 14:19:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:56075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 14:19:36 -0400
Date: Sat, 9 Aug 2014 20:19:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140809181920.GO9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XV2oFgeyH+4vHrAu"
Content-Disposition: inline
In-Reply-To: <20140809160137.GJ5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XV2oFgeyH+4vHrAu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 09, 2014 at 09:01:37AM -0700, Paul E. McKenney wrote:
> > That's so wrong its not funny. If you need some abortion to deal with
> > NOHZ_FULL then put it under CONFIG_NOHZ_FULL, don't burden the entire
> > world with it.
>=20
> Peter, the polling approach actually -reduces- the common-case
> per-context-switch burden, as in when RCU-tasks isn't doing anything.
> See your own code above.

I'm not seeing it, CONFIG_PREEMPT already touches a per task cacheline
for each context switch. And for !PREEMPT this thing should pretty much
reduce to rcu_sched.

Would not the thing I proposed be a valid rcu_preempt implementation?
one where its rcu read side primitives run from (voluntary) schedule()
to (voluntary) schedule() call and therefore entirely cover smaller
sections.

> > As for idle tasks, I'm not sure about those, I think that we should say
> > NO to anything that would require waking idle CPUs, push the pain to
> > ftrace/kprobes, we should _not_ be waking idle cpus.
>=20
> So the current patch set wakes an idle task once per RCU-tasks grace
> period, but only when that idle task did not otherwise get awakened.
> This is not a real problem.

And on the other hand we're trying to reduce random wakeups, so this
sure is a problem. If we don't start, we don't have to fix later.

> And it could probably be reduced further, for example, for architectures
> where the program counter of sleeping CPUs can be remotely accessed and
> where the address of the am-asleep code is known.  I doubt that this
> would really be worth it, but it could be done, in theory anyway.  Or, as
> Steven suggested earlier, there could be a per-CPU variable that was set
> (with approapriate memory ordering) when the CPU was actually sleeping.
>=20
> So I don't believe that the current wakeup rate is a problem, and it
> can be reduced if it proves to be a problem.

How about we simply assume 'idle' code, as defined by the rcu idle hooks
are safe? Why do we want to bend over backwards to cover this?

--XV2oFgeyH+4vHrAu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5mYiAAoJEHZH4aRLwOS6ejsP/1sDGM119xciofJ3fEtbB6F0
i3gYj7EPkK401JAO4v4UJIFZHxqD0JTtuSfEkkayLBe6swzRFkt4ThJs4XLuikpU
o39Q1DxuRW6PJKYTuIZH4BGhmA/D7LL922TZyAgI6EhCCaERfqmiCY3YPmziRJbq
8OwPuxSL7CHo1fiD10BArjHHrtAG/OIJC1VkCkGHreNUVckyQe21CFUJY/NwIPij
Lst/DJi+jvIOOMw88scgzOxIf9qZp8/76icyTm0HrsaY2V+jza96OUKilYsDd716
oCdt92+CiMAsbfVGCXVUx9bnQqTHMMI5olXkxhZ2lphAuMUCac3560zh1z4+OCBN
XkgcO1kX8fR1ELgXnWcUgqrgvC3YwNPg37e7+1uFMqRTLC55ogqSK5Bl5BvCvrJd
4BwgGPojuVIicVucZUaQHIUXAcikxENBlkT9/ecof/9QWVPmjfYJkUQPpqmBc4Q4
vYrdGU0U15xP7OD4iIMqmlfWVtNQw4wTccpQ5yA4MH/OygLmbF8NY1pcKZQvJ0hR
fOJTMWapraVqKXOGNkTEf3q77EvKH2usEBqcyM2dtCVhMULFAqiX3tsPVdAHvvq9
70SdtnhZ2VaWic16eg2zmjWQnuWqCwAF+CajbPAOU1mQhTKftik7d/iL6Hg19JO0
UOzG/5eoaaZ6gad/m5ew
=q+eT
-----END PGP SIGNATURE-----

--XV2oFgeyH+4vHrAu--
