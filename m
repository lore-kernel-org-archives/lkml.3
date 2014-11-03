Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaKCCkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 21:40:06 -0500
Received: from ozlabs.org ([103.22.144.67]:45948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbaKCCkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 21:40:02 -0500
Date: Mon, 3 Nov 2014 13:39:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141103133953.3da4c209@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WeHpU=LiocUqgzo0H5LKs7M"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WeHpU=LiocUqgzo0H5LKs7M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/lustre/lustre/llite/namei.c between commits 8da673df2d77
("ll_get_child_fid(): callers already have the child") and  ("kill
ll_unlink_generic()") from the vfs tree and commit 2a80f844158b
("Staging: lustre: llite: Declare ptr args correctly") from the staging
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/lustre/lustre/llite/namei.c
index 8e926b385a60,2971a26370be..000000000000
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@@ -974,7 -1103,8 +974,7 @@@ out
   * Instead, ll_ddelete() and ll_d_iput() will update it based upon if the=
re
   * is any lock existing. They will recycle dentries and inodes based upon=
 locks
   * too. b=3D20433 */
- static int ll_unlink(struct inode * dir, struct dentry *dentry)
 -static int ll_unlink_generic(struct inode *dir, struct dentry *dparent,
 -			     struct dentry *dchild, struct qstr *name)
++static int ll_unlink(struct inode *dir, struct dentry *dentry)
  {
  	struct ptlrpc_request *request =3D NULL;
  	struct md_op_data *op_data;

--Sig_/WeHpU=LiocUqgzo0H5LKs7M
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUVur/AAoJEMDTa8Ir7ZwVhpoQAJUuN5S6Rm2oE81Dvz+KMRjP
p7nu7QAg8Qc+5N/0RxPNG9ZDnmDFgx8Pukdor5/uoLT3jaf3P55P9vBlW9u2+eHy
0xVvIamOlNviMqXzVrH0OGCsv4CbyFDGk5wCYyzJIl0wsybi+bgiYqLOHEp+Re8F
ZVzSrGqNgyCSajHajjZ9/g+GnHL+vmdjE1MulfLlcMXXN7ckbh6u110RqF1BLTaa
8Yplgi3yloX2uTzekrAZJwRwBXLDu923PJyuT3ZTYElRZ7ClKZ4Um+ERmrWedibR
yOM4TQme/l5PpqHBYnOQrdd9wl4jxyU3D9rF7rtOo8asiUXOiE/CrJQvfBWUs7OJ
2CIqkhnrIg7q+pQlnRJ+IX6saiaZTYDziZ1C9vRozPERaYDPVsWmY/296/CozKSJ
oIyEBp9NTKPTAFSGgmXPW/FyA3unDkmk31zvszAunmfcf9cDCJKQ+CBckctEg9iC
gIARDbLUnwWOsO03prg3C7pgPDhRCsBcDyXQ8Oj/13AH51guV5NaqRS+xUjkPujk
HnNiUZYjl9Ag1VRnDPh3VSd9gHu2B1L5LS4t9wId+VbALx+7Z/kCJkBFaJNqYYv6
jlKtNbs6aBGYePi1mMf3SWA0Q9xXaDAS6fCnwGay8ZaCo98mqBjWA8+wh/ZNSI+k
+huyvO99+6zLFCuUuCjk
=RVNN
-----END PGP SIGNATURE-----

--Sig_/WeHpU=LiocUqgzo0H5LKs7M--
