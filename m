Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaHIGRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 02:17:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHIGR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 02:17:28 -0400
Date: Sat, 9 Aug 2014 08:17:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] spin_lock_nested(): Always evaluate second argument
Message-ID: <20140809061712.GL9918@twins.programming.kicks-ass.net>
References: <53CE1019.10708@acm.org>
 <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org>
 <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com>
 <53E260D9.6030803@acm.org>
 <53E2618F.6040208@acm.org>
 <alpine.DEB.2.02.1408061455290.13545@chino.kir.corp.google.com>
 <53E4A73D.5080801@acm.org>
 <53E4A7F8.1040700@acm.org>
 <alpine.DEB.2.02.1408081451470.15603@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="srAoGIOs8asUHz4E"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408081451470.15603@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--srAoGIOs8asUHz4E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 02:52:50PM -0700, David Rientjes wrote:
> On Fri, 8 Aug 2014, Bart Van Assche wrote:
>=20
> > diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> > index 3f2867f..262ba4e 100644
> > --- a/include/linux/spinlock.h
> > +++ b/include/linux/spinlock.h
> > @@ -197,7 +197,13 @@ static inline void do_raw_spin_unlock(raw_spinlock=
_t *lock) __releases(lock)
> >  		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
> >  	 } while (0)
> >  #else
> > -# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
> > +/*
> > + * Always evaluate the 'subclass' argument to avoid that the compiler
> > + * warns about set-but-not-used variables when building with
> > + * CONFIG_DEBUG_LOCK_ALLOC=3Dn and with W=3D1.
> > + */
>=20
> I was hoping there was going to be a more important reason for this chang=
e=20
> than to avoid compiler warnings, such as an example where someone is doin=
g=20
> spin_lock_nested(lock, subclass) and the expression for "subclass"=20
> requires evaluation in all configs.

That would stink, having that argument have side effects. I'd call that
a plain old bug that needs fixing.



--srAoGIOs8asUHz4E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5bzoAAoJEHZH4aRLwOS6UWUP/jzdmQiN2ATnjoDsqcIam7gg
JKXFVU83zoC60nj9Fi6cIjgkFBthAXxjiUVxO6lftn5hUquT3b0QcrevfkMC5TvY
wpseLjHc4nOavimRaWDvPp+qy6F3/yDX1GXfqi7zZWR7hp0vdPoNs/UetfnoKi62
13xGh1CvC1w2hIqbEbWOD9pQ3uL8p4/iQH5t2vpTTYPJAN+dstmYIShXJlos1PNs
sD5WebVH7Ao+FuUFCNPCXjXHsMlxH0jXTBXeU5WImXs8c8MQtrtwxSl/n7tIFKyL
XfWl5NQ64yPklkjZuX/Oe9FVq981ygBHTiepzd/DOniQtHFHSc1+KchinpcEJ3qt
3a8XyeSCNpaWZVOH5j1mbMImkGIcxop4xUy/BzVUEBtl7ltm+uA6xljaSmHHKfAH
2usR03Lbn7JvPVjkubymEqhtIDKzmrdXGWuyvv6lvG2g2eJdmfQyNGAG8857gS/6
ZlQlhqtXlfhqsP9qVSGZFvUiDq68WyW4BYPQvdGp579Kvu0jdbGV04Ygn9PqVYiW
fQAiBW0S/x+A7xIJKTSAgo+p0+wDG39FO7msLUUauXxX2qKwQACCBYCKowheZstX
paiwhl7p2OOeOuW2wjUH5TTSqcJVjNf40r7x1VFiKihqyvg0OlUtLmkVC7tpghLg
vXK1rx8FRVDViEob3kQt
=FHQY
-----END PGP SIGNATURE-----

--srAoGIOs8asUHz4E--
