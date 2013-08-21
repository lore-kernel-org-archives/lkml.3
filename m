Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3HUIee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:34:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60617 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3HUIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:34:33 -0400
Date: Wed, 21 Aug 2013 18:34:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: linux-next: manual merge of the akpm-current tree with the
 aio-direct tree
Message-Id: <20130821183422.af59fd4ceaa9f1d7464cc705@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_18_34_22_+1000_X2zFBRdFiz7SAFbJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_18_34_22_+1000_X2zFBRdFiz7SAFbJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/shmem.c between commit b080082bc3e8 ("tmpfs: add support for read_iter
and write_iter") from the aio-direct tree and commit c6dc71ff08f7 ("mm:
drop actor argument of do_shmem_file_read()") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/shmem.c
index 786d390,75010ba..0000000
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@@ -1555,13 -1546,14 +1555,14 @@@ static ssize_t shmem_file_read_iter(str
  		 * Ok, we have the page, and it's up-to-date, so
  		 * now we can copy it to user space...
  		 *
- 		 * The actor routine returns how many bytes were actually used..
 -		 * The file_read_actor routine returns how many bytes were actually
 -		 * used..
++		 * The file_read_iter_actor routine returns how many bytes
++		 * were actually used..
  		 * NOTE! This may not be the same as how much of a user buffer
  		 * we filled up (we may be padding etc), so we can only update
- 		 * "pos" here (the actor routine has to update the user buffer
 -		 * "pos" here (file_read_actor has to update the user buffer
--		 * pointers and the remaining count).
++		 * "pos" here (file_read_iter_actor has to update the user
++		 * buffer pointers and the remaining count).
  		 */
 -		ret =3D file_read_actor(desc, page, offset, nr);
 +		ret =3D file_read_iter_actor(&desc, page, offset, nr);
  		offset +=3D ret;
  		index +=3D offset >> PAGE_CACHE_SHIFT;
  		offset &=3D ~PAGE_CACHE_MASK;

--Signature=_Wed__21_Aug_2013_18_34_22_+1000_X2zFBRdFiz7SAFbJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFHuTAAoJEECxmPOUX5FEOv0P/3El0GsR+z1UDTO2ltqEL+jl
i3+L79o3FU4xSk4flFRkj/5Z8p/YVMKK49hc0qMSmKLA5IJZRNKWMpvNyoRHb9Yk
OdRrpDoSXOjbce8cLQjLaO0VvAyTr5MMAxVC/3k3C4oScjFDzCiNttO8KNCzUwxR
EOkY9v2DJoINccAwmsf8n5n7UQjCpXQrl5Iv1UrxTQpmBzdvcQNABlvnsj5T8X4S
7FcwGOULHsG9dDTteqz/bjXDZDCQKS87kV7YwM3kF7bUVLcsuKTCscXjd61wesQC
gkYA5EfHLccD+ir4DWrazZBKpTA98NXDtwtKfgfSvazQG+gf+XeNCuLtsYjFD8S5
r6svLziJWgXcWgwQHj2PIs+Qa4Kinxllj+uYsyTkqcKkXZBg01YAk4068s7Vf0i3
L2bK8H8iJEVDMW/wbqCeUU6v4rdV4FL1OCQXa78/8jTDUy3QSO7Ezs1AfZDG6Tsm
5WTcXHPBUNLl0KK7VvY1zrbN1cFjVy5pT0opCkmKTXQio6acOYsVzVSGd4sVMnuR
90+9jnAgHpJiJDMjeXZfNdXodDCjodpKvxfTVMael2yGZ8wjV9T0FeQAQNettXci
v1gQzPNcm+FtnQ5U+sWfRgCxYo9fzKGIaEizo2J6s7pYpM6fk9gUBRD7JmrqFURY
q3yfGm39scsTBWVpRJ/k
=Ad3x
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_18_34_22_+1000_X2zFBRdFiz7SAFbJ--
