Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbaGOGoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:44:01 -0400
Received: from ozlabs.org ([103.22.144.67]:39833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbaGOGn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:43:58 -0400
Date: Tue, 15 Jul 2014 16:43:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Noever <andreas.noever@gmail.com>
Subject: linux-next: manual merge of the char-misc tree with the ia64 tree
Message-ID: <20140715164349.5807b892@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/aecLEYhkRiEar43u.35Gn4o"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aecLEYhkRiEar43u.35Gn4o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got conflicts in
drivers/Kconfig and drivers/Makefile between commit 76ac8275f296
("trace, RAS: Add basic RAS trace event") from the ia64 tree and commit
16603153666d ("thunderbolt: Add initial cactus ridge NHI support") from
the char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Kconfig
index 4e6e66c3c8d6,9b2dcc2ea663..000000000000
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@@ -176,6 -176,6 +176,8 @@@ source "drivers/powercap/Kconfig
 =20
  source "drivers/mcb/Kconfig"
 =20
 +source "drivers/ras/Kconfig"
 +
+ source "drivers/thunderbolt/Kconfig"
+=20
  endmenu
diff --cc drivers/Makefile
index 8a72e1cc2afa,37b9ed4cd2d6..000000000000
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@@ -159,4 -158,4 +159,5 @@@ obj-$(CONFIG_NTB)		+=3D ntb
  obj-$(CONFIG_FMC)		+=3D fmc/
  obj-$(CONFIG_POWERCAP)		+=3D powercap/
  obj-$(CONFIG_MCB)		+=3D mcb/
 +obj-$(CONFIG_RAS)		+=3D ras/
+ obj-$(CONFIG_THUNDERBOLT)	+=3D thunderbolt/

--Sig_/aecLEYhkRiEar43u.35Gn4o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxM2sAAoJEMDTa8Ir7ZwVAigP/A/48YsM7rCg9Xzx+Tn+BGMU
sBjgbU9yUfNRO1oTwz+vXXSUG54X3t3jP9Qrt1V4wNV20aAFQYe6yicI+RooVZJM
27DxrYYhj1+c/IitOfb4wzo5BV4SEaH2Gm3ISZTlmMYTiMKdBCMoIoctQvdK/xVe
KCDrCMtIDZL1gIdARvRzqyzC9WWV+5YQSdusRWpc+1BBXuxvAf7rjh5hEh6VkMPC
YUs+QzaqB/DqxDoQWLnWFsY37ky3wTlNzPmWAWmoV9Ub/EcWZNuyfr9TFnHoLZAU
z/L8Dv1eMqLS0c7R0Tflu4RDypL6ayH5yCv8W1mvgg6rjnF6reKYffe1bFRlAert
kRgOrc9W9ZESeBMNwOH8PCuQ6v/IHTxd5S4dYTvUxYwYzK+dOntqJRs1uxVXccda
6t1umT2lShUSCOGYvZATfdRc57GXL0zqpZIMIuSuuuIdgihubV0+vDnNqFVQ7VC/
73iPGYBdZwZdmHweWRIGc2+XuJrdPChOPthok9GgXMyelFHwdrZlD9oQGUSy7y5I
A/5ioW/GW/qngfYEwHlbN/CqkRSTwugLVF1DroSGyMm8UGq2CdSgfTvqsSIWXRVu
BbijJ3/WT754j2bhj+F6q3XIrkX5ZWBfD4yZj1Yi9SSXrYNUwaG1yX9FN8u2L+lS
WetFN3xDfQBI6Jx0PKEY
=I5ri
-----END PGP SIGNATURE-----

--Sig_/aecLEYhkRiEar43u.35Gn4o--
