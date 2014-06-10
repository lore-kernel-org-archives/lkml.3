Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaFJBXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:23:13 -0400
Received: from ozlabs.org ([103.22.144.67]:54488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbaFJBXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:23:11 -0400
Date: Tue, 10 Jun 2014 11:23:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the vfs tree with the f2fs tree
Message-ID: <20140610112304.5ef43a2a@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/b6qwC9WSYdIB8U3k+XoD8BJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b6qwC9WSYdIB8U3k+XoD8BJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/f2fs/data.c between commit b6fe5873cb42 ("f2fs: fix to recover data
written by dio") from the f2fs tree and commits d8d3d94b80aa ("pass
iov_iter to ->direct_IO()") and 31b140398ce5 ("switch
{__,}blockdev_direct_IO() to iov_iter") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/f2fs/data.c
index c1fb6dd10911,1d2e7e9624d2..000000000000
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@@ -1044,14 -1018,11 +1043,14 @@@ static ssize_t f2fs_direct_IO(int rw, s
  	if (f2fs_has_inline_data(inode))
  		return 0;
 =20
- 	if (check_direct_IO(inode, rw, iov, offset, nr_segs))
+ 	if (check_direct_IO(inode, rw, iter, offset))
  		return 0;
 =20
 +	/* clear fsync mark to recover these blocks */
 +	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
 +
- 	return blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
- 							get_data_block);
+ 	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
+ 				  get_data_block);
  }
 =20
  static void f2fs_invalidate_data_page(struct page *page, unsigned int off=
set,

--Sig_/b6qwC9WSYdIB8U3k+XoD8BJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTll39AAoJEMDTa8Ir7ZwV/QkP/jFwASXQjY9I15O4WEDLwRwW
YzOkUhxbCXIxKzZGKKL4RjCGnHdc3FwbNBHKbWwvEqO1Mjqgqmk1NjMypQ3jPhKo
jtIOO42AIBizH2cwf5eUfq37xMebRC/4Z8KSkZM4boQhcy4rvU2KOp9Tl1AXQXPC
fWHVtvoP1I4sG8Qt+QljaSqs8ht42TwwGLRWSyPl1X9ZVxIqdORB+UDQi9V9bRof
NGigwOyJ9Z6yN8M9DFa3AjJasWu6z/0Dp2MoZORVJU/dGgznSOyYD+JkM15x6lHj
5tG1rVmxkWYrKG9CbECLl+/LVqhyNSglFaTJbJxx23/4xYlsJz1LI9GE2LsEacfB
WkHlaqoVPHvaM3TxOYfGMMy/wVeXX+R5Fivh+W3gC4Sxh7qg8LkwsJlAhapo7jYo
1vvZqY7mVpWGTK+Hnc60HrxSmUNVGW9+/pEsKR0w2m99O6YdtoAGlcQLi0XNM8jb
gNyccv8I6vA+NGr2xtG3HrGPGENcV6wDQZH5IkYE9sda7agDGi2Qzz61S+gbJcRd
lNS9pEzuYirmK38CtFPy1Cb7Y5QQ2jS1GAryZnOq+Ehe9i07lTzmxZKadWYTI4JV
B8syVZtF0W/XZGNzHIoMarTgA0W0tLKbVt8oSxUCV1lpqmTPXQM0ouMyn/+MYzhf
4Bh0DaQMjsF7IeVAiPNf
=FnN3
-----END PGP SIGNATURE-----

--Sig_/b6qwC9WSYdIB8U3k+XoD8BJ--
