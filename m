Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaLUJPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 04:15:35 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50381 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLUJPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 04:15:32 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sun, 21 Dec 2014 10:15:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1419012268-20805-1-git-send-email-pali.rohar@gmail.com> <5495C7C7.2030502@roeck-us.net>
In-Reply-To: <5495C7C7.2030502@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3109914.K9ll55OIMS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412211015.28895@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3109914.K9ll55OIMS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 20 December 2014 20:02:31 Guenter Roeck wrote:
> > +		for (fan =3D 0; fan < ARRAY_SIZE(i8k_fan_mult); ++fan) {
> > +			i8k_fan_mult[fan] =3D I8K_FAN_DEFAULT_MULT;
> > +			if (i8k_get_fan_speed(fan) > I8K_FAN_MAX_RPM) {
> > +				i8k_fan_mult[fan] =3D 1;
> > +				continue;
> > +			}
>=20
> Another note: On one of my systems, reading the current fan
> speed literally halts the entire system for a second or two.
> Given this, is the above really necessary ? It might be
> better to just try to use the nominal fan speeds and only
> read the actual fan speed if that doesn't work.
>=20

Ok. I added fallback to i8k_get_fan_speed() only if function=20
i8k_get_fan_nominal_speed() failed.

> > +			for (val =3D 0; val < 256; ++val) {
> > +				ret =3D i8k_get_fan_nominal_speed(fan, val);
> > +				if (ret > I8K_FAN_MAX_RPM) {
> > +					i8k_fan_mult[fan] =3D 1;
> > +					break;
> > +				} else if (ret < 0) {
> > +					break;
> > +				}
> > +			}
>=20
> I wonder if it would help to detect the maximum fan speed
> first. Once that is known, it should be possible to just read
> the nominal fan speed once, for the known maximum speed. With
> this, the 'val' loop here would be unnecessary.
>=20

Right, good point.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3109914.K9ll55OIMS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSWj7AACgkQi/DJPQPkQ1KjzACghGYd2MSMTiJk28RyoNRBu7fN
2I8An0XwfrZvDrZokuPuY/6eMvKoLS6D
=x2wc
-----END PGP SIGNATURE-----

--nextPart3109914.K9ll55OIMS--
