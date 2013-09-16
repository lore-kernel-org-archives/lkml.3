Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3IPAXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 20:23:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44022 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3IPAXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 20:23:52 -0400
Date: Mon, 16 Sep 2013 10:23:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kent Overstreet <koverstreet@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Asias He <asias@redhat.com>
Subject: linux-next: manual merge of the aio-direct tree with Linus' tree
Message-Id: <20130916102341.c71a2d226e9788c3984f6e6d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Sep_2013_10_23_41_+1000_4il/2RJ+Y_=Lu7=r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Sep_2013_10_23_41_+1000_4il/2RJ+Y_=Lu7=r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the aio-direct tree got a conflict in
fs/block_dev.c between commits 02afc27faec9 ("direct-io: Handle O_(D)SYNC
AIO") and 73a7075e3f6e ("aio: Kill aio_rw_vect_retry()") from Linus' tree
and commit b176eedb2a8b ("block_dev: add support for read_iter,
write_iter") from the aio-direct tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/block_dev.c
index 1e86823,89d8ec5..0000000
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@@ -1518,8 -1517,8 +1517,8 @@@ ssize_t blkdev_write_iter(struct kiocb=20
  	BUG_ON(iocb->ki_pos !=3D pos);
 =20
  	blk_start_plug(&plug);
- 	ret =3D __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
+ 	ret =3D __generic_file_write_iter(iocb, iter, &iocb->ki_pos);
 -	if (ret > 0 || ret =3D=3D -EIOCBQUEUED) {
 +	if (ret > 0) {
  		ssize_t err;
 =20
  		err =3D generic_write_sync(file, pos, ret);
@@@ -1542,9 -1541,9 +1541,9 @@@ static ssize_t blkdev_read_iter(struct=20
  		return 0;
 =20
  	size -=3D pos;
 -	if (size < iocb->ki_left)
 +	if (size < iocb->ki_nbytes)
- 		nr_segs =3D iov_shorten((struct iovec *)iov, nr_segs, size);
- 	return generic_file_aio_read(iocb, iov, nr_segs, pos);
+ 		iov_iter_shorten(iter, size);
+ 	return generic_file_read_iter(iocb, iter, pos);
  }
 =20
  /*

--Signature=_Mon__16_Sep_2013_10_23_41_+1000_4il/2RJ+Y_=Lu7=r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSNk+SAAoJEECxmPOUX5FEknoP/R3NJYB/xgDKSQJd2Hhg26Jm
VESefYAPUbjoCItkcTWZFyHmtYMT7TxjSCMlehuMLBukpw/1liEfabqW1Fdu6cwT
GHgxm3T83qYyGe/9riNZyRTzdID3JDODysrD4oQ0mBG8FRo6EYYmqjvN0j8VaYgS
DRS+nhvrUMYfxQrwKWoGfPQ+RmsR62uaOpdMVozqp8MLWm/Alp78TJdNS9sVwo+M
0il+SYguiPxxuPRrateGtuD+AFIhTvXRIgpOG9SSWcdYWyRrAxpsA38Vf8Gevtsm
gCdJnDyWWWFvyqzVIJuGsizK3mMTG1Ftuarm6Ce2T+H/wqCSxhLbOFsDrD0SESzO
YXjPo0Wmeys4ThUCOd05RRekhfNC3HqcEYafMN5qL4SLYINSriFbx0IENfZe7X+W
bWvtFtG9kCOsUiweHSC8XCgY2F2EtX96xXtsUICMPSNl4FQ7l0nU5Nz9mwHUcklK
J73bXZld+nvVnUMBJuF62WSKxq9telED2HaKzPjxg+lwExcyhi4gmRH9duzM1oeE
UuEpbKDz8YTlLathaolVNa9GyIzcvIZE1RVr7P6dmJbdMLQsq4yAj+ozKiYyOKGv
L1NYTxE95JZrwl69oTv8xfFQkKKiqA0NnJXoXAx6Swwn9Uiyw+83HWB+bUklteZz
47ajqUtFz0dy1LQjb6ai
=PEdR
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Sep_2013_10_23_41_+1000_4il/2RJ+Y_=Lu7=r--
