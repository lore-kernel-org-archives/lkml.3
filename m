Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3CFIzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:55:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56325 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3CFIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:55:05 -0500
Date: Wed, 6 Mar 2013 10:54:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: musb: ux500: add otg notifier support
Message-ID: <20130306085446.GI28587@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362047934-22337-1-git-send-email-fabio.baltieri@linaro.org>
 <1362047934-22337-4-git-send-email-fabio.baltieri@linaro.org>
 <20130304143810.GJ3397@arwen.pp.htv.fi>
 <20130306014028.GA11205@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZOudaV4lSIjFTlHv"
Content-Disposition: inline
In-Reply-To: <20130306014028.GA11205@balto.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZOudaV4lSIjFTlHv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 06, 2013 at 09:40:28AM +0800, Fabio Baltieri wrote:
> > > Add transceiver notifier event handling to the ux500 driver to set vb=
us
> > > on specific transceiver events.
> > >=20
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > > ---
> > >  drivers/usb/musb/ux500.c | 41 ++++++++++++++++++++++++++++++++++++++=
+++
> > >  1 file changed, 41 insertions(+)
> > >=20
> > > diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
> > > index 5b742ba..b20326bb 100644
> > > --- a/drivers/usb/musb/ux500.c
> > > +++ b/drivers/usb/musb/ux500.c
> > > @@ -98,6 +98,36 @@ static void ux500_musb_set_vbus(struct musb *musb,=
 int is_on)
> > >  		musb_readb(musb->mregs, MUSB_DEVCTL));
> > >  }
> > > =20
> > > +static int musb_otg_notifications(struct notifier_block *nb,
> > > +		unsigned long event, void *unused)
> > > +{
> > > +	struct musb *musb =3D container_of(nb, struct musb, nb);
> > > +
> > > +	dev_dbg(musb->controller, "musb_otg_notifications %ld %s\n",
> > > +			event, otg_state_string(musb->xceiv->state));
> > > +
> > > +	switch (event) {
> > > +	case USB_EVENT_ID:
> > > +		dev_dbg(musb->controller, "ID GND\n");
> > > +		ux500_musb_set_vbus(musb, 1);
> > > +		break;
> > > +	case USB_EVENT_VBUS:
> > > +		dev_dbg(musb->controller, "VBUS Connect\n");
> >=20
> > are you sure this is correct ? you're not doing anything in case of
> > vbus event. Shouldn't you make sure your vbus is off ?
>=20
> The implementation I'm taking as reference for this patches does not do
> anything on VBUS event and as I can see from commmit history, it has
> been based on the omap2430 one, that in turns used to just run phy_init
> - and that's not implemented.  But...
>=20
> > What if your user uses a non-standard cable which has id-pin grounded
> > on both sides ?
>=20
> A cable with two micro/mini connectors with grounded IDs?  Did you ever
> encountered such a thing?  I guess a ux500_musb_set_vbus(musb, 0) would

in fact, no...

> not hurt in that case.

right, just to be sure. Maybe I should fix omap2430 as well. I'll add it
to my TODO list.

--=20
balbi

--ZOudaV4lSIjFTlHv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNwRWAAoJEIaOsuA1yqREIk0P+wW3a6IG2vqBRpc0Fq+mNmXD
0Dvvf1hzZHgJh4rrBS5pspdRNVINsXzVXKpyffEOROtvO7CbOaojqBJ6BFQi0wzW
M0SZbuq9Ni/z78vOBltC5nlAq4PFLDkTLi1lc9qsj1ubmqBmlcfUZnZTOfaF2VyL
HEyD6wKDFAl3Vi90Q0Hmb2PNqe3xk8cxl9be5AppVNMH3BfC8rbwwYIIkrjtnlOV
S223HPPiGEVBE7b7WPo5XfMq8cWW14h/SF1QB4km4rbYmf+JY+x+sPwSCGchu4kg
5oF+F6WFCcgFFCu4+FqV1PTZ7TzQsJ1CAktP0H0uzwcP+Lc2CqNg5e0Uv1PBg6dO
cQ2KrcqD2lILEaIvQ2J8L3GIZfCGy4IPDFf3/9PIQkGZUBIR5ue8ggbxZcbW8LQ1
ZhBqlf9tabQEOZRu3Ep7WjEZ5A+brZOVHLwnCFgE/oX55KDWeyVASO8vLZx3PyXh
OIsZ8gE0Uy58jUVyGi1PqIMDj2Di/tsIvs7gDox9hZL/v+IVbPZRf+cT0/ijQkKn
2fiy2hapQNRE89rvQzjAjTF/Fi/4dxkUU8UgjAt4gpjugNpJAjGvhnzxPcPf9brH
JNSZ8e9EfYlHUA5HhdPw9FcOFACRQoFfta5yU1VF+nDl3K56zQ0G3k7ITgKbGhcV
wRPYyGSQhI0ckOVlzdJ8
=jX2V
-----END PGP SIGNATURE-----

--ZOudaV4lSIjFTlHv--
