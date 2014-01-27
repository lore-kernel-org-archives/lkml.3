Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaA0QHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:07:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59051 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbaA0QG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:06:59 -0500
Date: Mon, 27 Jan 2014 10:05:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <george.cherian@ti.com>, <rogerq@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
Message-ID: <20140127160458.GF13268@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
 <1390299099-14764-1-git-send-email-kishon@ti.com>
 <20140121144725.GF30451@saruman.home>
 <20140127150855.GA17928@xps8300>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Content-Disposition: inline
In-Reply-To: <20140127150855.GA17928@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 27, 2014 at 05:08:55PM +0200, Heikki Krogerus wrote:
> > > Since PHYs for dwc3 is optional (not all SoCs that have DWC3 use PHYs=
),
> > > do not return from probe if the USB PHY library returns -ENODEV as th=
at
> >=20
> > this isn't correct, they all have PHYs, some of them might not be
> > controllable.
> >=20
> > > indicates the platform does not have PHY.
> >=20
> > not really, that indicates the current platform tried to grab a PHY and
> > the PHY doesn't exist. If there's anybody with a non-controllable PHY
> > and someone gives me a really good reason for not using the generic
> > no-op PHY, then we should add a flag and we could:
> >=20
> > 	if (!likely(dwc->flags & DWC3_USB2PHY_DRIVER_NOT_NEEDED))
> > 		dwc3_grab_phys(dwc);
>=20
> Why would you need to know if the PHY drivers are needed or not
> explicitly in your controller driver?

because, one way or another, they all do need it. Except for quirky ones
like AM437x where a USB3 IP was hardwired into USB2-only mode, so it
really lacks a USB3 PHY.

> > But I really want to see the argument against using no-op. As far as I
> > could see, everybody needs a PHY driver one way or another, some
> > platforms just haven't sent any PHY driver upstream and have their own
> > hacked up solution to avoid using the PHY layer.
>=20
> Not true in our case. Platforms using Intel's SoCs and chip sets may
> or may not have controllable USB PHY. Quite often they don't. The
> Baytrails have usually ULPI PHY for USB2, but that does not mean they
> provide any vendor specific functions or any need for a driver in any
> case.

that's different from what I heard.

> Are we talking about the old USB PHY library or the new PHY framework
> with the no-op PHY driver?
>=20
> Well, in any case, I don't understand what is the purpose of the no-op
> PHY driver. What are you drying to achieve with that?

I'm trying to avoid supporting 500 different combinations for a single
driver. We already support old USB PHY layer and generic PHY layer, now
they both need to be made optional. The old USB PHY layer also provides
a no-op, now called phy-generic, which is actually pretty useful.

On top of all that, I'm sure you'll subscribe to the idea of preventing
dwc3 from becoming another MUSB which supports several different
configurations and none work correctly. I much prefer to take baby steps
which are well thought-out and very well exercised, so I'll be very
pedantic about proof of testing.

An invasive change such as $subject needs to be very well-tested in
different architectures with different Kconfig choices before I'd feel
comfortable applying it.

Also, the assumptions made in $subject are just plain wrong, which
gets me really iffy about applying it or not.

cheers

--=20
balbi

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS5oO/AAoJEIaOsuA1yqREIBMQALFjYLnDuz5DMwnWpgWzsJI1
Co6bNyF+u/5Ntvuogxr9EheJCtz119dWntIKHIc1rORwrKY/VEL07KFfpw8Ap+a3
2+4JHegg+UgSSNw2vBgwPac1bpPdB9xLVBnXlfxaR4pSFqq13+VEWFja6hvXLXMR
j+gBGRHlaVN4ZAEQJV/ucmW+jFn7hp2H531AnzgV4XSurp08jpWlBw9nPYdV2gCa
T6dDTKoD8gXZKthlH+/2zvYQoaZVkNwTO+O8fFHlEOhBy6gc250iVyDB/cy6ILBe
agKYvw+DybaV06XWigKYkUsP1anpHPz8QPplfY/EHS4nQvrQswOkUUhfe8B2C7EE
xRIhy5DnRt9AAvBiUv05EmGU/9nUhzjD7U/C3JmTEbH5djo3qN79Qh1ZzXAWygmV
gXoGtL6TMcUHrzWuAJHD7SOKpjPZfYAFges6fTUikMgBHbV6lNj4liIdxjCe4fZw
i2AzbsqcQ4a7cnsnFmW8g0uiqTkBrp1vdPfBQlLxPNXYw5VHQiiHQGZl7Iiuv81A
bPND6OBHy9dAPo1NVpdTOTDJG+aUQA9sHhWZT0sXbFOrW/jS321DNL0IsMQLiPJe
imLdIquGW1MF/WwYW2z9MgpV6/BVCDbQBjesF5Tp1I+CTueJ/PWA8WUAbtRB/LTA
qcLBtnnCMYXrPdzXbAbw
=tVlI
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
