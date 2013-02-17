Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab3BQQkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 11:40:47 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44976 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3BQQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 11:40:46 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Date: Sun, 17 Feb 2013 17:40:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-24-generic; KDE/4.10.0; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201302170046.26569@pali> <20130217162523.GC1583@opensource.wolfsonmicro.com>
In-Reply-To: <20130217162523.GC1583@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2123684.uNZyNx79sE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302171740.41985@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2123684.uNZyNx79sE
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 17 February 2013 17:25:24 Mark Brown wrote:
> On Sun, Feb 17, 2013 at 12:46:25AM +0100, Pali Roh=C3=A1r wrote:
> > Accelerometer driver lis3lv02d_i2c not working on Nokia
> > RX-51 with linux kernel 3.8-rc3. Probing for i2c device
> > failing.
> >=20
> > I tried to compile older version and it working without
> > problem. Then I bisected commit which broke support for
> > RX-51.
> >=20
> > That commit is ec400c9fab99d16a491cea17d27d0c6a5780b97c
> > "lis3lv02d: make regulator API usage unconditional"
> >=20
> > CCing everybody who signed off that commit. When I reverted
> > that commit on top of 3.8-rc3, lis3lv02d working without
> > problem.
> >=20
> > It looks like driver is trying to use some regulator, but
> > there is nothing defined for RX-51.
> >=20
> > Any idea what to do?
>=20
> It would be helpful to provide some more detailed information
> on the problem you are seeing than "the probe is failing".=20
> Are there any error messages or other indications as to where
> in the probe the error occurs?

I booted kernel without reverted that commit and here is dmesg output:

$ dmesg | grep lis3
[  110.454345] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
[  110.457397] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral
[  111.507415] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
[  111.510528] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral
[  126.720458] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
[  126.728149] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral
[  135.842803] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
[  135.856292] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2123684.uNZyNx79sE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlEhCAkACgkQi/DJPQPkQ1JSJACfSOIxU4w9PkppmY7cJuXgxTAX
zMgAn3iDB+7sDVmPfGHCLtIxnUEYlGwi
=6H0S
-----END PGP SIGNATURE-----

--nextPart2123684.uNZyNx79sE--
