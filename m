Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3CTEUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:20:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48393 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3CTEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:20:19 -0400
Date: Wed, 20 Mar 2013 15:20:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the akpm tree with the char-misc tree
Message-Id: <20130320152007.56de4a48eaf2760ccc07f02b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Mar_2013_15_20_07_+1100_OSPkR6SmVSmodvUy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Mar_2013_15_20_07_+1100_OSPkR6SmVSmodvUy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/hyperv.h between commit 96dd86fa5881 ("Drivers: hv: Add a
new driver to support host initiated backup") from the char-misc  tree
and commit "drivers/video: add Hyper-V Synthetic Video Frame Buffer
Driver" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/hyperv.h
index 95d0850,a460ee4..0000000
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@@ -1310,13 -1253,16 +1310,25 @@@ void vmbus_driver_unregister(struct hv_
  		}
 =20
  /*
 + * VSS (Backup/Restore) GUID
 + */
 +#define HV_VSS_GUID \
 +	.guid =3D { \
 +			0x29, 0x2e, 0xfa, 0x35, 0x23, 0xea, 0x36, 0x42, \
 +			0x96, 0xae, 0x3a, 0x6e, 0xba, 0xcb, 0xa4,  0x40 \
 +		}
++
++/*
+  * Synthetic Video GUID
+  * {DA0A7802-E377-4aac-8E77-0558EB1073F8}
+  */
+ #define HV_SYNTHVID_GUID \
+ 	.guid =3D { \
+ 			0x02, 0x78, 0x0a, 0xda, 0x77, 0xe3, 0xac, 0x4a, \
+ 			0x8e, 0x77, 0x05, 0x58, 0xeb, 0x10, 0x73, 0xf8 \
+ 		}
+=20
+=20
  /*
   * Common header for Hyper-V ICs
   */

--Signature=_Wed__20_Mar_2013_15_20_07_+1100_OSPkR6SmVSmodvUy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSTj3AAoJEECxmPOUX5FEiTwP/iIaByM5dKpdkjodf2kV55GK
MUN0fMijC9e+pa1v0w+L3dJ1VygI6TgKWbdeCfvRb8LBozGQZu3/z87+chorf9up
R+fmbtDTXnbEX6ZvTKu/POCzqztgupuSbiwXcJ4XAtEfPtKdAC/FYcgfonbl/beA
4elqx2mt+7ZxPJ7iEghDkrhJVh+on8bHwH+YL+8VPTojWgVLlSPUxd3CmKz+nn2f
dSeH9Qki2vwMoFD6CIg1jLM5xVoWeYb5T+bDHVvjhZ9VHOQC8/Y3HpgTnXl0nBAY
YBFl9EgzNag+AuTs9Z0PtXIq7FLHCHO9kPEph9kqXp/oj6Kw0ngtbQsgPbQcveid
cgnofy/CIRmN9O/txVldgixnnAw67tWKlIcHa/GfubAGDuLDyASkyhwoEPLA3qa1
Kaju23kYxtSlwoa8RUOtH/MG65Z0RjzfPoLU7rNdTzEPgqPSBmrmdZKSSMNQdHG5
ZqqgQ1ScrC0UiXuXESxBQkAVBuPOeqBSE6bqKTIf7qznFgsnmrSGS4stALQKcXXB
h/G3G2DYhGLF7CCuEgSx5eTiJ2nDo8ACwvjwD/bAxenhLJTt3R2XRAwQnhlz94zd
MYdE+mN+X382u6u9hjdDEQHIJfc7jzWqSIY2oykAgbO+WRQN2zFBF+L4PWReEapG
R13tM1zu5o3jFnaYBgcP
=d5Tu
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Mar_2013_15_20_07_+1100_OSPkR6SmVSmodvUy--
