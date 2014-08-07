Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbaHGR2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:28:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:48116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaHGR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:28:07 -0400
Date: Thu, 7 Aug 2014 19:27:53 +0200
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
Message-ID: <20140807172753.GG3588@twins.programming.kicks-ass.net>
References: <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
 <20140806224518.GA8101@linux.vnet.ibm.com>
 <20140807084544.GJ19379@twins.programming.kicks-ass.net>
 <20140807150031.GB5821@linux.vnet.ibm.com>
 <20140807152600.GW9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KzTpGdFWKkiGyjCs"
Content-Disposition: inline
In-Reply-To: <20140807152600.GW9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KzTpGdFWKkiGyjCs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 05:26:00PM +0200, Peter Zijlstra wrote:
> > > So do we really need the call_rcu_task() thing and why isn't something
> > > like synchronize_tasks() good enough?
> >=20
> > Sounds like a question for Steven.
> >=20
> > > So the thing is, the one proposed user is very rare (*) and for that
> > > you're adding overhead outside of that user (a separate kthread) and
> > > your adding overhead when its not used.
> >=20
> > If that really was the case, that would be bad.  However, in the latest
> > versions, that is no longer the case.
> >=20
> > > * I'm assuming that, since tracing is 'rare' and this is some tracing
> > > thing.
> >=20
> > Another good point for Steven.
>=20
> Yes.. and he's back now, so please :-)

Right, Steve (and Paul) please explain _why_ this is an 'RCU' at all?
_Why_ do we have call_rcu_task(), and why is it entwined in the 'normal'
RCU stuff? We've got SRCU -- which btw started out simple, without
call_srcu() -- and that lives entirely independent. And SRCU is far more
an actual RCU than this thing is, its got read side primitives and
everything.

Also, I cannot think of any other use besides trampolines for this
thing, but that might be my limited imagination.



--KzTpGdFWKkiGyjCs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT47cZAAoJEHZH4aRLwOS6xpcP/03fjku6RxtwJRSuP1ylt0xW
aYHfRuA2Y9ZaHa4UBVK9cfe6Arh4ASw2RhUqYjfF6guPNlzjY+SDczxz7f9XYdWa
KKb+jlBadndNMGI8Ynuhk9hsEj1MxGW/Yvpm0SLmRr6E9ZyGphzH35r7hJcXmotU
gfsaJZDry7HfWgfqtv11HXnqIgf96s5T9jQ8o6z+dBvvZtKCTyCPedKqPiichaKU
so0MVqM8XvQpXMd0z7NoJGPxaamzOabUq95rr5+8HXAfLWcqnc7bD4ygr3d0xMDW
RzOQo+GrRpVBEisxrRh/y3twP00fu0EJlnervRhPcYcYLek2flXkgQZLb1skblUS
JLtX0KOpNO/fs5iW2Y1G24ZuEDi/XMWoB+FXC8IT6Q/ID2cfCDl55BaI/oRG0VVO
X2cDmHRJN2e0hfclDkFLuhN7ewkd/GqI+xAHpxxad0Jjx8l5clgzzURULgJiT8La
Qede2KoaAH6jX+qHFcQHpDrxCyEINtbmiN5mHOtySlM0qyfunmfyIYycnexm1D+D
n1hj4uWcPw9+YHi12rRYzZIgCzFqVp7UX92QCOLC4iFEwBoFqrwYZD/dA/WB+wMQ
wlgRmXsCXjPcFDsvbuiDNbVEmrJo6eshlXjuGdHezH+HzskGlTVAPkRUXCHJ2sKr
JvU7hCI5ZEL78+LbAigB
=tsHC
-----END PGP SIGNATURE-----

--KzTpGdFWKkiGyjCs--
