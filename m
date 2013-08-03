Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab3HCKBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 06:01:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59305 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab3HCKBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 06:01:37 -0400
Message-ID: <1375524085.32254.26.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.50
From: Ben Hutchings <ben@decadent.org.uk>
To: Teck Choon Giam <giamteckchoon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org, lwn@lwn.net
Date: Sat, 03 Aug 2013 12:01:25 +0200
In-Reply-To: <CAEwRVpPdWLoZHq6Q94zVoPwG65e=TVUR6HyUJ1ZyvL6+8oCpgw@mail.gmail.com>
References: <1375480258.32254.24.camel@deadeye.wl.decadent.org.uk>
	 <CAEwRVpPdWLoZHq6Q94zVoPwG65e=TVUR6HyUJ1ZyvL6+8oCpgw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cGcYqIq137Cmyz8Mom6Y"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.218.101.46
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cGcYqIq137Cmyz8Mom6Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-08-03 at 09:09 +0800, Teck Choon Giam wrote:
[...]
> I am getting the following error while trying to compile for 32bit in
> Scientific Linux 6.4:
>=20
> drivers/net/ifb.c: In function 'ifb_init_module':
> drivers/net/ifb.c:298: error: implicit declaration of function 'cond_resc=
hed'
> make[2]: *** [drivers/net/ifb.o] Error 1
>=20
> Missing include of linux/sched.h in drivers/net/ifb.c file?
>=20
> I tried the following patch and it does compile successfully:
>=20
> --- a/drivers/net/ifb.c    2013-08-03 04:15:12.000000000 +0800
> +++ b/drivers/net/ifb.c 2013-08-03 08:43:29.040492584 +0800
> @@ -34,6 +34,7 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/moduleparam.h>
> +#include <linux/sched.h>
>  #include <net/pkt_sched.h>
>  #include <net/net_namespace.h>
>=20
>=20
> FYI and comment please.

Yes I think that's the right change.  Linux 3.0.88-rc1 had the same
problem and I should have remembered this was needed.

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-cGcYqIq137Cmyz8Mom6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfzU9ee/yOyVhhEJAQpddQ//Qs7f+uHANkcudlH0zVsIxu87AKvsE1XX
TqYeli/9XTTi1fCljn7/e4zsYMGzX1q/lraP1RxR75BL/+hemvBa0xIVAc2tTRbJ
2fMAQI+546nzrWw/aQqz6N2rQV9+nsRyHjPoaoI7VoeUr9oI1EKi0Hrq+St6IK2S
IpubK8D1zW2b4Z9UjRFWthPIH/9J/AzGl28qEjA8BsBHl1imyFFpId5sMDpYWCIO
8vFqK03k9EG3j3rFuwPfeMX6nzMtb0Em82n1gj+QTzhifYWdh+vT28598bJyIpy9
NISHeNqARYVGGw+fz9xKNE+QYldMPMLJljgHJt2W5p9Bnh+lKJsH7AJ5C/y+9eSY
PlWKMNilObAcq1mLzm3BXC9+WkW5FSp0NVWHk5mpRs0V4Nsk9W1hKahgWcbsI+ln
AI68q3mBJvkOU4zyEYAxhNtfPaj7sRSD5WDnH36izBJjePYUkxg0R+UCiUExVFDi
FTwb5tMkn+GG2OsIrHqp/xHAqcxM+CNbknfZtiC2fv5eYTYMZ7VpbP04ZjBF+GxX
AOSczVMKPhsxLbohe1RqDre62KwUNe507eLha4/J/KT1VW90PIiLH+yn3/vOLReT
poFxArf5SHEt1ySbU2//ypTP1B+Jvo5W7ql5j9AbUWOQ8HBLtNOVQ+4cECRKd1hx
7u/F7fT1dxE=
=2U+Y
-----END PGP SIGNATURE-----

--=-cGcYqIq137Cmyz8Mom6Y--
