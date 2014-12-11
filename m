Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023AbaLKVKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:10:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46728 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933169AbaLKVKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:10:14 -0500
Date: Thu, 11 Dec 2014 22:09:19 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: linux-sunxi@googlegroups.com, dmitry.torokhov@gmail.com,
        linux@arm.linux.org.uk, leafy.myeh@newbietech.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2 2/3] sunxi:drivers:input:ps2 Added sunxi A10/A20 ps2
 driver
Message-ID: <20141211210919.GI8739@lukather>
References: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
 <1417907719-26775-3-git-send-email-VishnuPatekar0510@gmail.com>
 <20141208224137.GO8739@lukather>
 <CAEzqOZu9TWmYyBOP8t+b7mepqdbKjhf-3P-uNJS_Od05XiBLZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="np3HfElajyDBpWGr"
Content-Disposition: inline
In-Reply-To: <CAEzqOZu9TWmYyBOP8t+b7mepqdbKjhf-3P-uNJS_Od05XiBLZw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--np3HfElajyDBpWGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Remember to reply to all the recipients.

On Tue, Dec 09, 2014 at 04:40:36PM +0530, Vishnu Patekar wrote:
> > > Signed-off-by: vishnupatekar <VishnuPatekar0510@gmail.com>
> > > ---
> > >  drivers/input/serio/Kconfig     |   10 ++
> > >  drivers/input/serio/Makefile    |    1 +
> > >  drivers/input/serio/sunxi-ps2.c |  364
> > +++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 375 insertions(+)
> > >  create mode 100644 drivers/input/serio/sunxi-ps2.c
> > >
> > > diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> > > index bc2d474..3a7599c 100644
> > > --- a/drivers/input/serio/Kconfig
> > > +++ b/drivers/input/serio/Kconfig
> > > @@ -281,4 +281,14 @@ config HYPERV_KEYBOARD
> > >         To compile this driver as a module, choose M here: the module
> > will
> > >         be called hyperv_keyboard.
> > >
> > > +config SERIO_SUNXI_PS2
> > > +     tristate "Allwinner Sun4i-A10/Sun7i-A20 PS/2 controller"
> >
> > Allwinner A10 is enough
> >
> Okie, Should I change the config option as well, like SERIO_SUN4I_PS2 ?

Yep.

> > > +     /*Set Clock Divider Register*/
> > > +     clk_scdf =3D DIV_ROUND_UP(src_clk, PS2_SAMPLE_CLK) - 1;
> > > +     clk_pcdf =3D DIV_ROUND_UP(PS2_SAMPLE_CLK, PS2_SCLK) - 1;
> >
> > So this is actually a rounding down?
> >
> > Why not just using src_clk / PS2_SAMPLE_CLK directly?
> >
> > > +     rval =3D (clk_scdf<<8) | clk_pcdf;
> >
> > Spaces between the operators. Remember, run checkpatch.
> >
> Okie.
>=20
> checkpatch could  not catch this!!

Well, then it should have :)

> > > +     writel(rval, drvdata->reg_base + PS2_REG_CLKDR);
> > > +
> > > +     /*Set Global Control Register*/
> > > +     rval =3D PS2_GCTL_RESET | PS2_GCTL_INTEN | PS2_GCTL_MASTER
> > > +             | PS2_GCTL_BUSEN;
> > > +     writel(rval, drvdata->reg_base + PS2_REG_GCTL);
> >
> > You seem to be reading/writing from the same registers than in your
> > interrupt handler, don't you need some locking in here?
> >
>
> Interrupt is getting enabled only after writing to GCTL register.
>
> do you think still we need to locking mechanism here?

Not really, you don't know the state of the device before your driver
is probed, and the interrupts are enabled as soon as request_irq. So
you can very well have the device running with the interrupts running
before this function is called.

Plus you might get spurious interrupts.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--np3HfElajyDBpWGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUigf/AAoJEBx+YmzsjxAgSY0P/1zLj2EkyQTweyShVSZGeybr
UTU0novQipS2mDOr3Y7EOHNelS9n8UEMICJukYh6uMbGQGtnYT02mDdRuWB9AmIb
RZv0N3F01zXb/iKi4r4gthoqQ7tBcP0PmlWV9Iybsjng1IuZz+zWBPxocAad28Zz
xKkGpri8dcPJ27/dUYTlIWOcf0OE18iOUi6ITOmf9wNqr/akWByxxBGLJgLHxkXU
G8H/p5IOYXtihTi33hm/oab5xQO6F9pOCamIJAwCxYEg0W+vRuGW0IVrnWjNdfE5
QHYxugQSN0ddn9YgtCM+Rad3/M9XJmRAxp+O8yM3dN9mo+ptcPEeMgBD27Dxf5ue
LLjKKa+RC5loUhqdwAAWCEbEVqHrp5OMUVFrbhuzAFxJxLjDX0XbC32NRRsiv+Mc
tKse/qoUVSwCwX5BU7BkFM5loenRYWxiwNG55WwoPv8WVBO/wbqbGATJy//LgL/e
qzarZpaMcGA9hKM+oisksgAB34HrwZ9OeNqhf1LXlos4RkclTr3oBb8NqNVfjLWf
SZ8L3AEZdx/7DrJ2uz5Z8eFXiqhHkApKFvyWC9awZZKM/yMPc3RbXnzeAyI+bVxQ
bn9eOFYjEL3go/wmqxCdNHVZK8F8B2tqu/vWrlDTZhSJAP+cFNDRVLDi//2/tLtk
0YUHdfsiU+ZO6U4FaDK0
=OkvP
-----END PGP SIGNATURE-----

--np3HfElajyDBpWGr--
