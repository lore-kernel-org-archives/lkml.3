Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab3BYDkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:40:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55760 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab3BYDkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:40:12 -0500
Date: Mon, 25 Feb 2013 14:40:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130225144001.0469c0661924fa98ac7cbe5b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Feb_2013_14_40_01_+1100_+nvl3v25CRhDe4tz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Feb_2013_14_40_01_+1100_+nvl3v25CRhDe4tz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/sysfs/bin.c between commit 496ad9aa8ef4 ("new helper: file_inode
(file)") from the vfs tree and commit "hlist: drop the node parameter
from iterators" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/sysfs/bin.c
index 2ce9a5d,f186e27..0000000
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@@ -468,8 -467,8 +467,8 @@@ void unmap_bin_file(struct sysfs_diren
 =20
  	mutex_lock(&sysfs_bin_lock);
 =20
- 	hlist_for_each_entry(bb, tmp, &attr_sd->s_bin_attr.buffers, list) {
+ 	hlist_for_each_entry(bb, &attr_sd->s_bin_attr.buffers, list) {
 -		struct inode *inode =3D bb->file->f_path.dentry->d_inode;
 +		struct inode *inode =3D file_inode(bb->file);
 =20
  		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
  	}

--Signature=_Mon__25_Feb_2013_14_40_01_+1100_+nvl3v25CRhDe4tz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRKt0SAAoJEECxmPOUX5FE0jsP/3TRtJLWu0cMtK5wj8BkrMqI
1T678mfEDZN/hPiq72053eIZatSBC07rR8ZEHJGTWyum2WpqAGxwhu2MZcXv29B1
t/oY25exf1ISepw43jhDgf519+Yut8vGazuUJn7d9mxp2Z2xJima76hvmLJD4ktf
3FvVJCnNoH6y+3FKKNr+ujMkmOJxcgD77NPD4ZEQ1cVbRgjuDaNEENQts2Qi7pJR
WMmVAoA/E9FdC1XK1547cTBs+kvdmkAxiBhcyQZoO6a9zMjc1hBKq/ox6V/+Lbu3
5s1oFF5cJglPje9kefYjrOmzYgBcos2WOb9K5mQDjHl9TdJ4lkv+o7+Q+67PfnoK
2Xj5zcY04/8255qrMRhDio9edoASnpxvXU0ZQKZi8IJB4WrIJMMCwSqaYJJNK905
Wn2bB2vVu5n2c07GGdUtk0DNJTsvz1q9eoTN7XLP3CmkaO9I2I5uaapn/adqT1g1
c7Eet9pcc5JdEtTusc6Um4yfUwEa8Z+Owcou98prsQPGokgZG3CwdIWIbrQ//jZ2
gZ9IfVwa61+i7Aq1yi3oUcg5ZcNvdaiJBQAYr0phqtn+YS2MJn/5gan/11B5iAsz
D1E9c0Xtoo0CQ5r00EyB7x/Mm6Z70yPs3NPL+TSM5Dolpw3FIr2QY3IVoIBedGFe
ugs/DzIy9wQAPivusL3z
=uJHP
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Feb_2013_14_40_01_+1100_+nvl3v25CRhDe4tz--
