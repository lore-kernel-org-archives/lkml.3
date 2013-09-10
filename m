Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3IJEmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:42:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47507 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab3IJEmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:42:04 -0400
Date: Tue, 10 Sep 2013 14:41:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130910144157.c0ae49ee90a23586e1614474@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Sep_2013_14_41_57_+1000_Ie0kSl3xevDaqs6l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Sep_2013_14_41_57_+1000_Ie0kSl3xevDaqs6l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/super.c
between commit d040790391f2 ("prune_super(): sb->s_op is never NULL")
from the vfs tree and commit "fs: convert inode and dentry shrinking to
be node aware" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/super.c
index cd3c2cd,efeabe8..0000000
--- a/fs/super.c
+++ b/fs/super.c
@@@ -75,11 -75,11 +75,11 @@@ static unsigned long super_cache_scan(s
  	if (!grab_super_passive(sb))
  		return SHRINK_STOP;
 =20
 -	if (sb->s_op && sb->s_op->nr_cached_objects)
 +	if (sb->s_op->nr_cached_objects)
- 		fs_objects =3D sb->s_op->nr_cached_objects(sb);
+ 		fs_objects =3D sb->s_op->nr_cached_objects(sb, sc->nid);
 =20
- 	inodes =3D list_lru_count(&sb->s_inode_lru);
- 	dentries =3D list_lru_count(&sb->s_dentry_lru);
+ 	inodes =3D list_lru_count_node(&sb->s_inode_lru, sc->nid);
+ 	dentries =3D list_lru_count_node(&sb->s_dentry_lru, sc->nid);
  	total_objects =3D dentries + inodes + fs_objects + 1;
 =20
  	/* proportion the scan between the caches */

--Signature=_Tue__10_Sep_2013_14_41_57_+1000_Ie0kSl3xevDaqs6l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLqMZAAoJEECxmPOUX5FEJKQP/01hjq389005dANGo4KB7uS/
/JSG1HT9/gUYD9/zBzBEgGidqknHxjWbHp6XX7BfCPKEEGAM0jCJ/zMGDMlcvVme
HWaQD9ZSFUHg/+UkZrwRg1QcLTt5h1UgK4SVsHuLxSR5xlZgpyYoF5VFkz1OeE42
gN6M2x+0Z0NA0fHvbTyQQZfU41d+B2cjEt92pnHuY/Px+dmdxbz0jJKhfWmhcx8c
XV4m3A9gRX1Am0vY1d51NB/Vx0gNSUR5dGu1tbec4w2Hgbbg0FPVv3Lp30ho/ZE0
57XlLbACjkP8uHZorJhBGLK3SK7r2029uVGYtTFwIpvSIjynGBtfI8IInEumOAlF
D+Cz65/izrkvS/6ahlxD1Le9nGvvaZy2CtSqYqEaItUlEDzCgUuBBg4YWwZ+CmJx
kzgm1EjT652sPhdVntPrW0PcGirtuNfOIqGIFiN1uWQV5o1J5KnWAgKeNgyaL7lm
aoypsskDIRtmnwYs1PbWiEqRtnxBBpJrp7n2t3MhSQwM/P0Wo0+W9jlsS4gSi4A5
0YxutIHJxe88KiAdLNm2tUS0L3VbQNOi8GFvQL18vwyA+ADbvPXZ4VZv0F3kubng
K0Fagy93hvQUfgbzHn9mOZJAfXFZlYo/5iBiRU/6flyD8VseihS3JUjiYw9Fnf6W
IfmMLCTXGYD+871xMsJJ
=e4am
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Sep_2013_14_41_57_+1000_Ie0kSl3xevDaqs6l--
