Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaLZQ0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:26:43 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43984 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaLZQ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:26:40 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] add omap34xx temperature monitoring support
Date: Fri, 26 Dec 2014 17:26:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        ivo.g.dimitrov.75@gmail.com, jdelvare@suse.de, linux@roeck-us.net,
        lm-sensors@lm-sensors.org
References: <20141226102933.GA28778@amd> <20141226155456.GB12409@atomide.com> <20141226161757.GD12409@atomide.com>
In-Reply-To: <20141226161757.GD12409@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7693259.07laUllPLH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412261726.35668@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7693259.07laUllPLH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 26 December 2014 17:17:57 Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [141226 07:57]:
> > * Pavel Machek <pavel@ucw.cz> [141226 02:32]:
> > > --- /dev/null
> > > +++ b/drivers/hwmon/omap34xx_temp.c
> > > @@ -0,0 +1,263 @@
> > > +/*
> > > + * omap34xx_temp.c - Linux kernel module for OMAP34xx
> > > hardware monitoring + *
> > > + * Copyright (C) 2008 Nokia Corporation
> > > + *
> > > + * Written by Peter De Schrijver
> > > <peter.de-schrijver@nokia.com> + *
> > > + * Inspired by k8temp.c
> > > + *
> > > + * This file is subject to the terms and conditions of
> > > the GNU General + * Public License. See the file
> > > "COPYING" in the main directory of this + * archive for
> > > more details.
> > > + *
> > > + * This program is distributed in the hope that it will
> > > be useful, + * but WITHOUT ANY WARRANTY; without even the
> > > implied warranty of + * MERCHANTABILITY or FITNESS FOR A
> > > PARTICULAR PURPOSE.  See the + * GNU General Public
> > > License for more details.
> > > + */
> > > +
> > > +#include <linux/clk.h>
> > > +#include <linux/hrtimer.h>
> > > +#include <linux/module.h>
> > > +#include <linux/hwmon.h>
> > > +#include <linux/hwmon-sysfs.h>
> > > +#include <linux/err.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/io.h>
> > > +#include <linux/slab.h>
> > > +
> > > +#include "../../arch/arm/mach-omap2/control.h"
> >=20
> > No need to do this, you can use syscon here like
> > pbias-regulator.c is doing.
>=20
> Oh looks like you're already using syscon, nice. What defines
> do you need from control.h?
>=20
> Those should be in the driver if private to the driver, or
> else we should have some minimal header in include/linux
> somewhere if some control.h defines really need to be
> exposed.
>=20
> Regards,
>=20
> Tony

Hi Tony,

Sebastian Reichel has already sent new version of temperature=20
driver. See email thread with subject:

[PATCH 0/3] OMAP3 temperature sensor

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart7693259.07laUllPLH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSdjDsACgkQi/DJPQPkQ1Lw+ACcDN2lz98KkTiOwdnJA1az4VzT
xB0AoMfO3MB7UJvxIw/Jll7njj/BkH2f
=SkcA
-----END PGP SIGNATURE-----

--nextPart7693259.07laUllPLH--
