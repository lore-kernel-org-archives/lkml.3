Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaLPBlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:41:35 -0500
Received: from ozlabs.org ([103.22.144.67]:49191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaLPBle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:41:34 -0500
Date: Tue, 16 Dec 2014 12:41:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Haggai Eran <haggaie@mellanox.com>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Message-ID: <20141216124123.14cdc5a4@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4P.dAzbqnKVPzSSjZQ9onL/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4P.dAzbqnKVPzSSjZQ9onL/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/hw/mlx5/mr.c between commit 479163f46082 ("mlx5:
don't duplicate kvfree()") from Linus' tree and commit 89c925949c1f
("IB/mlx5: Implement on demand paging by adding support for MMU
notifiers") from the infiniband tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/hw/mlx5/mr.c
index 5a80dd993761,a2dd7bfc129b..000000000000
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@@ -856,7 -1009,8 +1012,8 @@@ static struct mlx5_ib_mr *reg_create(st
  		goto err_2;
  	}
  	mr->umem =3D umem;
+ 	mr->live =3D 1;
 -	mlx5_vfree(in);
 +	kvfree(in);
 =20
  	mlx5_ib_dbg(dev, "mkey =3D 0x%x\n", mr->mmr.key);
 =20

--Sig_/4P.dAzbqnKVPzSSjZQ9onL/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj43JAAoJEMDTa8Ir7ZwVTcYP/3YfhoJLHUXawJqE/GlF+Xjx
6vntRmj3IV7EBmf2UM9vgJfTXCm87+N35m2ESr790GnYISq9ZGeqNd8xOL4W++V0
HUloh0L7Tf2JOuzDIgS/7rwTJLwDb5QPu9ghJSejeOR17REg8wbXmKUyiwZgbn5W
OGQEdGzJYu6ntZouUFHGESBFRubv65fE+F1fazmb3B6zJPgJ42nSMeU4amQ5D/ai
CrS7VZEbMV0vS2aIVQ43rjg/sFgs0e9zj3saYomeMc8OjHe/VTRGpI6tvwIUprQz
FGCKPlAboWY0iTo1CVIfMHDhvZ+GRehVqFijO8tOqpJBRM7yXkZCmLp5lkoySEWy
H+K/0M4idzPp6FPYS7YBqj9EllipLCEj2RQ/WbUa1Xs9l7GX/Lul9M8TKDO06vAG
bJGYUjLFf7TZhJ5CCDTnwe9ZjIdE4wAgR68PzET0hG0QAl48x5zXni1EnIMpOTld
hFVJ07bvqjO6MhsbC4A6vVH8qt3F/qGSku7pR0RP/26ePRnGSk15PqVE4O+KkvkF
1hy38QEJZv8og9Ujb26IpHaEuYtKVz/jQAJN2zlopFxaah9y7VccRf5rFZrP7jOR
fgCo7wRZocv3eEINryY+FKzNOZNg2my9Jruw5+n6ScDTv4jRTlayiI0HU2Jl7r1p
LbwzXqt9dKjk0DD22IcH
=PPMp
-----END PGP SIGNATURE-----

--Sig_/4P.dAzbqnKVPzSSjZQ9onL/--
