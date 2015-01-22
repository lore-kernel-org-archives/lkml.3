Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbbAVU3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:29:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45663 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbAVU3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:29:15 -0500
Date: Thu, 22 Jan 2015 14:29:07 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] extcon: usb: Introduce USB GPIO extcon driver. Fix
 DRA7 USB.
Message-ID: <20150122202907.GC22288@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1421689942-10201-1-git-send-email-rogerq@ti.com>
 <20150120190237.GG15169@saruman>
 <54C0FBDC.6040803@ti.com>
 <54C10FF4.5030503@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Content-Disposition: inline
In-Reply-To: <54C10FF4.5030503@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 04:57:56PM +0200, Roger Quadros wrote:
>=20
> On 22/01/15 15:32, Roger Quadros wrote:
> > Felipe,
> >=20
> > On 20/01/15 21:02, Felipe Balbi wrote:
> >> On Mon, Jan 19, 2015 at 07:52:17PM +0200, Roger Quadros wrote:
> >>> Hi,
> >>>
> >>> On DRA7 EVMs the USB ID pin is connected to a GPIO line. The USB driv=
ers
> >>> (dwc3 + dwc3-omap) depend on extcon framework to get the USB cable st=
ate
> >>> (USB or USB-Host) to put the controller in the right mode.
> >>>
> >>> There were earlier attempts [1] to get this working by trying to patc=
h up
> >>> the existing GPIO extcon driver.
> >>>
> >>> This series attemts to take a different approach by introducing a new
> >>> USB specific extcon driver to handle the USB ID GPIO pin and
> >>> interpret a right USB cable state.
> >>>
> >>> The reasoning to introduce this new driver is:
> >>> 1) The existing GPIO extcon driver doesn't understand USB cable states
> >>> and it can't handle more than one cable per instance.
> >>>   =20
> >>> For the USB case we need to handle at least 2 cable states.
> >>>     a) USB (attach/detach)
> >>>     b) USB-Host (attach/detach)
> >>> and could possible include more states like
> >>>     c) Fast-charger (attach/detach)
> >>>     d) Slow-charger (attach/detach)
> >>>    =20
> >>> 2) This USB specific driver can be easily updated in the future to
> >>> handle VBUS events, or charger detect events, in case it happens
> >>> to be available on GPIO for any platform.
> >>>
> >>> 3) The DT implementation is very easy. You just need one extcon node =
per USB
> >>> instead of one extcon node per cable state as in case of [1].
> >>>
> >>> 4) The cable state string doesn't need to be encoded in the device tr=
ee
> >>> as in case of [1].
> >>>
> >>> 5) With only ID event available, you can simulate a USB-peripheral at=
tach
> >>> when USB-Host is detacted instead of hacking the USB driver to do the=
 same.
> >>>
> >>> Tested on DRA7-evm and DRA72-evm.
> >>
> >> while at that, you might want to patch X15 too.
> >>
> > USB2 port is meant for peripheral use only. ID pin from USB port is not=
 connected to GPIO.
> >=20
>=20
> OK answering myself here :).
> Peripheral mode doesn't work on x15-bb as the USB driver (dwc3-omap)
> doesn't set the mailbox correctly even when dwc3 node is set as otg =3D "=
peripheral".
>=20
> Looks like we need to implement usb-gpio-extcon for x15 even though ID is=
 hard coded.

right, another option is to have dwc3-omap read the child's DTS to check
dr_mode and hardcode things based on that.

--=20
balbi

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwV2TAAoJEIaOsuA1yqREwQAP/1NXcm42yaTZAnyAH32DfY7R
XL7LhwBB5u02KlU53Zim+t8IwIUReTPwXzaHhm264vh6sAnySH0G9R4wt6RBUEPY
8huoIh07NGZaFDXqmGzMu8aVq76Jk4W2pqkfWqHC05hWjLBzRfGfk8yB/G2l6lDr
26pO7X05rr+JcNUAoDSa1YFpbY0ystd9vAOCNsi1dIWUIcQ0B1Zt1M7oiRLJ4IRJ
S+8Vbm9Fn1XVsUkmZjDwY9DQAvfRJZD/BjePhW1mfqlt8+InDPBOYykZ8gH9Lg0m
nPP8V5F1KPh+YgNI7gEIxevXVUFEpZA3ODgxjryLXnfeWv6Hg4wVWGNLgRFqF1lw
yFPp2g7/U5PNRK6EsI6+BKxxJvorY0OqQGCu9j8gu1HmndXs1ZPUqold9BhfdBDR
hpiE08SJnAid99ECuak/7/o3iV62RZZwR3qG890duPMIEdNbS5tZe9PrKKK9UVNM
eDHDzMDyZRR4auOXcqS/E0eirahiJpF1DXgqfjCR1mt2/fng4Ye3A+HigYXPgE49
yO5IcW38ZZ8GHiHfF+6MCHARlR9JJihw8xqtwBmT81YEnlk6ANilMot82cqTWaGl
BXl+8HvykdrRHrzuw57L5KouLlVJH/1sMjqlgLh4IknEePwFsQO6m4jeTwGTud5L
jOhJmoJS6RvNSgu3kK5d
=td1I
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
