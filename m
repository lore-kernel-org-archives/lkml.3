Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3KECvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:51:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41860 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KECvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:51:40 -0500
Date: Tue, 5 Nov 2013 13:51:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Joe Thornber <ejt@redhat.com>
Subject: linux-next: build failure after merge of the device-mapper tree
Message-Id: <20131105135128.496b8b2f599d11f2d30ad70c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Nov_2013_13_51_28_+1100_Xb21y0Nc8IppEk0d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Nov_2013_13_51_28_+1100_Xb21y0Nc8IppEk0d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the device-mapper tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/md/dm-cache-target.c: In function 'bio_writes_complete_block':
drivers/md/dm-cache-target.c:1020:7: error: 'struct bio' has no member name=
d 'bi_size'
   (bio->bi_size =3D=3D (cache->sectors_per_block << SECTOR_SHIFT));
       ^

Caused by commit 1bd270d800ec ("dm cache: promotion optimisation for
writes") interacting with commit ed2d2f9a8265 ("block: Abstract out bvec
iterator") from the block tree.

I applied this fix up patch and can carry it as necessary:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Nov 2013 13:49:25 +1100
Subject: [PATCH] dm_cache: fix up for bvec iterator abstraction

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/dm-cache-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index a977d5c6d544..5ce0f5ec6d74 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1017,7 +1017,7 @@ static void issue_overwrite(struct dm_cache_migration=
 *mg, struct bio *bio)
 static bool bio_writes_complete_block(struct cache *cache, struct bio *bio)
 {
 	return (bio_data_dir(bio) =3D=3D WRITE) &&
-		(bio->bi_size =3D=3D (cache->sectors_per_block << SECTOR_SHIFT));
+		(bio->bi_iter.bi_size =3D=3D (cache->sectors_per_block << SECTOR_SHIFT));
 }
=20
 static void avoid_copy(struct dm_cache_migration *mg)
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Nov_2013_13_51_28_+1100_Xb21y0Nc8IppEk0d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeF01AAoJEMDTa8Ir7ZwVOZAP/j4FbYoT4lzSnAjM1Uxl+9zf
8pIr9PoPR73C5U1SuHqo8eo//u+dE0OfMYeh+of8yhwX51vQtUtc+jv2gDt5UkRC
/Lpn/xcxjRI5nZrlfN/LgVruJFoqTnnRAS5xNBbFLBbBgOpJc4/zIi3ROCk0l99F
88c/wr3jRktg/735KcVRpxbBY2SQHKQ6Xx1uVGSlDmkMMKgJRKZRCIb0MgSyz0SW
ABeSh47fpV+nU0FtpqE7bDYYD/Z2gZy/G6hQZuITcZqJYUJgHCl+2QUDVIg4IZad
OuDMS9jvESG1PBZ9AbXeXoPlB0vtc6xQTsLTtSyLd23uWqrAMcZFmvZtXpihQgdp
+Git6Nx2KPeeM6uAFYFNLIgWJcScC4YjDaCTnqqVkVNr3YRpLUcAkKE9H46Zoz6z
AUusD7qRavPPUBLvXO5yeHF6el4nYXTpHW4YXaPBLbmMIIqk59VXaEp6Q9SI0Zdq
B36L8BxHjZ7Mslyz/iNOlOHGvV/twzvvhiPHnRfefF6aWbj35FNgHr/w90ztCvDj
8+XNZJD2ddJHVOaywO9W4oAmv017TPSHwrLm8xI0z3gnwVE2FTkIqMUnngQSWU2P
chGqs4Z4FbYUekoT6Hxd8knhFQHvqI7WtQgPuCZ5fu/qqsrrr04l8IHiyKNpcrp/
1fY+o2SrFVqZFZRHfHqP
=6hm4
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Nov_2013_13_51_28_+1100_Xb21y0Nc8IppEk0d--
