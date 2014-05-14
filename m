Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaENHFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:05:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44005 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750721AbaENHFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:05:04 -0400
Date: Wed, 14 May 2014 09:00:38 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 4/6] arm: add basic support for Mediatek MT6589 boards
Message-ID: <20140514070038.GG29258@lukather>
References: <1399938570-11356-1-git-send-email-matthias.bgg@gmail.com>
 <1399938570-11356-5-git-send-email-matthias.bgg@gmail.com>
 <20140513224732.GJ20486@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzX0AQGjRQPusK/O"
Content-Disposition: inline
In-Reply-To: <20140513224732.GJ20486@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzX0AQGjRQPusK/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Tue, May 13, 2014 at 03:47:32PM -0700, Stephen Boyd wrote:
> On 05/13, Matthias Brugger wrote:
> > diff --git a/arch/arm/mach-mediatek/mediatek.c b/arch/arm/mach-mediatek=
/mediatek.c
> > new file mode 100644
> > index 0000000..73dfb05
> > --- /dev/null
> > +++ b/arch/arm/mach-mediatek/mediatek.c
> > @@ -0,0 +1,32 @@
> > +/*
> > + * Device Tree support for Mediatek SoCs
> > + *
> > + * Copyright (c) 2014 MundoReader S.L.
> > + * Author: Matthias Brugger <matthias.bgg@gmail.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/irqchip.h>
> > +#include <asm/mach/arch.h>
> > +#include <asm/mach/map.h>
> > +
> > +static const char * const mediatek_board_dt_compat[] =3D {
>=20
> __initconst?
>=20
> > +	"mediatek,mt6589",
> > +	NULL,
> > +};
> > +
> > +DT_MACHINE_START(MEDIATEK_DT, "Mediatek Cortex-A7 (Device Tree)")
> > +	.dt_compat	=3D mediatek_board_dt_compat,
> > +MACHINE_END
>=20
> You shouldn't need this file at all if the platform is part of
> the multi-platform kernel.

=46rom a technical point of view, you don't. But it's interesting to
keep it mostly for two things:
  - You get to see the platform name in /proc/cpuinfo
  - If you ever need to add platform quirks, it's already there

We had a similar discussion two weeks ago for mach-sunxi with Olof and
Arnd, and ended up keeping this minimal machine.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NzX0AQGjRQPusK/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcxSWAAoJEBx+YmzsjxAgWbUP/1KjxjXr7cMTDuUDXH3PeY82
MD2yTOL0Xu8nkg8I8kw38RCNb5/6TEavsNm3gBkAANo+h45VQPtNC3oyzsWIOMOQ
8MTJAh3azNQKO4YHJ92G2uR1o/O0nzkWXJB6yWeWlVjsOKk2dytVUD4d17g2yy4B
kfMNjH7/Zu3PeFHgIvgTBsKptvbl5iOUq9RY3V/soH0jVoS4s2JIWHnegcu4dNU9
X1mzlkPnbf2WvrIVPdzLg20jiqo8/w9Roq6PIsv9R9eaUYrXz7WVlAcEEFP2Xqyp
rgenE5ysbqJznHu8mUmkWf3TkUdZ72od+GiYA/2FEox0UK2M8m/OaNlYBh3Ikn0k
7X9kGtaoHnF70IzvNfJi8vnZuWJz2Uz7SHPYpEgwb2sEbu56kB0biLI8dQQjqtOw
jOsH75GnvqW37K4FVTsfH5KVXRWZYNVky/1nm+ANmnMHAdUk9uz9ICiUM8I8YOyK
9BH5BP8Ggwmnwo6wz6pNMfAP1cr1D6hSGhJqNfVzduFg8DMp0MK1+agkSZ/PCarV
CBWSo3QP95E+zGLl2red0MnumxCckQG+9znSH/QppMiQPT40DnIDtxVQ1yPagelS
LfyXV/J2x8t0iaFiuZvt9uaN82Q5m7jxyVUQylHxTjm29P/om8d/PadksHdBq4fw
IY74rYaRWr/Rk6NxoD4V
=esYU
-----END PGP SIGNATURE-----

--NzX0AQGjRQPusK/O--
