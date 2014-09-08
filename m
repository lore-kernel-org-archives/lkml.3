Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaIHInE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:43:04 -0400
Received: from ozlabs.org ([103.22.144.67]:47885 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaIHInA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:43:00 -0400
Date: Mon, 8 Sep 2014 18:42:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jade Bilkey <herself@thefumon.com>, Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Brown <broonie@kernel.org>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-ID: <20140908184253.74ff5470@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GSXtvqE015B/HL/RWWbr6=3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GSXtvqE015B/HL/RWWbr6=3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/ath/ath5k/debug.c: In function 'open_file_eeprom':
drivers/net/wireless/ath/ath5k/debug.c:933:2: error: implicit declaration o=
f function 'vmalloc' [-Werror=3Dimplicit-function-declaration]
  buf =3D vmalloc(eesize);
  ^
drivers/net/wireless/ath/ath5k/debug.c:933:6: warning: assignment makes poi=
nter from integer without a cast
  buf =3D vmalloc(eesize);
      ^
drivers/net/wireless/ath/ath5k/debug.c:960:2: error: implicit declaration o=
f function 'vfree' [-Werror=3Dimplicit-function-declaration]
  vfree(buf);
  ^

Caused by commit db906eb2101b ("ath5k: added debugfs file for dumping
eeprom").  Also reported by Guenter Roeck.

I have used Geert Uytterhoeven's suggested fix of including vmalloc.h
and so added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Sep 2014 18:39:23 +1000
Subject: [PATCH] ath5k: fix debugfs addition

Reported-by: Guenter Roeck <linux@roeck-us.net>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ath5k/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/=
ath/ath5k/debug.c
index 30e4e1fd4b04..399728618fb9 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -62,6 +62,7 @@
=20
 #include <linux/export.h>
 #include <linux/moduleparam.h>
+#include <linux/vmalloc.h>
=20
 #include <linux/seq_file.h>
 #include <linux/list.h>
--=20
2.1.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/GSXtvqE015B/HL/RWWbr6=3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDWwRAAoJEMDTa8Ir7ZwVO5sP/RamhCBC8S+fpfgmqs2Td4dZ
MKCJvuWO07XItTeVJyHhTWCJ660Pn7RK5z2mIH6kZvaACDIoMbq92Ovu0BLs3PaQ
jKS4wub6l0E2DFARi+av/usv2/z9e/jNjK9IC5+03XW65+nH2t2mCLdEQ7a9omKB
bea3E6fnvEo9mdaqt7uIWI4mhBlYy42okDGxhN2DV0fllu+lHM++knBIJK2UMxBx
QD9NGd6VtKib/BmO9JZXlkM5neU9b5jCMJbe1LWwSmXq96poQ9MTwTLf2ObhavNi
K1Fffdk/UDkUFogPU3IIc0VEckK23r/VNpz2vyENcyMCedGM2RSOFfjJD6WdtRnE
SqZtltVyh+xsE7jnp/6yKBNQizWP+a+KF8o8Yu6EhJWXcxr5ShZtBt9jwnYD55X7
CvPrUJWQ/w+Ru1YBCt508x6tC8pXws+9ESKoaZ8EoSkcgIP4vo2GRFwJpNlxHHx0
ZQC1wMtZ03XSH4rgApWMGmrkWGZzQ8KHiixgcyTjOUBBiYIVqn7bm/wP0horm/K1
LpqPooSuZXrRlgc99GSjC8ts0xMiH5NQ7SZ0o7fri52EQHTcJMKF8AhAzDDGQoMi
DLRuVUfo1AtG69yMnvsuHVAzK2+ePV2FIEeli1WIh/Ssna+8o45BF/Txp/SXkuOj
vrwripzW0nCEWBV7nCoL
=g0Bl
-----END PGP SIGNATURE-----

--Sig_/GSXtvqE015B/HL/RWWbr6=3--
