Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3CXXEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 19:04:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37092 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab3CXXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 19:04:45 -0400
Date: Sun, 24 Mar 2013 23:04:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130324230435.GE18316@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
 <201303242227.32528@pali>
 <20130324221444.GD18316@opensource.wolfsonmicro.com>
 <201303242345.00176@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EgVrEAR5UttbsTXg"
Content-Disposition: inline
In-Reply-To: <201303242345.00176@pali>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EgVrEAR5UttbsTXg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 24, 2013 at 11:44:59PM +0100, Pali Roh=E1r wrote:
> On Sunday 24 March 2013 23:14:46 Mark Brown wrote:

> > Well, you should seek support from the board vendor then.=20

> Not possible. Nokia is already using Windows Phones and life=20
> cycle for Nokia N900 phone is at the end. And Nokia never=20
> released any HW documentations to community...

There may well still be people with the required information, though in
general this sort of thing is always going to be a hazard when working
on undocumented hardware.

> Another question: what was reason for that commit=20
> ec400c9fab99d16a491cea17d27d0c6a5780b97c
> "lis3lv02d: make regulator API usage unconditional" ?

Failing to provide power to a device is typically a very serious
problem for device operation but the code that was there handles such
errors by ignoring them.  This isn't a robust way forwards and such code
should never have been merged in the first place, as the changelog says
the regulator core provides a number of facilities for stubbing itself
out when it is not required which boards should use.

Handling the possibility that supplies may not be there not only creates
needless repetitive complexity in device drivers but also decreases the
robustness of the system since error handling for access to powered down
devices often isn't very pretty and other drivers or the core may
disrupt the operation of the device by for example powering it down due
to not thinking it's in use.

> I think that for N900 support is reverting above commit needed, I=20
> do not see other solution...

If you're convinced that the regulator is kept on for some reason you
could always just provide a fake supply, though obviously it would be
better to hook up the real regulator since this may break if at some
point the kernel decides that whatever is actually providing the supply
is unused and can be turned off.

--EgVrEAR5UttbsTXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRT4Z7AAoJELSic+t+oim9fvMP/192OdVzYWLoRCvhw9GnwHLv
V1am3R9TJ8IMjSE2ltqEqw/hfHujfsslUjxR4a5AKqqnQyvTYVV8bxw5oLoV/pZ5
8oZx7dwAmN8M6H6MqgVX5AqIyEwrozDla275tBNAEasyHJSwSRFrtLNCUPiq+3zB
b6tYwJ2QXUV4/yEcCaUECeRFd6NFGBueuHcNH6M2om4CsotWW7tZimEioZ+vZvE/
wUksFwuTnrn+TpsaAYXXKucX5EQ8F4igpcbuuHMENNsBQaBqeyaYoxHVukmt/EXc
4o52mxVdLQR14BPOGOII2ayFqBKsLvpZSiSF0khl5SHUQOK8Q0iUGe9Sn6g2oGm3
mLvgwe9lap3wxNhrSU7AkE1HQ79lYLoHg/kViDAz/eyad2b5MFzx6rVlD4VKPAk1
Z5I0WT8a1vKTYBO5ZCq1C79mDC3NAPSzABN5z/egpDecZ27gyBba3l6EGFrk2mpC
iO+JaUJ+A7bT7ZYAoK5q0kvtt1MBstBQd7OQmm9qF2j0Xx7fbTNuRX9VsKGZ8J8s
Z2Z6UQpHfuxG3u5Ws87bML/U6HQPTYcGOK7/AYQdPOa7uoe89y0lmSOfobvDePFx
z+uvZwMx2FKZCMzhc7oG9CMtl9ogf115lM0vKl7feUgYRBF4k53oUOGskF1NJjVy
/PoT/BMRicDj6Q+4QUPO
=OT+s
-----END PGP SIGNATURE-----

--EgVrEAR5UttbsTXg--
