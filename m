Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaBKAbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:31:43 -0500
Received: from mout.gmx.net ([212.227.15.15]:51233 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbaBKAbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:31:35 -0500
Date: Tue, 11 Feb 2014 01:22:18 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-fsdevel@vger.kernel.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fs: ufs: Remove unused ufs_super_block_first pointer
Message-ID: <20140211012218.2f0713f4@spike>
In-Reply-To: <20140211012012.6384d52f@spike>
References: <20140211012012.6384d52f@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L/QjZJM=A86Ps5wUInQqcLJ"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:q3wKYFfwKzK98ZvYn3RD2OAENvEaCM0wn9w92ZZDF+H33N9AdWa
 xiQn4hOXS4OwQ2ZHDRIgHZCgj1kAfos+d4FLDMKPh/5GNC7HbL7An9ZCKPDmdWy/ioQ+17b
 M/Wfm4ZhqwllG2sDy/DidYF03njB5+rmXbYEXslpJfSF89kVgiTKxmF0ozZHV/h2WeBGyx3
 iahjHipMVxp6t9kwuxQhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/L/QjZJM=A86Ps5wUInQqcLJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Remove occurences of unused pointers to struct ufs_super_block_first that w=
ere
acquired via ubh_get_usb_first().

Detected by Coverity: CID 139929 - CID 139936, CID 139940.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 fs/ufs/balloc.c | 12 ------------
 fs/ufs/ialloc.c |  4 ----
 fs/ufs/super.c  |  2 --
 3 files changed, 18 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index a7ea492..0ab1de4 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -38,7 +38,6 @@ void ufs_free_fragments(struct inode *inode, u64 fragment=
, unsigned count)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned cgno, bit, end_bit, bbase, blkmap, i;
@@ -46,7 +45,6 @@ void ufs_free_fragments(struct inode *inode, u64 fragment=
, unsigned count)
 =09
 	sb =3D inode->i_sb;
 	uspi =3D UFS_SB(sb)->s_uspi;
-	usb1 =3D ubh_get_usb_first(uspi);
 =09
 	UFSD("ENTER, fragment %llu, count %u\n",
 	     (unsigned long long)fragment, count);
@@ -135,7 +133,6 @@ void ufs_free_blocks(struct inode *inode, u64 fragment,=
 unsigned count)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned overflow, cgno, bit, end_bit, i;
@@ -143,7 +140,6 @@ void ufs_free_blocks(struct inode *inode, u64 fragment,=
 unsigned count)
 =09
 	sb =3D inode->i_sb;
 	uspi =3D UFS_SB(sb)->s_uspi;
-	usb1 =3D ubh_get_usb_first(uspi);
=20
 	UFSD("ENTER, fragment %llu, count %u\n",
 	     (unsigned long long)fragment, count);
@@ -499,7 +495,6 @@ static u64 ufs_add_fragments(struct inode *inode, u64 f=
ragment,
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned cgno, fragno, fragoff, count, fragsize, i;
@@ -509,7 +504,6 @@ static u64 ufs_add_fragments(struct inode *inode, u64 f=
ragment,
 =09
 	sb =3D inode->i_sb;
 	uspi =3D UFS_SB(sb)->s_uspi;
-	usb1 =3D ubh_get_usb_first (uspi);
 	count =3D newcount - oldcount;
 =09
 	cgno =3D ufs_dtog(uspi, fragment);
@@ -577,7 +571,6 @@ static u64 ufs_alloc_fragments(struct inode *inode, uns=
igned cgno,
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	unsigned oldcg, i, j, k, allocsize;
@@ -588,7 +581,6 @@ static u64 ufs_alloc_fragments(struct inode *inode, uns=
igned cgno,
=20
 	sb =3D inode->i_sb;
 	uspi =3D UFS_SB(sb)->s_uspi;
-	usb1 =3D ubh_get_usb_first(uspi);
 	oldcg =3D cgno;
 =09
 	/*
@@ -690,7 +682,6 @@ static u64 ufs_alloccg_block(struct inode *inode,
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cylinder_group * ucg;
 	u64 result, blkno;
=20
@@ -698,7 +689,6 @@ static u64 ufs_alloccg_block(struct inode *inode,
=20
 	sb =3D inode->i_sb;
 	uspi =3D UFS_SB(sb)->s_uspi;
-	usb1 =3D ubh_get_usb_first(uspi);
 	ucg =3D ubh_get_ucg(UCPI_UBH(ucpi));
=20
 	if (goal =3D=3D 0) {
@@ -794,7 +784,6 @@ static u64 ufs_bitmap_search(struct super_block *sb,
 		0x0, 0x2, 0x6, 0xe, 0x1e, 0x3e, 0x7e, 0xfe, 0x1fe
 	};
 	struct ufs_sb_private_info *uspi =3D UFS_SB(sb)->s_uspi;
-	struct ufs_super_block_first *usb1;
 	struct ufs_cylinder_group *ucg;
 	unsigned start, length, loc;
 	unsigned pos, want, blockmap, mask, end;
@@ -803,7 +792,6 @@ static u64 ufs_bitmap_search(struct super_block *sb,
 	UFSD("ENTER, cg %u, goal %llu, count %u\n", ucpi->c_cgx,
 	     (unsigned long long)goal, count);
=20
-	usb1 =3D ubh_get_usb_first (uspi);
 	ucg =3D ubh_get_ucg(UCPI_UBH(ucpi));
=20
 	if (goal)
diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index d0426d7..98f7211 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -57,7 +57,6 @@ void ufs_free_inode (struct inode * inode)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	int is_directory;
@@ -67,7 +66,6 @@ void ufs_free_inode (struct inode * inode)
=20
 	sb =3D inode->i_sb;
 	uspi =3D UFS_SB(sb)->s_uspi;
-	usb1 =3D ubh_get_usb_first(uspi);
 =09
 	ino =3D inode->i_ino;
=20
@@ -175,7 +173,6 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t =
mode)
 	struct super_block * sb;
 	struct ufs_sb_info * sbi;
 	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	struct inode * inode;
@@ -195,7 +192,6 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t =
mode)
 	ufsi =3D UFS_I(inode);
 	sbi =3D UFS_SB(sb);
 	uspi =3D sbi->s_uspi;
-	usb1 =3D ubh_get_usb_first(uspi);
=20
 	mutex_lock(&sbi->s_lock);
=20
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 329f2f5..3f2c086 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1389,14 +1389,12 @@ static int ufs_statfs(struct dentry *dentry, struct=
 kstatfs *buf)
 	struct super_block *sb =3D dentry->d_sb;
 	struct ufs_sb_private_info *uspi=3D UFS_SB(sb)->s_uspi;
 	unsigned  flags =3D UFS_SB(sb)->s_flags;
-	struct ufs_super_block_first *usb1;
 	struct ufs_super_block_second *usb2;
 	struct ufs_super_block_third *usb3;
 	u64 id =3D huge_encode_dev(sb->s_bdev->bd_dev);
=20
 	lock_ufs(sb);
=20
-	usb1 =3D ubh_get_usb_first(uspi);
 	usb2 =3D ubh_get_usb_second(uspi);
 	usb3 =3D ubh_get_usb_third(uspi);
 =09
--=20
1.8.3.2

--Sig_/L/QjZJM=A86Ps5wUInQqcLJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS+W06AAoJEKssnEpaPQKESjoP/0M0XSs8lT/7R6uW9NVIEW1D
AswN6NrwNBKXaROJOitetwfrCelmwMGh8/mZQJKieAcMyA1qteySkPn/7Q2kV69h
X7DQmga/04HqCkfCmlGiNTHRj8zG6qBqUFHBwZy3j2+hpTtZnKBUzF3x2bKc+z3t
YboY8NLjk1qM5ju0jtCvxaqjCRMNzEq6ZfSNVsy7nmCNte2ZKCUaKx+S57jSUVEj
9o2r8rOEJNARnnAlngomHHseMeBjLebEVaXSzm6l5JkY/rKYVFgqWfrxFNjQdBXP
zJ9z+IQ88aaBKqTcQcQ/pPDmvVu5t8qLtMt7dwPhez7DMLz0k+daNuhnxIGaPcmU
v9+YrFrHcTLO+fO/CsGo4a3h8FJtuhA/OS2E6v3lvvSVtXvXXF+vH4E2RO62QUcz
d7UpnwX0jRfvLMpFPj1WMuqajxhaSwUq6XWpuFOTBE3GKPDbs9ZTbanvWU9gEn6S
8Rov0e0auWWNnpjwCOIlSpSE1VQwIErGPVxB/F1Rbr4RdlReKqDtCjyVI0vXHGOl
jUKD8/vaqyoYm4jLQB3fBRyp5xB9xCvj5EP3Os51O9672bGfTW5E5ZV7FTTUXYtt
nZ8woTHlIGQNM7J7gL4VZB3sKJtIWgBx53ODxoVecprtmPc2h1S+POPrutBqAebs
3O8zYtMB/xSg1Xf2BTUI
=sTnb
-----END PGP SIGNATURE-----

--Sig_/L/QjZJM=A86Ps5wUInQqcLJ--
