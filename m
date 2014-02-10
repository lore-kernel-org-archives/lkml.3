Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaBJVc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:32:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbaBJVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:32:20 -0500
Message-ID: <1392067925.12555.19.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 0/3] Fix perf build breakages in 3.13
From: Ben Hutchings <ben@decadent.org.uk>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Mon, 10 Feb 2014 21:32:05 +0000
In-Reply-To: <20140210175215.GD20833@ghostprotocols.net>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
	 <20140206134817.GC8026@ghostprotocols.net>
	 <1391695995.3003.108.camel@deadeye.wl.decadent.org.uk>
	 <20140210175215.GD20833@ghostprotocols.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pGZ8OlG26xBT9HIzUBDq"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pGZ8OlG26xBT9HIzUBDq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-02-10 at 14:52 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 06, 2014 at 02:13:15PM +0000, Ben Hutchings escreveu:
> > On Thu, 2014-02-06 at 10:48 -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Feb 06, 2014 at 12:59:21AM +0000, Ben Hutchings escreveu:
> > > > perf no longer compiles on powerpc and sparc due to changes in the =
trace
> > > > sub-command.  This series fixes those compile errors; I compile-tes=
ted
> > > > in Debian sid on armhf, i386, powerpc and sparc.
> > > >=20
> > > > I would much prefer not to revert the tty ioctl decoding but I thin=
k
> > > > it's going to take a much more sophisticated approach to do it righ=
t
> > > > across all supported architectures.
> > >=20
> > > Second thought on the revert one:
> > >=20
> > > Do you have a problem of switching the big hammer to one that makes t=
his
> > > work just on x86/x86-64?
> >=20
> > That seems reasonable as a temporary measure.
>=20
> Applying this to my perf/urgent branch, ack?
>
> - Arnaldo
>=20
> commit 57f7077f41104c5499a89803f58b5886ee51555f
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Mon Feb 10 14:09:48 2014 -0300
>=20
>     perf trace: Fix ioctl 'request' beautifier build problems on !(i386 |=
| x86_64) arches
>    =20
>     Supporting decoding the ioctl 'request' parameter needs more work to
>     properly support more architectures, the current approach doesn't wor=
k
>     on at least powerpc and sparc, as reported by Ben Hutchings in
>     http://lkml.kernel.org/r/1391593985.3003.48.camel@deadeye.wl.decadent=
.org.uk .
>    =20
>     Work around that by making it to be ifdefed for the architectures kno=
wn
>     to work with the current, limited approach, i386 and x86_64 till bett=
er
>     code is written.
>    =20
>     Reported-by: Ben Hutchings <ben@decadent.org.uk>
>     Cc: Adrian Hunter <adrian.hunter@intel.com>
>     Cc: David Ahern <dsahern@gmail.com>
>     Cc: Frederic Weisbecker <fweisbec@gmail.com>
>     Cc: Jiri Olsa <jolsa@redhat.com>
>     Cc: Mike Galbraith <efault@gmx.de>
>     Cc: Namhyung Kim <namhyung@kernel.org>
>     Cc: Paul Mackerras <paulus@samba.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Stephane Eranian <eranian@google.com>
[...]

Please add:

Cc: <stable@vger.kernel.org> # 3.13
Fixes: 78645cf3ed32 ("perf trace: Initial beautifier for ioctl's 'cmd' arg"=
)

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camu=
s

--=-pGZ8OlG26xBT9HIzUBDq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvlFVee/yOyVhhEJAQqqlxAAxN22aU6zLJ9GfIIHFjBVm2M/ANhWSwWJ
7+OWvQ1bqqQCfqrm1EUf+kY0Eww9DIugDz7XF2XdpYImX2mh1VOnnZFRcWe03Vbp
LiD8gKznQzDSQ9tqf7bPogDqfw2n1qVpas3qIdswHiqNcBMq1w0VdDGr8+TtUbF+
0Sb6H6s6hLjEJi2wm21PYMyvN+5K9eSHgPKZTrOQZcEIzIpjc3c2h9VicGWcP2j2
M2ecHhAuA7Ja03SwL6Q/dQvskNvCPXm+XIICj23BEe2UipC/F4nwwAe79ogcabFQ
IrtO3Jv9ufCyeDvp/GkMDOeJCq8Y73yoJfH3BZ9/VvNK6sxDHQ2xYnSYJjOV7oHh
91tnP68V9LL469YPGuLQmulouq0BD6rOXAd37H5G1y/Z/FOFBebYogRqMK9Xs3qz
YeGqt2180KbiT5z+8fY7VNSDhSk3adbgQvOjEHd7PCOQjf+JTuH8fMppByeMo/7q
YlMg+5bsLJpNsLwF0RNRGHutEh7vTTZVt38Ay6W7L/KjVbotaIjFhFBwmLVz2kZv
Jg6evRC6vCVFrQH/5MU1RiDhKooHTrZ8Q8kBd0cY6pmrjwMTvznYT7NFFbaEx/2F
XXFK6GxHs8+SVUvNWAQb1j92tTmzf4TITkc6u1B/W/BUcY6+HJNwjbCIDT98kL81
Yp5peR0QGIY=
=lU6B
-----END PGP SIGNATURE-----

--=-pGZ8OlG26xBT9HIzUBDq--
