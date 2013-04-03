Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab3DCBNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:13:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58335 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3DCBNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:13:00 -0400
Date: Wed, 3 Apr 2013 12:12:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        Frank Schaefer <fschaefer.oss@googlemail.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the i2c tree
Message-Id: <20130403121257.852f64242bff004461d8b081@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Apr_2013_12_12_57_+1100_1fX8UUYlAFjNyJhd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Apr_2013_12_12_57_+1100_1fX8UUYlAFjNyJhd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/media/pci/bt8xx/bttv-input.c between commit bf51a8c5e0b6 ("i2c:
Ignore return value of i2c_del_adapter()") from the i2c tree and commit
457ba4ce4f43 ("[media] bttv: move fini_bttv_i2c() from bttv-input.c to
bttv-i2c.c") from the v4l-dvb tree.

The latter moved the code that the former modified, so I added the
following fix patch and can carry the fix as necessary (no action is
required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 3 Apr 2013 12:10:05 +1100
Subject: [PATCH] i2c: fixup for code movement from bttv_input.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/pci/bt8xx/bttv-i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/b=
ttv-i2c.c
index b7c52dc..d43911d 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -397,8 +397,8 @@ int init_bttv_i2c(struct bttv *btv)
=20
 int fini_bttv_i2c(struct bttv *btv)
 {
-	if (0 !=3D btv->i2c_rc)
-		return 0;
+	if (btv->i2c_rc =3D=3D 0)
+		i2c_del_adapter(&btv->c.i2c_adap);
=20
-	return i2c_del_adapter(&btv->c.i2c_adap);
+	return 0;
 }
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Apr_2013_12_12_57_+1100_1fX8UUYlAFjNyJhd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRW4IZAAoJEECxmPOUX5FEDDQQAKDTWaNPTm9wvcuUq901UnEI
W5eoLthAvOD4KQF/bDyFX/H19Gz7EohByV26OPKpcPimTVAhDiDzPW0qzGOujtCn
MfJ+OfLbiASzx3UvzdyEdfV1Aq6lGd17GppdQjJNeNxxuri5ibkWgflZZkIJNqcg
lXYgGBMTDjeMyykE4HnRhdaseUHIQYKao/vXmjbLSTXILHhbqoY8PXkL+nWITBMR
3WktDNEiBspYwqUzwjawWmyCTQ0U13VbvxFEjuG4pKqOCAXIsHTVsJ1no+Pwh1oR
TAKrlU3MwSFuypd325bg1DvHiUsKuJ1MJqdLqZYuQrouW1/4OXw10JW/I1BRux79
wbXorqrWgxmhx6+u9Po59innwdCV6J5hxPj5SJ+zC/fTR9vPSg6G5Q/LTjsT4RFQ
PU4zid07oKYfW01nr03JuIkoPFkcE6NEJGaIUEZEH84TC6bkVwoi8DgQ6vWDJmkI
tiG2Iau7YE7xBnLEvOtBcje0I17Q4qDfc1iUDXd7yL7jz1SstfKtLTyUmHFau+Dd
n1quKS//qENU0XV94R0+4v2HHAQ3ZJzjjCjSrKEeF9/pbkftdJxUJbafoZPZWBFI
DJrEluVXVjfosJEsinGZp8jX5/6lAusAtHYKaKCygOW8FjjtH6y+aDakAZEWWrfM
/0eQoHDf+aG2MkJNk+V7
=swrQ
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Apr_2013_12_12_57_+1100_1fX8UUYlAFjNyJhd--
