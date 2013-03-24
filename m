Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3CXOur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:50:47 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:46742 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3CXOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:50:46 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Date: Sun, 24 Mar 2013 15:50:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201302170046.26569@pali> <201302171740.41985@pali> <20130217181756.GE1583@opensource.wolfsonmicro.com>
In-Reply-To: <20130217181756.GE1583@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3239038.VZLPqB4gik";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303241550.42801@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3239038.VZLPqB4gik
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 17 February 2013 19:17:59 Mark Brown wrote:
> On Sun, Feb 17, 2013 at 05:40:41PM +0100, Pali Roh=C3=A1r wrote:
> > $ dmesg | grep lis3
> > [  110.454345] lis3lv02d_i2c 3-001d: Failed to get supply
> > 'Vdd': -517 [  110.457397] i2c 3-001d: Driver lis3lv02d_i2c
> > requests probe deferral [  111.507415] lis3lv02d_i2c
> > 3-001d: Failed to get supply 'Vdd': -517 [  111.510528] i2c
> > 3-001d: Driver lis3lv02d_i2c requests probe deferral [=20
> > 126.720458] lis3lv02d_i2c 3-001d: Failed to get supply
> > 'Vdd': -517 [  126.728149] i2c 3-001d: Driver lis3lv02d_i2c
> > requests probe deferral [  135.842803] lis3lv02d_i2c
> > 3-001d: Failed to get supply 'Vdd': -517 [  135.856292] i2c
> > 3-001d: Driver lis3lv02d_i2c requests probe deferral
>=20
> This just looks like a basic error in the board hookup - the
> supplies are not mapped for the device.  Add the supply
> mappings and you should be fine.  This should have been done
> when the device was added, the commit doing that looks like
> it was never tested in mainline as the driver problem was
> fixed in October 2011 but the RX51 didn't start using the
> device until May 2012.

There is no regulator 'Vdd' supply in board rx51 files. Can you=20
look at code how it can be fixed?=20
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/a=
rm/mach-omap2/board-rx51-peripherals.c#n86

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3239038.VZLPqB4gik
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFPEsIACgkQi/DJPQPkQ1J06gCfdKSF/NPlDg0Pm0YsgKJzlNkM
o3gAoLTyTsnEMh5Gap3PHPa0RtpJ04J7
=OeD4
-----END PGP SIGNATURE-----

--nextPart3239038.VZLPqB4gik--
