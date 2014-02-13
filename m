Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaBMCTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:19:31 -0500
Received: from ozlabs.org ([203.10.76.45]:35084 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaBMCT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:19:29 -0500
Date: Thu, 13 Feb 2014 13:19:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140213131923.4a0b79959e0b27399c021aa7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Feb_2014_13_19_23_+1100_MEyXkd/Q2jO4U.GM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Feb_2014_13_19_23_+1100_MEyXkd/Q2jO4U.GM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/rtl8821ae/rc.c:289:2: error: unknown field 'module' specifi=
ed in initializer
  .module =3D NULL,
  ^

Caused by commit cc01f9b55fe7 ("mac80211: remove module handling from
rate control ops") interacting with commit 3c05bedb5fef ("Staging:
rtl8812ae: Add Realtek 8821 PCI WIFI driver") which entered Linus' tree
before v3.14-rc1.

I added this merge fix patch and can carry it as necessary (John, if you
back merge v3.14-rc1, you should include this patch in the merge commit):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 13 Feb 2014 13:14:13 +1100
Subject: [PATCH] Staging: rtl8812ae: remove modules field of rate_control_o=
ps

This has been removed in further work.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/rtl8821ae/rc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rc.c b/drivers/staging/rtl8821ae/rc.c
index d387f13ea7dc..0cc32c60ddee 100644
--- a/drivers/staging/rtl8821ae/rc.c
+++ b/drivers/staging/rtl8821ae/rc.c
@@ -286,7 +286,6 @@ static void rtl_rate_free_sta(void *rtlpriv,
 }
=20
 static struct rate_control_ops rtl_rate_ops =3D {
-	.module =3D NULL,
 	.name =3D "rtl_rc",
 	.alloc =3D rtl_rate_alloc,
 	.free =3D rtl_rate_free,
--=20
1.9.rc1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Feb_2014_13_19_23_+1100_MEyXkd/Q2jO4U.GM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/CuvAAoJEMDTa8Ir7ZwVLS0QAIMxpGT3FT9j1dl/Le1g5Ieu
6Qt/7NKTGyFuS9U10AlhU9AKZvUIRalgXbccBXnGdXr1FG5BNdP6H0Soqg5xCAah
C5i/qq3bLt1Yq+1HDifKGjDtnMmrgbwyGzqjC1M1WvlxjRMvYs0HfVxpbXkOn+jb
Ya4J+/5h5PwNMV0CS1kCDyuwaK1h7necdkZ22Wp6oH/htfu/fC2y7uAkXLdIMJD2
F8uUMPEZNmQcXxM5NNdBULHcTr5ydB1RFp+bljwueBKx65/lkA0O2egxKLfANlTU
p8Pk3eecjr3dgN0NRsGHDy+/noKzl3rqXk+wqfmOo+IDYLa8No+v6PDasCbWNOST
xF/pVzcJVmsOIaR3d9Xy9zB0TK7HyCSifDgT0dsppqN5/N4cp133sAXXqcPjkbw2
As5Ybg4HrC7yJe5jSdBZVRc6mD3iL7X5E5m50B8/Vbjg+sILnVmsasxK4jVYUMZn
JvoXQcfsDnfbM38Bu6zcRa/bLP0vuLkquuJ5p5NePGfdMnJ7PBaCOpQ7OW7gBO03
NsaPld/UvR+2+r/wNc12uQKrMhACGmBOIJORw0Klx0u1dM/Olhyobig7wVWP6HZV
qYGBWrjt19jRWbvoj5oePFOT0gj59mMSSoYLKlWy8C3NJZy1Uf8pBZvsAPp/b90X
j9iYFeoL6BLFns+8cVZO
=mVXd
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Feb_2014_13_19_23_+1100_MEyXkd/Q2jO4U.GM--
