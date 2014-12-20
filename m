Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaLTI5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 03:57:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34133 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaLTI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 03:57:42 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sat, 20 Dec 2014 09:57:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412191951.25562@pali> <20141219192808.GA8493@roeck-us.net>
In-Reply-To: <20141219192808.GA8493@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart67578544.QBRLKvmjuG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412200957.38638@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart67578544.QBRLKvmjuG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 19 December 2014 20:28:08 Guenter Roeck wrote:
> On Fri, Dec 19, 2014 at 07:51:25PM +0100, Pali Roh=C3=A1r wrote:
> > On Friday 19 December 2014 19:32:37 Guenter Roeck wrote:
> > > > -static int i8k_fan_mult;
> > > > -static int i8k_pwm_mult;
> > > > -static int i8k_fan_max =3D I8K_FAN_HIGH;
> > > > +static int i8k_fan_mult[2];
> > > > +static int i8k_pwm_mult[2];
> > > > +static int i8k_fan_max[2];
> > >=20
> > > The rationale for this change is not explained in the
> > > commit log.
> > >=20
> > > Do you have any indication that those values would ever be
> > > different for the two fans, ie that you actually need
> > > arrays here ?
> >=20
> > I do not know... But if we decide to use only single value
> > for multiplier and max value which fan to use for
> > autodetection?
>=20
> That does not answer my question. That you can not decide
> which fan to use for auto-detection does not mean that the
> result of that auto-detection would be different for
> different fans.
>=20

Really I do not know if some dell products which have more fans=20
(some Precision models have 2) and each fan is using different=20
multiplier or has different max speed value.

> > > > @@ -271,8 +274,25 @@ static int i8k_get_fan_speed(int
> > > > fan)
> > > >=20
> > > >  {
> > > > =20
> > > >  	struct smm_regs regs =3D { .eax =3D I8K_SMM_GET_SPEED, };
> > > >=20
> > > > +	if (fan < 0 || fan >=3D ARRAY_SIZE(i8k_fan_mult))
> > > > +		return -EINVAL;
> > > > +
> > >=20
> > > This range check (and probably others) is still
> > > unnecessary.
> > >=20
> > > Guenter
> >=20
> > No, it is necessary. Function i8k_get_fan_speed is called
> > from ioctl callback with value which comes from userspace.
> > If userspace specify fan out of that array we can get
> > kernel panic.
>=20
> Yes, but just because you introduced an array for various
> variables, and you still have the unnecessary check for other
> callers.
>=20
> If you want to return -EINVAL for bad ioctl parameters, add a
> range check check there. But that would be a separate patch.
>=20
> Guenter
>=20

So you want to move that checks into ioctl code and do not do=20
checks in smm functions?

> > > >  	regs.ebx =3D fan & 0xff;
> > > >=20
> > > > -	return i8k_smm(&regs) ? : (regs.eax & 0xffff) *
> > > > i8k_fan_mult; +	return i8k_smm(&regs) ? : (regs.eax &
> > > > 0xffff) * i8k_fan_mult[fan]; +}

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart67578544.QBRLKvmjuG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSVOgIACgkQi/DJPQPkQ1KlyACgsJXlxELJpHYi8Jx6sCzlPvSo
CwcAoI+fWLK5shJcSWxdxmAesY/TuIdG
=04OR
-----END PGP SIGNATURE-----

--nextPart67578544.QBRLKvmjuG--
