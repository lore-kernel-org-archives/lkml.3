Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3HVFjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:39:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44558 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3HVFjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:39:53 -0400
Date: Thu, 22 Aug 2013 15:39:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20130822153942.66d098b122092d6944186c53@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Aug_2013_15_39_42_+1000_xu6L31DNtu3aEjw4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Aug_2013_15_39_42_+1000_xu6L31DNtu3aEjw4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/kobject.h:21:0,
                 from include/linux/module.h:16,
                 from drivers/acpi/bgrt.c:11:
drivers/acpi/bgrt.c: In function 'bgrt_init':
drivers/acpi/bgrt.c:89:23: error: 'image_attr' undeclared (first use in thi=
s function)
  sysfs_bin_attr_init(&image_attr);
                       ^
include/linux/sysfs.h:53:3: note: in definition of macro 'sysfs_attr_init'
  (attr)->key =3D &__key;    \
   ^
drivers/acpi/bgrt.c:89:2: note: in expansion of macro 'sysfs_bin_attr_init'
  sysfs_bin_attr_init(&image_attr);
  ^
drivers/acpi/bgrt.c:89:23: note: each undeclared identifier is reported onl=
y once for each function it appears in
  sysfs_bin_attr_init(&image_attr);
                       ^
include/linux/sysfs.h:53:3: note: in definition of macro 'sysfs_attr_init'
  (attr)->key =3D &__key;    \
   ^
drivers/acpi/bgrt.c:89:2: note: in expansion of macro 'sysfs_bin_attr_init'
  sysfs_bin_attr_init(&image_attr);
  ^

Presumably caused by commit 65f44679580d ("ACPI: bgrt: take advantage of
binary sysfs groups").

I have used the driver-core tree from next-20130821 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__22_Aug_2013_15_39_42_+1000_xu6L31DNtu3aEjw4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFaQjAAoJEECxmPOUX5FEJL4P/iVRRqTfywf6uQxiftjXPzkT
edBmxPKBIJTFdpnN+cPbhavAtJj5Hd6SJF7PX+Yr3zdZuGrU0zRz70ucS12lobjz
qLNKD2f5mXrHpcxrRkrh00d5ilBHngCtD7tbB5vSoccVPcS0dZhWmnmLw05U3Muu
tYlHKbNy1NFWnjHtrnOHCv5MME3ydCyAdGlfvcxsU+ghF/aaa6JCZ9/i2omYu5z5
TghwmZdOtFtspqIN5QEQwSc80iBet9f84LosVErEDBIwqyMt5PA6dOruKl6iEduB
pmwtZXrjD4PBrbSGdhn+4i2JLQzknCu/xjWU8lusboujIxfBMAEisxLTlw0dqVHG
bRrBTQwDDoyEGzVQ8hCGkvO8ZfJUbnxa7Nch6CsCD5P1XGr1Bvp1OLouPgK7NNJU
MInLQlsSBT+og5oG2VW6m60AlDwV4I5qlJ47s60zdrYO8yXTIO67i2YSOK6/NiMa
k7nx7Yt5i/Yn2ShBMrZ3NZ7WOUrZGRtXHIDtsk4NWvuRxNZagycQSnioTiYfRt13
8eMfBrtmRn5bfgINSTK/fZ9GQzM9vVEDOTyI7AO5f7pMTmrRoKNdIE9M8YA1HzHd
dcw1rwZuKWKS2PYzzes/AzJMAjFCaQ971zJT4DxlIRiQucIZbtf44s7rZIla1xjr
884ZXfKqN0svGnNKlW3P
=xMWK
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Aug_2013_15_39_42_+1000_xu6L31DNtu3aEjw4--
