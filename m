Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3GFMBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 08:01:15 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54260 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3GFMBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 08:01:14 -0400
Date: Sat, 6 Jul 2013 14:01:12 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org
Subject: Re: MTD EEPROM support and driver integration
Message-ID: <20130706120112.GA11069@lukather>
References: <20130705201118.GM2959@lukather>
 <201307060033.13259.arnd@arndb.de>
 <20130706082804.GZ2959@lukather>
 <5811519.oHVuMujf0I@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <5811519.oHVuMujf0I@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm not exactly sure on what happened to the previous mail that has been
sent empty, but anyway:

On Sat, Jul 06, 2013 at 11:18:00AM +0200, Arnd Bergmann wrote:
> On Saturday 06 July 2013 10:28:04 Maxime Ripard wrote:
> > > a) like interrupts, regs, dmas, clocks, pinctrl, reset, pwm: fixed pr=
operty names
> > >=20
> > >       regmap =3D <&at25 0xstart 0xlen>;
> > >       regmap-names =3D "mac-address";
> > >=20
> > > b) like gpio, regulator: variable property names
> > >=20
> > >       mac-storage =3D <&at25 0xstart 0xlen>;
> > >=20
> > > It's unfortunate that we already have examples of both. They are larg=
ely
> > > equivalent, but the tendency is towards the first.
> >=20
> > I don't have a strong feeling for one against another, so whatever works
> > best. Both solutions will be a huge improvement anyway=20
> >=20
> > Just out of curiosity, is there any advantages besides having a fixed
> > property name to the first solution?
>=20
> I think it's mostly for consistency: trying to get most subsystems to
> do it the same way to make it easier for people to write dts files.
>=20
> A lesser point is that it simplifies the driver code if you don't
> have to pass a name.

So that leave us with mainly one path to achieve this goal:
  - Add a regmap-mtd backend
  - Add DT parsing code for regmap
  - Move the EEPROM drivers from misc to mtd

What other option would we have?

I also thought about writing an EEPROM framework of its own, but the
line is really thin between a large EEPROM and say a small SPI
dataflash, which would make it pretty hard to choose between such a
framework and MTD.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2AcHAAoJEBx+YmzsjxAgccMP/0YOuF1pBSNVfSKRyHXktDel
IgCnTkClK5/8fV4BMF7vxvSQGZUGQc0uVBfv/mzWOFkwMvnCeRCfW9UgMs6hiH36
Mqv95zTS5tzpoYYWtcc5hPw6eYbUzHpRoobZ7X29o06jQCQHddqeo6XZJJXyT+Zy
A2NQ1uopC42SCCYMsGNXolPnOD8Kw/RTCDke4iaC0f6kRkb+SFXMiP6uEeryryJL
+2aaQY/6BeqM61wRpRzWjOSnt+WXc3euRQk/zOjnAvtaiKhHCeaJWWwWGIwtAaK8
TeMwAj34263rPmymvH6UmVb+TKG0Ez/WQsjbepNoy7x9Vp039LwixTgKEUXroBY7
uajLR0cdiOS9vBeBNP8Iy05AeveULirIFexgqH2phJRybIj6SgKIPxlOCFDjRTQt
D38y2uuS5HLOmVKx0sjriHrN9YUF8Yt9YGdk7HOM3Y5aAM7RfCGzl5o6SLtC8I3N
ongzNUJodQVxdfwMsl8YTx8XjAYs94PJwlJYdO3qPB0huARxBf6jkALrDfQlYOJe
XsMcehjpFzGCHnOG7/ivmpO+KyNH8l8BVIApsf3K9XR/h+i5d2piu2yVcp/zrbYX
muML1uofcupnddbSE3lvQIZScHR8KYeqpi+CCBVbM/AIvHds21iK6ZLq7+nh3i/S
VcAec4Lue9vP3Hfcgrk6
=+npG
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
