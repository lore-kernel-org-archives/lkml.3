Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaLJHps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:45:48 -0500
Received: from ozlabs.org ([103.22.144.67]:39420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaLJHpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:45:46 -0500
Date: Wed, 10 Dec 2014 18:45:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-ID: <20141210184537.4b0d98dd@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=Hg3UASG/QTphXDBljXbXzC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=Hg3UASG/QTphXDBljXbXzC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
allnoconfig) failed like this:

fs/nsfs.c: In function 'ns_get_path':
fs/nsfs.c:83:2: error: implicit declaration of function 'current_kernel_tim=
e' [-Werror=3Dimplicit-function-declaration]
  inode->i_mtime =3D inode->i_atime =3D inode->i_ctime =3D CURRENT_TIME;
  ^
fs/nsfs.c:83:51: error: incompatible types when assigning to type 'struct t=
imespec' from type 'int'
  inode->i_mtime =3D inode->i_atime =3D inode->i_ctime =3D CURRENT_TIME;
                                                   ^

Caused by commit 87fb64a6c1f7 ("take the targets of /proc/*/ns/*
symlinks to separate fs").

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 10 Dec 2014 18:37:32 +1100
Subject: [PATCH] nsfs: need include/ktime.h and timekeeping.h for CURRENT_T=
IME

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 0791d086804d..7d98db03c2ce 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -3,6 +3,8 @@
 #include <linux/fs.h>
 #include <linux/proc_ns.h>
 #include <linux/magic.h>
+#include <linux/ktime.h>
+#include <linux/timekeeping.h>
=20
 static struct vfsmount *nsfs_mnt;
=20
--=20
2.1.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/=Hg3UASG/QTphXDBljXbXzC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUh/omAAoJEMDTa8Ir7ZwVsKUP/3LPWiK3BOMgKGpPpzUB49JJ
fRUkz28AcuAuj7KtyOq9ninl2iHxcBBc8iElW38WQgdAD8OpgOhMShdknoSKQC8F
IJBSh8pkPlf+6fbR7Ir7Od4EoXoBrG+oSyB9mwusd3TmB7LFWr+NDqIkz9AnRJqJ
jJ0A4WgpU5pUHEVJOKs57Zt+hSOjfokGz5Gv6xXP4hlzQJfapkyCYdlxB7FPcbQk
PDuWO9zBZrFXfmLFNaHgdCHASZP3k+74UExSzpL7K+5emkcT+KCDWLEl5l6I+2lg
DlwCCgpVYZoVpMnGDxG8cRvu6IgSeU95iO+3SvJFB/Fa0pzvZeapvRYpYM10FlJQ
r/1oGwKpxW8ybHyGsM3bpKmkXyaSlstpBXc2TrDHwhgsMJoiln1KMAEnDXIsIEfO
zF7gBuLUwfY0oaufGXiw31fTvIzLHoxcHLAqa8nb7YfCOlPMEQ7fOp5j4q7b+jH7
XUce75cMj4kat+QlTjeOhF9dfQOvV5osl/j1EoPugoyAfDw7nxi5wL9HeFOB72ji
+HhO2K3SsIC+bvdiaKR/pbwJFYGUisT1Ab7T4mWtp7TJy33JczWKWUE0q2de9g5N
gJvF+8iHxjGOaRkfrrbG3n0VEs0uYK1RXutEXjcsLGmMlaJEUNbbTdOmfwuF8PqS
ej+2CsSQa81TWZQ9GBb/
=oNR7
-----END PGP SIGNATURE-----

--Sig_/=Hg3UASG/QTphXDBljXbXzC--
