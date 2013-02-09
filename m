Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3BILCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 06:02:22 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37992 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab3BILCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 06:02:20 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH] bq27x00_battery: Fix reporting battery temperature
Date: Sat, 9 Feb 2013 12:02:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-23-generic; KDE/4.9.4; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com> <201302061856.35366@pali> <20130209015718.GA13561@lizard.sbx05663.mountca.wayport.net>
In-Reply-To: <20130209015718.GA13561@lizard.sbx05663.mountca.wayport.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1413886.p5mlmc2fRI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302091202.16019@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1413886.p5mlmc2fRI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 09 February 2013 02:57:18 Anton Vorontsov wrote:
>=20
> Hm. The documentation says tenth (1/10) degrees, and you even
> restate it in the commit message. But the subject, and your
> example seem to prove that you still report it in 1/100 of
> Celsius.
>=20
> Unless your phone was on fire during the time you took the
> values, I tend to think the patch needs to be fixed. :-)
>=20
> Thanks,
> Anton
>=20

Ah, my mistake. I very quicky looked that bq and rx driver
reporting different values... But bad conversation is in
rx51_battery driver, not in bq. So drop previous bq patch...

Here is patch for rx51_battery. I think now it should report
correct temperature. On Nokia N900 it reporting: POWER_SUPPLY_TEMP=3D350

=46rom 92efbf24ac2fdc7af41abb12afd5e8c319479f6b Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Pali=3D20Roh=3DC3=3DA1r?=3D <pali.rohar@gmail.com>
Date: Sat, 9 Feb 2013 11:06:48 +0100
Subject: [PATCH] =3D?UTF-8?q?rx51=3D5Fbattery:=3D20Fix=3D20reporting=3D20te=
mperature=3D20?=3D
 =3D?UTF-8?q?(in=3D201/10=3D20=3DC2=3DB0C)?=3D
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

=2D--
 drivers/power/rx51_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
index 8208888..527d256 100644
=2D-- a/drivers/power/rx51_battery.c
+++ b/drivers/power/rx51_battery.c
@@ -119,7 +119,7 @@ static int rx51_battery_read_temperature(struct rx51_de=
vice_info *di)
=20
 	/* First check for temperature in first direct table */
 	if (raw < ARRAY_SIZE(rx51_temp_table1))
=2D		return rx51_temp_table1[raw] * 100;
+		return rx51_temp_table1[raw] * 10;
=20
 	/* Binary search RAW value in second inverse table */
 	while (max - min > 1) {
@@ -132,7 +132,7 @@ static int rx51_battery_read_temperature(struct rx51_de=
vice_info *di)
 			break;
 	}
=20
=2D	return (rx51_temp_table2_first - min) * 100;
+	return (rx51_temp_table2_first - min) * 10;
 }
=20
 /*
=2D-=20
1.7.10.4

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1413886.p5mlmc2fRI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlEWLLcACgkQi/DJPQPkQ1IUDACfdoB1KVrPexgnUI4FQxQWTwqb
1JEAoJ3hoYjHcKbp8FTGm5GGUGEkRwam
=HKx5
-----END PGP SIGNATURE-----

--nextPart1413886.p5mlmc2fRI--
