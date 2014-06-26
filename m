Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaFZJaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:30:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42375 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbaFZJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:30:05 -0400
Date: Thu, 26 Jun 2014 11:28:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] AT91: PIT: (Almost) remove the global variables
Message-ID: <20140626092820.GA3385@lukather>
References: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com>
 <1403701605-26678-10-git-send-email-maxime.ripard@free-electrons.com>
 <53ABABA6.1060205@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <53ABABA6.1060205@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Thu, Jun 26, 2014 at 07:12:06AM +0200, Boris BREZILLON wrote:
> Hello Maxime,
>=20
> On 25/06/2014 15:06, Maxime Ripard wrote:
> > The timer driver is using some global variables to define some variable=
s it has
> > to use in most of its functions, like the base address.
> >
> > Use some container_of calls to have a single dynamic (and local) variab=
le to
> > hold this content.
> >
> > The only exception is in the !DT case, where the call chain to
> > at91sam926x_ioremap_pit and then at91sam926x_pit_init as init_time make=
s it
> > hard for the moment to pass the physical address of the timer.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/mach-at91/at91sam926x_time.c | 179 ++++++++++++++++++++------=
--------
> >  1 file changed, 108 insertions(+), 71 deletions(-)
> >
> > diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91=
/at91sam926x_time.c
> > index 9678ac391a81..f2c463567beb 100644
> > --- a/arch/arm/mach-at91/at91sam926x_time.c
> > +++ b/arch/arm/mach-at91/at91sam926x_time.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/of.h>
> >  #include <linux/of_address.h>
> >  #include <linux/of_irq.h>
> > +#include <linux/slab.h>
> > =20
>=20
> [...]
>=20
> >  	unsigned	bits;
> > @@ -186,67 +195,95 @@ static void __init at91sam926x_pit_common_init(un=
signed int pit_irq)
> >  	 * Use our actual MCK to figure out how many MCK/16 ticks per
> >  	 * 1/HZ period (instead of a compile-time constant LATCH).
> >  	 */
> > -	pit_rate =3D clk_get_rate(mck) / 16;
> > -	pit_cycle =3D (pit_rate + HZ/2) / HZ;
> > -	WARN_ON(((pit_cycle - 1) & ~AT91_PIT_PIV) !=3D 0);
> > +	pit_rate =3D clk_get_rate(data->mck) / 16;
> > +	data->cycle =3D (pit_rate + HZ/2) / HZ;
>=20
> You could use DIV_ROUND_CLOSEST here.

I usually prefer not to introduce such changes whenever I'm just
renaming a variable, but it's true that this change would be
welcome. I'll do the change in a separate patch.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTq+e0AAoJEBx+YmzsjxAgmVMP/jMwCtq9JTvquij3D0gsZBJ0
QI2by2pttsmseis3tIppOGMSDgITWFzCC0WMpfRsl5RLCQVEgAUeD+kIVe7fH6xB
ALgk5lHXNXEdTet1KBkc0dSQ3+ZVks+g5LDZfZWnWcd9nvEPUxCgoic0Rz4BzrMd
hYMofHxjtXD3N1K1i6LhngM8CM6fbeAiLTbO4G1piSbkYyleJ3/f2S9IWrxvz4Kd
7aFXXN992qTQKuZMFCPI8FS1d/ZoqbYCwPBbU1K2KXDXrEYa7WONJft0SOHK2/KP
/xUTBnkgXTgYEmzUXpu4ejxgWBZZmuLiyHaoOddjf0iy6Om9hQRw20melXmfyA6W
B2Z6mqnSBiPzRppZt+aG8sqe5aTzG2GLJfifNmCprilsvY6QgYMIHfLzRdSGf6ko
1PkktWwFbdB/GqKiK2MDv+dAXgjSYwNwBzY/4/n7kSa2ScR7PLvgl9toXjtNG2ku
leMWpTLfXLvKCYl+vBlJxv/pzfLWuLNLapSdZgScgtFQS51paAfjS1enJLmVoNYs
OFQCJow11AqJCNbos+m+XvydeygNbNoHvazfCIXmin/4oLqUONV5kr9F7ruz6mdw
khPWVZRmXAy2uhQ8Ma1kLfJTPNXZ+fNqJ5jAha5/K0Q9gg2vox/d+ua/zjnqjVRV
T2ppicbNFvF79oEfmYod
=k/l/
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
