Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbaDWPFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:05:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33118 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbaDWPFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:05:24 -0400
Date: Wed, 23 Apr 2014 10:02:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v6 01/19] usb: phy: msm: Make driver selectable on
 ARCH_QCOM
Message-ID: <20140423150259.GE9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
 <1398158438-21579-2-git-send-email-iivanov@mm-sol.com>
 <20140422145701.GI5524@saruman.home>
 <1398179795.4724.170.camel@iivanov-dev>
 <20140422152425.GL5524@saruman.home>
 <1398242909.4724.204.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PPYy/fEw/8QCHSq3"
Content-Disposition: inline
In-Reply-To: <1398242909.4724.204.camel@iivanov-dev>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PPYy/fEw/8QCHSq3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 11:48:29AM +0300, Ivan T. Ivanov wrote:
> On Tue, 2014-04-22 at 10:24 -0500, Felipe Balbi wrote:
> > On Tue, Apr 22, 2014 at 06:16:35PM +0300, Ivan T. Ivanov wrote:
> > >=20
> > > Hi,=20
> > >=20
> > > On Tue, 2014-04-22 at 09:57 -0500, Felipe Balbi wrote:
> > > > On Tue, Apr 22, 2014 at 12:20:20PM +0300, Ivan T. Ivanov wrote:
> > > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > >=20
> > > > > Controller could be found on APQ and MSM platforms,
> > > > > make configuration description more generic.
> > > > >=20
> > > > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > > > ---
> > > > >  drivers/usb/phy/Kconfig | 6 +++---
> > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> > > > > index 416e0c8..0c668a3 100644
> > > > > --- a/drivers/usb/phy/Kconfig
> > > > > +++ b/drivers/usb/phy/Kconfig
> > > > > @@ -171,11 +171,11 @@ config USB_ISP1301
> > > > >  	  module will be called phy-isp1301.
> > > > >=20
> > > > >  config USB_MSM_OTG
> > > > > -	tristate "OTG support for Qualcomm on-chip USB controller"
> > > > > -	depends on (USB || USB_GADGET) && ARCH_MSM
> > > > > +	tristate "Qualcomm on-chip USB OTG controller support"
> > > > > +	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)
> > > >=20
> > > > I would actually drop USB || USB_GADGET dependency here just make it
> > > > easier to enable the driver on Kconfig, other you have to enable
> > > > USB_SUPPORT, then enable USB, go back one menu level, go down to PHY
> > > > menu, and choose this driver.
> > > >=20
> > >=20
> > > Because phy directory already depends on USB_SUPPORT?
> >=20
> > right
>=20
> Build fails if USB and USB_GADGET are not selected.=20
> of_usb_get_dr_mode is part of USB_COMMON.=20
>=20
> ...
>=20
> if USB_SUPPORT
>=20
> config USB_COMMON
> 	tristate
> 	default y
> 	depends on USB || USB_GADGET
>=20
> ...
>=20
> of_usb_get_dr_mode() is no part of this patch, but should I remove
> dependency here and add it several patches later?

I guess we can keep it as is and I'll sort that out globaly later, I can
see a few other PHYs have some "weirdness" in their dependencies

--=20
balbi

--PPYy/fEw/8QCHSq3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV9YjAAoJEIaOsuA1yqREvrwP/RJ/RJ9eHFyOjHKjdgEJ3/Vi
K04iefOicAK8Z4hqCrRppgB4O/1AZ8JitQ3z7RHtXZbI1EoSc7GV4aTzG7rqzaX/
1aufBamntT+S/vI8SFaLn6DHt2dUuxyVxAdaCAhoItharVO38z2u5ym6J7KRGInb
H+AC9XtDwTNaT6hwP//pmTRNaxLAE4myTDkVefgV2z/PCG9FDDE+Y+UhW2jkWpDr
1ASnSixWyxfYg7wIiUEyMOHx1iyT034bMzET0CA7+kHCa8LoxxFvxWa6FCHWu6Ug
F1M6ja2qmA2ujCn7Izwz31+vg7iPjpaopmjiqOLhtO8UkPL2QOPrbHta8Kk3ixA1
XOTUAI4f4pzp6k8D0e9hF6bKP1cXGmZhBWRGYozQdLClm/1xY3iSjStC8xGKRGT+
mUmiOWYllJ0w2WA1bSSB+9atyAXKdurf4VES8IhHPPyoH+RJ28EkGuL09k/InQAb
Fo2pOk2JQ2i3Za7A8HUYiMC4yg6T+j7M2s8SvvPE28kCmUxH1jdgW43hD+x+2QBb
SNWI9CeZ0bsXign092nwoRD/kIH7yfIp976xcpEyVlpiqmHqgcBU61t+deQgmaar
ZztUWFzmw8dBh7fmDCSQXb0Ws+KqVa2qHZHVcPIhMqUxhmXmjj21lKSzHDSk89bt
lpZEDgjHsvDe6kKc3ipC
=GhD1
-----END PGP SIGNATURE-----

--PPYy/fEw/8QCHSq3--
