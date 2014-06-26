Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaFZJfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:35:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42436 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbaFZJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:35:04 -0400
Date: Thu, 26 Jun 2014 11:30:06 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] AT91: PIT: Move the driver to drivers/clocksource
Message-ID: <20140626093006.GB3385@lukather>
References: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com>
 <1403701605-26678-14-git-send-email-maxime.ripard@free-electrons.com>
 <53ABAF1E.5030405@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <53ABAF1E.5030405@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Thu, Jun 26, 2014 at 07:26:54AM +0200, Boris BREZILLON wrote:
>=20
> On 25/06/2014 15:06, Maxime Ripard wrote:
> > Now that we don't depend on anyting in the mach-at91 directory, we can =
just
> > move the driver to where it belongs.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/mach-at91/Kconfig                                     | 4 ----
> >  arch/arm/mach-at91/Makefile                                    | 1 -
> >  drivers/clocksource/Kconfig                                    | 4 ++++
> >  drivers/clocksource/Makefile                                   | 1 +
> >  {arch/arm/mach-at91 =3D> drivers/clocksource}/at91sam926x_time.c | 0
> >  5 files changed, 5 insertions(+), 5 deletions(-)
> >  rename {arch/arm/mach-at91 =3D> drivers/clocksource}/at91sam926x_time.=
c (100%)
> >
> > diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> > index a64412a020d3..b10db0990999 100644
> > --- a/arch/arm/mach-at91/Kconfig
> > +++ b/arch/arm/mach-at91/Kconfig
> > @@ -36,10 +36,6 @@ config AT91_SAM9G45_RESET
> >  	bool
> >  	default !ARCH_AT91X40
> > =20
> > -config AT91_SAM9_TIME
> > -	select CLKSRC_OF if OF
> > -	bool
> > -
> >  config HAVE_AT91_SMD
> >  	bool
> > =20
> > diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> > index 78e9cec282f4..1a916ececbfd 100644
> > --- a/arch/arm/mach-at91/Makefile
> > +++ b/arch/arm/mach-at91/Makefile
> > @@ -10,7 +10,6 @@ obj-		:=3D
> >  obj-$(CONFIG_OLD_CLK_AT91)	+=3D clock.o
> >  obj-$(CONFIG_AT91_SAM9_ALT_RESET) +=3D at91sam9_alt_reset.o
> >  obj-$(CONFIG_AT91_SAM9G45_RESET) +=3D at91sam9g45_reset.o
> > -obj-$(CONFIG_AT91_SAM9_TIME)	+=3D at91sam926x_time.o
> >  obj-$(CONFIG_SOC_AT91SAM9)	+=3D sam9_smc.o
> > =20
> >  # CPU-specific support
> > diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> > index 065131cbfcc0..cd8b73ddbef3 100644
> > --- a/drivers/clocksource/Kconfig
> > +++ b/drivers/clocksource/Kconfig
> > @@ -118,6 +118,10 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
> >  	help
> >  	 Use ARM global timer clock source as sched_clock
> > =20
> > +config AT91_SAM9_TIME
> > +	select CLKSRC_OF if OF
> > +	bool
> > +
> >  config CLKSRC_METAG_GENERIC
> >  	def_bool y if METAG
> >  	help
> > diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> > index 800b1303c236..3088928070f8 100644
> > --- a/drivers/clocksource/Makefile
> > +++ b/drivers/clocksource/Makefile
> > @@ -1,5 +1,6 @@
> >  obj-$(CONFIG_CLKSRC_OF)	+=3D clksrc-of.o
> >  obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+=3D tcb_clksrc.o
> > +obj-$(CONFIG_AT91_SAM9_TIME)	+=3D at91sam926x_time.o
>=20
> I would rename both Kconfig and source file name into ATMEL_PIT and
> atmel_pit.c (or AT91_PIT and atmel_pit.c) to cleary show that this
> driver add support for the PIT block.

I actually had the same idea, but older AT91 SoCs (rm9200, for
example) also mention the PIT, even though the IP is different.

Since AT91_PIT was just too generic and only added confusion, I left
it as is, but maybe we can find a better name.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTq+geAAoJEBx+YmzsjxAg988P/iuKJhFLPh7tFrHAvXGrPNzt
ZD5OP/VkpAkuGwCmcHkpM/DmmRIJPIOPy19ZtLhI5hbSbqWsTMhqX9NSBnDf5vWk
2bxJI+F7yI1wqaxLZCGr+Hyh46wMt014l7B0qVCUgfnvYhCQ2K6mJc9J2zcvjnWu
hyzlZngOfbLHgglr0C3YJVA/hFEEqP7T8+r7Np5+q8dQx+9AnuV7Gk/GpDt2RUEH
WRI9RTFCa8LDYRntlQsiWqM3AZlQeetcgV+2yR2RnKzHtCh+l4WgFp6iGueFGAQp
UHNv60wIZ9LnHHPfLWy4A0pwN7pxGK17C+iIYI5oC8HGRDS910gAdzCpbH45PUl0
HLh0ipbHgFF2CjI7fQ28XsdTxKuMmWHrrCU6OGMgM0qCUzg0MIXtOHhXBQyOskqP
q/nGVog5Ly/GRcrRA+iJmTSNIU023Wb2ZJadi5DSxp4t/u3sR7ZnxcbZ+C4eY3Hc
tsrMiuWirMleUDklhkePhvwMa3jGzpB+cPxoT5fO9n8x5eNpD6MzFBoaX/f7kkqz
Uh8MCStajpIYn55DLI1TauWyDfE7MUDV/woVC5tnDy6loOke6ImE4Nbrt5CtWtNh
uIXIrO0YPE7b4Xg6aayLdwdS8HhEvmrdJAhBaw2lz0EwzLWP+jqYh63tTkAu7N1Q
kUTSrG4WSoLwl5ACk0Q8
=sVbO
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
