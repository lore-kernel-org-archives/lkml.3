Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3AYLLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:11:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33397 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3AYLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:11:50 -0500
Date: Fri, 25 Jan 2013 13:11:21 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "tony@atomide.com" <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 1/4] drivers: usb: phy: add a new driver for usb part
 of control module
Message-ID: <20130125111120.GP15886@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359109440-2195-1-git-send-email-kishon@ti.com>
 <1359109440-2195-2-git-send-email-kishon@ti.com>
 <20130125110141.GK3075@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mh8CTEa8Ax54aLHp"
Content-Disposition: inline
In-Reply-To: <20130125110141.GK3075@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Mh8CTEa8Ax54aLHp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 25, 2013 at 11:01:41AM +0000, Mark Rutland wrote:
> On Fri, Jan 25, 2013 at 10:23:57AM +0000, Kishon Vijay Abraham I wrote:
> > Added a new driver for the usb part of control module. This has an API
> > to power on the USB2 phy and an API to write to the mailbox depending on
> > whether MUSB has to act in host mode or in device mode.
> >=20
> > Writing to control module registers for doing the above task which was
> > previously done in omap glue and in omap-usb2 phy will be removed.
> >=20
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> >  Documentation/devicetree/bindings/usb/omap-usb.txt |   30 +-
> >  Documentation/devicetree/bindings/usb/usb-phy.txt  |    5 +
> >  drivers/usb/phy/Kconfig                            |   10 +
> >  drivers/usb/phy/Makefile                           |    1 +
> >  drivers/usb/phy/omap-control-usb.c                 |  295 ++++++++++++=
++++++++
> >  include/linux/usb/omap_control_usb.h               |   92 ++++++
> >  6 files changed, 432 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/usb/phy/omap-control-usb.c
> >  create mode 100644 include/linux/usb/omap_control_usb.h
> >=20
> > diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Docum=
entation/devicetree/bindings/usb/omap-usb.txt
> > index 29a043e..2d8c6c4 100644
> > --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> > +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> > @@ -1,4 +1,4 @@
> > -OMAP GLUE
> > +OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
> >=20
> >  OMAP MUSB GLUE
> >   - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
> > @@ -16,6 +16,10 @@ OMAP MUSB GLUE
> >   - power : Should be "50". This signifies the controller can supply up=
to
> >     100mA when operating in host mode.
> >=20
> > +Optional properties:
> > + - ctrl-module : phandle of the control module this glue uses to write=
 to
> > +   mailbox
> > +
> >  SOC specific device node entry
> >  usb_otg_hs: usb_otg_hs@4a0ab000 {
> >         compatible =3D "ti,omap4-musb";
> > @@ -23,6 +27,7 @@ usb_otg_hs: usb_otg_hs@4a0ab000 {
> >         multipoint =3D <1>;
> >         num_eps =3D <16>;
> >         ram_bits =3D <12>;
> > +       ctrl-module =3D <&omap_control_usb>;
> >  };
> >=20
> >  Board specific device node entry
> > @@ -31,3 +36,26 @@ Board specific device node entry
> >         mode =3D <3>;
> >         power =3D <50>;
> >  };
> > +
> > +OMAP CONTROL USB
> > +
> > +Required properties:
> > + - compatible: Should be "ti,omap-control-usb"
> > + - reg : Address and length of the register set for the device. It con=
tains
> > +   the address of "control_dev_conf" and "otghs_control" or "phy_power=
_usb"
>=20
> Could you not use '-' over '_' here?

that's part of omap hwmod.

> > +   depending upon omap4 or omap5.
> > + - reg-names: The names of the register addresses corresponding to the=
 registers
> > +   filled in "reg".
> > + - ti,type: This is used to differentiate whether the control module h=
as
> > +   usb mailbox or usb3 phy power. omap4 has usb mailbox in control mod=
ule to
> > +   notify events to the musb core and omap5 has usb3 phy power registe=
r to
> > +   power on usb3 phy. Should be "1" if it has mailbox and "2" if it ha=
s usb3
> > +   phy power.
>=20
> Why not make this a string property, perhaps values "mailbox" or "registe=
r"?

NAK.

--=20
balbi

--Mh8CTEa8Ax54aLHp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAmhYAAoJEIaOsuA1yqREqasQAI2O0nN30szN6MAAATlw2mYv
MdjW701EyDLFLNV98+a5mjYyqMW50D+BlWLRWHnEB0MSzeD8jGtKw7tirexlIq/a
Cwo0w1r5CxdwJ+WFDzggfBWIPhDPh4pW/MLepZIdFL8f3UnwprIkqTVRUlLx+HWB
hmzHmljm32H9lDdejPnYIB/JcAd48imnhk9rH7XVIwvPnZB8ZMjFPge/b9YCdN2c
wxgxF3OQDu42Myzw8SOcSLU4cFYxnX+nIDpQ0nsX+ISydCepccomj8HLwWVpfvHQ
ccqaq8GHg+mY4OyfChfejlEDrSglos37AVhRhtrr2xyB4qxlh1eDYVBoZLFB8+mp
hIAMqeR62pCS9VBF933c2M43NPVj9cQ1U6dRWIhsB4h8htp26xEolc0adz2blz5T
4UJUifWkxltiJwqBuZYbE5ExVWnaxvGh/Y6MJXIPypea5OUaJBA0fEoWkQmTPZ9H
VxRHrNvo6cLDlJyWjd19FQ8gRH3MKM4fY3oZqDuASEax9/dvhroWUUvrRS58gf5C
VOOcqmUXNjQkQ76rWL9DEm/JAlKYWR7Ceu5z6Ugk07MkuupOWW4MEyuDliL/y2AM
t8t04J9ck111nLkAOAhz36doE19D0AAfAYHbXwtmgaMBMJ0mTjc+trk1DknYHy9n
KD2IAUo8Va9FsYRqGdwz
=/ptF
-----END PGP SIGNATURE-----

--Mh8CTEa8Ax54aLHp--
