Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3BQSSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:18:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37709 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614Ab3BQSSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:18:07 -0500
Date: Sun, 17 Feb 2013 18:17:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130217181756.GE1583@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
 <20130217162523.GC1583@opensource.wolfsonmicro.com>
 <201302171740.41985@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z+pzSjdB7cqptWpS"
Content-Disposition: inline
In-Reply-To: <201302171740.41985@pali>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z+pzSjdB7cqptWpS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 17, 2013 at 05:40:41PM +0100, Pali Roh=E1r wrote:

> $ dmesg | grep lis3
> [  110.454345] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
> [  110.457397] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral
> [  111.507415] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
> [  111.510528] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral
> [  126.720458] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
> [  126.728149] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral
> [  135.842803] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
> [  135.856292] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral

This just looks like a basic error in the board hookup - the supplies
are not mapped for the device.  Add the supply mappings and you should
be fine.  This should have been done when the device was added, the
commit doing that looks like it was never tested in mainline as the
driver problem was fixed in October 2011 but the RX51 didn't start using
the device until May 2012.

--z+pzSjdB7cqptWpS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIR7MAAoJELSic+t+oim9/jUP/jjGHqoCYbuRWdZeDeAHZzZ4
GZlZfb+nkgCiWcTHe6tYVhgUe47TO6yHf9eHLVOw1g/LY4BYxAXfSX2nC0avbloH
VEDJfmK4fskGvb2jEdBmYuZg/EiugCjUT7KtUOg1CQDBKRf8eWbtqUWgArumiF5x
jhHdDVyf9fQaGAM/kjAoNyxSCp7wyi3Z3Ax/pHUBtCnAnH1SN4CKPY8rFl0cyIUl
pZNgRPADKHwcxBO7SFBtgNU5gaIhWixrvmDYbjMJEHmdQXt91e3UxTuMeljkeXn7
gTvw98J+9Jp2B/qa4/0fv4hni4CbhAHlYTWhzOL/aO71vZ2DcnjUKBcu3qkqRxdd
s6yF+qTWCZRFYTYNeFAc4h39aXZnZ3LfPXVyHo9OlMgv0u4fDQTXc2UW5mjZO4fz
lJabqQ47KxbOMHTvjNmp/N1jLRWSYlL20eGScvajIqR5eI/MxeT7/VQaNADFxcFr
z4iklswpI08dw/GxfC8DNZaSx4vnXaIWnKBwI0Cx0jQtEGiGfRTXCOxGea/PirNP
o2BLAGZ952wRqsrrTJBXJvnGqd8Pyios+2ZpvEdGY1BZzFI2pb3scfAydil0VFBa
NC4jZlT/dPARfYdMgWZa5Hhj+UYqYuIS0LCOHVigndxix6vdr5fiPHXVNxFGqGjO
wtjZXufl7W98ltqy1aUo
=p2sk
-----END PGP SIGNATURE-----

--z+pzSjdB7cqptWpS--
