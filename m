Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3IWEm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:42:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40828 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3IWEm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:42:56 -0400
Date: Mon, 23 Sep 2013 14:42:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the random tree
Message-Id: <20130923144250.9bd2ffb8ace7fd58480ebcb6@canb.auug.org.au>
In-Reply-To: <20130923143924.730ce3cbffbebdb7f82ce2cf@canb.auug.org.au>
References: <20130923143924.730ce3cbffbebdb7f82ce2cf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_14_42_50_+1000_/+TESG//G+pBOsPA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_14_42_50_+1000_/+TESG//G+pBOsPA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Mon, 23 Sep 2013 14:39:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the random tree, today's linux-next build (powerpc64
> allnoconfig) produced this warning:
>=20
> In file included from include/linux/kernel.h:10:0,
>                  from include/linux/sched.h:15,
>                  from include/linux/utsname.h:5,
>                  from drivers/char/random.c:238:
> drivers/char/random.c: In function 'add_interrupt_randomness':
> include/linux/bitops.h:96:2: warning: 'input[3]' may be used uninitialize=
d in this function [-Wmaybe-uninitialized]
>   return (word << shift) | (word >> (32 - shift));
>   ^
> drivers/char/random.c:827:10: note: 'input[3]' was declared here
>   __u32   input[4], cycles =3D random_get_entropy();
>           ^
> In file included from include/linux/kernel.h:10:0,
>                  from include/linux/sched.h:15,
>                  from include/linux/utsname.h:5,
>                  from drivers/char/random.c:238:
> include/linux/bitops.h:96:2: warning: 'input[2]' may be used uninitialize=
d in this function [-Wmaybe-uninitialized]
>   return (word << shift) | (word >> (32 - shift));
>   ^
> drivers/char/random.c:827:10: note: 'input[2]' was declared here
>   __u32   input[4], cycles =3D random_get_entropy();
>           ^
>=20
> Probably introduced by commit d5693ae494f2 ("random: speed up the
> fast_mix function by a factor of four").

i386 defconfig produces similar (to make testing easier).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Sep_2013_14_42_50_+1000_/+TESG//G+pBOsPA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP8bOAAoJEECxmPOUX5FEvqkQAKW4y9WFJKzsHQNmNkaFIdlA
TcOun7hrdNCugew6WJj7cXp4SFI8C5uRYqi9C5uFRWYGNB4JU7/sRmc5rZOTIgQQ
D+rV8GSr8+LlETh9rMiQ78czMq2irN42o2DMOzxbV/2QSKPZRvCPgSBO+VT+oOUO
kIb6X+rktiWLCe81cAPa/abKdT7Mh20vCb75FDIlsmaZSiGA74x6cD7/Zr8k0LAZ
vrkrELWTpCvlY16OjCKouOaZqpSrJNnACn/Rc/mayTkVd+3NGoSk/HDwW4X0rrdu
uzBSG6aRfU4tvrhQCgr7g2D5uKw5GlI5iB5S8ZxGK/1ixZ0SQ5BALSpnvmXChKA/
EWYfqzinSK2QSh6S0G9ZAs0TtRFv56PhapSWO04PSN69weTCB9fD/f1LOHXpg0mV
fYOxTBzu+UHsbOUxUodZuO76WvcKtVrPPP9iy6nxvS0vbucoXfNUdVovHa7l1+pT
aXblpiMiPAlbXsdteSKonEO7xg1WkVBGTLmnWQH1saMGk84lMSKIfE/rroWNtYoR
raQa15Tq2BTUG+BJmuMhj5PrIX23cGUHMYJG76pyBRW7EzidwmNfrIIrswa6gAci
1HO3RJg9QvELdFaRWy+V8CwoXlhlsaEue+KjIJi0+vb2vJPOiECQoqJGoab8T2YO
SG9ETo5C+ps2f2D3Ojd+
=cIQZ
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_14_42_50_+1000_/+TESG//G+pBOsPA--
