Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaETI4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:56:55 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47241 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaETI4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:56:52 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/2] platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
Date: Tue, 20 May 2014 10:56:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-doc@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com> <1399114077-19314-2-git-send-email-pali.rohar@gmail.com> <20135.1400569205@turing-police.cc.vt.edu>
In-Reply-To: <20135.1400569205@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2591801.r1EHKV3grs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405201056.47726@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2591801.r1EHKV3grs
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 20 May 2014 09:00:05 Valdis.Kletnieks@vt.edu wrote:
> On Sat, 03 May 2014 12:47:56 +0200, Pali Roh=C3=A1r said:
> > This acpi driver provide supports for freefall sensors
> > SMO8800/SMO8810 which can be found on Dell Latitude
> > laptops. Driver register /dev/freefall misc device which
> > has same interface as driver hp_accel freefall driver. So
> > any existing applications for HP freefall sensor
> > /dev/freefall will work for with this new driver for Dell
> > Latitude laptops too.
>=20
> So just for grins, I tossed this patchset on top of
> next-20140519, and it actually works on my Dell Latitude
> E6530. Tested with a controlled drop of 3-4 inches, and I get
> the distinctive sound of a head park, and the following in
> /var/log/messages:
>=20
> May 20 02:46:22 turing-police kernel: [18839.158926] smo8800
> SMO8810:00: detected free fall May 20 02:46:22 turing-police
> FREE FALL[1337]: Parked /dev/sda disk head May 20 02:46:24
> turing-police FREE FALL[1337]: Unparked /dev/sda disk head
>=20
> I did a quick read-through of the code, looks OK.  checkpatch
> complains about missing blank lines after declarations in 3-4
> places. Sparse and gcc have no complaints. We've certainly
> merged much uglier code.  And it certainly makes the world a
> better place for us Dell users.
>=20

Hm? Which errors? Here is output from checkpacth:

total: 0 errors, 0 warnings, 276 lines checked

0001-platform-x86-dell-smo8800-Dell-Latitude-freefall-dri.patch=20
has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 181 lines checked

0002-Documentation-Rename-hpfall.c-freefall.c-fixes-for-D.patch=20
has no obvious style problems and is ready for submission.

> So it's OK by me if Pali adds this to the signoffs after
> fixing the checkpatch and the one serious nit below....
>=20
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> Acked-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>=20
> One nit:
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -127,6 +127,16 @@ config DELL_WMI_AIO
> >=20
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called dell-wmi-aio.
> >=20
> > +config DELL_SMO8800
> > +	tristate "Dell Latitude freefall driver (ACPI
> > SMO8800/SMO8810)" +	depends ON ACPI
>=20
> Lowercase ON.  Not sure how this escaped, Kbuild barfs on it.

I will send new version with some changes from Sonal.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2591801.r1EHKV3grs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlN7GM8ACgkQi/DJPQPkQ1IZRACfdKA/rTZlOdvyEpzZiLXr3ad5
fM0AoKAjlWlJTSUuRN5jgOkvXP9zUeyH
=5n8A
-----END PGP SIGNATURE-----

--nextPart2591801.r1EHKV3grs--
