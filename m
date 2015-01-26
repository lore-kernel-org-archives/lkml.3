Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbbAZNkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:40:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35396 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbbAZNkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:40:07 -0500
Date: Mon, 26 Jan 2015 14:37:51 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v2 1/9] clk: sunxi: Add support for sun9i a80 usb clocks
 and resets
Message-ID: <20150126133751.GE31568@lukather>
References: <1422188530-1794-1-git-send-email-wens@csie.org>
 <1422188530-1794-2-git-send-email-wens@csie.org>
 <20150125160253.GG8470@lukather>
 <CAGb2v667DGBPXGdU1jO1x=pxmu3Oue9qxVZmZz5KxqzC_9xxGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="924gEkU1VlJlwnwX"
Content-Disposition: inline
In-Reply-To: <CAGb2v667DGBPXGdU1jO1x=pxmu3Oue9qxVZmZz5KxqzC_9xxGw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2015 at 05:25:49PM +0800, Chen-Yu Tsai wrote:
> Hi,
>=20
> 2015=E5=B9=B41=E6=9C=8825=E6=97=A5 =E4=B8=8B=E5=8D=8811:05 =E6=96=BC "Max=
ime Ripard" <maxime.ripard@free-electrons.com> =E5=AF=AB=E9=81=93=EF=BC=9A
> >
> > Hi,
> >
> > On Sun, Jan 25, 2015 at 08:22:02PM +0800, Chen-Yu Tsai wrote:
> > > The USB controller/phy clocks and reset controls are in a separate
> > > address block, unlike previous SoCs where they were in the clock
> > > controller.
> > >
> > > This patch copies the original gates clk functions used for usb
> > > clocks into a separate file, and renames them to *_usb_*. Also
> > > add a per-gate parent index, so we can set different parents for
> > > each gate.
> > >
> > > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > > ---
> > >  Documentation/devicetree/bindings/clock/sunxi.txt |   2 +
> > >  drivers/clk/sunxi/Makefile                        |   1 +
> > >  drivers/clk/sunxi/clk-usb.c                       | 193 ++++++++++++=
++++++++++
> > >  3 files changed, 196 insertions(+)
> > >  create mode 100644 drivers/clk/sunxi/clk-usb.c
> > >
> > > diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Docu=
mentation/devicetree/bindings/clock/sunxi.txt
> > > index 60b44285250d..3f1dcd879af7 100644
> > > --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> > > +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> > > @@ -66,6 +66,8 @@ Required properties:
> > >       "allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 /=
 A20
> > >       "allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
> > >       "allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
> > > +     "allwinner,sun9i-a80-usb-mod-clk" - for usb gates + resets on A=
80
> > > +     "allwinner,sun9i-a80-usb-phy-clk" - for usb phy gates + resets =
on A80
> > >
> > >  Required properties for all clocks:
> > >  - reg : shall be the control register address for the clock.
> > > diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
> > > index 3a5292e3fcf8..058f273d6154 100644
> > > --- a/drivers/clk/sunxi/Makefile
> > > +++ b/drivers/clk/sunxi/Makefile
> > > @@ -9,6 +9,7 @@ obj-y +=3D clk-mod0.o
> > >  obj-y +=3D clk-sun8i-mbus.o
> > >  obj-y +=3D clk-sun9i-core.o
> > >  obj-y +=3D clk-sun9i-mmc.o
> > > +obj-y +=3D clk-usb.o
> >
> > Is that supposed to handle the other USB clocks in the future as well?
>=20
> I plan to do that. If you compare this and the original USB clk driver,
> you'll notice it's pretty much the same.

Yeah, hence why I asked :)

I'd rather not have two distinct copies of the same code. Could you
move these old clocks first, and then add the A80 clocks?

At least your commit log somewhat induces that this is new code, while
it clearly isn't.

> > >
> > >  obj-$(CONFIG_MFD_SUN6I_PRCM) +=3D \
> > >       clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
> > > diff --git a/drivers/clk/sunxi/clk-usb.c b/drivers/clk/sunxi/clk-usb.c
> > > new file mode 100644
> > > index 000000000000..1a93400353de
> > > --- /dev/null
> > > +++ b/drivers/clk/sunxi/clk-usb.c
> > > @@ -0,0 +1,193 @@
> > > +/*
> > > + * Copyright 2013 Emilio L=C3=B3pez
> > > + *
> > > + * Emilio L=C3=B3pez <emilio@elopez.com.ar>
> >
> > Hmmmm, the copyright notice seems weird :)
>=20
> The code was pulled from clk-sunxi.c, which only has Emilio's
> copyright. I suppose I could dig up who actually wrote the code.
> I think it was Hans.

Ok. The copyright date should at least be updated.

> > > +     clk_data->clks =3D kzalloc((qty+1) * sizeof(struct clk *), GFP_=
KERNEL);
> > > +     if (!clk_data->clks) {
> > > +             kfree(clk_data);
> > > +             return;
> > > +     }
> > > +
> > > +     for_each_set_bit(i, (unsigned long *)&data->clk_mask,
> > > +                      SUNXI_USB_MAX_SIZE) {
> > > +             of_property_read_string_index(node, "clock-output-names=
",
> > > +                                           j, &clk_name);
> > > +             clk_data->clks[i] =3D clk_register_gate(NULL, clk_name,
> > > +                                                   clk_parent, 0,
> > > +                                                   reg, i, 0, lock);
> > > +             WARN_ON(IS_ERR(clk_data->clks[i]));
> > > +             clk_register_clkdev(clk_data->clks[i], clk_name, NULL);
> >
> > Do we really need to use clkdev for these clocks?
>=20
> Original code. I don't think we do.

The only reason why we should have clkdev is for the protected
clocks. We should move away from that code, and I don't think any of
the USB clocks are in that case anyway.

> > > +     if (IS_ERR(reset_data->clk)) {
> > > +             pr_err("Could not get clock for reset controls\n");
> > > +             kfree(reset_data);
> > > +             return;
> > > +     }
> >
> > Newline, and that block should probably be part of the if block above.
>=20
> NULL is not considered an error, but maybe being in the same block
> makes it clear that they are related.

Yeah, maybe it's just me, but it triggered a might-be-uninitialized
warning in my brain while reading it (while the kzalloc above
obviously takes care of it)

It would be more logical to have that inside the if statement.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--924gEkU1VlJlwnwX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxkMvAAoJEBx+YmzsjxAgmYUQALIc4h5yCRJrnGT/7aZ23hB3
UXq1rRQ7sWNK+t1Iw1lo2xStcWQMiEwHXHBrOJeqjSfYPXI0Rjc3cm2RPzHQ2/of
LxK9d5STplJQ+IrruSJuXcc1zS0ouB70uC4Is675BaIbJv21gGGLwBNIbBVYviwU
7gHt3DYNpEBUhJWC/DnIrATEZZKYduyJENKFE8we0j/clDSCv/qIhhbqQVcNvULZ
FzuXsg1BieiMQfARymOAFWe6xRSWwn28XOc5oZFL41hQPtmvsS0/Hjkm4jU0CrdR
jYL0EyNmDxO5vBsB8ve4yFncE2Mie5N4H7wO7xjab606mSYFTTYfgjJgo7gUGn4j
WJnPWKytwe5YhJojD+IoeHimrEPmpaYq8e11etDaum/lpCElFpQsInbg3aRIWbrn
J6WnKZDNywRY7Fzw2no9dn0rnYJDMox1JNNr39IGQgdbHlgTY3jTncvetUkJh1gC
1NKRsRviVk9vATEs10dw4rPetwWyRX0R6Ite0IJrRIJ7Ni7i66AoCwH/c+9/Qp7w
NU97RsX03Yu1olH4OeCYHV+wYOl5hd4ZCylTY1jL20K3Z6x4uId59z4F1WUqLUV4
vsJ5ydrnRXSYHtGdj3BbZAzeXiomJ/BUXzpv7559fh6mkpSO9jsPJYdLLZk3gsYD
GjcaFkzhppvjhXfsdRn7
=2MRX
-----END PGP SIGNATURE-----

--924gEkU1VlJlwnwX--
