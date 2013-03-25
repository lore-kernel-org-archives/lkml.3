Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3CYEXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:23:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42692 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3CYEXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:23:10 -0400
Date: Mon, 25 Mar 2013 15:22:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130325152258.b930b51cccd98bedceeca92c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Mar_2013_15_22_58_+1100_RGlvdfRyH.K68Y9n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Mar_2013_15_22_58_+1100_RGlvdfRyH.K68Y9n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/inode.c between commit  ("vfs,proc: guarantee unique inodes
in /proc") from Linus' tree and commit
"procfs-improve-scaling-in-proc-v5" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/inode.c
index 38f0775,f53660a..0000000
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@@ -463,10 -464,10 +464,11 @@@ static const struct file_operations pro
 =20
  struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entr=
y *de)
  {
 -	struct inode *inode =3D iget_locked(sb, de->low_ino);
 +	struct inode *inode =3D new_inode_pseudo(sb);
+ 	const struct file_operations *fops;
 =20
 -	if (inode && (inode->i_state & I_NEW)) {
 +	if (inode) {
 +		inode->i_ino =3D de->low_ino;
  		inode->i_mtime =3D inode->i_atime =3D inode->i_ctime =3D CURRENT_TIME;
  		PROC_I(inode)->pde =3D de;
 =20
@@@ -491,9 -494,11 +495,10 @@@
  #endif
  					inode->i_fop =3D &proc_reg_file_ops;
  			} else {
- 				inode->i_fop =3D de->proc_fops;
+ 				inode->i_fop =3D fops;
  			}
  		}
+ 		rcu_read_unlock();
 -		unlock_new_inode(inode);
  	} else
  	       pde_put(de);
  	return inode;

--Signature=_Mon__25_Mar_2013_15_22_58_+1100_RGlvdfRyH.K68Y9n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRT9EiAAoJEECxmPOUX5FEuEcP/ixF8rPMBmE0SNzoKgMRonUJ
oTckvTgfcB2V9CDqdx3OPsYLDx4WDm/cP45PIx88CzGaSZozSClSUc9SmRvGNcS+
0S1UmWhoQVWcd40YygzT8kEsHPUNPKleiqg8NQ6ZyboUMj692Oh+JVYkA+L5Wkl7
Aa82j0ZJ5cNyzvApcs0GdKTBjvnDRRrCFRYY5DwchXfKSExXVD93HMjgINb6jzFt
TlBbUUcCoEtYoUNs6EU0gZ15xnsGpYleggU0FuO9OhwjqL8G4v4OGglH4V9lr6yI
h0UvZONaTU+9Hvzqx67z5V1txW7nSBUPGJS8DM+s3pKZD6aHf2oa5u0qBGNOIEHo
27gnT2X8OnADp5lmFBpWHZL5fh/Q6mBa6UHTbwEysCLfZrkmeg8762rZrk/TXZb1
9XihyMmmSp2AOZ2TZ/1NnqirkSDFX++9+L3+5BwmK76EzyWmI52TxOVpujkvBH0n
370dNI0KoC13F0MLS3ZI4V8Gt6hVFVQxGGOa+l7JJjOgfBEo4+hoWjQb3Dy5DpLC
AOuJ/ysba93dEbe/oKsuHJ92EYTKIZA6ISuzKzV8tpMSA3HkLE49/NnwyKZFVbIK
o88xVf3WYRB+gMg1t6zROqzH3n63Rs6Z6dOpuRjPhVchXvgbCNeaNEp0XoBsFDP1
I8DyW7z8SE2wqsfb1Z4B
=d2Gh
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Mar_2013_15_22_58_+1100_RGlvdfRyH.K68Y9n--
