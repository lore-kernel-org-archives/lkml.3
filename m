Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbbATTDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:03:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47688 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbbATTDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:03:31 -0500
Date: Tue, 20 Jan 2015 13:02:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] extcon: usb: Introduce USB GPIO extcon driver. Fix
 DRA7 USB.
Message-ID: <20150120190237.GG15169@saruman>
Reply-To: <balbi@ti.com>
References: <1421689942-10201-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rV8arf8D5Dod9UkK"
Content-Disposition: inline
In-Reply-To: <1421689942-10201-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rV8arf8D5Dod9UkK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 07:52:17PM +0200, Roger Quadros wrote:
> Hi,
>=20
> On DRA7 EVMs the USB ID pin is connected to a GPIO line. The USB drivers
> (dwc3 + dwc3-omap) depend on extcon framework to get the USB cable state
> (USB or USB-Host) to put the controller in the right mode.
>=20
> There were earlier attempts [1] to get this working by trying to patch up
> the existing GPIO extcon driver.
>=20
> This series attemts to take a different approach by introducing a new
> USB specific extcon driver to handle the USB ID GPIO pin and
> interpret a right USB cable state.
>=20
> The reasoning to introduce this new driver is:
> 1) The existing GPIO extcon driver doesn't understand USB cable states
> and it can't handle more than one cable per instance.
>   =20
> For the USB case we need to handle at least 2 cable states.
>     a) USB (attach/detach)
>     b) USB-Host (attach/detach)
> and could possible include more states like
>     c) Fast-charger (attach/detach)
>     d) Slow-charger (attach/detach)
>    =20
> 2) This USB specific driver can be easily updated in the future to
> handle VBUS events, or charger detect events, in case it happens
> to be available on GPIO for any platform.
>=20
> 3) The DT implementation is very easy. You just need one extcon node per =
USB
> instead of one extcon node per cable state as in case of [1].
>=20
> 4) The cable state string doesn't need to be encoded in the device tree
> as in case of [1].
>=20
> 5) With only ID event available, you can simulate a USB-peripheral attach
> when USB-Host is detacted instead of hacking the USB driver to do the sam=
e.
>=20
> Tested on DRA7-evm and DRA72-evm.

while at that, you might want to patch X15 too.

--=20
balbi

--rV8arf8D5Dod9UkK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvqZNAAoJEIaOsuA1yqREynQP/25JUbOYs+UiFaV7NHFcFNgL
iR8q5QvpXRXz09ryR7IX+qAq1EB/IhAFUd03tbM6kOGZV1s/fAsjaAftANJJRr2w
bipR1obgg7dPTBUiE8ActUcLGVubMo0Rb6IGpadrCL7TxhPUXt7u0W1U92/a8xdu
3tGlNGBXGxW3id3N0u3ljS3isWX9pqkGjm68nRbSwKbUYmV7xAf9vkSqYPQVo5lp
Hq/P3NLSP6mDxER+lO2+3K3Wq245hpZoY8kPdlTRoGMc5AMwjTe6876AQY36q8Z/
w4TO3Lu+IWH1O6hkLp5DzSRRuPbMTZhweiOR+Noc9vDFJZh6TA55g0umOXTov3Qa
H1U5Asi28nSCM3muQrAOtuRza1mZ/V69hZ5e9kvBrPeN0e5RB8jd0HB0/HjKGzqP
eBDduYJeRZfINQRMC6U3ZKfaKB8+WJBz0Swr0zGDRCTAweNhZzd3ZfxiSXY4m6AD
CktC/WLrI95N3+iZC6n0Otx/xt8bbGnwhNuKg5afGU5G/o5IvpFAat6rtEINArfG
of5oxF31Ua88v5BkFLTXDzcvWtNA/K6Jl9rwYIeOjJLpvKFfy+jhLfCvEIW/MEvQ
98F3CN4EWh66vHo9yGnYjKgJpat8GyOpD49GyVKcRODNY6I2HUmJMRDaLlYd/b0F
BEQ7P+54ubiRdsTZYeqv
=JCEx
-----END PGP SIGNATURE-----

--rV8arf8D5Dod9UkK--
