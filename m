Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbbA0TPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:15:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56149 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210AbbA0TPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:15:03 -0500
Date: Tue, 27 Jan 2015 13:14:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
CC: Felipe Balbi <balbi@ti.com>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Ola Jeppson <ola@adapteva.com>,
        <linux-gpio@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: phy-generic: Don't fail on missing gpio reset
Message-ID: <20150127191427.GN14878@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422323129-20969-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150127152047.GA13776@saruman.tx.rr.com>
 <19e48726b36942cfb0430fc625b41e1b@BY2FFO11FD043.protection.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B3NBd8mrXZtPJEYR"
Content-Disposition: inline
In-Reply-To: <19e48726b36942cfb0430fc625b41e1b@BY2FFO11FD043.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--B3NBd8mrXZtPJEYR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 11:13:08AM -0800, S=F6ren Brinkmann wrote:
> On Tue, 2015-01-27 at 09:20AM -0600, Felipe Balbi wrote:
> > On Mon, Jan 26, 2015 at 05:45:29PM -0800, Soren Brinkmann wrote:
> > > A reset through a GPIO is optional. Don't fail probing when it is
> > > missing.
> > >=20
> > > Reported-by: Andreas F=E4rber <afaerber@suse.de>
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > ---
> > > Hi Andreas,
> > >=20
> > > does this do the trick?
> > >=20
> > > 	Thanks,
> > > 	S=F6ren
> > >=20
> > >  drivers/usb/phy/phy-generic.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-gene=
ric.c
> > > index dd05254241fb..a73d4c738f0b 100644
> > > --- a/drivers/usb/phy/phy-generic.c
> > > +++ b/drivers/usb/phy/phy-generic.c
> > > @@ -241,10 +241,8 @@ int usb_phy_gen_create_phy(struct device *dev, s=
truct usb_phy_generic *nop,
> > > =20
> > >  	if (err =3D=3D -EPROBE_DEFER)
> > >  		return -EPROBE_DEFER;
> > > -	if (err) {
> > > -		dev_err(dev, "Error requesting RESET GPIO\n");
> > > -		return err;
> > > -	}
> > > +	if (err)
> > > +		nop->gpiod_reset =3D NULL;
> >=20
> > there's a better patch to use gpiod_get_optional(), instead.
>=20
> Great, apparently that wasn't in linux-next yesterday. I'll give it a
> shot once it arrives there.

It's still under discussion ;-)

--=20
balbi

--B3NBd8mrXZtPJEYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx+OTAAoJEIaOsuA1yqREyasP/RX1i4b5DIF/mhYSGxNTmUdV
awMNco82ACBvOur+afxzWwVCMMK/Xd9JwpLPFjXBMLyPIu/eRXYYozF1BPRtBstN
yl2Y0YTjXQpTmpVn9iQGz2T3Uuz3HZ/Op3+cmrmsnJDrYbK1Kh73U3scxXFzzxih
V8pgkKYKcO6dVq77wD3vlDkltRLY643f5Ji5+T3RVv3KQl6HPNzMBkL2UohnFzkI
UTGVgRCYIki8ezwmBH92AdBabcYNTkd4SzJJxrnfba4/bdWtDX8swuKcMlN0DjkT
fIDXbM2BmATsJ1a/wadm52GOl8Qz0twn1IgeuRwgSTldkuBL+58qiFfAGpi9LPKv
LJUOPv1z91/tsV+EoA5W8PTbjBTLUYdvUcfXSd25X0okD8zGX+0Diu35yzW7vfsp
HBkIG6IhpijHad4RRH8l+BT50kMzGuOEMr+F9OYPEeqWYx5awXN322qImMroqjWM
NRil2pmzqxibbM11YysvJMcwVDKRER3ZWKsab8ig3ZI3LThUsTTT+s5yRor2zITn
9SK4yIAZiyK/rOvgeM9kd0G+mG6RbDt8Y/o9v5ZBqcZIh8DIEAaAVK1zrYZhRCZN
g9U2aN9YkZZnd/97SPrNG9rsTsVyWC/Nkv9YBbhYwlREWENsuYnqMlscDT25GzxW
nFO8AwVqoLglIA28Terv
=SGSb
-----END PGP SIGNATURE-----

--B3NBd8mrXZtPJEYR--
