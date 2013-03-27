Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3C0LKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:10:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55748 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3C0LKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:10:36 -0400
Message-ID: <5152D39F.1090104@ti.com>
Date: Wed, 27 Mar 2013 13:10:23 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: <linux-fbdev@vger.kernel.org>, <florianschandinat@gmx.de>,
        <vt8500-wm8505-linux-kernel@googlegroups.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] video: fb: vt8500: Convert framebuffer drivers to
 standardized binding
References: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz> <1364374021-10844-7-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1364374021-10844-7-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig376836BFAA8AAA23B8CFC0F7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig376836BFAA8AAA23B8CFC0F7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-03-27 10:47, Tony Prisk wrote:
> Now that a display timing binding is available, convert our almost iden=
tical
> binding to use the standard binding.
>=20
> This patch converts the vt8500 and wm8505 framebuffer drivers and
> associated dts/dtsi files to use the standard binding as defined in
> bindings/video/display-timing.txt.
>=20
> There are two side-effects of making this conversion:
>=20
> 1) The fb node should now be in the board file, rather than the soc fil=
e as
> the display-timing node is a child of the fb node.
>=20
> 2) We still require a bits per pixel property to initialize the framebu=
ffer
> for the different lcd panels. Rather than including this as part of the=

> display timing, it is moved into the framebuffer node.
>=20
> I have also taken the opportunity to alphabetise the includes of each
> driver to avoid double-ups.

I don't think this is correct. I don't have that much experience with
DT, but I think you should have, for example:

wm8850.dtsi:

	fb: fb@d8051700 {
		compatible =3D "wm,wm8505-fb";
		reg =3D <0xd8051700 0x200>;
	};

wm8850-w70v2.dts:

&fb {
	bits-per-pixel =3D <16>;

	display-timings {
		native-mode =3D <&timing0>;
		timing0: 800x480 {
			clock-frequency =3D <0>;
			...
		};
	};
};

So, the core fb part should be in the SoC's file, as it's part of the
SoC. And the stuff that tells what kind of display is attached is in the
board dts file.

Also, just a word of warning, I think the videomode series I've sent for
review will cause some breakage with this series if the videomode series
is accepted. Nothing difficult to fix, though, but we'll need some extra
management to avoid compilation failures.

 Tomi



--------------enig376836BFAA8AAA23B8CFC0F7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRUtOfAAoJEPo9qoy8lh71/EYP/0JKVD/rqgcE71MywBTPZdYk
XEV4tY8ALrfutQy0AXKTxSbG3PzJRZbR4QcIlU6J/5OdTn0diuXDeBG5GbFyFyAe
K1BqiRxJGRWVKn7Tl1zSOHw52nenRI9iB09drZYRpxGIkXud89/cxGbuH0W2YoAe
Dv11ZRP3tfbWBKCl95GvjPqa6HMONqWOsE3xXYWKbBmkPiolKjcanPBwLhLU2kmA
iRwdB3WN1LDsd+plVlLngM0KodZUlpa0ZVRVzdvtmQ8zMs7BlrfXYmfY3p3opPGu
8BxPxbfGkC+Sb1CxfSjSXqx3r/637K00tCn8sw2u+fkiXKFv8jzZmpxl73mUj9PT
KRgBatqkJBKneRHoAFKWFcwQUEonxkOVd86bO+GDLUeJbfrfCr2Cmfn20CmTrlRV
UBkPzQiIGjuIssaCMqvUBjdYmj1PbVmMlYxgJkR9yp7sjpR2OdmYDMFKQ6Lpsi6C
ZynxAmPb5OrLuRmHDgep4PkDcEDa+K0OjVtAHnm4bhDIIKO9zKW1wVHu6qJaamuC
12nwKueViOSLmsWyKwT5ZL7E9+XyRhPgSQm/ULsLiUKBCGaOCmnSK2zK2nmENEUp
/E/BzPBarTVTa+FPOtGsEq98RZe1vt6XWrktaqLfi3OXZzL5XxceiMW5lgQVmRyD
oI59oVcFoeU1xBiSuTh8
=bulL
-----END PGP SIGNATURE-----

--------------enig376836BFAA8AAA23B8CFC0F7--
