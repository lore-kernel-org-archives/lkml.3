Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaBKAbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:31:45 -0500
Received: from mout.gmx.net ([212.227.17.20]:52579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaBKAbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:31:36 -0500
Date: Tue, 11 Feb 2014 01:23:16 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-fsdevel@vger.kernel.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] fs: ufs: Remove unused ufs_super_block_second pointer
Message-ID: <20140211012316.519cfa6b@spike>
In-Reply-To: <20140211012012.6384d52f@spike>
References: <20140211012012.6384d52f@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VG8gff3LKRwt6VCyV8ONU2A"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:5fqHfMZhbLcR33HkVAD+UrLNGFTf/zchQTPyMkXt572o+BwLnio
 xYXF2wbhSc1TTzcIGUhMtyHHxn0uUl1LSEGSiYemhW8MIk1qsIe2ztJ2j1JmPQ1kh541JFg
 KQ2/1HuHpnOHBNjRLURc8ThPpScUgF0B4RsEZI0Hm4bOepZD3EnYe3BvKDGuTDghrqj6W5c
 RDnlyy3eJG2xo3+j95aQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VG8gff3LKRwt6VCyV8ONU2A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Pointer 'usb2' to struct ufs_super_block_second acquired via
ubh_get_usb_second() is never used in function ufs_statfs().
Thus remove it.

Detected by Coverity: CID 139940.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 fs/ufs/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3f2c086..53ce1af 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1389,13 +1389,11 @@ static int ufs_statfs(struct dentry *dentry, struct=
 kstatfs *buf)
 	struct super_block *sb =3D dentry->d_sb;
 	struct ufs_sb_private_info *uspi=3D UFS_SB(sb)->s_uspi;
 	unsigned  flags =3D UFS_SB(sb)->s_flags;
-	struct ufs_super_block_second *usb2;
 	struct ufs_super_block_third *usb3;
 	u64 id =3D huge_encode_dev(sb->s_bdev->bd_dev);
=20
 	lock_ufs(sb);
=20
-	usb2 =3D ubh_get_usb_second(uspi);
 	usb3 =3D ubh_get_usb_third(uspi);
 =09
 	if ((flags & UFS_TYPE_MASK) =3D=3D UFS_TYPE_UFS2) {
--=20
1.8.3.2

--Sig_/VG8gff3LKRwt6VCyV8ONU2A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS+W10AAoJEKssnEpaPQKEZGYP/Rot68gF+3xGl5edrKEEVA25
OA/ieALX+qoKsxqTG7YuLrqFLY5BsbP5XFP3ddmJq1VYIr8Rzz2gLwBnJkzQir6j
UohHCL4pebP5MwxcZAKigfdL8tIcThDy2PaT1y8cNbZIn+d5IZI6ZmTW8sQUidzL
DnvFjupdta4l0G8a0SRwlKE0qqNBfVyVDZ+qm7rvv76V3EcZCdcZSCg7BsDU8aY3
M4gI5BuqgLAKik/8Zw3psoLqFemqWbJ/x/Rija9//DlvSFLn2XzBUU/RBqZ5mAWN
j9F+tPBl8Fkxi8SvBoIaAN6GcTlBMRmZO28TuJExqNO9lnL1adf7YAkRbyBwV5LK
wxm5g3SuT6PUQFHRwYJMJWRWdkgbF90faD881c5sCcorjQc/vk6OuXbl9xWzhdYz
yeeTAUOwLwfEaT3UC2VfP/h7XCDMHV6YZn6sktSh0BM4QLw2WvvlV8W5O0E+qCpW
5uG6Lm7dfMJuaNA0vfTBcOZfSvCLIgH1YBrmcSDoN0Gazz9Ben2vKNA3D9rZHJ7r
V9/l70aY4Z3ugfN4WxBW8tSkfL8cgDeMnSPtat8lk7RVpp00wAezXqXM6/vSWtM1
DJdVO8ozJB7annuEgIoVER9wj7r7QV52/D6fC3xew32uO+eh961n8tIbftNsQwJA
TImyPmRQPabPrsAusG8b
=LCX9
-----END PGP SIGNATURE-----

--Sig_/VG8gff3LKRwt6VCyV8ONU2A--
