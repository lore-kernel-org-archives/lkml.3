Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaLUMJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:09:47 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64955 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLUMJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:09:46 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v3] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sun, 21 Dec 2014 13:09:40 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1419012268-20805-1-git-send-email-pali.rohar@gmail.com> <1419153618-6930-1-git-send-email-pali.rohar@gmail.com> <5496B594.6050205@roeck-us.net>
In-Reply-To: <5496B594.6050205@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1609934.qFTfh9r98J";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412211309.41077@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1609934.qFTfh9r98J
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 21 December 2014 12:57:08 Guenter Roeck wrote:
> > -#define I8K_FAN_MULT		30
> > +#define I8K_FAN_MAX_RPM		30000
> >=20
> >   #define I8K_MAX_TEMP		127
> >  =20
> >   #define I8K_FN_NONE		0x00
> >=20
> > @@ -64,7 +66,7 @@ static DEFINE_MUTEX(i8k_mutex);
> >=20
> >   static char bios_version[4];
> >   static struct device *i8k_hwmon_dev;
> >   static u32 i8k_hwmon_flags;
> >=20
> > -static int i8k_fan_mult;
> > +static int i8k_fan_mult =3D 30;
>=20
> Why did you drop I8K_FAN_MULT ?
>=20

Because I think it is not needed anymore... It is used only in=20
one place (there ^). But if you want I can revert it back.

> >   static int __init i8k_probe(void)
> >   {
> >=20
> > +	const struct i8k_config_data *conf;
>=20
> Why did you move this variable declaration ?
>=20

Comes from previous version of patches where I moved all=20
variables to start of function. I will revert this change.

> >=20
> > -		const struct i8k_config_data *conf =3D id->driver_data;
> > +		conf =3D id->driver_data;
> > +		if (fan_mult <=3D 0 && conf->fan_mult > 0)
>=20
> I still don't see the value in accepting fan_mult < 0
> (compeared to =3D=3D 0).
>=20

Ok. What kernel driver should do if user load it with negative=20
parameter? We should not propagate negative value to functions.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1609934.qFTfh9r98J
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSWuIUACgkQi/DJPQPkQ1L/SQCePNuL/tpRti3vFgJuF+x7m/oi
H2oAn0mLykwf+sKRgb4maTkUERcm20Kw
=n0YM
-----END PGP SIGNATURE-----

--nextPart1609934.qFTfh9r98J--
