Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbaELPZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:25:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbaELPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:25:41 -0400
Date: Mon, 12 May 2014 17:25:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Subject: Re: SCHED_DEADLINE, sched_getscheduler(), and sched_getparam()
Message-ID: <20140512152536.GR30445@twins.programming.kicks-ass.net>
References: <CAKgNAkiA23kAFyXQkFV4z0aUE+y5K7AFNwRW+4LqwAyVj=tQtQ@mail.gmail.com>
 <20140512122452.GB13467@laptop.programming.kicks-ass.net>
 <CAKgNAkjsEjGM+Znu4iXa7yA-ruDHCDx9SvFow2wn3z2=zAHqCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qkWs0iooC3sIAMHP"
Content-Disposition: inline
In-Reply-To: <CAKgNAkjsEjGM+Znu4iXa7yA-ruDHCDx9SvFow2wn3z2=zAHqCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qkWs0iooC3sIAMHP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 02:33:42PM +0200, Michael Kerrisk (man-pages) wrote:
> > I'm a proponent of fail hard instead of fail silently and muddle on.
> > And while we can fully and correctly return sched_getscheduler() we
> > cannot do so for sched_getparam().
> >
> > Returning sched_param::sched_priority =3D=3D 0 for DEADLINE would also =
break
> > the symmetry between sched_setparam() and sched_getparam(), both will
> > fail for SCHED_DEADLINE.
>=20
> Maybe. But there seems to me to be a problem with your logic here.
> (And the symmetry argument seems a weak one to me.)
>=20
> I mean, applications that are currently using sched_getscheduler()
> will now get back a new policy (SCHED_DEADLINE) that they may not
> understand, and so they may break.
>=20
> On the other hand, applications that call sched_getparam() will fail
> with EINVAL, even though sched_priority has no meaning for
> SCHED_DEADLINE (as for the non-real-time policies), and so it would
> seem to be harmless to succeed and return a sched_priority of 0 in
> this case. It seems to break user-space needlessly, IMHO.
>=20
> If anything, I'd have said it would have made more sense to have the
> sched_getscheduler() case fail, while having the sched_getparam() case
> succeed. (But, I can see the argument for having _both_ cases
> succeed.)

Hmm,.. maybe. Can we still change this? Again, maybe, there's not really
that much userspace that relies on this.

In any case, the way I read the little there is on getparam() it seems
to imply the only case where it does make sense to call it at all is
when sched_getscheduler() returns either SCHED_FIFO or SCHED_RR.

And in that sense I suppose the precedent for all other currently
available classes to not fail the param call but return 0 should be
extended.

If only we'd started out with sched_yield()/sched_getparam() etc failing
when not !SCHED_FIFO/RR :-)

--qkWs0iooC3sIAMHP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcOfwAAoJEHZH4aRLwOS6oL4P/ie0b0B3wHnyA7wu2C7I4+GK
WP3BQgPZrIdYz2r1nlM4dPrXaNGI8yLavMzlf2s2l/lNYb+xyS92+PyohLxoPisG
row9PTaQ4oFb58IdNM8zmdSZrbNGCpWnGvQJDWXoXMb4v5PBUnKAoYmFWD3aEEMc
EUYtqs+1hZz5yoOuc6p794Ex2iQdiniey1JKFYIjeUXMiQArffFKO1UNu6IgGLKI
Yjjwain+ns1um9gWFReY3JYGyIRmmT0+vjQC2WHQn+SrHBSux+5f3MPZrBUxou1R
dRmeTUnYMTFDUg6cHR9ch2bWaFon6UsG66Im1QDbiUELfL3VJKiPoD8bz++crdKX
sfvAlX2PnFyQtzb2lxEItvaf8A1YHfvM+9vcduI9n+1TDBLs26bim/A69PgXY/3y
mPDChBVcgwJk1KHirQ3LmtRT3GKvtFzlhmsto40zw5eeY6hZr83WyWuRL4X98qRG
eDAqNMPLYEBl6eR7SVAC7ujTH/6IfsGs4di4phuLqvFoesINHVlVPgJzj9zn41Dy
FIA0VA1NPzivkgLBIqTRcU+XV55pVfzmthYx+9Iywqu/pb/PkxIw8J0BpgLav/11
ycrnsmegXbCW50VcMA/lAvUG1YNpYBvWfzEE+h7py1v0ReUkaY4eAbrpvpfnh3ox
iteIJ3EIl5EkfR6BHeeJ
=fJDy
-----END PGP SIGNATURE-----

--qkWs0iooC3sIAMHP--
