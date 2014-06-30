Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaF3PUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:20:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55949 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbaF3PUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:20:04 -0400
Date: Mon, 30 Jun 2014 17:19:06 +0200
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
Message-ID: <20140630151906.GG28647@lukather>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140630142054.GA8756@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKNXkkdQCYZ6W5l3"
Content-Disposition: inline
In-Reply-To: <20140630142054.GA8756@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UKNXkkdQCYZ6W5l3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 03:20:54PM +0100, Mark Rutland wrote:
> Hi Maxime,
>=20
> On Mon, Jun 30, 2014 at 02:20:54PM +0100, Maxime Ripard wrote:
> > The Allwinner A31 has a 16 channels DMA controller that it shares with =
the
> > newer A23. Although sharing some similarities with the DMA controller o=
f the
> > older Allwinner SoCs, it's significantly different, I don't expect it t=
o be
> > possible to share the driver for these two.
> >
> > The A31 Controller is able to memory-to-memory or memory-to-device tran=
sfers on
> > the 16 channels in parallel.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/dma/Kconfig     |    8 +
> >  drivers/dma/Makefile    |    1 +
> >  drivers/dma/sun6i-dma.c | 1058 +++++++++++++++++++++++++++++++++++++++=
++++++++
> >  3 files changed, 1067 insertions(+)
> >  create mode 100644 drivers/dma/sun6i-dma.c
>=20
> [...]
>=20
> > +       sdc->clk =3D devm_clk_get(&pdev->dev, NULL);
> > +       if (IS_ERR(sdc->clk)) {
> > +               dev_err(&pdev->dev, "No clock specified\n");
> > +               return PTR_ERR(sdc->clk);
> > +       }
> > +
> > +       mux =3D clk_get(NULL, "ahb1_mux");
> > +       if (IS_ERR(mux)) {
> > +               dev_err(&pdev->dev, "Couldn't get AHB1 Mux\n");
> > +               return PTR_ERR(mux);
> > +       }
> > +
> > +       pll6 =3D clk_get(NULL, "pll6");
> > +       if (IS_ERR(pll6)) {
> > +               dev_err(&pdev->dev, "Couldn't get PLL6\n");
> > +               clk_put(mux);
> > +               return PTR_ERR(pll6);
> > +       }
>=20
> I'm slightly confused. The binding listed a single unnamed clock (the
> AHB clock). What is going on here?

The device itself needs only a single clock to work...

>=20
> > +       ret =3D clk_set_parent(mux, pll6);
> > +       clk_put(pll6);
> > +       clk_put(mux);
> > +
> > +       if (ret) {
> > +               dev_err(&pdev->dev, "Couldn't reparent AHB1 on PLL6\n");
> > +               return ret;
> > +       }
>=20
> Why do we need to reparent the mux?

=2E.. but will function only if this clock is derived from PLL6.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UKNXkkdQCYZ6W5l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsX/qAAoJEBx+YmzsjxAgiBQP/i1Bt/MURmqOl/i99S0lQaKZ
QaE/6JYnbTMeKhvCVGfiqa2ePedDoHT+W4v7dlPgZ1vytPDKfInOXuKceCD+cQ1b
h3Zt5Cngp0ZqxHbFZIwYRv0inS5e6tRzCqpo3yv+VaOh8KHuIOOH7GhLsOPdgQ8o
iTekM0HPZ4HH/m3XKMcNO7JXtKOgxbFzHqFpS9yQIgj931XkuPlJY8IKAaO/QiSG
jLpeX6hmyPHWt6iCRny9sg7G80F0fLVmrdpQjDnhPFsXkH9iG4pfJuzyDl5kRhFJ
mehxW4rEYvd3FzSUMyXj+eRDSECtVJxP9mLaOtkuqeVEGo9E/bl81ZZcFEQPbCbB
paU+BMC06b4wrqU0lcjXAJir+Jvy/1819QJ8DVesx2a7kkqxlEeNUk2aQTCohHuI
NzQCM6Ztfyiuj5va0juVrMMi3NH0YuyNRi60BfMMebRUCHv9OSZLokdFDozLgCDb
A3oinkkznggdU3whKwrrKoCbmy+lWIJbJRMhCQ+SVpCg5yx+LVA1FhwwnqUGxUDG
22iUhW1lLTq3Z84A/oTuu8ydOiwzeDSckgINVmP7tDClwVHVQzkbL2JVebC5TqLU
7dtQtFsXznd3TXegqlyg33wl4q0YUxw4Ton/1YAyAaBKwo8tRG9Qv3tFPrJiRpeF
LFztFuLbUmJXtm00avpR
=/YaY
-----END PGP SIGNATURE-----

--UKNXkkdQCYZ6W5l3--
