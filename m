Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaEQWyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:54:22 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43532 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaEQWyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:54:21 -0400
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
Subject: Re: Dell Latitude E6440 & i8k
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Sun, 18 May 2014 00:54:17 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2023768.syW3doBge0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405180054.17746@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2023768.syW3doBge0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 16 May 2014 21:11:17 you wrote:
> Hi Pali,
>=20
> On Fri, 16 May 2014 20:37:41 +0200, Pali Roh=C3=A1r wrote:
> > Hello,
> >=20
> > on Dell Latitude E6440 driver i8k reporting total nonsense
> > values
>=20
> That's kind of excessive wording, the output isn't that bad.
>=20
> > $ sensors
> > i8k-virtual-0
> > Adapter: Virtual device
> > Right Fan:   93450 RPM
> > CPU:          +57.0=C2=B0C
> > temp2:        +57.0=C2=B0C
> > temp3:        +40.0=C2=B0C
> > temp4:       +127.0=C2=B0C
> >=20
> > Right Fan and temp4 are for sure incorrect.
>=20
> Driver is reverse-engineered so this is best effort and some
> tweaking may be needed.
>=20
> > Value temp4 is always 127 and is never changing, but value
> > for Right Fan is increasing when fan is more noisy. So it
> > looks like value for Right Fan is not correctly normalized
> > or multiplier is incorrect.
> >=20
> > And name "Right" is incorrect too. Fan is on left side of
> > this notebook, not right as reported by driver.
> >=20
> > It is possible to fix these problems?
>=20
> Load the i8k driver with fan_mult=3D1.
>=20
> Add the following to /etc/sensors.d/i8k.conf:
>=20
> chip "i8k-virtual-0"
>=20
>    label fan2 "Left Fan"
>    ignore temp4

I have some new info about temp4.

When I read value from temp4 for first time it reports (possible)=20
correct value:

$ cat /sys/class/hwmon/hwmon2/temp4_input
49000

But every next call it returns 127000 which is incorrect.

So this looks like bug in BIOS or incorrect usage of SMM call...

Do you know if there is any way to extract BIOS SMM code? Or it=20
is something which is not possible to do from OS/kernel side?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2023768.syW3doBge0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlN36JkACgkQi/DJPQPkQ1KiuQCgsZoya3r3I5kxzBwHW1NUVc87
sDUAnAg36IfhnoeJQ9CyK3eZmL6KjS1j
=5JLv
-----END PGP SIGNATURE-----

--nextPart2023768.syW3doBge0--
