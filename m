Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3HUHVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:21:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47609 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3HUHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:21:37 -0400
Date: Wed, 21 Aug 2013 17:21:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: linux-next: manual merge of the aio tree with the aio-direct tree
Message-Id: <20130821172134.cb52a6e4b7eab3abec0adc0c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_17_21_34_+1000_XuYwI9u4tbN1APRb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_17_21_34_+1000_XuYwI9u4tbN1APRb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benjamin,

Today's linux-next merge of the aio tree got a conflict in fs/block_dev.c
between commit b176eedb2a8b ("block_dev: add support for read_iter,
write_iter") from the aio-direct tree and commit 73a7075e3f6e ("aio: Kill
aio_rw_vect_retry()") from the aio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/block_dev.c
index 89d8ec5,8772b15..0000000
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@@ -1541,9 -1542,9 +1541,9 @@@ static ssize_t blkdev_read_iter(struct=20
  		return 0;
 =20
  	size -=3D pos;
- 	if (size < iocb->ki_left)
+ 	if (size < iocb->ki_nbytes)
 -		nr_segs =3D iov_shorten((struct iovec *)iov, nr_segs, size);
 -	return generic_file_aio_read(iocb, iov, nr_segs, pos);
 +		iov_iter_shorten(iter, size);
 +	return generic_file_read_iter(iocb, iter, pos);
  }
 =20
  /*

--Signature=_Wed__21_Aug_2013_17_21_34_+1000_XuYwI9u4tbN1APRb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFGp+AAoJEECxmPOUX5FEALUP/0hjzTVTy88CXclShmIO64CL
j47NjVwOOPz13oY2F9hieExvtWHwdN/mie32IlXe16lTLopmiALMpTlP32SGuvCz
LohP3xWZaBdYpoLxbqDCoX6FEF7Zp/AdHK80raYzSCFlGx2u+7xFayOt3qw8cAIV
dw07TtFcJK59iNUhDNMra3MV4ceQJX2EYWUEtMzse1kwSzZUsCb9UwfxtrM8uH95
vBIqez5K9bDp7I1ENYFcHraySiM+coz7aWZTGaqi3vNtSC88gMnBq/8EFH2fr78t
v5lHR88s4NwDM1b0CLgjOV0encvS0zho9Y4EQLYDC0M9MjZ0oFszB3F3G6qBe+Ho
IGCX0oRDR0bjR/WEAxJdjTyJaevZ4DyfviP93XtMvRjANMaDxkZ94+x7fzKnBVMZ
5sWjNRRBNkLUFZ5jMhmGEAFopBGOZnCvFM8cfX/exvI11wdjJQ2GfRFg0u0u0arc
u0hWWsF4a/JvlLmMxP5dlp7FdNnM24Anddpoq9yWqO4ts7qKdwSOczoGfMkDnGSp
+J9ZYITdV3u7O0ixqx7VDXcXWx7GBefpd7DFHN3x9+7ANt8KXDfI5ke/D6yMWaXN
oD1B/XARiPQ4Ik74PlTxfTTUZ2XeBlJWDh/L7/83Tz5o9zThQFYBb3C2kH5sCZzY
nxYOLnfDlPwJ7X676EVn
=Hyct
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_17_21_34_+1000_XuYwI9u4tbN1APRb--
