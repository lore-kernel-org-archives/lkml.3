Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3A3IVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:21:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55061 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab3A3IVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:21:04 -0500
Date: Wed, 30 Jan 2013 10:20:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "'Vivek Gautam'" <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <grant.likely@secretlab.ca>,
        <sylvester.nawrocki@gmail.com>, <tomasz.figa@gmail.com>,
        <av.tikhomirov@samsung.com>, <dianders@chromium.org>,
        <p.paneri@samsung.com>
Subject: Re: [PATCH v4 2/2] usb: phy: samsung: Add PHY support for USB 3.0
 controller
Message-ID: <20130130082034.GF15258@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358168377-22919-3-git-send-email-gautam.vivek@samsung.com>
 <1359368782-30224-1-git-send-email-gautam.vivek@samsung.com>
 <077f01cdfeaf$4f7b8780$ee729680$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H4SyuGOnfnj3aJqJ"
Content-Disposition: inline
In-Reply-To: <077f01cdfeaf$4f7b8780$ee729680$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--H4SyuGOnfnj3aJqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2013 at 10:01:52PM -0800, Kukjin Kim wrote:
> Vivek Gautam wrote:
> >=20
> > Adding PHY driver support for USB 3.0 controller for Samsung's
> > SoCs.
> >=20
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > ---
> >=20
> > Changes from v3:
> >  - Making SAMSUNG_USB3PHY dependent on SAMSUNG_USBPHY.
> >  - Adding USB_DWC3 to dependencies of SAMSUNG_USB2PHY since
> >    dwc3 controller also looks for USB2 type PHY.
> >=20
> >  drivers/usb/phy/Kconfig          |   11 +-
> >  drivers/usb/phy/Makefile         |    1 +
> >  drivers/usb/phy/samsung-usb3.c   |  349
> > ++++++++++++++++++++++++++++++++++++++
> >  drivers/usb/phy/samsung-usbphy.h |   81 +++++++++
> >  4 files changed, 441 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/usb/phy/samsung-usb3.c
> >=20
> > diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> > index cc0d230..9325a95 100644
> > --- a/drivers/usb/phy/Kconfig
> > +++ b/drivers/usb/phy/Kconfig
> > @@ -52,14 +52,23 @@ config SAMSUNG_USBPHY
> >  	help
> >  	  Enable this to support Samsung USB phy controllers for Samsung
> >  	  SoCs.
> > +	  Further enable USB 2.0 type PHY or USB 3.0 type PHY as required
> > +	  for USB controllers in use.
> >=20
> >  if SAMSUNG_USBPHY
> >=20
> >  config SAMSUNG_USB2PHY
> >  	bool "Samsung USB 2.0 PHY controller Driver"
> > -	depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
> > USB_OHCI_EXYNOS
> > +	depends on USB_S3C_HSOTG || USB_EHCI_S5P ||
> > USB_OHCI_EXYNOS || USB_DWC3
> >  	help
> >  	  Enable this to support Samsung USB 2.0 (High Speed) phy controller
> >  	  for Samsung SoCs.
> >=20
> > +config SAMSUNG_USB3PHY
> > +	bool "Samsung USB 3.0 PHY controller Driver"
> > +	depends on USB_DWC3
> > +	help
> > +	  Enable this to support Samsung USB 3.0 (Super Speed) phy
> > controller
> > +	  for samsung SoCs.
> > +
> >  endif
>=20
> It mean, when USB_DWC3 is selected, we can select only one USB2PHY or
> USB3PHY?

right, not sure that's a wise idea. It makes enabling USB support
trickier than it needs to be. How about just dropping all dependencies
if it compiles cleanly on all arches ?

--=20
balbi

--H4SyuGOnfnj3aJqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCNfSAAoJEIaOsuA1yqREkSkP/0wapvF8o3GEmWHLcfm1QNYk
lX6n7FGi1uG3h+83gbGJdsgC1jFyXZ9A0r6N5SfQylH3Biyi2mODABXAD/JwkOea
mwR1a+FStGDpu1hYo34ed6YFcClUojRUBWosB4iLrWiQJyC5iYDAHMiZH7j2jD6X
uSo4Ju2AF0tS5JU02RQGpEStftBitkAy/xYbvCkhDsRzJCtEMs2mPwFto/zTEPxe
7u/iaol3SxTRP3XUUTDIhCrPVIN2I8WmM2a8Ih4dWosu2WMEwUKNf/p2JYg6G15g
vQpovf9Gpclfrr4zb1g4t0eO+Vf1sJsWRaGbtR82rQlM09BCt7a/xi8v8V6lDqTO
4lnH2V442uEzrBfnUZNX2+DJ3NVFESGD/V9DFAM420Dadu/hfKLWRuGxvH2cyGZF
pKdprlexirvZ8jWBSehyLp90Vs6tYE7Cu/IoXv7C1EQEtaFzr+MTLUDKd1J3YBAQ
KjDDwIHroTFGhLKTCzwDdmZ2C6xXBPkfAjIXV5g8Yxn8fod7BKICdc3sL9f+YNus
eEjiJ0JH5WCMTKSNXbleqzIeJW1M8Xxp73S1tYdWxqcmqk7XZ5iCLCsr1MgbxVo6
QnJbrbPcb6FrvLWTn29BuFXSpxRzB+0NnZPnTM+2g9NNMrzkqvnI98aZkWHctOea
x2Q6nbtMNHAm5WinW02q
=dydY
-----END PGP SIGNATURE-----

--H4SyuGOnfnj3aJqJ--
