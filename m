Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3DOFVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:21:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49713 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3DOFVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:21:16 -0400
Date: Mon, 15 Apr 2013 15:21:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the akpm tree with the staging tree
Message-Id: <20130415152105.c658ed6f5ce2140b1034beca@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Apr_2013_15_21_05_+1000_YWtygs=i2O81SYCj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Apr_2013_15_21_05_+1000_YWtygs=i2O81SYCj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/staging/zcache/ramster/ramster.c between commit df735543008f
("staging: ramster: Move debugfs code out of ramster.c file") from the
staging tree and commit "staging: zcache: enable ramster to be
built/loaded as a module" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/zcache/ramster/ramster.c
index 8781627,3ead248..0000000
--- a/drivers/staging/zcache/ramster/ramster.c
+++ b/drivers/staging/zcache/ramster/ramster.c
diff --git a/drivers/staging/zcache/ramster/debug.c b/drivers/staging/zcach=
e/ramster/debug.c
index bf34133..327e4f0 100644
--- a/drivers/staging/zcache/ramster/debug.c
+++ b/drivers/staging/zcache/ramster/debug.c
@@ -43,7 +43,7 @@ static struct debug_entry {
 };
 #undef ATTR
=20
-int __init ramster_debugfs_init(void)
+int ramster_debugfs_init(void)
 {
 	int i;
 	struct dentry *root =3D debugfs_create_dir("ramster", NULL);

--Signature=_Mon__15_Apr_2013_15_21_05_+1000_YWtygs=i2O81SYCj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRa45BAAoJEECxmPOUX5FEDioP+wduwFUTIaXYCdNMf+SI/9Ki
WEFC8QBWyLiWkdlKKcWYxqpU1uI6aQS+cp+zj9KEXYFrsZtaKBI5w3Dz6IsMC28z
kBo+eAerlSDb5Emh5qj7MX/7j6OaT9X8+vqvjKMzdqxRF4LdvmuTGErdDkiPNjoE
Bz9XOfP9y5GjcFFB+UxFHTx26yMTq0Xe2HbOOwV+mxzfiPJMMx3QgSMGyT4V68A5
rcz94anAWCsLhOY9Fav27hA4lVzP8/E7lkKN7oYAAnHoksBhbcTVGVtcIcUH9PQJ
BzMSrd8isxB84+msmiove1xc5+gOf0hSLU9bMmvzbz3KTokKz5xndniSlrJP0PdD
6nR2YD2OZOyMZJMmVJnUosyadjSVdkqhdVZGdHRGXcDYhsiaeqcH724pGpGmn223
MBqosrcxBfxunoOihrBjqPPujKbh8whSQ3TaolLPgQ24PZoF1sy1U3loHfw2FAqQ
mUQNpnSJxgL3vlbUY+Z/V416XveD1uHxC58V8n2HSFy+01ql7GhSFq2de5kZ6aHv
+JaYr7PjJLEOB9WL/GYDjCEgGyoBIxooWVk/tcoO0nU8Ckz+sgkfFqRQ6F0LadIm
9JAnHxPdX8PEr0YyF96US8g70b/qHLA+ZMG56vnmDpTiMgOV/hI+roWuSGTNjV7v
jN39JpjCxl9pUtPF+H5J
=ONPV
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Apr_2013_15_21_05_+1000_YWtygs=i2O81SYCj--
