Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbaHGP0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:26:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:47749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaHGP0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:26:16 -0400
Date: Thu, 7 Aug 2014 17:26:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807152600.GW9918@twins.programming.kicks-ass.net>
References: <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
 <20140806224518.GA8101@linux.vnet.ibm.com>
 <20140807084544.GJ19379@twins.programming.kicks-ass.net>
 <20140807150031.GB5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vf1V7NSjayOCeZIo"
Content-Disposition: inline
In-Reply-To: <20140807150031.GB5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vf1V7NSjayOCeZIo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 08:00:31AM -0700, Paul E. McKenney wrote:
> On Thu, Aug 07, 2014 at 10:45:44AM +0200, Peter Zijlstra wrote:
> > On Wed, Aug 06, 2014 at 03:45:18PM -0700, Paul E. McKenney wrote:
> > > > > > But I still very much hate the polling stuff...
> > >=20
> > > The nice thing about the polling approach is minimal overhead in the
> > > common case where RCU-tasks is not in use.
> >=20
> > No, quite the reverse, there is overhead when its not in use, as opposed
> > to no overhead at all.
>=20
> Say what???
>=20
> > I'm still not convinced we need this 'generic' rcu-task stuff and create
> > yet another kthread with polling semantics, we want to let the system
> > idle out when there's nothing to do, not keep waking it up.
>=20
> Which is exactly what happens.  The kthread is created only at first
> use, so if no one uses RCU-tasks, then no kthread is created, see
> https://lkml.org/lkml/2014/8/4/630.  Even if a kthread is created, if
> there is no more work for it to do, it sleeps indefinitely.  See for
> example https://lkml.org/lkml/2014/8/4/629.

Ah, the 'full' patch I was staring at for reference did an unconditional
poll.

> > So do we really need the call_rcu_task() thing and why isn't something
> > like synchronize_tasks() good enough?
>=20
> Sounds like a question for Steven.
>=20
> > So the thing is, the one proposed user is very rare (*) and for that
> > you're adding overhead outside of that user (a separate kthread) and
> > your adding overhead when its not used.
>=20
> If that really was the case, that would be bad.  However, in the latest
> versions, that is no longer the case.
>=20
> > * I'm assuming that, since tracing is 'rare' and this is some tracing
> > thing.
>=20
> Another good point for Steven.

Yes.. and he's back now, so please :-)

--vf1V7NSjayOCeZIo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT45qIAAoJEHZH4aRLwOS6xZsP/1JbtTHE9iFQb2mo/Us7eK8I
19grhhXsr9Ip8Jbdzj3Qq29iKbtqp2MUsgUhcl9AU3RzTVZ8M1bWANGujDj/tQmq
Im/JYKJCfTRhvbpxdFlWh4pOWyeCR4TIkIuf9WUH+yHV5bW6Vm09iCJkbwkwttDl
93f0bJY0SlTaoGWGu3Q3Z3HkegBWbytNftdPtEe5XeeaTZqvGgZOnJchdUKYbC9c
2cYD+NpXdeuG11ggaXUgCvrZZaR09EU3qFM0Gg88iGwBlDbg22lI/UgFkRdEDRJl
5n0W6T0PzFc9OqhQPdvXGjK4f4CM+sG3De1acvMr80cias8jaEU8Z8+KnBEOpISU
o/dtZM018j0mwwNttbhWNNpj9AxF2bu7xnQhHZJi2l22emAMLQZyd1Cp5p4ZlJc1
5MEjRaQJnHqfvCSqE2R9q9Ub5zuDYNza6Ya4tCT5uAkdAWP4zV/SFOB/CSR7gD5J
MAyCTv01uo0FoIZQvDA/Usg94cO7SYgiGLar/wYZ15No3Us/ouRIoleM5JdeAv2J
ehHpy2rxwuSLHu0jy3FVL3OeJL0AUhBWIeE0dPBJzd5JKd8hfXuWYdEfZNBr/D5e
dGRX8jdNm9ieup/dAhsD0hRxbJlbftsw37+99YLwAHez+kEL1IUTMW8SS9PTlETS
6NjtBiM42FbVzelwTUN7
=Qn+p
-----END PGP SIGNATURE-----

--vf1V7NSjayOCeZIo--
