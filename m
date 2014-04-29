Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbaD2AhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:37:16 -0400
Received: from ozlabs.org ([103.22.144.67]:54998 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaD2AhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:37:10 -0400
Date: Tue, 29 Apr 2014 10:37:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Yu <chao2.yu@samsung.com>
Subject: linux-next: manual merge of the vfs tree with the f2fs tree
Message-Id: <20140429103703.efca943550755ccb0ed875eb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Apr_2014_10_37_03_+1000_W7sbrYXuhzot3eL_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Apr_2014_10_37_03_+1000_W7sbrYXuhzot3eL_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/f2fs/file.c
between commit adeb670f1fee ("f2fs: introduce f2fs_seek_block to support
SEEK_{DATA, HOLE} in llseek") from the f2fs tree and commits 8eb02141b8a6
("switch simple generic_file_aio_read() users to ->read_iter()") and
e6552301fb08 ("write_iter variants of {__,}generic_file_aio_write()")
from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/f2fs/file.c
index b9f4fbf5c07e,e4ba4b93f96a..000000000000
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@@ -802,11 -678,11 +802,11 @@@ long f2fs_compat_ioctl(struct file *fil
  #endif
 =20
  const struct file_operations f2fs_file_operations =3D {
 -	.llseek		=3D generic_file_llseek,
 +	.llseek		=3D f2fs_llseek,
- 	.read		=3D do_sync_read,
- 	.write		=3D do_sync_write,
- 	.aio_read	=3D generic_file_aio_read,
- 	.aio_write	=3D generic_file_aio_write,
+ 	.read		=3D new_sync_read,
+ 	.write		=3D new_sync_write,
+ 	.read_iter	=3D generic_file_read_iter,
+ 	.write_iter	=3D generic_file_write_iter,
  	.open		=3D generic_file_open,
  	.mmap		=3D f2fs_file_mmap,
  	.fsync		=3D f2fs_sync_file,

--Signature=_Tue__29_Apr_2014_10_37_03_+1000_W7sbrYXuhzot3eL_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTXvQ0AAoJEMDTa8Ir7ZwVt+MP/AxLH1yUhfigWUpj88HhkNgW
Iiv2Zyr1Z2Ky06Iu5qGE+hlLc2gN9xcqLFK/lC4U+Xh4DCggo0+DvL5OhUjNTMMG
ZspWcU9ugkZz7/QJP/bfzubBk0zPCj7Q7bnHdSCg1F2oD/LwkZturJ+hq7A0A8we
MdFnQCO04bUimdP0czyK7yOIG1bYLZVs03Zbk2u7bQPTJFjXLDcpn8b7qDHb1lZE
nuJfjqS+rYA4/Wo6SuMW8foQ61bvweSG3pV4/Vy1ZosGFn/P70G3ENSU79gpFl78
FGl5QNsQGuYaQKe2TEMl72hFAr02a/bs2/aHczc23dYnrzob3s6klrRykuRofpWC
0MhC36OfimUy56OUmF4uwppVq/zqGMsf5jjiC9JYx58Mv2yPdJaOFNXaJE79Zi/s
HU+H6abgrWV6THlVbazlQh7gpipmbElndcVqKUnqfobDGlvDo65N44S01PPEjNNy
MqsMywOPiv283DLSfSbHt+0oDyhFbWLSrcZIHKP2BNUrrUT0qZ0Co4se12eESD5d
vMHqf1tiebQqigb+8AzAgQdMd8Puttr0Zs+Up03MwGLMVhIRUU3cI1Jje035Exkv
PJE6fT7PxolNUF+GAhKs/wVHYCPNfaxfMUDQ0f6zMJh3BhT/bW2spbaBcLx2+9rn
pzYXym1ZpGs+GDhPMJh6
=DFvG
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Apr_2014_10_37_03_+1000_W7sbrYXuhzot3eL_--
