Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaKCCb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 21:31:59 -0500
Received: from ozlabs.org ([103.22.144.67]:50215 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbaKCCb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 21:31:57 -0500
Date: Mon, 3 Nov 2014 13:31:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tina Johnson <tinajohnson.1234@gmail.com>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141103133150.456111d8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g1mUJDwzDU.JeXrK+0I8pb8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g1mUJDwzDU.JeXrK+0I8pb8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/lustre/lustre/llite/llite_lib.c between commit
94b5670e78ce ("move d_rcu from overlapping d_child to overlapping
d_alias") from the vfs tree and commit cf29a7b6eae8 ("Staging: lustre:
Fix checkpatch warning: Missing blank line") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/lustre/lustre/llite/llite_lib.c
index 7b6b9e2e0102,afb433a33d25..000000000000
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@@ -709,7 -712,8 +710,8 @@@ void lustre_dump_dentry(struct dentry *
  		return;
 =20
  	list_for_each(tmp, &dentry->d_subdirs) {
 -		struct dentry *d =3D list_entry(tmp, struct dentry, d_u.d_child);
 +		struct dentry *d =3D list_entry(tmp, struct dentry, d_child);
+=20
  		lustre_dump_dentry(d, recur - 1);
  	}
  }

--Sig_/g1mUJDwzDU.JeXrK+0I8pb8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUVukbAAoJEMDTa8Ir7ZwVhRQP/1Rw9HDCnWfoo1+tLgktlskZ
f/o3zviEkXJynGx94W1raxGUxiupIxxoq+DOQm1axVyud4NPGCgdybsGPqatKfp7
HWxpxvawq83zgp1Ud6YH2evsktowGGNruWIODbxRqtZI+y6FoLYZ3sCH4jkMB6Mw
P1BUexotNyHTPw8UwM/9HDOQwF+i90KMyJA3Wj3j0AkS33lvyVWQXroOD9zCwyPs
nvrLEHquBTrTu8wkLTcjnfuJoSE8ECjBOUEIIH0wiWwiFgHnAexeBcEN0WozSx0u
gu9zB+Nmp5UIVcllGHFAxjQZneBNoi9xuL3aqzJu7QoR56FtQGUx5TVMQHKEiEyr
fTUEtvvdlCmXFy4yDRekHijqACeHuzlR/8Pyc7OSxtDGQgJTjxaScJsLKVr4uvbU
XGG9mk32+S5xnQemPcnaymdMWa8aKQ3hgvIR528dvIQHlZBwR/XL2qLTB7PVcgX2
l2rAI3bDv8W3ejtU12k8CXDimRMeo/s5DT06qch6hQWvjgujU3gU5aWHBz9cotZZ
5W9At+l3d+ikWLtMTNI1Q9vZBSgA7S9QG8rD+PabDgyx/nnJNKqdxMZblqZR8BhP
sfCDaAAUYB1l0SrBQQcaY4UIYK2e2D1PAdfgcU1QwzweyCgcK59H07Tjxwc8O5Z3
AQ14PvlSrL7+3bIg3ndi
=khwI
-----END PGP SIGNATURE-----

--Sig_/g1mUJDwzDU.JeXrK+0I8pb8--
