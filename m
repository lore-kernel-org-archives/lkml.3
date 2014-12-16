Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaLPBr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:47:58 -0500
Received: from ozlabs.org ([103.22.144.67]:41251 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaLPBr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:47:57 -0500
Date: Tue, 16 Dec 2014 12:47:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        Haggai Eran <haggaie@mellanox.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the infiniband tree
Message-ID: <20141216124750.153e3fdd@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UQQO4pX7abOKhts/BrsgpgH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UQQO4pX7abOKhts/BrsgpgH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_query_device':
drivers/infiniband/hw/mlx5/main.c:248:34: error: 'MLX5_DEV_CAP_FLAG_ON_DMND=
_PG' undeclared (first use in this function)
  if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
                                  ^
drivers/net/ethernet/mellanox/mlx5/core/fw.c: In function 'mlx5_query_odp_c=
aps':
drivers/net/ethernet/mellanox/mlx5/core/fw.c:79:30: error: 'MLX5_DEV_CAP_FL=
AG_ON_DMND_PG' undeclared (first use in this function)
  if (!(dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
                              ^
drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function 'mlx5_start_eqs':
drivers/net/ethernet/mellanox/mlx5/core/eq.c:459:28: error: 'MLX5_DEV_CAP_F=
LAG_ON_DMND_PG' undeclared (first use in this function)
  if (dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
                            ^

Really?  Code added half way though the merge window not even build
tested?

I have used the infiniband tree from next-20141215 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/UQQO4pX7abOKhts/BrsgpgH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj49KAAoJEMDTa8Ir7ZwV16IP/15ZzM3O90EgQsDh2NCZ9HyK
SuPkUwMoLbI+/a4TjbvxddCBtxb6WXLnxyin8uUT+92ZtH5wq/bjqL2OOeNutL1s
x0uVOfWBu0L6FLvZlE/sdTNW5w1yQbDX6jRrSrupjGVffCYbYU+vC4p9ylceMpoF
TeQczsZFZp8FDiKXa4nSOV4Fp2zLvZtk4G74kPyFVf6AVl/l4+Uc+UmhzjbQKk6s
h4+RfqVo76xU5qRnWEogJiJnLV1zlgI3HN+WOZUKTDa3O4grIJMvax2odYGNPUF9
HrQsRqyLsGcFXjH+thTEArcEpYJ5Bhq7plvK8Gv7d1FfIzxgoNqCHKVnTaWdXr2s
yENlVsWca4pJyN9ioCvzjDRz3M4v2OtfErEc2/cC30akOGKHO8HbDWkKrGvfw9Gd
McWGPFS11oCfYoKH5KIRBvexVJvnyLlFuxYwRCLUCN0QmJHqlJoFTy4gbnxtxukw
qV7ncDpdTaR5eJRtU0Rz9BL3ZTFO7HDTgyE26GwNrFWThMWivstLtMV9n1Ip/D/2
yWmq12ke48aQ27IiE68sPgHzS0yI91q7KebKd/5agxYrJaAv2QmrHMJ2AvwZRjkf
ezvN3bnRUzeLIydVa2gRdk109ozVoGbl5ziXiYvjAnmbgYVfSIyv43neeuGNskhc
Vv07z9NgxQeLshEZh9tf
=HGnS
-----END PGP SIGNATURE-----

--Sig_/UQQO4pX7abOKhts/BrsgpgH--
