Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3GPF1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:27:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45621 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3GPF1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:27:39 -0400
Date: Tue, 16 Jul 2013 15:27:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: linux-next: manual merge of the cpuinit tree with the hwmon-staging
 tree
Message-Id: <20130716152737.507bc6f1cc7cfe069e97d245@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_15_27_37_+1000_TEPZD7NVcAZdMmPv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_15_27_37_+1000_TEPZD7NVcAZdMmPv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the cpuinit tree got a conflict in
drivers/hwmon/coretemp.c between commit cc58db361386 ("hwmon: (coretemp)
Atom CPUs don't support TjMax; no warning needed") from the hwmon-staging
tree and commit "hwmon: delete __cpuinit usage from all hwmon files" from
the cpuinit tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hwmon/coretemp.c
index be58da1,2e5e2dc..0000000
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@@ -317,20 -316,7 +316,19 @@@ static int adjust_tjmax(struct cpuinfo_
  	return tjmax;
  }
 =20
 +static bool cpu_has_tjmax(struct cpuinfo_x86 *c)
 +{
 +	u8 model =3D c->x86_model;
 +
 +	return model > 0xe &&
 +	       model !=3D 0x1c &&
 +	       model !=3D 0x26 &&
 +	       model !=3D 0x27 &&
 +	       model !=3D 0x35 &&
 +	       model !=3D 0x36;
 +}
 +
- static int __cpuinit get_tjmax(struct cpuinfo_x86 *c, u32 id,
- 			       struct device *dev)
+ static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
  {
  	int err;
  	u32 eax, edx;

--Signature=_Tue__16_Jul_2013_15_27_37_+1000_TEPZD7NVcAZdMmPv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5NnJAAoJEECxmPOUX5FEjnIQAJNVhb4iQOS5tKaBoeNi7YpP
pkuToIzImCUeB96/iZ6tsBxU6h4bA7Q/syo7AXBreF7MJ9gYjU11hLVJ2h9LedH+
QcgBWQO8wg6bobWSkn1OzlpSeZpaTLKzy2y1wTS3E3EJe4O9rj7H9QLjjcKpZxbd
AUwx/pVlPwy8zH7WuNA6Y+sAOJHz+wVUXObtHzn14zuuouyF+4xSwXrw1UWQ1pK5
/KnI9NLEZMhAvNtYbu0EPcJDwCfw1p0xJm0O/CM+X9sLodVz/nF3d7/X2Ka64X1+
amWg+KWDxWGqVmLZ2tQaxHvNT5YCWZTCzO5rDz99Kqal6zfjFXpkOZ+Mmx2bY/BF
O3Q03GFq4B0zQ0pinszuxvEufuZmxAx9612gPdriUxnITfkZ0L3mnikWNeml9/Ym
AmssRzhgsX68igwOV+fXSq05M9XCMkOIyx82FM3uEBPS+hvZy9A/u/rtNzUYneBr
tlkLFCaXg8/Mcg8qyDGugha+xU1v5D5oPq3TjWbIvaIJBGs6P/KDv5Tn6BQOUdaA
SHZUcAgM7LXX7Th8+fEkQePl23QQaKfMpHC6yrcom9WQ3QD7ob8yAyD08wNPxQSZ
MQRnWGXkyilLywkO/xt2yTeM6diibESdMmp4FuZjInQ3IZOqWTH4+9K4SI/uJzRF
jpuW5S3YV5XZNUoLIwiG
=EPL+
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_15_27_37_+1000_TEPZD7NVcAZdMmPv--
