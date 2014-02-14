Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaBNEzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:55:25 -0500
Received: from ozlabs.org ([203.10.76.45]:47742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaBNEzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:55:24 -0500
Date: Fri, 14 Feb 2014 15:55:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the akpm tree with the spi tree
Message-Id: <20140214155515.3f3eab9f398dd5293eff0788@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Feb_2014_15_55_15_+1100_2zsRs/LQ56NKHwNm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Feb_2014_15_55_15_+1100_2zsRs/LQ56NKHwNm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/spi/spi.c between commit 513273538a6c ("spi: Make max_tx and
max_rx the same type") from the spi tree and commit "drivers/spi/spi.c:
fix max() warning" from the akpm tree.

I fixed it up (I used the version from the akpm tree giving the patch
below) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a7c3691456dd..99bc9c513b70 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -644,12 +644,11 @@ static int spi_map_msg(struct spi_master *master, str=
uct spi_message *msg)
 	struct device *tx_dev, *rx_dev;
 	struct spi_transfer *xfer;
 	void *tmp;
-	unsigned int max_tx, max_rx;
 	int ret;
=20
 	if (master->flags & (SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX)) {
-		max_tx =3D 0;
-		max_rx =3D 0;
+		unsigned max_tx =3D 0;
+		unsigned max_rx =3D 0;
=20
 		list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 			if ((master->flags & SPI_MASTER_MUST_TX) &&

--Signature=_Fri__14_Feb_2014_15_55_15_+1100_2zsRs/LQ56NKHwNm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/aG3AAoJEMDTa8Ir7ZwVE4oP/iSKWpxiRRFJviqjzNGWKSx7
3NhOOivWnH+7iyVhngVpZlcik9YHzWljfmsYlPT9wt+qdyTR0Nek/1MFurlW6qnw
PBiNBIGGBZ/nm5yO90kMckG4P+tQ3V3RPiFdkAWgw9a/8cvW6hAvHkRAg3D3iyGM
saiIqjmvglkWyimiT3dPEt1goeNrTkZKBZt8yXNiC+7fgkg2LiGIN6iLkiXK0EDJ
Y3ba1wWzeBaWICwxk5ScbY9Pv3YbZ30PAvU1/Yo9D/E3dOxZMS0VBCCT3GsMOhJc
6nE/w+p9H7Ep1lB+S5xjbcjqRy0gsXj9kJ7yqitu75VODqpkGlUG909EC1xnmlnl
lf1FX4xY2KXbQfWh5K+1w8ALiB9ErniyDpmfgNBWgHKCsypQK92SWdBlF4rRSOl3
lUNVrXx+u4+rtPVQVTTV5SIkXvw4HJIYo76O/dkyG8qZtOOjtsgcuBXey8LKhPNj
1h5iJXGhZt+yjDCy5Poeht94EjJavT6+muUf9b1bLmGZV7mULBkIbWLEIV5Omo2r
OV4SfKDoOqnFQmfpQgxD4i59S/g6fuYJK1061uGkpYDbZclNpa5JJdBZ6Zj1+tvB
JyPFRzc38kaO7AGl13wN9d/r6sdEendL8DF9tOUFNoskg+XvsVITF4n74etvmdFR
Hb8UdfueJ0jNPya8/DGL
=+/BO
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Feb_2014_15_55_15_+1100_2zsRs/LQ56NKHwNm--
