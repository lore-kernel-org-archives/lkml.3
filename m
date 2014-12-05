Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbaLECDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:03:54 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59595 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbaLECDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:03:52 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Fri, 5 Dec 2014 03:03:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <1416754245-15550-1-git-send-email-pali.rohar@gmail.com> <20141203084319.GA52608@vmdeb7>
In-Reply-To: <20141203084319.GA52608@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3027145.38HYxrhLTQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412050303.49206@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3027145.38HYxrhLTQ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 09:43:21 Darren Hart wrote:
> On Sun, Nov 23, 2014 at 03:50:45PM +0100, Pali Roh=C3=A1r wrote:
> > This patch adds support for configuring keyboard backlight
> > settings on supported Dell laptops. It exports kernel leds
> > interface and uses Dell SMBIOS tokens or keyboard class
> > interface.
> >=20
> > With this patch it is possible to set:
> > * keyboard backlight level
> > * timeout after which will be backlight automatically turned
> > off * input activity triggers (keyboard, touchpad, mouse)
> > which enable backlight * ambient light settings
> >=20
> > Settings are exported via sysfs:
> > /sys/class/leds/dell::kbd_backlight/
> >=20
> > Code is based on newly released documentation by Dell in
> > libsmbios project.
>=20
> Hi Pali,
>=20
> I would really like to see this broken up. Possibly adding
> levels and timeouts as separate patches for example. It is
> quite difficult to review this all at once in a reasonable
> amount of time.
>=20

It is really hard to split this patch into more parts which every=20
one will compile and ideally also work. In my opinion every=20
single git commit should be possible to compile and should also=20
work (it helps also other developers to use git bisect).

And because we need to pass all (previous unchanged) values in=20
smbios call we need to parse all of them.

I understand that it could be hard to review long patch, but=20
there are more parts which interacts and do not work without=20
other. Also some of settings (e.g keyboard backlight level) could=20
be changed via different ways (and on some machines only one is=20
working) and also that smbios keyboard interface has complicated=20
logic...

> During this review I caught a few more CodingStyle violations,
> and raised some questions about the timeout and levels
> mechanisms.
>=20

I will fix style problems in next v3 patch.
=20
What to do with Dan Carpenter patch which fixing kbd_timeout=20
handling? Should I integrate it into v3? It does not apply on top=20
of next v3 patch, because there will be new comment about quirk=20
plus style fixes...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3027145.38HYxrhLTQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSBEoUACgkQi/DJPQPkQ1JnbgCfbKF4MKaaCMH3KxWEn+1ARZ/i
9ckAn07cmIRQOnX4OIc3nalixsjVzQDj
=CQXl
-----END PGP SIGNATURE-----

--nextPart3027145.38HYxrhLTQ--
