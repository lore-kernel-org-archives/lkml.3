Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbbAUDSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:18:44 -0500
Received: from ozlabs.org ([103.22.144.67]:37183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbbAUDSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:18:43 -0500
Date: Wed, 21 Jan 2015 14:18:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Brian Norris <computersforpeace@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the block tree with the l2-mtd tree
Message-ID: <20150121141836.50c26e27@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zO6cReBlcjg6gvTlXQeXoZV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zO6cReBlcjg6gvTlXQeXoZV
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
index cbc0fc46d2d6,ff38a1df22f7..000000000000
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@@ -366,17 -339,22 +340,33 @@@ static struct device_type mtd_devtype=20
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
+ #endif
+=20
  /**
   *	add_mtd_device - register an MTD device
   *	@mtd: pointer to new MTD device info structure

--Sig_/zO6cReBlcjg6gvTlXQeXoZV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvxqRAAoJEMDTa8Ir7ZwVYqwP/3TI1LdOdHBNbCTlZgmtGN2N
n1zj7/DMNaIZvEYfnpY/R2pkgkj8mhcN1uJwV11SyxRK3e9LzftYVTl04ByFYqry
Q1I4HiNnEvtpVke6rHp6QmWy+Y77fItb5wINdFbx1Lc0mMI/p8W5W1/FwY4nhe46
LzPlSYdsf/pLlkXTvKwy/DKRoHfSsiCup87mA8rY3saCZnWthWaCA2w/CdR8IVhq
6CK9tF86jdTP8BhurxPAa3pajb7qbv+xhZzZlEZA8QO/dNtkpGyU1YjHwZ3jFLcG
jOUwAwUoO66UWt5ussUzw5fu20gG2rD2d+mTADh750oqlrGL7D9tKYussebiX1or
e3hQbgPgdffCDn4dh8EqWel40PQwShNDpIteRqcUpvN3+N5DHyFc88AXHzxGQv0h
AtXrLC+lP+R+fUSVjJwpIfTN+dmCBf2kuuD03HDEg9vA/3zpcyEoxx7GMg+usssY
F5zjaZhzMGW/xnq7Uh4KG4pXfNlb3vLJEchFSAVdOVJi8jV+eLdqfZFXpR9HMEsU
4cUUfrSK9nOaQPLLuHnxWPAFRJB9xrTYhQw8cMFf5Fp/e0i5qQocQ9w+lca114o/
exeZZSx0a9RNsX1nLDTKOQqUsGl/PG2jHUHVvZ6q9fxrkjQR+rkTx7oStg5RqtkG
+Ir27pM13YBt5GWjMDWc
=v+Mz
-----END PGP SIGNATURE-----

--Sig_/zO6cReBlcjg6gvTlXQeXoZV--
