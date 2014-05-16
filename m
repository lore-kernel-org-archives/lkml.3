Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaEPTXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:23:52 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48501 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbaEPTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:23:51 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: Dell Latitude E6440 & i8k
Date: Fri, 16 May 2014 21:23:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
References: <201405162037.41782@pali> <20140516211117.0c766287@endymion.delvare>
In-Reply-To: <20140516211117.0c766287@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8594476.hWbopdW9hk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405162123.02112@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8594476.hWbopdW9hk
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 16 May 2014 21:11:17 Jean Delvare wrote:
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

I mean fan RPM & temp4. Those are for sure incorrect.

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

Ok, if driver is developed without any documentation, then it=20
make sense that not working correctly on new machines...

So is not there any documentation? I think that Dell released=20
some SMM/BIOS code... But I'm not sure about it.

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

Looks like now it reports more plausible value for fan. When fan=20
is at low it reporting between 3000 - 3100 RPM.

> Add the following to /etc/sensors.d/i8k.conf:
>=20
> chip "i8k-virtual-0"
>=20
>    label fan2 "Left Fan"
>    ignore temp4

And this fixing output from sensors program.

$ sensors
i8k-virtual-0
Adapter: Virtual device
Left Fan:    3088 RPM
CPU:          +54.0=C2=B0C =20
temp2:        +57.0=C2=B0C =20
temp3:        +40.0=C2=B0C

But Right Fan name is still present in kernel sysfs:

$ grep "" /sys/class/hwmon/hwmon1/*
/sys/class/hwmon/hwmon1/fan2_input:3091
/sys/class/hwmon/hwmon1/fan2_label:Right Fan
/sys/class/hwmon/hwmon1/name:i8k
/sys/class/hwmon/hwmon1/pwm2:128
/sys/class/hwmon/hwmon1/temp1_input:56000
/sys/class/hwmon/hwmon1/temp1_label:CPU
/sys/class/hwmon/hwmon1/temp2_input:57000
/sys/class/hwmon/hwmon1/temp3_input:40000
/sys/class/hwmon/hwmon1/temp4_input:127000

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8594476.hWbopdW9hk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlN2ZZYACgkQi/DJPQPkQ1KElgCgmT8H59KavCet4mzk6favU28N
7GEAnjA0bvy3udC+2xQ9pSPq6XB0Dcvq
=MaMD
-----END PGP SIGNATURE-----

--nextPart8594476.hWbopdW9hk--
