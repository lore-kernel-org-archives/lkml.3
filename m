Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaGDIAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:00:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56138 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754437AbaGDIAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:00:06 -0400
Date: Fri, 4 Jul 2014 09:57:10 +0200
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
Message-ID: <20140704075710.GN31996@lukather>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140630142054.GA8756@leverpostej>
 <20140630151906.GG28647@lukather>
 <20140630153305.GA28740@leverpostej>
 <20140701072119.GH28647@lukather>
 <20140701124852.GB6064@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kK1uqZGE6pgsGNyR"
Content-Disposition: inline
In-Reply-To: <20140701124852.GB6064@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, Jul 01, 2014 at 01:48:52PM +0100, Mark Rutland wrote:
> On Tue, Jul 01, 2014 at 08:21:19AM +0100, Maxime Ripard wrote:
> > On Mon, Jun 30, 2014 at 04:33:05PM +0100, Mark Rutland wrote:
> > > On Mon, Jun 30, 2014 at 04:19:06PM +0100, Maxime Ripard wrote:
> > > > On Mon, Jun 30, 2014 at 03:20:54PM +0100, Mark Rutland wrote:
> > > > > Hi Maxime,
> > > > >=20
> > > > > On Mon, Jun 30, 2014 at 02:20:54PM +0100, Maxime Ripard wrote:
> > > > > > The Allwinner A31 has a 16 channels DMA controller that it shar=
es with the
> > > > > > newer A23. Although sharing some similarities with the DMA cont=
roller of the
> > > > > > older Allwinner SoCs, it's significantly different, I don't exp=
ect it to be
> > > > > > possible to share the driver for these two.
> > > > > >
> > > > > > The A31 Controller is able to memory-to-memory or memory-to-dev=
ice transfers on
> > > > > > the 16 channels in parallel.
> > > > > >
> > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > > > ---
> > > > > >  drivers/dma/Kconfig     |    8 +
> > > > > >  drivers/dma/Makefile    |    1 +
> > > > > >  drivers/dma/sun6i-dma.c | 1058 +++++++++++++++++++++++++++++++=
++++++++++++++++
> > > > > >  3 files changed, 1067 insertions(+)
> > > > > >  create mode 100644 drivers/dma/sun6i-dma.c
> > > > >=20
> > > > > [...]
> > > > >=20
> > > > > > +       sdc->clk =3D devm_clk_get(&pdev->dev, NULL);
> > > > > > +       if (IS_ERR(sdc->clk)) {
> > > > > > +               dev_err(&pdev->dev, "No clock specified\n");
> > > > > > +               return PTR_ERR(sdc->clk);
> > > > > > +       }
> > > > > > +
> > > > > > +       mux =3D clk_get(NULL, "ahb1_mux");
> > > > > > +       if (IS_ERR(mux)) {
> > > > > > +               dev_err(&pdev->dev, "Couldn't get AHB1 Mux\n");
> > > > > > +               return PTR_ERR(mux);
> > > > > > +       }
> > > > > > +
> > > > > > +       pll6 =3D clk_get(NULL, "pll6");
> > > > > > +       if (IS_ERR(pll6)) {
> > > > > > +               dev_err(&pdev->dev, "Couldn't get PLL6\n");
> > > > > > +               clk_put(mux);
> > > > > > +               return PTR_ERR(pll6);
> > > > > > +       }
> > > > >=20
> > > > > I'm slightly confused. The binding listed a single unnamed clock =
(the
> > > > > AHB clock). What is going on here?
> > > >=20
> > > > The device itself needs only a single clock to work...
> > > >=20
> > > > >=20
> > > > > > +       ret =3D clk_set_parent(mux, pll6);
> > > > > > +       clk_put(pll6);
> > > > > > +       clk_put(mux);
> > > > > > +
> > > > > > +       if (ret) {
> > > > > > +               dev_err(&pdev->dev, "Couldn't reparent AHB1 on =
PLL6\n");
> > > > > > +               return ret;
> > > > > > +       }
> > > > >=20
> > > > > Why do we need to reparent the mux?
> > > >=20
> > > > ... but will function only if this clock is derived from PLL6.
> > >=20
> > > Ok, but _why_ is that the case? Could we at least have a comment for
> > > that?
> >=20
> > I have no idea, sorry.
>=20
> Oh no :(
>=20
> Where did this requirement turn up? Did an issue crop up in testing and
> using PLL6 just happened to work, or does some manual somewhere say that
> the device must have its clock derived from PLL6 without further
> explanation?

I first tried with the default clocks (the 24MHz oscillator) and only
transfers to devices and/or SRAM we working, but transfers from/to the
DRAM were not. Switching to PLL6 was making everything work fine. It
seems to be a bug in the A31 itself, but I don't have much details
yet.

> Does PLL6 drive some other clock that the DMA clock needs to stay in
> sync with, possibly?

PLL6 also drives some peripherals directly yes (such as the MMC or the
SPI controllers), but since I tested this using the SPI, with the main
oscillator as a source for both, I don't think it's related to
that. Or at least, not as directly related as what you were
suggesting.

>=20
> > > Where does the driver get the named clocks from if they aren't provid=
ed
> > > on the device node? Is there a clock-ranges somewhere?
> >=20
> > No, it just looks up the global clock name.
>=20
> Ok.
>=20
> > > It feels a little fragile to rely on the organisation of the clock tr=
ee
> > > and the naming thereof. If the IP block is ever reused on an SoC with=
 a
> > > different clock tree layout then we have to handle things differently.
> >=20
> > What do you suggest then?
>=20
> I will admit that I don't have a better suggestion.
>=20
> Without knowing which particular constraint on the mux parent clock we
> care about it's difficult to suggest anything useful.

Well, I first made it into the mach- directory, and then was told to
move it in the driver itself, so we're kind of running out of options
:)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--kK1uqZGE6pgsGNyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtl5WAAoJEBx+YmzsjxAgP1oP/jrhZ/65UZTDyENkNXRPcSHD
Et+7ev8/ge+wndlIjvYZnfdNB6KSckha5y+dZIv/WL8ul4ygRp8GAS9RmTuGAVXM
zp5l+qE7+H3APTRQ94bPX7xOJY8MBMwLhQA5eqrIut1+LqTmsVBDiznTc0QU0rhs
+X3w+vsXatx6N+A0BMkiW+0ZgTZEqYIIUjKGssRrK4ArzaTmXKZwCWyVITdp/fH+
OU9Qcki70p2BDYeXWV/BYvpKJfOdh0OZFxZVnLqj4NJaJ9nZPHyP2qJJm7SoO7V0
xBSH95dPuU8tcKOwDPm8Dp2OTIzkqZjdrEbrnplQUvR017jRK2KwsRHpjRAG8HJq
B1Caxr5v7RYyV/ZDraPNf46dZaXSwQXfAZR+2y+JaeJz/quaSx3nY1Se1Q1lVpIW
OhzVwua1rbzO7zgpvj6SDGzcZ3GN4yz3LpqsbMOufJS47xydnVcyrSpdPMtpmZFN
1HUtgkZFSMtfohh7ymo5xFIvkN+zKzQiFEwjUmuvejmcyGkh0CNiJJPOs6Kz5Zac
NcLN+oaBfrcfyBq0tfB6CBEKu0nXQhWw9Mw3najyCW9vXxBhJjoDf9ih7N84YoBK
85Xjvciy2dsCV6l1NDI3wmfsYMP29SsbaA3rym85azo8MU14TUtQ4uijFzJR5luo
Bg5gFH6y3J9Oy4edxX3k
=uEZu
-----END PGP SIGNATURE-----

--kK1uqZGE6pgsGNyR--
