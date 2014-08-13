Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaHMOd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:33:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:44789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaHMOdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:33:25 -0400
Date: Wed, 13 Aug 2014 16:33:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 14/16] rcu: Remove redundant
 preempt_disable() from rcu_note_voluntary_context_switch()
Message-ID: <20140813143310.GP9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813105618.GI9918@twins.programming.kicks-ass.net>
 <20140813140751.GT4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lm2aua8EgO0wdo9l"
Content-Disposition: inline
In-Reply-To: <20140813140751.GT4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lm2aua8EgO0wdo9l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 07:07:51AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 13, 2014 at 12:56:18PM +0200, Peter Zijlstra wrote:
> > On Mon, Aug 11, 2014 at 03:49:03PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > >=20
> > > In theory, synchronize_sched() requires a read-side critical section =
to
> > > order against.  In practice, preemption can be thought of as being
> > > disabled across every machine instruction.  So this commit removes
> > > the redundant preempt_disable() from rcu_note_voluntary_context_switc=
h().
> >=20
> > >  #define rcu_note_voluntary_context_switch(t) \
> > >  	do { \
> > > -		preempt_disable(); /* Exclude synchronize_sched(); */ \
> > >  		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
> > >  			ACCESS_ONCE((t)->rcu_tasks_holdout) =3D 0; \
> > > -		preempt_enable(); \
> > >  	} while (0)
> >=20
> > But that's more than 1 instruction.
>=20
> Yeah, the commit log could use some help.  The instruction in question
> is the store.  The "if" is just an optimization.
>=20
> So suppose that this sequence is preempted between the "if" and the store,
> and that the synchronize_sched() (and quite a bit more besides!) takes
> place during this preemption.  The task is still in a quiescent state
> at the time of the store, so the store is still legitimate.
>=20
> That said, it might be better to just leave preemption disabled, as that
> certainly makes things simpler.  Thoughts?

A comment explaining it should be fine I think. I was just raising the
obvious fail in the changelog.

--Lm2aua8EgO0wdo9l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT63cmAAoJEHZH4aRLwOS6Y/cQAKCsjDOm9xWvndhbA9/yNiQy
6RDE51rYy20loLM2smWJ6ySc6qyqOg/QbWqWF1ydhhkmewoMQ9Zki2LdAY0xQBdV
kMTbqtoDbs9j9XQhq5d29AumWmDKJGh61F9cO1L5uJZVfIZR1odlwBdU9I2Z89JU
F/fkzHUYW1ooErWTRosJR+QbwdvEjnhf068BwJvCs/3GgzYWmH4mjxLrJvSG7gIj
f7lnZHaTW8yim4fFWu9dRi9lZEPl4xuLnad9qlY+d+y3uIpsoSGsEe7HOURYQE93
kkP4XOfi72k3avrcA6WcS88JnlD0wa03DvtAiyhBKUteyYl8zgWhdTc6kakLabV3
isFy+sgwKT18zHAQKuViAMLBFAUKFvyIOrwsa3w5wrwifV49KCow3JihG2SOik3E
8LkZPyGl3Pr6Y7LXl+XRu4mhdv6wdONgs4xygduSY3GS+rtTUlVgr2ZcVuWcKyFi
/YvEOla7vw9egFpNUKntnIG6cfth3lsY4rP3ww/vrySQsovNK/RP779cFUyaSg1I
zGXjvhS7hwVQVJYuijrtaLO88bTnu7ltg3ii2V+J38ZohaeM90E1AW5e3OJLcFli
EmL9ZLuvcvn33DoKEVw5Zvk8WYIZ2OpVcUYqRDN+VZpoKXhPLT2vnqqtCwuQ8Ouf
6vcUpFbqx+jTYYBTNqCz
=fTju
-----END PGP SIGNATURE-----

--Lm2aua8EgO0wdo9l--
