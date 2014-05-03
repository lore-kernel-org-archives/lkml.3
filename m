Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaECXQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 19:16:04 -0400
Received: from mout.gmx.net ([212.227.15.19]:56959 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbaECXQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 19:16:02 -0400
Date: Sun, 4 May 2014 01:15:49 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: john.stultz@linaro.org, serban.constantinescu@arm.com, arve@android.com,
        ccross@android.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: binder: fix usage of uninit scalar in
 binder_transaction()
Message-ID: <20140504011549.04805208@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SxYTrB_k9A+pA+e8wyu1clw"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:1+XiBk8wI5zTBDVi6+72ZRvsjurI1EWnQWcoj9DXCLB7etS4TkA
 i/EgqxR+83jOLbzhOlljC/c4H0Xc3sBeRygjAn+pH/mAdIIkyZ4u8JHGBOCsLdwrChi/F5U
 qibEOq7G+WmPcsa2jTP4XrFKHOHsQ9D/LboYJkXrpC5TY9l1nI7PDYBECNWls/GEYez8Tiu
 QCHl8ih3WdBIcJNT1rbpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SxYTrB_k9A+pA+e8wyu1clw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix the error path when a cookie mismatch is detected. In that case the
function jumps to the exit label without setting the uninitialized, local
variable 'return_error'. Detected by Coverity - CID 201453.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/android/binder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/bin=
der.c
index 1f5e249..ca1b0e3 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1529,6 +1529,7 @@ static void binder_transaction(struct binder_proc *pr=
oc,
 					proc->pid, thread->pid,
 					(u64)fp->binder, node->debug_id,
 					(u64)fp->cookie, (u64)node->cookie);
+				return_error =3D BR_FAILED_REPLY;
 				goto err_binder_get_ref_for_node_failed;
 			}
 			ref =3D binder_get_ref_for_node(target_proc, node);
--=20
1.9.1

--Sig_/SxYTrB_k9A+pA+e8wyu1clw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTZXilAAoJEKssnEpaPQKEIO0P/1xO0j58e7Wq7+R9TC5vWxBQ
IHK+66/78iPP2t5eVAN5iouY/qtCL+6TakVs1Z7NyI+kmbw2Ehckv7sxD5IhQafP
niGWm5HOLs4Q2CYnQkAMZpKuRU8GdrSphDesW/aQRYkwxjAm+32BmLY9Ses3itHc
S9gQBTLutktnofNy9LXlqDGUhg/eUxCzZl5XmGbc4iwRjAeAw2UYkEo5Kzwxx6Pr
T8gRjxdl5n0AhVgPDAbfffz0D+2GZdIgPLvgKjd5FyWafvs0vjQyLl3kWhZ5bBmM
DrwDFMGBwF9vo997iOrKbDB9aIdpiGdZw/S3roFFq/OrSXrsVpL385MvbVrd2sfA
Ob4E9B544c4+Jw784CuaA2WOKWS32JAITeo5T2Gbvzqejoqlv4PkyyEV0vAyX/Mz
nouv5ez6crJOxasxXILWfDD/zNWvI1mQD9e5uq50IaqcTssfEsl2pFLPdct87SrI
j3meKL3vfoSccfvWXe3CZ9wISdplmeZdtQBvocNKryzLnwn2E/0ZWB/WjMRZxVKI
0vMQpbBv+eIb48SB8SrAm3ucCeuzg1vZHbHB3Obh9zwnqAjXz7O21NrMLV4HlFOQ
Azha0IFjpJ05lwo+Rn/sNzmVaNscQyLiVmUKDjcJ0uGLRp4sZoNhQhtUQY4laRpP
o27LXBnO7caWLCnEOd9e
=tLPu
-----END PGP SIGNATURE-----

--Sig_/SxYTrB_k9A+pA+e8wyu1clw--
