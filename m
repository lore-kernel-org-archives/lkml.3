Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaK3Ool (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 09:44:41 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48147 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaK3Ook (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 09:44:40 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Fix temperature bug handling in i8k_get_temp()
Date: Sun, 30 Nov 2014 15:44:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <201411181546.51284@pali> <1416322614-10308-1-git-send-email-pali.rohar@gmail.com> <20141130001207.GA26101@roeck-us.net>
In-Reply-To: <20141130001207.GA26101@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1660214.YuunbV9Eor";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411301544.36856@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1660214.YuunbV9Eor
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 November 2014 01:12:07 Guenter Roeck wrote:
> > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > index 7272b08..e34a019 100644
> > --- a/drivers/char/i8k.c
> > +++ b/drivers/char/i8k.c
> > @@ -298,7 +298,7 @@ static int i8k_get_temp(int sensor)
> >
> >       int temp;
> > =20
> >  #ifdef I8K_TEMPERATURE_BUG
> >
> > -     static int prev[4];
> > +     static int prev[4] =3D { I8K_MAX_TEMP+1, I8K_MAX_TEMP+1,
> > I8K_MAX_TEMP+1, I8K_MAX_TEMP+1 };
>=20
> This results in a checkpatch warning. Please split, and add a
> space before and after '+'. Actually, I would suggest to use
> something something like
>=20
> #define I8K_INVALID_TEMP        (I8K_MAX_TEMP + 1)
>=20
> and to use it instead of hard-coding "I8K_MAX_TEMP + 1" in the
> code.

I will define I8K_INVALID_TEMP and use it instead I8K_MAX_TEMP.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1660214.YuunbV9Eor
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR7LVQACgkQi/DJPQPkQ1J+3wCfVzqonzfGZYohEKiTOZcuWC1y
1N8AoJlzMIvOrrONDRKLfEWu8C4OgF7D
=WuB4
-----END PGP SIGNATURE-----

--nextPart1660214.YuunbV9Eor--
