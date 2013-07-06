Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3GFI20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 04:28:26 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53953 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3GFI2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 04:28:16 -0400
Date: Sat, 6 Jul 2013 10:28:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org
Subject: Re: MTD EEPROM support and driver integration
Message-ID: <20130706082804.GZ2959@lukather>
References: <20130705201118.GM2959@lukather>
 <201307052302.40588.arnd@arndb.de>
 <20130705222342.GP2959@lukather>
 <201307060033.13259.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FilwpOHBrTVNlmJ3"
Content-Disposition: inline
In-Reply-To: <201307060033.13259.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FilwpOHBrTVNlmJ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 06, 2013 at 12:33:13AM +0200, Arnd Bergmann wrote:
> On Saturday 06 July 2013, Maxime Ripard wrote:
> > > My first thought is that it should be more generic than that and not
> > > have the mac address hardcoded as the purpose. We could possibly use
> > > regmap as the in-kernel interface, and come up with a more generic
> > > way of referring to registers in another device node.
> >=20
> > Hmm, I maybe wasn't as clear as I wanted. Here mac-storage was just an
> > example. It should indeed be completely generic, and a device could have
> > several "storage source" defined, each driver knowing what property it
> > would need, pretty much like what's done currently for the regulators
> > for example.
> >=20
> > We will have such a use case anyway for the Allwinner stuff, since the
> > fuses can be used for several thing, including storing the SoC ID,
> > serial numbers, and so on.
>=20
> Ah, I see. In general, we have two ways of expressing the same thing
> here:
>=20
> a) like interrupts, regs, dmas, clocks, pinctrl, reset, pwm: fixed proper=
ty names
>=20
> 	regmap =3D <&at25 0xstart 0xlen>;
> 	regmap-names =3D "mac-address";
>=20
> b) like gpio, regulator: variable property names
>=20
> 	mac-storage =3D <&at25 0xstart 0xlen>;
>=20
> It's unfortunate that we already have examples of both. They are largely
> equivalent, but the tendency is towards the first.

I don't have a strong feeling for one against another, so whatever works
best. Both solutions will be a huge improvement anyway :)

Just out of curiosity, is there any advantages besides having a fixed
property name to the first solution?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--FilwpOHBrTVNlmJ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR19UUAAoJEBx+YmzsjxAgeo0QAKVjrA8g07FlbI9ElVjbGWbq
/Xd5i3W75P6frSG9xAOpx2gDkCkbdAWlRaKY2QMkdjG4rgY2LQrsJt1MeaKp2nl5
+UhHipdof9m9fpI536kPJTTqQQzhOYVzrUSIJcBHMkHMmlMdmiFsDH4LzU3HkaLF
DNSVRIDC3e+M7PRzc5mI8sGxJia+ptUxdtynUxKCHead/b3AxcBMx1RtElzPDhSl
vDIQ4enzboP8k5YjrN8onYoV+/DaHGy+4ltDt4JTznubzW0safto9oHr69g4OMF6
4oLWCzGoJBVOwSpEKQVeLKD90P7Dv+RwEFWPq6hYtl8BeGp5jx591co6SzEiFV9k
nfKS+NlovtX4AULjD4hoJEYLfKdXHSKGn/z3g5LtkAAZgoSUOsSbF9Ha21gAM82H
04lg3KNwsIoJLJC+SHKeD9fEeVxZJysodJG6UwfKfNb4prM6gsNCPg8iMDsu2Ht5
apkqucunbPa/zemaYdzAMGHT4Ed1Yk+doh5tDCKYq1pwb2IHUCK48xoXL5/OVjUQ
RBmlU+Bc9TAhXoypzEQpU8pPYak6uskGje6Tdir1K3Acxnt1KRXWd08W0XuiFOeb
DiVicZM1r77nBXXFc2w4nSz3iMkTC63PSgXrhVLNE5yYitdM127Dg8QeSf3nfzTD
bfSBOddQtniXwP4SBTby
=SqFZ
-----END PGP SIGNATURE-----

--FilwpOHBrTVNlmJ3--
