Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaJOArI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 20:47:08 -0400
Received: from ozlabs.org ([103.22.144.67]:54552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaJOArH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 20:47:07 -0400
Date: Wed, 15 Oct 2014 11:46:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Message-ID: <20141015114653.1a55081c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0n3JkOwKLiY6iSmA=.YGLan"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0n3JkOwKLiY6iSmA=.YGLan
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/hw/mlx5/qp.c between commit c7a08ac7ee68
("net/mlx5_core: Update device capabilities handling") from Linus' tree
and commit f83b42636a91 ("IB/mlx5: Remove duplicate code from
mlx5_set_path") from the infiniband tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/hw/mlx5/qp.c
index dbfe498870c1,f1b49e024664..000000000000
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@@ -1317,6 -1302,11 +1317,11 @@@ static int mlx5_set_path(struct mlx5_ib
  	path->rlid	=3D cpu_to_be16(ah->dlid);
 =20
  	if (ah->ah_flags & IB_AH_GRH) {
 -		if (ah->grh.sgid_index >=3D dev->mdev->caps.port[port - 1].gid_table_le=
n) {
++		if (ah->grh.sgid_index >=3D gen->port[port - 1].gid_table_len) {
+ 			pr_err(KERN_ERR "sgid_index (%u) too large. max is %d\n",
 -			       ah->grh.sgid_index, dev->mdev->caps.port[port - 1].gid_table_le=
n);
++			       ah->grh.sgid_index, gen->port[port - 1].gid_table_len);
+ 			return -EINVAL;
+ 		}
  		path->grh_mlid |=3D 1 << 7;
  		path->mgid_index =3D ah->grh.sgid_index;
  		path->hop_limit  =3D ah->grh.hop_limit;

--Sig_/0n3JkOwKLiY6iSmA=.YGLan
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUPcQHAAoJEMDTa8Ir7ZwVc8YP/jVsDhMHsVrPby4qJyYYuTwB
SYLu9Uq9FY2FshbcWhBJ6Afb8E3SzYqzapcdI9VWj9sPrM6yAVr4o7vdYYB0kXGJ
jMn8jLFm40VoyNw2yLbsrwG9W1W/6CHfuZ0Rr/AXHEEbd4NTZwzmeLSf5mCe2w7K
2h6IYDV7TchIz4ZARLmX1TH2E6CMS2mgBhDVcqIIhPi6X16aENRzkaQs6YhAugFt
2ohXx2K2pRFMPEBgfCpTeK0TebvMKQMgICp4Izxfb0358Um7+LbIsjLie+MpTNkN
WGGDeBXNCOfe3LUAwb0yHhHC+n30GwspheGU7klE4OhyuwlHk/686Q+clxQ4AvN6
CvZe85xtH7oZK0xsyckUY1dcLlhePdGe5n7M2KpZRlJxpeU3s6cEdIqupwJxxBW3
Nd17laCP2UnspnP60hcK3L8Vk50yNsaK12nU8/ecZyfxmwu4CDa5Trg1zaH+5jgb
CnSRThjex81oX3rEB2thc5lDFT8QOiOSxCzzzQupMi6RCxlOAjpanFT2iK/Jjnnd
4TJPbxCpNCDmSzt4K/6chbGgGe7eXoIGzzAmTote/Ty6cO9UQsaH3D3yQdsir1G3
RXx3CTKyiyZqloGZHj21hOFCbBvw7ZjmDLb8Cox00JGvUAY4aUDRg94f2eoAqvhM
Yv1oEX0LJX1WLG2/lDDm
=nECD
-----END PGP SIGNATURE-----

--Sig_/0n3JkOwKLiY6iSmA=.YGLan--
