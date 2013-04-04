Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763954Ab3DDHIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:08:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57543 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763939Ab3DDHIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:08:46 -0400
Date: Thu, 4 Apr 2013 10:08:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Felipe Balbi <balbi@ti.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry@gilfi.de>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the usb tree
Message-ID: <20130404070815.GA30287@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130404151845.406517e19f29380ccb90ac35@canb.auug.org.au>
 <20130404062730.GA4806@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20130404062730.GA4806@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 04, 2013 at 08:27:30AM +0200, Thierry Reding wrote:
> On Thu, Apr 04, 2013 at 03:18:45PM +1100, Stephen Rothwell wrote:
> > Hi Felipe,
> >=20
> > Today's linux-next merge of the usb-gadget tree got a conflict in
> > drivers/usb/host/ehci-tegra.c between commit 369a9a9d2af7 ("usb: host:
> > ehci-tegra: Fix oops in error cleanup") from the usb tree and commit
> > 4261b8f3538c ("usb: host: ehci-tegra: fix PHY error handling") from the
> > usb-gadget tree.
> >=20
> > I fixed it up (I think - see below) and can carry the fix as necessary
> > (no action is required).
> >=20
> > --=20
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> >=20
> > diff --cc drivers/usb/host/ehci-tegra.c
> > index 4f3cfb8,1d2488c..0000000
> > --- a/drivers/usb/host/ehci-tegra.c
> > +++ b/drivers/usb/host/ehci-tegra.c
> > @@@ -770,19 -765,15 +770,17 @@@ static int tegra_ehci_probe(struct plat
> >   	if (!irq) {
> >   		dev_err(&pdev->dev, "Failed to get IRQ\n");
> >   		err =3D -ENODEV;
> >  -		goto fail;
> >  +		goto fail_phy;
> >   	}
> >  =20
> >   	if (pdata->operating_mode =3D=3D TEGRA_USB_OTG) {
> >   		tegra->transceiver =3D
> >   			devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> > - 		if (!IS_ERR_OR_NULL(tegra->transceiver))
> > + 		if (!IS_ERR(tegra->transceiver))
> >   			otg_set_host(tegra->transceiver->otg, &hcd->self);
> >  +	} else {
> >  +		tegra->transceiver =3D ERR_PTR(-ENODEV);
> >   	}
> > - #endif
> >  =20
> >   	err =3D usb_add_hcd(hcd, irq, IRQF_SHARED);
> >   	if (err) {
> > @@@ -801,11 -792,8 +799,9 @@@
> >   	return err;
> >  =20
> >   fail:
> > - #ifdef CONFIG_USB_OTG_UTILS
> > - 	if (!IS_ERR_OR_NULL(tegra->transceiver))
> > + 	if (!IS_ERR(tegra->transceiver))
> >   		otg_set_host(tegra->transceiver->otg, NULL);
> > - #endif
> >  +fail_phy:
> >   	usb_phy_shutdown(hcd->phy);
> >   fail_io:
> >   	clk_disable_unprepare(tegra->clk);
>=20
> Looks good to me, thanks.

looks correct indeed, thanks

--=20
balbi

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXSbfAAoJEIaOsuA1yqREspQP/0UdBAxkzZbLurvOc20qRpVH
3mk0H4mpk0JlobWxBarC8dwWUjIz++lS360Y7m+4s+pXqEP2AGRuDu8OzAto2YPg
THzDIvyUeMvBlbxykSTgurfH3+eAdwG+Fa9NUXqn6HXVSXChrkMqSoTgxl0ilaaM
gzljHNBVdX6BbNBoKGCD1J3LozikMHjP6yQzQHNKXZ2fvDkGInIxRezNK6cr+pRN
KiXAo7+LHnxvwtUaThVfER0jH/5kIHt7c2cNc3FcG6yPAItXhY0uxHUV6Im0ImwA
b+FbzqItkhPyqjtpfQy/UAgYU+aaKFgKlWOXMWVbG6GGBydtVFFt4gE6fw125v71
CJLQtiXEPjjlP2CEcCcplkbzESYTL9YOtasAvInEw9JhxsyrxIGwO9zXnFe7sACD
yxe6FLh37tK7NXXApz4FUAW5GUUqYSktsFC6co8NKeYy4oIXfbfptJc4cmSuWIvS
hwC0p7Dj0onI9UyJpuhiUc5S6+cTYmJQtKGe24oJqlWa+Joa/BH2Ju4IgOgsgRgQ
VeZhp+wdq1/YjVfPso3Vvzr6BTGAYPBdz3xIvWqLkhftEc3UhTW2HTx91nvpU+E2
l/O9iVhCc9gJyjBnfAk49HDsP9mQApPik1dJyIlNi9lbDYWSuvqfNFJD9pBkCZ9+
dWbLP2DaNI0i6F+l6z4b
=vr8C
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
