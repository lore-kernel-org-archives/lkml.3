Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaK3QAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:00:41 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63081 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaK3QAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:00:40 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Fix temperature bug handling in i8k_get_temp()
Date: Sun, 30 Nov 2014 17:00:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <201411181546.51284@pali> <201411301548.16031@pali> <547B3E30.3030600@roeck-us.net>
In-Reply-To: <547B3E30.3030600@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart21479622.O9CLKuXoLG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411301700.36828@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart21479622.O9CLKuXoLG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 November 2014 16:56:32 Guenter Roeck wrote:
> On 11/30/2014 06:48 AM, Pali Roh=C3=A1r wrote:
> [ ... ]
>=20
> >>> +	if (temp > I8K_MAX_TEMP)
> >>> +		return -ERANGE;
> >>=20
> >> Can we return -ENODATA in this case ? I think that would be
> >> more appropriate.
> >=20
> > This is internal kernel function, no problem. If you prefer
> > NODATA instead RANGE I will change it.
>=20
> The idea was to return ENODATA to user space (see below).
>=20
> >>>    #endif
> >>>   =20
> >>>    	return temp;
> >>>=20
> >>> @@ -499,6 +501,8 @@ static ssize_t
> >>> i8k_hwmon_show_temp(struct device *dev,
> >>>=20
> >>>    	int temp;
> >>>    =09
> >>>    	temp =3D i8k_get_temp(index);
> >>>=20
> >>> +	if (temp =3D=3D -ERANGE)
> >>> +		return -EINVAL;
> >>=20
> >> and can we also return -ENODATA to user space ?
> >> This would make the code a bit cleaner.
> >>=20
> >> Thanks,
> >> Guenter
> >=20
> > There was some problems when I tested similar patch for
> > radeon.ko (do not report temperature to userspace when card
> > is turned off).
>=20
> You mean when returning -ENODATA to user space ?
> I tested that; it worked for me and does what we want it to do
> (the sensors command to displays N/A). This would avoid having
> to change -ERANGE to a different error code above.
>=20
> Guenter

Now I tested it too on Ubuntu and it working. sensors display N/A=20
without error message. So I will change code.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart21479622.O9CLKuXoLG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR7PyQACgkQi/DJPQPkQ1INIQCguWP6r5KhmtEed+xL20mntopG
nTIAn18c/vZefU3oYF9auILSE4RCPsom
=Dffg
-----END PGP SIGNATURE-----

--nextPart21479622.O9CLKuXoLG--
