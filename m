Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3ISWVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:21:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40699 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3ISWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:21:03 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] RX-51: Add missing max_current to rx51_lp5523_led_config
Date: Fri, 20 Sep 2013 00:20:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com> <201309192301.58761@pali> <20130919212922.GA27501@atomide.com>
In-Reply-To: <20130919212922.GA27501@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3701850.WM6TTXiHuD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309200020.58671@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3701850.WM6TTXiHuD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 19 September 2013 23:29:22 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130919 14:10]:
> > On Thursday 19 September 2013 00:26:43 Tony Lindgren wrote:
> > > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130918 15:02]:
> > > > Without max_current data in board file lp5523 driver
> > > > does not change current.
> > >=20
> > > Hmm is this a regression or are there other reasons to
> > > merge this during the -rc cycle?
> >=20
> > I think this is regression,
> > drivers/leds/leds-lp55xx-common.c code refuse to change
> > led_current sysfs attribute if value is higher than
> > max_current specified in board file. And because in board
> > file max_current is not specified it is by default zero as
> > global variable. So changing led_current is not possible
> > because any positive value is more than zero. First I saw
> > this behaviour in 3.10, but I forgot to send this patch.
>=20
> OK thanks, can you please update the patch description with
> that so I can merge it for the -rc cycle? Ideally of course
> with the breaking commit too.
>=20
> Regards,
>=20
> Tony

I do not know which commit broke it. There was some change in lp driver whi=
ch
caused that driver not worked with testing applications. Now it should be f=
ixed.
So I resending my patch with updated description.



RX-51: Add missing max_current to rx51_lp5523_led_config

=46ile drivers/leds/leds-lp55xx-common.c refuse to change led_current sysfs
attribute if value is higher than max_current specified in board file. By d=
efault
global C variables are zero, so changing always failed. This patch adding m=
issing
max_current and setting it to max value 255.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
=2D--
 arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-o=
map2/board-rx51-peripherals.c
index 9326890..d0f857c 100644
=2D-- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -180,38 +180,47 @@ static struct lp55xx_led_config rx51_lp5523_led_confi=
g[] =3D {
 		.name		=3D "lp5523:kb1",
 		.chan_nr	=3D 0,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:kb2",
 		.chan_nr	=3D 1,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:kb3",
 		.chan_nr	=3D 2,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:kb4",
 		.chan_nr	=3D 3,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:b",
 		.chan_nr	=3D 4,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:g",
 		.chan_nr	=3D 5,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:r",
 		.chan_nr	=3D 6,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:kb5",
 		.chan_nr	=3D 7,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}, {
 		.name		=3D "lp5523:kb6",
 		.chan_nr	=3D 8,
 		.led_current	=3D 50,
+		.max_current	=3D 255,
 	}
 };
=20
=2D-=20
1.7.10.4

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3701850.WM6TTXiHuD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI7eMoACgkQi/DJPQPkQ1JUNgCdEaSFwTrG+1DuDwQK8OyAO0K3
OlgAnRfe8y/FnGC3jAbW1G7Qu77eym/d
=oX2V
-----END PGP SIGNATURE-----

--nextPart3701850.WM6TTXiHuD--
