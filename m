Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaLAHtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:49:46 -0500
Received: from ozlabs.org ([103.22.144.67]:54552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaLAHtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:49:45 -0500
Date: Mon, 1 Dec 2014 18:49:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the driver-core tree
Message-ID: <20141201184939.69c44428@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bSFSZ+AZryAMRNci/fHXRzU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bSFSZ+AZryAMRNci/fHXRzU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

fs/debugfs/file.c:797:16: error: conflicting types for 'debugfs_create_devm=
_seqfile'
 struct dentry *debugfs_create_devm_seqfile(struct device *dev, const char =
*name,
                ^
In file included from fs/debugfs/file.c:21:0:
include/linux/debugfs.h:102:16: note: previous declaration of 'debugfs_crea=
te_devm_seqfile' was here
 struct dentry *debugfs_create_devm_seqfile(struct device *dev, const char =
*name,
                ^

Caused by commit 98210b7f73f1 ("debugfs: add helper function to create
device related seq_file") but I am not sure how ... it seems to be
related to the warning I reported earlier as the following patch fixes
it (and the warnings).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Dec 2014 18:42:52 +1100
Subject: [PATCH] debugfs: predeclare struct device

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/debugfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index d145287c0e44..37b17d95d648 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -21,6 +21,7 @@
 #include <linux/types.h>
=20
 struct file_operations;
+struct device;
=20
 struct debugfs_blob_wrapper {
 	void *data;
--=20
2.1.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/bSFSZ+AZryAMRNci/fHXRzU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUfB2XAAoJEMDTa8Ir7ZwVHHEP/2P9+oTZnSDC9tuMqHbw+BN4
NO4g1xSddDWKDLEDOM9Vut5n43UNX13bN6xQObPjl6oxPS9dIKKWduq16VZ9vnL4
KoITY86chfIWuTCD7NPFPSTED0Zyv04goaEWSpaWEZipMYafeIdql82x36/1IEsV
wq+DNc/B+8peVvmLiL+qbXbb6eO+v9rBOy4w6OcnU3tzchP1Sk3IHHEEJ4Sm5DOw
J8COeJ6WqRkhIEpSio3KBh5cyMFZ2Y4D9/ZzoMQCTf5ddQekCZWfKwdWbwSH43Yb
9NdHR89ztz0YhXKTR6xLtFUzw4f+SKzbvkslODVf0u0SlwjOwdv65wpyRhq9nxmV
dlCMuXuBzxs3X1cvxq8gAuueiLhDZ2ErboDDmQfR1OMSRjxean3L7gG7KA0F6tBb
bm8+F9NlPClvXMJGEbeZGasoFcgOyrNCpse0kF1yQFwDfpberTceQJwyGDCVrz/O
sn6atHpyX8ktMV0ixR699UuaX/QjmhKLl779BefPuKZdzn1ZiUfuR9MLzlBFFOkj
onQpCPA8VI4+7w3O4HA3jsfdAlB6bw1RhTqv8QB/opjfQVJBF1OrMIdkh5SS7qGl
R9T6c5UW/UIQgWDn0HM2xNYclyZERlNQ/V+Gg6dcTrG5xqz3SgE13yafjwd6nYhA
naPLE2m55r0B8E4V93by
=yMV8
-----END PGP SIGNATURE-----

--Sig_/bSFSZ+AZryAMRNci/fHXRzU--
