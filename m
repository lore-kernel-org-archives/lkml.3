Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbbA2DEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:04:25 -0500
Received: from ozlabs.org ([103.22.144.67]:41272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbbA2DEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:04:23 -0500
Date: Thu, 29 Jan 2015 14:04:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Brian Norris <computersforpeace@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the block tree with the l2-mtd tree
Message-ID: <20150129140412.10a5e16a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ESq_PQdUKZ.lM2Ccis=Yu33"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ESq_PQdUKZ.lM2Ccis=Yu33
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/mtd/mtdcore.c between commit 3efe41be224c ("mtd: implement
common reboot notifier boilerplate") from the  tree and commit
b4caecd48005 ("fs: introduce f_op->mmap_capabilities for nommu mmap
support") from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/mtdcore.c
index cbc0fc46d2d6,0ec4d6ea1e4b..000000000000
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@@ -366,17 -339,23 +340,34 @@@ static struct device_type mtd_devtype=20
  	.release	=3D mtd_release,
  };
 =20
 +static int mtd_reboot_notifier(struct notifier_block *n, unsigned long st=
ate,
 +			       void *cmd)
 +{
 +	struct mtd_info *mtd;
 +
 +	mtd =3D container_of(n, struct mtd_info, reboot_notifier);
 +	mtd->_reboot(mtd);
 +
 +	return NOTIFY_DONE;
 +}
 +
+ #ifndef CONFIG_MMU
+ unsigned mtd_mmap_capabilities(struct mtd_info *mtd)
+ {
+ 	switch (mtd->type) {
+ 	case MTD_RAM:
+ 		return NOMMU_MAP_COPY | NOMMU_MAP_DIRECT | NOMMU_MAP_EXEC |
+ 			NOMMU_MAP_READ | NOMMU_MAP_WRITE;
+ 	case MTD_ROM:
+ 		return NOMMU_MAP_COPY | NOMMU_MAP_DIRECT | NOMMU_MAP_EXEC |
+ 			NOMMU_MAP_READ;
+ 	default:
+ 		return NOMMU_MAP_COPY;
+ 	}
+ }
+ EXPORT_SYMBOL_GPL(mtd_mmap_capabilities);
+ #endif
+=20
  /**
   *	add_mtd_device - register an MTD device
   *	@mtd: pointer to new MTD device info structure

--Sig_/ESq_PQdUKZ.lM2Ccis=Yu33
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyaM1AAoJEMDTa8Ir7ZwVEkIP/jHHMrO/vJUTgffYYYhxVhlI
amA2a2auSzpw8p0WYlLdBwGcdh2vL7VwLnUvQjMEJRXiqrdYUhIT7Fz00smgGWYi
Q+Nqq35XseFxngNzWGcPszYYGLfKvdoIECDXJjyL39NX5ntUIyqF4kz6QXrl6mbR
A6AHAO7is10fjqP0ncd0S3vn18FkfYKsvPZbGjKOdh4FnYedY8og4/wyjKTEBfCA
jnL/VHfPFXkkGN3EhI412k5jjvFA8CZsAZB4/36Z5BIJ7+XiYKNM8vFDMNQwNQW8
h5U5JLKB0ki0nD1JZkw2okQ1184QHWH7J7Q9vTR1nEqFmUmiI0OlK5cRpjFUCvqp
geBZuE/kD++4XinpTbgG6Rb4mbo3k+cyv/2DryXrxsOavVA/Z80T0zwxKjUA8C+v
RZ/6gtNragA/ibG+Ru6RR9rwIf2Gg4Hx6IDiPwHXpRPz6va4/e0j0jcyaIftlQw0
MUB38EFktvvCIZz1n1drlJu6n4TodSfJLKnC7sBPBTMkpwX+z+IFXja11xXUiu9/
PjIOiHecB8L2qoDGXobuM6vXptkCNzLq5DewNd9ZzhF1kyc3iA5c5gMmk6W/ObpK
CWTW2v0yb3jQyUuEV0q0ErqQO5/DcZeSgZPMq6BKo+Q7WaE6iY1tBCtUPyO/rfUf
BQlcYQKVoGwMjp8OkmPg
=HR2k
-----END PGP SIGNATURE-----

--Sig_/ESq_PQdUKZ.lM2Ccis=Yu33--
