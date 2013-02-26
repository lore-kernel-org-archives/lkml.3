Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab3BZApV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:45:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42634 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BZApS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:45:18 -0500
Date: Tue, 26 Feb 2013 11:45:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hadar Hen Zion <hadarh@mellanox.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Shani Michaeli <shanim@mellanox.com>,
        Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Message-Id: <20130226114508.0f8d1101156f9f4a309579f6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Feb_2013_11_45_08_+1100_5VQ.Sey5M+0YYHMR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Feb_2013_11_45_08_+1100_5VQ.Sey5M+0YYHMR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/net/ethernet/mellanox/mlx4/mlx4.h between commit 23537b732f5d
("net/mlx4_core: Use firmware driven flow steering hash mode") from
Linus' tree and commit e448834e3545 ("mlx4_core: Enable memory windows in
{INIT, QUERY}_HCA") from the infiniband tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/mellanox/mlx4/mlx4.h
index ed4a695,8b75d5e..0000000
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@@ -60,6 -60,13 +60,8 @@@
  #define MLX4_FS_MGM_LOG_ENTRY_SIZE	7
  #define MLX4_FS_NUM_MCG			(1 << 17)
 =20
+ #define INIT_HCA_TPT_MW_ENABLE          (1 << 7)
+=20
 -enum {
 -	MLX4_FS_L2_HASH =3D 0,
 -	MLX4_FS_L2_L3_L4_HASH,
 -};
 -
  #define MLX4_NUM_UP		8
  #define MLX4_NUM_TC		8
  #define MLX4_RATELIMIT_UNITS 3 /* 100 Mbps */

--Signature=_Tue__26_Feb_2013_11_45_08_+1100_5VQ.Sey5M+0YYHMR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRLAWUAAoJEECxmPOUX5FEWXoP/ipAtcUnrZtBgk0zBNCOXBZs
PBEZbRhdyqLIVOwGkYDk53hyK4EzkvQw/3zpUXud85LEzl433sjFqLu1EVYowjzn
cYuXa8vYi8C3ehi/PImceRQttLjn5zIoFUoVTO54ks04m96+QQKnrfjBzRNIMcvV
ct6EpiqgaiQHFlxM9Wy1ai452uap2X2EYnGfOUAvStsxAry1FwmJKRb9lobWeDHD
GveG+n5oArmkDgntLN/fS//yXdkEihdWMBwyonmu7+RwMbRdqeiN4tDhsb/z35tF
b/68zE+eIrqbj8Ngcwpt77V5Ql3DlbiECO6e/jVyiWCcuW9t4D6fM1rS/et+ZhlF
iv/MHmPVBd2XWrH6EmCVpRQOvq6eeiEoIW8lnRuUHq5kJzzaycvs83PJHMPE4TGt
2sYmAB8G7vk9mEyqyjt/baPD4iDfk+Fl4ZAnlZ3SVACfV2RuUj3nrL12ZZXEumkr
JsodduCYAxv/kL4AWCeuSn3GdjuwOOICSvpAfxJOvTanr6JK/iODxNWH0ypnHnAB
ENMD1B3ctABIwilPPYyIEkZpUW4mh9vyubG9RwjllDK4UDyq2xrbh11WhtHL4Tmd
gg0ymFPsJul/KVtFqkYezkIcVPOjqofiojotHzbcXskcq7gjQdkpdNSrCDkzd7VC
iv0C5w77WdYfA7YZ3zVo
=YK2k
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Feb_2013_11_45_08_+1100_5VQ.Sey5M+0YYHMR--
