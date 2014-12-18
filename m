Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953AbaLRQfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:35:03 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40533 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaLRQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:35:00 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Thu, 18 Dec 2014 17:34:56 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412181208.58969@pali> <21066.1418915331@turing-police.cc.vt.edu>
In-Reply-To: <21066.1418915331@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1460430.1M8Crbo4gH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412181734.56353@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1460430.1M8Crbo4gH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 18 December 2014 16:08:51 Valdis.Kletnieks@vt.edu=20
wrote:
> On Thu, 18 Dec 2014 12:08:58 +0100, Pali Roh=C3=A1r said:
> > So your BIOS cannot report nominal_rpm and because your
> > machine=3D20 is not in dmi list, all 3 patches do nothing for
> > your machine.
> >=20
> > But you need to set multiplier to 1, right?
> >=20
> > What about this patch? (on top of 3/3)
> >=20
> > --- a/drivers/char/i8k.c
> > +++ b/drivers/char/i8k.c
> > @@ -850,6 +850,10 @@ static int __init i8k_probe(void)
> >=20
> >  		 */
> >  	=09
> >  		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan) {
> >  	=09
> >  			i8k_fan_mult[fan] =3D I8K_FAN_DEFAULT_MULT;
> >=20
> > +			if (i8k_get_fan_rpm(fan) > I8K_FAN_MAX_RPM) {
> > +				i8k_fan_mult[fan] =3D 1;
> > +				continue;
> > +			}
> >=20
> >  			for (val =3D 0; val < 256; ++val) {
>=20
> Dell Latitude E6530, linux-next 20141208 plus the 3 patches
> you posted on Nov 30 (support labels), plus the 4 of 3
> patches in this go around, and sensors reports:
>=20
> i8k-virtual-0
> Adapter: Virtual device
> fan2:        2774 RPM
>=20
> and under CPU load, that number rises to 3200 or so, so it
> seems to be working....
>=20
> So you probably should fold this into the current set of
> patches, and feel free to put this in there:
>=20
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Thanks for testing. Anyway I would like to know if your dell=20
machine supports i8k_get_fan_nominal_rpm(). Can you test without=20
above 4 lines patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1460430.1M8Crbo4gH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSTAjAACgkQi/DJPQPkQ1K17wCeKkbz1RW9M6NdY0bxurGqAG02
hE4AoIZHCfYW24ayEFW6eI+eIh5ACQRY
=teUu
-----END PGP SIGNATURE-----

--nextPart1460430.1M8Crbo4gH--
