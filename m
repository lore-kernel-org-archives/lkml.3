Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaGBRXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:23:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:33566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaGBRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:23:43 -0400
Date: Wed, 2 Jul 2014 19:23:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, Waiman.Long@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
Message-ID: <20140702172333.GQ19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
 <20140702162749.GP19379@twins.programming.kicks-ass.net>
 <1404320356.3170.12.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CbqR2XcyIs6OSP+I"
Content-Disposition: inline
In-Reply-To: <1404320356.3170.12.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CbqR2XcyIs6OSP+I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 09:59:16AM -0700, Jason Low wrote:
> On Wed, 2014-07-02 at 18:27 +0200, Peter Zijlstra wrote:
> > On Wed, Jul 02, 2014 at 09:21:10AM -0700, Jason Low wrote:
> > > The cancellable MCS spinlock is currently used to queue threads that =
are
> > > doing optimistic spinning. It uses per-cpu nodes, where a thread obta=
ining
> > > the lock would access and queue the local node corresponding to the C=
PU that
> > > it's running on. Currently, the cancellable MCS lock is implemented b=
y using
> > > pointers to these nodes.
> > >=20
> > > In this RFC patch, instead of operating on pointers to the per-cpu no=
des, we
> > > store the CPU numbers in which the per-cpu nodes correspond to in ato=
mic_t.
> > > A similar concept is used with the qspinlock.
> > >=20
> > > We add 1 to the CPU number to retrive an "encoded value" representing=
 the node
> > > of that CPU. By doing this, 0 can represent "no CPU", which allows us=
 to
> > > keep the simple "if (CPU)" and "if (!CPU)" checks. In this patch, the=
 next and
> > > prev pointers in each node were also modified to store encoded CPU va=
lues.
> > >=20
> > > By operating on the CPU # of the nodes using atomic_t instead of poin=
ters
> > > to those nodes, this can reduce the overhead of the cancellable MCS s=
pinlock
> > > by 32 bits (on 64 bit systems).
> >=20
> > Still struggling to figure out why you did this.
>=20
> Why I converted pointers to atomic_t?
>=20
> This would avoid the potentially racy ACCESS_ONCE stores + cmpxchg while
> also using less overhead, since atomic_t is often only 32 bits while
> pointers could be 64 bits.

So no real good reason.. The ACCESS_ONCE stores + cmpxchg stuff is
likely broken all over the place, and 'fixing' this one place doesn't
cure the problem.

--CbqR2XcyIs6OSP+I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtEAVAAoJEHZH4aRLwOS6tf4QAJX18449C9JFqmXOn+nm2GC3
S2h1SYOhcmfhfiUhFobEKZrlskrjoKiUxHgj7lfLy7cHO27QlMrtVJHVypmDADtB
LojAT+XDmQxfyJ9SK5+wOA79xqK67pbNtEIGY3fnLCm49YNuuS+DIT5qVYAicl4l
ClISi4j1Nael+imDX94Z8G9lP6uJz1DfG9VdwBnZbJbQFZWJrH6cDPAJ4rL2t5ld
6aDIkvQatPQ80EtSc+5y2r+QFK35JhsK0ULM6iUI2lb2TFudkZfAx68IYT89SBhE
DMnl8WTAdV2pK5tPgEH0yJeqZ8bO0cgY9ar9a7DMx+aRjprVaNsVPdluJYfS5VNr
C4fBZj4bMjIVeGiFsXMkmrtX+2FMLue+7KE04qfXfiCzs8tmk5i8wFccqbQ0nsyb
elK5ASEsyEoCObGDeg7SUCY4/CJYneOyZOLylG7ATEcxFHpDkFjXBEtkzLQYZI61
/oDOjmhXRrZ7io8yOAT3mcxpb+y7hZpayPajkLeQNi8oKwB1AmbfwIEVZGpC08U5
w8iY2RMwLEQcyHZ6C/sPf3qV0rkLSHtXoMv1NBWGaKSZj5NTx4tFOZWzEKrgPyXF
a21VSHsNtYi4Yeut51mTnDE1a1hGkURYoAPNCB9B3adAXPqznMCaz/07IGHhlv7u
0jRwR93UCh3hq0sHeYQF
=KdwU
-----END PGP SIGNATURE-----

--CbqR2XcyIs6OSP+I--
