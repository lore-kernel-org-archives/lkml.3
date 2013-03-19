Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3CSCxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:53:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41478 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab3CSCxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:53:12 -0400
Message-ID: <1363661587.3937.360.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 42/88] exec: use -ELOOP for max recursion depth
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Kees Cook <keescook@chromium.org>,
        halfdog <me@halfdog.net>, P J P <ppandit@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Tue, 19 Mar 2013 02:53:07 +0000
In-Reply-To: <1363257381-15900-43-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
	 <1363257381-15900-43-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PCqqsG8oOAHZvZi5HuKr"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PCqqsG8oOAHZvZi5HuKr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-03-14 at 10:35 +0000, Luis Henriques wrote:
> 3.5.7.8 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Kees Cook <keescook@chromium.org>
>=20
> commit d740269867021faf4ce38a449353d2b986c34a67 upstream.
>=20
> To avoid an explosion of request_module calls on a chain of abusive
> scripts, fail maximum recursion with -ELOOP instead of -ENOEXEC. As soon
> as maximum recursion depth is hit, the error will fail all the way back
> up the chain, aborting immediately.
>=20
> This also has the side-effect of stopping the user's shell from attemptin=
g
> to reexecute the top-level file as a shell script. As seen in the
> dash source:
>=20
>         if (cmd !=3D path_bshell && errno =3D=3D ENOEXEC) {
>                 *argv-- =3D cmd;
>                 *argv =3D cmd =3D path_bshell;
>                 goto repeat;
>         }
>=20
> The above logic was designed for running scripts automatically that lacke=
d
> the "#!" header, not to re-try failed recursion. On a legitimate -ENOEXEC=
,
> things continue to behave as the shell expects.
>=20
> Additionally, when tracking recursion, the binfmt handlers should not be
> involved. The recursion being tracked is the depth of calls through
> search_binary_handler(), so that function should be exclusively responsib=
le
> for tracking the depth.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: halfdog <me@halfdog.net>
> Cc: P J P <ppandit@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [ luis: backport to 3.5 ]
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
[...]

Greg, I also included this in 3.2.y (commit 511d07b) but it is missing
from 3.0.y and 3.4.y.  I hope one or other of these backports will be
suitable for them (it was just a context fix for 3.2.y).

Ben.

--=20
Ben Hutchings
When you say `I wrote a program that crashed Windows', people just stare ..=
.
and say `Hey, I got those with the system, *for free*'. - Linus Torvalds

--=-PCqqsG8oOAHZvZi5HuKr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUfTE+e/yOyVhhEJAQpEQw/9FcDqrUAyTq/DFyDf8e0ZPx3DKqoGTls7
cTnSrccun2tnB6/ni4y2k2FZS0IZTKsPRlOPp/NOezDZtRq25m+L+zUfxEpp10Oi
8w61W8dnktLR245njlPdSFNakcw2kXgnkIaWqHhbacxdfg15ntrGPH9DFAgZ/n87
YoaXMKwoKDnzn+mHNXfgu71sxNb25WgfTj+K+GLdmTmZ0pHwN8UexmYf+ZST/Pfb
H4HpvX68DbaChXuUNbQBjMSBwWsmleerwTpvUE1omR6c3xL8uyQh9GUUnw2LkrRk
2eIdsWmf2K1b0IqI58uaWpPqcL2/NEvREZ+NALF8tBMafFKdpf59b6eoVPrVwGLe
ByItUh2KOgEkVWC84/nIhhS67bPH7gv2njdN47d+Y470hjnwRsW/nqVn9KUcs1Jr
BGfTLJDfK+cnUxahaC0XBb/SwGX22Z8MoyE4kk3r823VLUP99w3ViMCMJ+Htb9nG
HKClC4G5JDO9sMxXu/EelDzCqbz2fyh+s4kFYw1nft8lwOZPgEaekRejm5edsPH5
fxFpjhrEv1O7kFlxnQ0ua/vl+8D34U7RosePMSqnjNVVRcs45UQAxZNB5nZQfcTV
30mF1zwoPiCEpK7YMEv1Eo7tWiXaufU2WRLEpbyNnojXoMHDLHKhOhd8OYWvkzg6
MH5B59t+X7Q=
=4nQI
-----END PGP SIGNATURE-----

--=-PCqqsG8oOAHZvZi5HuKr--
