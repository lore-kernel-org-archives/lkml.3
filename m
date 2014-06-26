Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaFZMzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:55:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35076 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708AbaFZMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:55:04 -0400
Date: Thu, 26 Jun 2014 14:54:19 +0200
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
Message-ID: <20140626125419.GC3385@lukather>
References: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com>
 <1403701605-26678-14-git-send-email-maxime.ripard@free-electrons.com>
 <53ABAF1E.5030405@free-electrons.com>
 <20140626093006.GB3385@lukather>
 <53AC0882.3010601@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <53AC0882.3010601@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2014 at 01:48:18PM +0200, Boris BREZILLON wrote:
>=20
> On 26/06/2014 11:30, Maxime Ripard wrote:
> > Hi Boris,
> >
> > On Thu, Jun 26, 2014 at 07:26:54AM +0200, Boris BREZILLON wrote:
> >> On 25/06/2014 15:06, Maxime Ripard wrote:
> >>> Now that we don't depend on anyting in the mach-at91 directory, we ca=
n just
> >>> move the driver to where it belongs.
> >>>
> >>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >>> ---
> >>>  arch/arm/mach-at91/Kconfig                                     | 4 -=
---
> >>>  arch/arm/mach-at91/Makefile                                    | 1 -
> >>>  drivers/clocksource/Kconfig                                    | 4 +=
+++
> >>>  drivers/clocksource/Makefile                                   | 1 +
> >>>  {arch/arm/mach-at91 =3D> drivers/clocksource}/at91sam926x_time.c | 0
> >>>  5 files changed, 5 insertions(+), 5 deletions(-)
> >>>  rename {arch/arm/mach-at91 =3D> drivers/clocksource}/at91sam926x_tim=
e.c (100%)
> >>>
> >>> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> >>> index a64412a020d3..b10db0990999 100644
> >>> --- a/arch/arm/mach-at91/Kconfig
> >>> +++ b/arch/arm/mach-at91/Kconfig
> >>> @@ -36,10 +36,6 @@ config AT91_SAM9G45_RESET
> >>>  	bool
> >>>  	default !ARCH_AT91X40
> >>> =20
> >>> -config AT91_SAM9_TIME
> >>> -	select CLKSRC_OF if OF
> >>> -	bool
> >>> -
> >>>  config HAVE_AT91_SMD
> >>>  	bool
> >>> =20
> >>> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> >>> index 78e9cec282f4..1a916ececbfd 100644
> >>> --- a/arch/arm/mach-at91/Makefile
> >>> +++ b/arch/arm/mach-at91/Makefile
> >>> @@ -10,7 +10,6 @@ obj-		:=3D
> >>>  obj-$(CONFIG_OLD_CLK_AT91)	+=3D clock.o
> >>>  obj-$(CONFIG_AT91_SAM9_ALT_RESET) +=3D at91sam9_alt_reset.o
> >>>  obj-$(CONFIG_AT91_SAM9G45_RESET) +=3D at91sam9g45_reset.o
> >>> -obj-$(CONFIG_AT91_SAM9_TIME)	+=3D at91sam926x_time.o
> >>>  obj-$(CONFIG_SOC_AT91SAM9)	+=3D sam9_smc.o
> >>> =20
> >>>  # CPU-specific support
> >>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> >>> index 065131cbfcc0..cd8b73ddbef3 100644
> >>> --- a/drivers/clocksource/Kconfig
> >>> +++ b/drivers/clocksource/Kconfig
> >>> @@ -118,6 +118,10 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
> >>>  	help
> >>>  	 Use ARM global timer clock source as sched_clock
> >>> =20
> >>> +config AT91_SAM9_TIME
> >>> +	select CLKSRC_OF if OF
> >>> +	bool
> >>> +
> >>>  config CLKSRC_METAG_GENERIC
> >>>  	def_bool y if METAG
> >>>  	help
> >>> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makef=
ile
> >>> index 800b1303c236..3088928070f8 100644
> >>> --- a/drivers/clocksource/Makefile
> >>> +++ b/drivers/clocksource/Makefile
> >>> @@ -1,5 +1,6 @@
> >>>  obj-$(CONFIG_CLKSRC_OF)	+=3D clksrc-of.o
> >>>  obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+=3D tcb_clksrc.o
> >>> +obj-$(CONFIG_AT91_SAM9_TIME)	+=3D at91sam926x_time.o
> >> I would rename both Kconfig and source file name into ATMEL_PIT and
> >> atmel_pit.c (or AT91_PIT and atmel_pit.c) to cleary show that this
> >> driver add support for the PIT block.
> > I actually had the same idea, but older AT91 SoCs (rm9200, for
> > example) also mention the PIT, even though the IP is different.
>=20
> I checked at91rm9200 datasheet, and indeed it mention the concept of PIT
> (Periodic Interval Timer), but the HW block is called ST (System Timer).
>=20
> How about using the name ATMEL_PIT for this driver and later use
> ATMEL_ST when we decide to move at91rm9200_time.c driver into
> drivers/clocksource ?

Works for me.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrBf7AAoJEBx+YmzsjxAgv+sP/1QwvXCIwnoC6Z1E4Dy6gpVM
kyUVRiK8BIm9foZ4uiJJULe5Lj46bF8d2ZIsjvMmiKSg/7rXuVCXmNbFybp6RxNV
0i6MnVnjsi00Nt6r39Hcg9b1QIiGdYG6BmvrEbkrMsmdHxDrj3r1wqQAHdQklRAK
PPX7tks7qRv7DP/VT9BSambNjkB5JkC5UJqRAP4/TtYvm2qgg+45BgR6zB+G1frM
ip+hny63A1NF2Oqa7fe2qv7Uq1V8NDpOSsvsRjLQ6p1gtZ6EjlampT1qb5u/3lq8
5n9yBa1vO4zZnXvtylw1Hx9sH6cAse1LE12X9JdboVyIydZQ7H+T/T11Zzqyu3E5
ta5aG1TtoZMbnQUY+jqJzUDS7H5PZ1k7lPWSo9S6RBhuP05oVG3W6fXUv9xxRDcn
2/7ItEmf540Wtd7hi2EjP70Hk2yDhAgyrySZZ0zjX46QxC8zw6mGQVl5lprW3/26
gt6NsRkOZHeTy/+q1T90d76l/lHrODKT5nHu5sgQEjrBbQN6uUbVOkI7m2yw5QX0
xjyD/vqoP1ocxQ7XUXhuaGYBZWsJgJtgABi1wiM2+eZ3szR4Y0TpQokG4ra3LING
izkW4oBS6ieALt1Cfr5VB0jLVYOIuy/KGV2MJFuxzgDINlzotZblkL8juCgKMWbb
TCHpcLue/imgZn8oyv4z
=LbC9
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
