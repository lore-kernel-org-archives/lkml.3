Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3DKSaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:30:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35553 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab3DKSaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:30:00 -0400
Date: Thu, 11 Apr 2013 21:29:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexander Holler <holler@ahsoftware.de>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
Message-ID: <20130411182946.GA20264@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <5166856C.3080906@ti.com>
 <20130411100435.GB14394@arwen.pp.htv.fi>
 <516695A4.2050804@ti.com>
 <20130411105557.GE14394@arwen.pp.htv.fi>
 <5166AFD2.4070108@ti.com>
 <5166B450.1000404@ahsoftware.de>
 <5166CC30.4060507@ti.com>
 <5166F3EC.8040807@ahsoftware.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <5166F3EC.8040807@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 11, 2013 at 07:33:32PM +0200, Alexander Holler wrote:
> >>Sorry, but this just will end up with many users having broken configs
> >>because of disabled stuff they don't know why they have to enable them.
> >>And thus with a never ending stream of questions and thus with a needed
> >>FAQ entry.
> >>
> >
> >Alexander,
> >
> >I agree with you that it can get difficult with users. But it is best for
> >users do not disable anything they are not familiar with.
> >
> >As the USB_PHY option doesn't depend on anything, it is safe to select it
> >from USB_EHCI_HCD_OMAP.
> >
> >However, the PHY drivers themselves must be selected from the board conf=
igs.
>=20
> Maybe I understood something wrong, but if the OMAP USB driver
> requires CONFIG_USB_PHY (or similiar), it should be selected
> automatically and not just enabled in the board config.

and who said OMAP USB depends on CONFIG_USB_PHY ? Some platforms need to
control a PHY and some don't.

> I just had it to often, that I needed to search around why a driver
> doesn't work (or even compiles), just to find out that I need to
> enable some strange config option which wasn't selected
> automatically. Especially with OMAPs. ;)

so ? Send a patch fixing it, those are really welcome. You see, it's
very difficult to get all of this perfectly right and if people continue
to rant rather than fix, we will get nowhere.

> And this not only occured when disabling options, it often occured by
> just updating the kernel. Suddenly some obscur option was needed too,
> it wasn't selected automatically by make oldconfig, bang. So the
> argument to not remove anything from a board config doesn't help
> much.

blablabla, Kconfig changes are *always* necessary. Specially when we
need to re-design an entire API because the previous one was just a
*SINGLE* global pointer.

Go check out kernel 2.6.39 (maybe even 3.1 and 3.2) and you'll see that
we're much better off today where we can actually have multiple PHY
drivers and multiple UDC drivers enabled (either as modules or
built-in), but the fact is that changing all of this over takes time and
sometimes people make mistakes, but that's alright, since we have the
-rc series to catch those unwanted errors.

Without the help of the rest of the community, though, it'll just get
slower and slower. With the whole single zImage effort going on in the
ARM land, things have gotten much more critical WRT getting rid of
"selects" and turning legacy "drivers" into real drivers, not just a
bunch of exported functions which a single architecture uses.

Add to that all the rework going on in the Gadget Framework, PHY layer
and EHCI drivers (which now has a core re-usable library thanks to Alan
Stern) and you have a lot of work to do.

Next time you consider ranting about something, use that 'frustration'
and turn it into motivation to write patches, then we all win. Also
consider that under drivers/usb/ alone we have 270K LOCs, and that's
quite a lot of code to handle with only a few of us (Greg, Sarah, Alan,
Alex and myself) being the gateway towards mainline.

With all that comes the responsibility of revieweing drivers for
architectures we, most of the times, don't have access to with drivers
that only compile in some ceratin ways.

Cleaning all of that takes time. Look at all the effort it's taking the
Chipidea folks just to get rid of a couple copies of the chipidea
driver. It takes time, it takes sweat and we can all use some help
rather than some random rant.

--=20
balbi

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZwEaAAoJEIaOsuA1yqRE+5sP/0zFNqWTCH/vFp6tPZl6d4pq
vbI9jBkSUb7lFQmegMZ7LX/DjcWYE9pXMV6sEPSjsSU+Nggf34Mo+1avSY/DSfh+
W/9npi1oRvIVEsQ1KA3Z4CRN3GcRyzAarCWthiphlOareRhPmSSWsA9vUy7QjdoT
89LL2gE4f7TCRfU5bg2aknwfQbT1vH0mhsCdZ1iIbXKkga+JTylgc4I1DckxcokM
KavM8kaSmfG0t5Xv219iB9H7tL8qpx9jvzDnbkB+JOinPi3hpmeNJ0BG+sve46VZ
jrJkB9BuVVL27zswFfa9yEOLT34wMdoTGz0JNIYiqaMQz24hE76pn1u1LzQb69yC
YZT6B4kBG4w4QmMO2GCNLVuFzmZ/yb9zOqVJP7AG6fZISUAt0HYWmvwj7dLtFZth
aIWSB96T6u8CvvT9QR8lyUxP8vz4+8GFlVulk4xKlTyk3NdM3ajAHrUuJRStdA7d
BLsigFlrZnCMRnI4rGKBYaojD/HtFG0+SZlcTE83p1R4FG1tiRt+gLXKzJ5KCUgr
Z+CXzCLmqZar9/Mn4wiVaWULmpKm0nOPVtecBuUGoLkWlRJI2t2kZzNdz6OfcV++
s3CkPv75zSF0oZxyndO8oxqCaimMF8mCV4n+KdTtMDSkpMJCrNuhaqnSGBA7HcTF
VV4X/YEy9HzNnx6elen/
=ppBP
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
