Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbaGAHZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:25:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60818 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbaGAHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:25:05 -0400
Date: Tue, 1 Jul 2014 09:21:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        "andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] dmaengine: sun6i: Add driver for the Allwinner
 A31 DMA controller
Message-ID: <20140701072119.GH28647@lukather>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140630142054.GA8756@leverpostej>
 <20140630151906.GG28647@lukather>
 <20140630153305.GA28740@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
Content-Disposition: inline
In-Reply-To: <20140630153305.GA28740@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:33:05PM +0100, Mark Rutland wrote:
> On Mon, Jun 30, 2014 at 04:19:06PM +0100, Maxime Ripard wrote:
> > On Mon, Jun 30, 2014 at 03:20:54PM +0100, Mark Rutland wrote:
> > > Hi Maxime,
> > >=20
> > > On Mon, Jun 30, 2014 at 02:20:54PM +0100, Maxime Ripard wrote:
> > > > The Allwinner A31 has a 16 channels DMA controller that it shares w=
ith the
> > > > newer A23. Although sharing some similarities with the DMA controll=
er of the
> > > > older Allwinner SoCs, it's significantly different, I don't expect =
it to be
> > > > possible to share the driver for these two.
> > > >
> > > > The A31 Controller is able to memory-to-memory or memory-to-device =
transfers on
> > > > the 16 channels in parallel.
> > > >
> > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > ---
> > > >  drivers/dma/Kconfig     |    8 +
> > > >  drivers/dma/Makefile    |    1 +
> > > >  drivers/dma/sun6i-dma.c | 1058 +++++++++++++++++++++++++++++++++++=
++++++++++++
> > > >  3 files changed, 1067 insertions(+)
> > > >  create mode 100644 drivers/dma/sun6i-dma.c
> > >=20
> > > [...]
> > >=20
> > > > +       sdc->clk =3D devm_clk_get(&pdev->dev, NULL);
> > > > +       if (IS_ERR(sdc->clk)) {
> > > > +               dev_err(&pdev->dev, "No clock specified\n");
> > > > +               return PTR_ERR(sdc->clk);
> > > > +       }
> > > > +
> > > > +       mux =3D clk_get(NULL, "ahb1_mux");
> > > > +       if (IS_ERR(mux)) {
> > > > +               dev_err(&pdev->dev, "Couldn't get AHB1 Mux\n");
> > > > +               return PTR_ERR(mux);
> > > > +       }
> > > > +
> > > > +       pll6 =3D clk_get(NULL, "pll6");
> > > > +       if (IS_ERR(pll6)) {
> > > > +               dev_err(&pdev->dev, "Couldn't get PLL6\n");
> > > > +               clk_put(mux);
> > > > +               return PTR_ERR(pll6);
> > > > +       }
> > >=20
> > > I'm slightly confused. The binding listed a single unnamed clock (the
> > > AHB clock). What is going on here?
> >=20
> > The device itself needs only a single clock to work...
> >=20
> > >=20
> > > > +       ret =3D clk_set_parent(mux, pll6);
> > > > +       clk_put(pll6);
> > > > +       clk_put(mux);
> > > > +
> > > > +       if (ret) {
> > > > +               dev_err(&pdev->dev, "Couldn't reparent AHB1 on PLL6=
\n");
> > > > +               return ret;
> > > > +       }
> > >=20
> > > Why do we need to reparent the mux?
> >=20
> > ... but will function only if this clock is derived from PLL6.
>=20
> Ok, but _why_ is that the case? Could we at least have a comment for
> that?

I have no idea, sorry.

> Where does the driver get the named clocks from if they aren't provided
> on the device node? Is there a clock-ranges somewhere?

No, it just looks up the global clock name.

> It feels a little fragile to rely on the organisation of the clock tree
> and the naming thereof. If the IP block is ever reused on an SoC with a
> different clock tree layout then we have to handle things differently.

What do you suggest then?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsmFvAAoJEBx+YmzsjxAgA/YP/1eA9rTQ3HXNcG2dB44RWRNB
XUnth2Rh/nMlTpp0sRGiUmGCMhVjTEIHJ6f44wH4sqVjsATw62UfMysnvidrPQhc
PCzAjq1wEs77hZDbUCBM/aQTX75+O3iJTPTnV4OuJRuoSuxAUhgy2VT0Y2AZYE7h
8hUNy+RKo7DA+KxGRV205FKtJ/fqYykwmuv+o5PJ8pBAvOlCpDrniMcwgVDlOgs/
O2/hN1IHeZpTDRAXsKipR5ZQHdb+q1h3PskAWeRVKV99/5+CgucS5bQK7ogd+hAz
IfcjIwnC6UynRBT+M5HHj4+2hbLrEK5jbG2L65rARChAKOmpz8AqxvXlFkbTjFel
JPtxLv4CB6clqa2VT3HsLIOuWl+CB0LrPg7UG/K/mD5sGpGaekuCCLY8goE4Iv4T
bmLKJjbMKFf1gzrfO2/sTU3pCUNyccUluVCFIUxYWfhh8U3qTtnf1VwRja8/1UkQ
6fcO310YxkzYM0VZoqcpdyFFJ1BEz5bwQHcucN71Cn4rd52hNPiiCC1efERrJ8Hj
fbLLIdDr0KLI6ZZpUfOwPJtRco4iFpd2kSBlTQxhuV0RDSTq0XK++DSWkGInnt7r
JxdBQz79zGOLbtRkoBV+K6HtsyUl3RpKu7AysgYyu1r7XQeTLYe6IA1TeGy88eiJ
tz16JE2kEYCXa6sKELSI
=PV8a
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
