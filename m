Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaLSIu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:50:26 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42251 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaLSIuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:50:23 -0500
Date: Fri, 19 Dec 2014 09:50:17 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org
Subject: Re: randconfig build error with next-20141204, in drivers/pwm
Message-ID: <20141219085015.GA7352@ulmo>
References: <CA+r1Zhj2ugeO7yqfmnbmkF4xqmZiiSbvq0zVXDMXdfOYGiHcRg@mail.gmail.com>
 <20141218094442.GA24383@ulmo>
 <20141218205132.3025b1ef@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20141218205132.3025b1ef@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2014 at 08:51:32PM +0100, Boris Brezillon wrote:
> Hi Thierry,
>=20
> On Thu, 18 Dec 2014 10:44:44 +0100
> Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Thu, Dec 04, 2014 at 09:10:55AM -0700, Jim Davis wrote:
> > > Building with the attached random configuration file,
> > >=20
> > > ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined! =
=20
> >=20
> > This took a while to figure out. The attached patch fixes this build
> > failure, though the driver should probably be fixed to avoid division by
> > zero, just in case. Adding Boris for visibility.
>=20
> Thanks for fixing this build issue. I'll propose a patch to prevent
> this div by 0 from happening.
>=20
> >=20
> > Thierry
> >=20
> > From 7933af1d2e5f3941d934eec88f32f5547ee218c3 Mon Sep 17 00:00:00 2001
> > From: Thierry Reding <thierry.reding@gmail.com>
> > Date: Thu, 18 Dec 2014 10:09:42 +0100
> > Subject: [PATCH] pwm: atmel-hlcdc: Depend on HAVE_CLK
> >=20
> > The include/linux/clk.h header defines dummy implementations for the
> > various clk_*() functions if HAVE_CLK is not selected to improve build
> > coverage in randconfig builds.
> >=20
> > The dummy implementation of clk_get_rate() returns 0, which causes the
> > Atmel HLCDC PWM driver's atmel_hlcdc_pwm_config() implementation to end
> > up calling:
> >=20
> > 	do_div(clk_period_ns, 0)
> >=20
> > On x86, do_div(n, base) will end up evaluating to this:
> >=20
> > 	n >>=3D ilog2(base)
> >=20
> > with base =3D 0, the implementation of ilog2() will call ____ilog2_NaN(=
),
> > which is purposely undefined and results in a linker failure:
> >=20
> > 	ERROR: "____ilog2_NaN" [drivers/pwm/pwm-atmel-hlcdc.ko] undefined!
> >=20
> > The implementation of do_div() checks that base is a power of 2 before
> > calling ilog2(). The compiler doesn't optimize this away, presumably
> > because is_power_of_2() is an inline function and the compiler doesn't
> > or can't inspect it closely enough. ilog2() being a macro it still ends
> > up generating the ____ilog2_NaN() because of the constant 0.
> >=20
> > The root of the problem is that the driver really should be checking
> > before possibly dividing by zero. That should eventually be fixed, but
> > for now just assume that the clock runs at a sensible frequency when
> > available.
> >=20
> > Reported-by: Jim Davis <jim.epost@gmail.com>
> > Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
>=20
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Applied, thanks.

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUk+bHAAoJEN0jrNd/PrOhAEEQAIYFbWvaydNVtlUFiXEP1gnW
91iAsS++cIS5005VPAS1m5hHPmcLAVAVna+Tw8zvR2wjURctNTeUvqzJuHKUEwHn
u+pNwjrfJ2Iu3aYLqTlCAlU1HnBybdPXMEE78yTpkGWzHiUvlfNZ/rFx3J8fvxAt
GQlW/+JkFKnmHmTxFDfySlmgJslJO3bTvigdf38XCFj1yKA8OXT4Y/fZeUxYfcpM
M5c2xoMw/qIXSROZCQqmBDtQTdjZJZTT7sd/+0O70qCWB07KamdgbErVbiDx3GTh
EVRWZ+H6VJjoMGSlWvxJyXitITuxUZWgbWOsn9RkIxJbYZC9Zj9GluvZYFhzxPTQ
X8UD8mfxMsQXPW3lDx9ibOcCZeDXaYJ2ZOYzWKHnMgo4lo3cYEcHkxHAZht4xp0n
ySTL6O0EkqJDHqd+XOOqSsze4Lzx4bJB1wU3/ecRbeH9UUt+sFkKWfzEvCzNgSXE
bnFGH/VebKLax+pYfAvop0MUWI0LRTYkl8ACszvJmPUVLYim65N4RxfOVWdhJ07c
od14hSqoeX9MBlbejnzcGqCvBNvTIZ2f5QdU6FPxgomqDFnqt7yAjWlIlqMQ0Z3H
cyDDDhaDADGikyyVg9WoPHOo6rN20JGW3x11Ux9pvjp7UPoUaPBHHgGEUEoouZgk
deBh3dkEY6l1Z/aTUroe
=0REt
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
