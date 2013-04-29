Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3D2Bi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 21:38:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49010 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3D2Bi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 21:38:58 -0400
Date: Mon, 29 Apr 2013 11:38:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20130429113855.777e65f0beee6a99961c51f3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_11_38_55_+1000_7a0t7FKDRnmJiXDs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_11_38_55_+1000_7a0t7FKDRnmJiXDs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
drivers/firmware/efivars.c between commit 0635eb8a54cf ("Move utf16
functions to kernel core and rename") from Linus' tree and commit
a2162ae42bc4 ("Include missing linux/magic.h inclusions") from the vfs
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/firmware/efivars.c
index f4baa11,0f102601..0000000
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@@ -80,7 -80,7 +80,8 @@@
  #include <linux/slab.h>
  #include <linux/pstore.h>
  #include <linux/ctype.h>
 +#include <linux/ucs2_string.h>
+ #include <linux/magic.h>
 =20
  #include <linux/fs.h>
  #include <linux/ramfs.h>

--Signature=_Mon__29_Apr_2013_11_38_55_+1000_7a0t7FKDRnmJiXDs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfc8vAAoJEECxmPOUX5FELDsQAJmsDAH3aOm3fBVWogNtlnLD
YI8qkX8vtJjkok9YPxXJ4c+Y6NwP9sLGq09DaK8dePoxBGpD/Bmi0IskEBUNQ9CU
JizzlZ0v7IYgSratnMQ5UWWhx3gy356rfqWOoP5Eyhu0enOx3sKMa2oGRl67B8dj
qkaxvn0RDaidIXINlZI+z6zW6VLxLlvbTxgFX8eomej8CVVFzOIcxe7ahmqnIl/2
CKJvzm5xtrsGzh/vhXVQtOeE1ndIh0XUbQ4a6ethATSehMjCO4J6TnD2j8VF/C8X
Qtby6nYle4Cz+JtUrDOxDbQ59yyePLmXVP3d5Ru0Spf/W+LwTJ1CdAr+UFYEiy2s
tU+bFmAjWqQbafwJiXjpefSdTxjYI+GQnMMJYnkCBhe+qR508is+QG0uvTXEXzCN
TBO1D/e0MCtZARwn4e16nirPaOviGP1L8lRTTx6+0LahpKNLB3zAMgoylI9Myhnr
TyLuvqYrY2mbQOLhjjXcdBOt+Zn3zxzc3PyyoXvYIZVgBbdJH1TAqYAbe1vXXvdG
1vmBcZzyzq2LJAJ8vCWXesKFsM/3jnDlXWkVARsYxiey4nAO9/Ror7cZfVePb35I
t/AFPpwCvhuusaVNnuRroQXHdaFlz3bHtJ+4sH7xzr7qyTOof5aQYFCJiRfwyIrP
8Rh7XJNQQBV1Gvbhq8Sr
=wJaJ
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_11_38_55_+1000_7a0t7FKDRnmJiXDs--
