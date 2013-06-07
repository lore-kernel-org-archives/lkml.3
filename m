Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3FGEuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:50:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50089 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab3FGEuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:50:12 -0400
Message-ID: <1370580600.4021.72.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 010/184] usermodehelper: introduce umh_complete(sub_info)
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>, dann frazier <dannf@debian.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 07 Jun 2013 05:50:00 +0100
In-Reply-To: <20130604172130.718498876@1wt.eu>
References: <20130604172130.718498876@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fscV4bUBeKn4rtX/cIqI"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fscV4bUBeKn4rtX/cIqI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:21 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Oleg Nesterov <oleg@redhat.com>
>=20
> commit b3449922502f5a161ee2b5022a33aec8472fbf18 upstream
>=20
> Preparation.  Add the new trivial helper, umh_complete().  Currently it
> simply does complete(sub_info->complete).
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [dannf: Adjusted to apply to Debian's 2.6.32]

Dann's backports are mostly missing his Signed-off-by.  (We don't
usually bother with this in the Debian patch queue, but probably ought
to do so when backporting.)

Ben.

> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  kernel/kmod.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index a061472..2a27d17 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -206,6 +206,11 @@ void call_usermodehelper_freeinfo(struct subprocess_=
info *info)
>  }
>  EXPORT_SYMBOL(call_usermodehelper_freeinfo);
> =20
> +static void umh_complete(struct subprocess_info *sub_info)
> +{
> +	complete(sub_info->complete);
> +}
> +
>  /* Keventd can't block, but this (a child) can. */
>  static int wait_for_helper(void *data)
>  {
> @@ -245,7 +250,7 @@ static int wait_for_helper(void *data)
>  	if (sub_info->wait =3D=3D UMH_NO_WAIT)
>  		call_usermodehelper_freeinfo(sub_info);
>  	else
> -		complete(sub_info->complete);
> +		umh_complete(sub_info);
>  	return 0;
>  }
> =20
> @@ -280,7 +285,7 @@ static void __call_usermodehelper(struct work_struct =
*work)
>  		/* FALLTHROUGH */
> =20
>  	case UMH_WAIT_EXEC:
> -		complete(sub_info->complete);
> +		umh_complete(sub_info);
>  	}
>  }
> =20

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-fscV4bUBeKn4rtX/cIqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFmeOe/yOyVhhEJAQqK8A/+KrcqvmRLvgRXcrTa2FPwchyfNabCQ9Sp
CsZZfny6FkgwqIvsho9twsHYhsEt7RuNLsJn4ioCAdpZOP97u8vuJX+QpD3o+8Hz
tUHMQeX118r3B/jaWS03XMa/Db9qftXUvzHeJPq8ZnKvaFuSOY85sbMlpLr4tZRK
GiNQ5aZMLzKJZEv5JbloVBl0ruI/2BHMfwXLeBgS9SzZfM5zABxYYkzkDdRllYJL
QNiAbt1F05z+84qEQ6F/nwUTapKyvFX7bkPPCe0719+qIlEViIBFBejpveHmUvyR
tAHzgLr6lOVZ3vSJvij46pr48uTWxYpU9VLAYu67G6XyxdZ/dCkYwXg0VZ3IixO6
ox8zbMV9DRlZFdkAoZAnmIBvaOr9whVxQ+xoyHj072oogBbkk+70Qi4J1WWiDS1j
l3+rtG3ZP8bEWtVpMKYxT5kN8L2K5zDrf7nsFs4EFWrT4Ij3E/n2J43yb7lQGXh5
DEqLd0rnUAmL3yuBolZSMzLvMTj/pZUIpSTqYMmKr8dXpn1zrYvaxic1yw26vkRn
ao0rD8r/aer9Ffm69oeHMOtxfcNOD3BHdO5+CUuT1ILDc/lrevD7kXnm0Rr7pEtP
kMwDNJ+s0j/326uUqVsUEuVVFtzxJX+sxt1J3cp8tilDhb35b4NeVF2NMpkJSeM7
JXk0536Yr5g=
=7vJS
-----END PGP SIGNATURE-----

--=-fscV4bUBeKn4rtX/cIqI--
