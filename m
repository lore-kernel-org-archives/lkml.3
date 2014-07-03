Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbaGCOzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:55:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965219AbaGCOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:55:06 -0400
Date: Thu, 3 Jul 2014 16:53:46 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux@maxim.org.za, Nicolas FERRE <nicolas.ferre@atmel.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 12/18] power: reset: Add AT91 poweroff driver
Message-ID: <20140703145346.GG31996@lukather>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404396906-25194-22-git-send-email-maxime.ripard@free-electrons.com>
 <6296F186-1B0C-4089-928A-4B0950BE847A@jcrosoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="64j1qyTOoGvYcHb1"
Content-Disposition: inline
In-Reply-To: <6296F186-1B0C-4089-928A-4B0950BE847A@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--64j1qyTOoGvYcHb1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 10:31:27PM +0800, Jean-Christophe PLAGNIOL-VILLARD =
wrote:
>=20
> On Jul 3, 2014, at 10:14 PM, Maxime Ripard <maxime.ripard@free-electrons.=
com> wrote:
>=20
> >=20
> > Add a driver to handle the shutdown of the Atmel SoCs. This code used t=
o be
> > (and still is) in arch/arm/mach-at91. We didn't removed it yet so that =
we can
> > convert all the boards to using this driver, before removing it entirel=
y in a
> > separate patch.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> > drivers/power/reset/Kconfig         |   7 ++
> > drivers/power/reset/Makefile        |   1 +
> > drivers/power/reset/at91-poweroff.c | 156 +++++++++++++++++++++++++++++=
+++++++
> > 3 files changed, 164 insertions(+)
> > create mode 100644 drivers/power/reset/at91-poweroff.c
> >=20
> > diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> > index b3fef01d7cbb..f9d53af50ec0 100644
> > --- a/drivers/power/reset/Kconfig
> > +++ b/drivers/power/reset/Kconfig
> > @@ -14,6 +14,13 @@ config POWER_RESET_AS3722
> > 	help
> > 	  This driver supports turning off board via a ams AS3722 power-off.
> >=20
> > +config POWER_RESET_AT91_POWEROFF
> > +	bool "Atmel AT91 poweroff driver"
> > +	default SOC_AT91SAM9 || SOC_SAMA5
> > +	help
> > +	  This driver supports poweroff for Atmel AT91SAM9 and SAMA5
> > +	  SoCs
> > +
> > config POWER_RESET_AT91_RESET
> > 	bool "Atmel AT91 reset driver"
> > 	default SOC_AT91SAM9 || SOC_SAMA5
> > diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> > index 1599214b91d9..8bf941bac3da 100644
> > --- a/drivers/power/reset/Makefile
> > +++ b/drivers/power/reset/Makefile
> > @@ -1,4 +1,5 @@
> > obj-$(CONFIG_POWER_RESET_AS3722) +=3D as3722-poweroff.o
> > +obj-$(CONFIG_POWER_RESET_AT91_POWEROFF) +=3D at91-poweroff.o
> > obj-$(CONFIG_POWER_RESET_AT91_RESET) +=3D at91-reset.o
> > obj-$(CONFIG_POWER_RESET_AXXIA) +=3D axxia-reset.o
> > obj-$(CONFIG_POWER_RESET_GPIO) +=3D gpio-poweroff.o
> > diff --git a/drivers/power/reset/at91-poweroff.c b/drivers/power/reset/=
at91-poweroff.c
> > new file mode 100644
> > index 000000000000..2f2a69e9bae3
> > --- /dev/null
> > +++ b/drivers/power/reset/at91-poweroff.c
> > @@ -0,0 +1,156 @@
> > +/*
> > + * Atmel AT91 SAM9 SoCs reset code
> > + *
> > + * Copyright (C) 2014 Maxime Ripard
> > + *
> > + * Maxime Ripard <maxime.ripard@free-electrons.com>
> > + *
>=20
> As it=E2=80=99s mostly a copy of other people work you can not claim the =
copyright

Yep. It was a wrongful copy and paste on my side.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--64j1qyTOoGvYcHb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtW56AAoJEBx+YmzsjxAgzk8P/1rCSS9xtfgRusMpK7rT9jON
Z0fM++ezGM++2v0bIW9YJJthEbqOSvvkHq+ube8vBh3ZXwm9ESWPG+dp/+5ZcWia
07Y0Gsz8QUGu+PWtcEKNY5+vsRWbeuzbHKU30xfnWDoOYzW1JrXwKhFzC56sn7Ex
9qNHYryRVpyE5I5F1sOpp6/m99pfMcnqyI6OsKUzTQ9UqEhfFwiAIcx0KoKGSRTv
pC+VyOiD0rfnA38ol6FERignRMm4UTPdTjxBV4n/X5mhxKcya9hjLPOuWzM8R5Vz
E4FkfVBmCoGUw4DW6Kxbl3bI0Wukqq2sc4UfGcUCwFLS51+cKKtpSK3D7DTcSMsa
kuI7/bDP7EGPWazQRo96FZHpQ87q68gTeEMSpPUhhO6m2iuTqOlDYCJ4elWXc1c1
82LqM0j/yF6EbvBNvLedT3qYXfWYl/T/Sm39NS1x84RmwQV0wqlKOVpIffBO1s6m
vx7lgXrDmn0LjpZiWwb1QdATTPGKLfoff7vvRKqZS62kBNhvZQEi/9dMuK0QkuaW
EP10vBv3wb8xzOs9GYjrcUhXlto0odSKX3AXTp/3aiKRHBE7KY1MORYc6lHVtiHd
uMs5VfDa+/W71ZzBOQCumzpe859Fq3pLIUJxM2le/EHIPbv3p5e61TMqCAft3wwc
QGuZbRzMecS/PIq5mYDL
=uarQ
-----END PGP SIGNATURE-----

--64j1qyTOoGvYcHb1--
