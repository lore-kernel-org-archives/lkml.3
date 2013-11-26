Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3KZBAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:00:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48908 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3KZBAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:00:32 -0500
Date: Tue, 26 Nov 2013 12:00:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Yu <chao2.yu@samsung.com>
Subject: linux-next: manual merge of the block tree with the f2fs tree
Message-Id: <20131126120024.3532de1b44c22372ac1c37f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Nov_2013_12_00_24_+1100_vWatN8D0KUb08/kt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Nov_2013_12_00_24_+1100_vWatN8D0KUb08/kt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
include/trace/events/f2fs.h between commit 4bfc388c73a1 ("f2fs: adds a
tracepoint for f2fs_submit_read_bio") from the  tree and commit
4f024f3797c4 ("block: Abstract out bvec iterator") from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/trace/events/f2fs.h
index 204fcc3201b1,bd3ee4fbe7a7..000000000000
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@@ -627,16 -614,16 +627,16 @@@ DECLARE_EVENT_CLASS(f2fs__submit_bio
 =20
  	TP_fast_assign(
  		__entry->dev		=3D sb->s_dev;
 -		__entry->btype		=3D btype;
 -		__entry->sync		=3D sync;
 +		__entry->rw		=3D rw;
 +		__entry->type		=3D type;
- 		__entry->sector		=3D bio->bi_sector;
- 		__entry->size		=3D bio->bi_size;
+ 		__entry->sector		=3D bio->bi_iter.bi_sector;
+ 		__entry->size		=3D bio->bi_iter.bi_size;
  	),
 =20
 -	TP_printk("dev =3D (%d,%d), type =3D %s, io =3D %s, sector =3D %lld, siz=
e =3D %u",
 +	TP_printk("dev =3D (%d,%d), %s%s, %s, sector =3D %lld, size =3D %u",
  		show_dev(__entry),
 -		show_block_type(__entry->btype),
 -		__entry->sync ? "sync" : "no sync",
 +		show_bio_type(__entry->rw),
 +		show_block_type(__entry->type),
  		(unsigned long long)__entry->sector,
  		__entry->size)
  );

--Signature=_Tue__26_Nov_2013_12_00_24_+1100_vWatN8D0KUb08/kt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSk/KtAAoJEMDTa8Ir7ZwVMSAQAJJPhJU0/96v5fr5piMydiU+
QevF7FQiYhiZtm+dri00J9tzT7WYpHLvOtDxlchZA30mbCF/xevRVoPD9NFy2gQ0
1eiYiJvwhacaSEutpd2lUZC1nnL1SIBrSzKKYaz3XVFtj2upsWAkP9AaNH/hTTjM
5GOPIunZaIoFnatsFCY1oJLkQ2waYZnJPCRe9G8ua7NmPSUALSWY0che9gbwzSyA
V4uf7ITML6a97Oylb4jUjdhEvsyNw5wP+VRhiNoi4xJhZXJhdRdbs6cCngqCc7D+
2DkNA5bXdOg8xpnVkGPezDJqIP0r/4U5ljy+RBsVP76KaL5JkOgszfEf61TUwwb9
UAh4jCdGHnWqKU1+os7Rk7mkKR5Jg6qxnz9MsGWKIKvWKnnW5zWegIbQYPUUNIJM
5R8FS+sTvQGmJMeLQXKoOfHUCwNUUqryTIrBQnnjokvMG4hLPCDVg9J0XvbxGvIf
trn5Tgevt4P4+YMKb7zLzSyGG/pkBezhmQbynZJ4ksJiNEppAT7fur35NKkOJeF8
DxKLY2eTxMZE3zoewanJEv997zE2m2kpxKTNeKJzNg6BG/nEpwtoR19nSh39UayT
L9U6zlk3QqC0v5VOgT+jrK/rpnack6rV5xL9jJLx/ylvh36heqboiLMOjOrP8n4H
8kR0mvO4hiJJc/paDzEZ
=dMOK
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Nov_2013_12_00_24_+1100_vWatN8D0KUb08/kt--
