Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3CRKT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:19:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57131 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab3CRKTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:19:24 -0400
Date: Mon, 18 Mar 2013 12:18:54 +0200
From: Felipe Balbi <balbi@ti.com>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <sarah.a.sharp@linux.intel.com>, <Julia.Lawall@lip6.fr>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, <john453@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
Message-ID: <20130318101854.GQ17135@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
 <20130206163759.GB9952@arwen.pp.htv.fi>
 <CADB-GoJJbV10YGtBU-qWT7XK9SvkgPXkg3x-7oKq9RjSsODuEA@mail.gmail.com>
 <CADB-GoJMKJ_ed+K4_du5nXo54ZfGBy3s42uca1-vcQzm6Fdzyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="soWJpSPh+l8Y6Fy7"
Content-Disposition: inline
In-Reply-To: <CADB-GoJMKJ_ed+K4_du5nXo54ZfGBy3s42uca1-vcQzm6Fdzyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--soWJpSPh+l8Y6Fy7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(don't top-post)

On Mon, Mar 18, 2013 at 06:06:18PM +0800, Yuan-Hsin Chen wrote:
> Hi,
>=20
> I tried to modify fusbh200 hcd driver following ehci-platform.c.
> However, the register definition of fusbh200 is partially incompatible
> to ehci. For fusbh200, only the elements between "command" and
> "async_next" in struct ehci_regs are consistent with ehci which means
> it would cause copious modification and duplication of ehci hcd
> driver. For example, there is no "configured_flag" register in
> fusbh200 controller, yet, ehci hcd driver accesses "configured_flag"
> in function ehci_run which would cause compile errors. Therefore,
> maybe my first patch which refers to oxu210hp-hcd is a better
> solution?

why don't you just add a quirk flag to ehci struct so that it knows it
shouldn't access CONFIGFLAG register when that's non-existent ?

There are only 5 uses of configured_flag in ehci-hcd.c, so it should be
easy to wrap that around a flag check.

Alan, would you have a better idea ? Looks like this is a non-standard
EHCI implementation.

--=20
balbi

--soWJpSPh+l8Y6Fy7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRRuoOAAoJEIaOsuA1yqRECV8P/32bDTwmu8ZXGSU4bLEvTs+n
JkXzQcnbaPdsvHG9cmb6segdfq4LlnhI/tVeRCu3ZBtRF19KjqOz2SgOk53jOIJZ
3VAw/oG4TaZw67w8X0kMWoaDfmnE60+jgYMR91/JTuzJDlOSA06W4IB3TkjnLyFk
UDSx7UHT1n29xfGXt8my4Pxkx3V8CSb3uZGrrdNVs+XSv7hvdX0KmeCKt602d/Xb
0Fo79SqcBTMEReOcnzqO5KBbg2kddkytz6A2EB9PZPTurI/bbTL+ycSVe/Ao/UG9
1d8ZEK2r2v9plunPu0TzY4t66gxglCm9oxjOvFlLIHyaA+Y1RtRyqqKFwdZCxu1T
ySf9gXXTIugTazi2rT0TREODp2/fcKAAQ1afZoVwzjFKhpkswHJ4qLaDB78q4Twk
EJ+GZj+DkdooWqxVmuC+9FZDhr/9AV3vJPM0Oh0+KgVaiF1w75UrOK5yu72+zLK4
+Fs2R2cPn29trxs8UKSWT9X4KF3EphopNZbH2YcmteLbPOn5dAlcUWaS5RAfIrUL
ldHP9pPYT8KsFT+DwGN/JTV5gkgaST4iHDtaftn6FWqLVEldqBqtIAlI2MEA3DRg
xLashtbHh72IMWtnkYg+GDeOs7H2reLYt/pi/3+35HMWe95AKxLGUEiGy7pZ5bro
Ke24qVPreGcRz4VOUm7X
=vGzx
-----END PGP SIGNATURE-----

--soWJpSPh+l8Y6Fy7--
