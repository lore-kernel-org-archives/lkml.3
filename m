Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaAIOZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:25:23 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:47338 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbaAIOY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:24:59 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Subject: Re: Broken locking in leds-lp5523.c
Date: Thu, 9 Jan 2014 15:24:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.12.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, milo kim <milo.kim@ti.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>
References: <20140107204233.GA22413@amd.pavel.ucw.cz> <CAK5ve-Kk9BuH=56F98aZOgPS+w-=8iF0HtpOYWNjRN8am2Zqjg@mail.gmail.com>
In-Reply-To: <CAK5ve-Kk9BuH=56F98aZOgPS+w-=8iF0HtpOYWNjRN8am2Zqjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2342032.7oLgp7sGUA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201401091524.53417@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2342032.7oLgp7sGUA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 08 January 2014 01:32:15 Bryan Wu wrote:
> On Tue, Jan 7, 2014 at 12:42 PM, Pavel Machek <pavel@ucw.cz>=20
wrote:
> > Hi!
> >=20
> > There's some locking weirdness, and few missing comments in
> > lp5523 driver.
> >=20
> > Now, this is untested patch from my reverse-engineering. I
> > hope I understood things right...
> >=20
> > In particular, there's unbalanced unlock in
> > lp5523_update_program_memory, and
> > lp5523_update_program_memory needs to be protected by the
> > lock.
> >=20
> > Comments? Does someone maintain this?
>=20
> Actually the locking issue was fixed in my for-next branch,
> http://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-led
> s.git/commit/?h=3Dfor-next&id=3D0d70bdb957cde2c25a4b3e4c93d0d33403
> 795be9
>=20
> Thanks,
> -Bryan
>=20

Now, with linus tree lp5523 driver does not work without above=20
commit on Nokia N900 device. I think that commit should go to=20
3.13 and stable... What do you think?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2342032.7oLgp7sGUA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlLOsTUACgkQi/DJPQPkQ1LPMQCgw+1ISSh9sKHacsx9nIQ+esd+
ITIAoIwil0UvJFvkN7Dp+STjDRPG8+Cx
=4WNb
-----END PGP SIGNATURE-----

--nextPart2342032.7oLgp7sGUA--
