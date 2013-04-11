Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935998Ab3DKOeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:34:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53874 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab3DKOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:34:15 -0400
Date: Thu, 11 Apr 2013 17:34:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
Message-ID: <20130411143404.GO14394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <5166856C.3080906@ti.com>
 <20130411100435.GB14394@arwen.pp.htv.fi>
 <516695A4.2050804@ti.com>
 <20130411105557.GE14394@arwen.pp.htv.fi>
 <5166AFD2.4070108@ti.com>
 <5166B829.1020304@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bEjdSXxHv0Az5++U"
Content-Disposition: inline
In-Reply-To: <5166B829.1020304@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bEjdSXxHv0Az5++U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 11, 2013 at 04:18:33PM +0300, Roger Quadros wrote:
> On 04/11/2013 03:42 PM, Roger Quadros wrote:
> > On 04/11/2013 01:55 PM, Felipe Balbi wrote:
> >> Hi,
> >>
> >> On Thu, Apr 11, 2013 at 01:51:16PM +0300, Roger Quadros wrote:
> >>> On 04/11/2013 01:04 PM, Felipe Balbi wrote:
> >>>> Hi,
> >>>>
> >>>> On Thu, Apr 11, 2013 at 12:42:04PM +0300, Roger Quadros wrote:
> >>>>> Hi Greg,
> >>>>>
> >>>>> The following patch gets rid of Kbuild warnings when USB_EHCI_HCD_O=
MAP
> >>>>> is enabled.
> >>>>>
> >>>>> Patch is based on your usb-next branch and is needed for 3.10.
> >>>>>
> >>>>> From: Roger Quadros <rogerq@ti.com>
> >>>>> Date: Thu, 11 Apr 2013 12:08:19 +0300
> >>>>> Subject: [PATCH] USB: ehci-omap: Select USB_PHY
> >>>>>
> >>>>> As we need NOP_USB_XCEIV which depends on USB_PHY
> >>>>> we need to select USB_PHY as well.
> >>>>>
> >>>>> Gets rid of the below warnings when USB_EHCI_HCD_OMAP
> >>>>> is enabled.
> >>>>>
> >>>>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet =
direct dependencies (USB_SUPPORT && USB_PHY)
> >>>>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet =
direct dependencies (USB_SUPPORT && USB_PHY)
> >>>>>
> >>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >>>>
> >>>> Ideally, however, we wouldn't select any PHY in particular as differ=
ent
> >>>> boards might need a different PHY driver, even on OMAP ;-)
> >>>>
> >>> Right, but we need to select USB_PHY here as the driver uses
> >>> the USB_PHY APIs.
> >>>
> >>> The NOP_USB_XCEIV selection could be done by the board config.
> >>
> >> I would avoid 'select' completely and just update omap2plus_defconfig
> >> adding those two as modules.
> >>
> >=20
> > OK, makes sense. I will update the patch to remove "select NOP_USB_XCEI=
V".
> >=20
>=20
> One more issue to clarify.
>=20
> if USB_PHY is not enabled, then all phy_get() API's should return NULL an=
d not
> -ENXIO as it does now.

ENXIO means "No such device or address", looks alright to me ;-)

> This way the drivers need not treat it as an error and all PHY ops can
> be NOPs.

drivers will already be using if (IS_ERR()) construction, returning
-ENXIO when the API is disabled gives them an oportunity to *not*
request probe deferral since the API isn't enabled anyway.

> This will make it behave like other frameworks. e.g. clk.

if we return NULL we will need IS_ERR_OR_NULL() which will cause
problems with people who aren't careful enough.

--=20
balbi

--bEjdSXxHv0Az5++U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZsncAAoJEIaOsuA1yqREEbEP/A8kf7oxaa/pMjpU7Ts7rt4x
N9FObKwMSsTc7fvvZNUBf7lbjMBtt/O+HfZZQqqr9i0zYEfKBsDFDqXpdjjiAs7R
dxTI5cqrMHlHyyX5VmghngJy6a18xJ1B6caSrbeNLLnIPV/VN1GgL+H9ekDddzx1
Bf2y3GK7eG5j9iVJw9HtRD7XtS/TkCzpm7hQcg1iFWVqlMelzH+asNEy0FQ7ZwRz
c2zVYzH/Y9WTMQLiVrBmdAzjJO5D2YxX6n3ej9NHZlrIRG6X5vRX+HwOiLswpUmW
ZaHjhCi3fD3rgChW+STCM5wAiFBKSrkvFpcMe3btJo/j+aw+0wbJ4MBM8axsI25M
H341B6H5yu1SEQBwoROHpml6+C0zItAd8qrKG3kr7KIIrVkraEcPynBka1ZbO5Mk
B/HO/KA2zqfX0qY9SkfRqmyWkZ6ePkPMzoObmFl9DkBiQ9Fj2uDDNjhDq5Soy1FJ
PwXvtHZIA/5kFd0qCrSEfWWLZ1w+mJ8Yi5hV3iy8wjtUqOirf9BoJCjoK/Jkn9Ot
uMYhcfs/eqwGSe10CTvxEnRtxPDjgmPj+Ls0hZRNpqbg7hJv+kSsnAzEjnXbgCz9
Coo882O1qnl/2Woa/OnjuPShCdR6LV1zcffQy8OApglsmT5vYY74acduVlyQLKLL
66m80MNnndcQ8ehBsRO/
=a65H
-----END PGP SIGNATURE-----

--bEjdSXxHv0Az5++U--
