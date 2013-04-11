Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935962Ab3DKPJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:09:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39093 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3DKPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:09:47 -0400
Date: Thu, 11 Apr 2013 18:09:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
Message-ID: <20130411150938.GS14394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <5166856C.3080906@ti.com>
 <20130411100435.GB14394@arwen.pp.htv.fi>
 <516695A4.2050804@ti.com>
 <20130411105557.GE14394@arwen.pp.htv.fi>
 <5166AFD2.4070108@ti.com>
 <5166B829.1020304@ti.com>
 <20130411143404.GO14394@arwen.pp.htv.fi>
 <5166CE56.2070400@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WWBpDPuG52WufD7Q"
Content-Disposition: inline
In-Reply-To: <5166CE56.2070400@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WWBpDPuG52WufD7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 11, 2013 at 05:53:10PM +0300, Roger Quadros wrote:
> >>>>>>> From: Roger Quadros <rogerq@ti.com>
> >>>>>>> Date: Thu, 11 Apr 2013 12:08:19 +0300
> >>>>>>> Subject: [PATCH] USB: ehci-omap: Select USB_PHY
> >>>>>>>
> >>>>>>> As we need NOP_USB_XCEIV which depends on USB_PHY
> >>>>>>> we need to select USB_PHY as well.
> >>>>>>>
> >>>>>>> Gets rid of the below warnings when USB_EHCI_HCD_OMAP
> >>>>>>> is enabled.
> >>>>>>>
> >>>>>>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unme=
t direct dependencies (USB_SUPPORT && USB_PHY)
> >>>>>>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unme=
t direct dependencies (USB_SUPPORT && USB_PHY)
> >>>>>>>
> >>>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >>>>>>
> >>>>>> Ideally, however, we wouldn't select any PHY in particular as diff=
erent
> >>>>>> boards might need a different PHY driver, even on OMAP ;-)
> >>>>>>
> >>>>> Right, but we need to select USB_PHY here as the driver uses
> >>>>> the USB_PHY APIs.
> >>>>>
> >>>>> The NOP_USB_XCEIV selection could be done by the board config.
> >>>>
> >>>> I would avoid 'select' completely and just update omap2plus_defconfig
> >>>> adding those two as modules.
> >>>>
> >>>
> >>> OK, makes sense. I will update the patch to remove "select NOP_USB_XC=
EIV".
> >>>
> >>
> >> One more issue to clarify.
> >>
> >> if USB_PHY is not enabled, then all phy_get() API's should return NULL=
 and not
> >> -ENXIO as it does now.
> >=20
> > ENXIO means "No such device or address", looks alright to me ;-)
> >=20
> >> This way the drivers need not treat it as an error and all PHY ops can
> >> be NOPs.
> >=20
> > drivers will already be using if (IS_ERR()) construction, returning
> > -ENXIO when the API is disabled gives them an oportunity to *not*
> > request probe deferral since the API isn't enabled anyway.
>=20
> on second thoughts I agree with you. So the general understanding is
> that USB_PHY users without USB_PHY enabled is an error case.
>=20
> This means we need to allow controller drivers to select USB_PHY
> and minimize this possibility.

perhaps but OTOH careless select will also cause lots of problems.
distro-like kernels will just put all those as modules and product-like
kernels will only enable exactly what they need, so it makes no
difference if we select or not. Except that select will enable that PHY
even in e.g. beaglebone derivative which is, for now, using the same DTS
file.

--=20
balbi

--WWBpDPuG52WufD7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZtIyAAoJEIaOsuA1yqREmIIP/RQNc1jdqk667CXTj47opLVx
XYyOkQHGM+u09qiJ3+5W7lwktzUS1PGbJPYF7iu7md7nze6iONYkZcQ0GtYSR63s
jY8um+DheXRNBpliohJeKzELM/mgPzYM9ZSUqv9x55kgGhObmAwcTi6WKHi4Jdf/
j7xOv5yeMCuDo+dumrECWk+1KwGzgvYc2p2uy+YqK2/1u8D2Pl2d92jPNJI4TS6X
RyLHma4Mycasp+iGUbu9RrRig57s9PNRLHfK1lgAj7+daOAd+Mwk/dMx1W4emCj6
sDAoxd/d6Qpr9n7vHqHHwtd0IH8+LUj+D0tfP5zB+GLxmZbReQpZlp1RhJojhJef
8U5dHCE5s4JDPv7c0KqSxhqjS20LRV5AvI9JpW4wak8ewxnkRhdkWoJHzEAgkOB/
GlPQTo9Nfj7Gc0wYePCm6+s96VUheAo8H/axzYtC/KYzl0KcYEIBkxWhtpCkqOUs
WxIrL7rnNSz6hSs7rWqjBu7efc5jl6zMG5nHsZo+v+VYXR/N3FQofXCTwI5QP4SR
vE89Gcp8+T060WEMJCVenLmVvZGXecPVG5Oedu27Y0Ynd+kB/WYOz4T2nv/118rI
uOUmguC8T0BzI0Z/yBP4KcxMlzjdE6xcj16i3/+plDTDI0tRpvOiBeVFc/8vw2Ak
hkEK7L2Kg32raUIJfG26
=5qhv
-----END PGP SIGNATURE-----

--WWBpDPuG52WufD7Q--
