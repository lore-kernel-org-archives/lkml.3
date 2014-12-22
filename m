Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaLVPHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:07:45 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57450 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaLVPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:07:44 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v4] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Mon, 22 Dec 2014 16:07:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com> <1419182630-20211-1-git-send-email-pali.rohar@gmail.com> <549724B2.4050209@roeck-us.net>
In-Reply-To: <549724B2.4050209@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4831754.k7gjMxHlcH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412221607.34978@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4831754.k7gjMxHlcH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 21 December 2014 20:51:14 Guenter Roeck wrote:
> On 12/21/2014 09:23 AM, Pali Roh=C3=A1r wrote:
> > This patch adds new function i8k_get_fan_nominal_speed() for
> > doing SMM call which will return nominal fan RPM for
> > specified fan speed. It returns nominal RPM value at which
> > fan operate when speed (0, 1, 2, 3) is set. It looks like
> > RPM value is not accurate, but still provides very useful
> > information.
> >=20
> > First it can be used to validate if certain fan speed could
> > be accepted by SMM for setting fan speed and we can use
> > this routine to detect maximal fan speed.
> >=20
> > Second it returns RPM value, so we can check if value looks
> > correct with multiplier 30 or multiplier 1 (until now only
> > these two multiplier were used). If RPM value with
> > multiplier 30 is too high, then multiplier 1 is used.
> >=20
> > In case when SMM reports that new function is not supported
> > we will fallback to old hardcoded values. Maximal fan speed
> > would be 2 and RPM multiplier 30.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Auto-detection of both multiplier and maximum speed tested
> working on M140 (after removing its configuration entry).
>=20
> On Studio 1555, multiplier auto-detection works, but fan_max
> auto-detection fails. A speed value of '3' is accepted, but
> it does not set the fan speed to its maximum. Also, after
> setting the speed value to '3', reading it back returns to
> old value. No idea what it does or is expected to do. Reading
> the nominal speed does return a valid value.
>=20
> Given that, I think we should not try to auto-detect fan_max,
> but keep the current code (meaning either use 2 or 3
> depending on the configuration data, with 2 as default if
> nothing else is known).
>=20
> Thanks,
> Guenter

Ok. In this case I will remove max fan speed detection code and=20
we will use config data for those some machines which support=20
TURBO speed. If multiplier detection on Studio is working fine, I=20
can send another patch which remove config data for Studio=20
(because default multiplier is 2).

Can you check which nominal value Studio returns for speed 3?=20
Maybe it is some special?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4831754.k7gjMxHlcH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSYM7YACgkQi/DJPQPkQ1JxvgCgr9axrXym97M9w0Z+DkdpcP5I
gbcAoKqLEN+AVI0BEPgcXs5/unZSua8Y
=WsrJ
-----END PGP SIGNATURE-----

--nextPart4831754.k7gjMxHlcH--
