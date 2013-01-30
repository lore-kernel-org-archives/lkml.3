Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3A3Osc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:48:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59845 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3A3Os2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:48:28 -0500
Date: Thu, 31 Jan 2013 01:48:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130131014827.09251ece97f74377abada4ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Jan_2013_01_48_27_+1100_B1vb+z.lc=M0+X/+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Jan_2013_01_48_27_+1100_B1vb+z.lc=M0+X/+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-exynos/common.c between commit b533c8685b16 ("ARM: dts: fix
compatible value for exynos pinctrl") from the arm-soc tree and commit
d28a60d89c83 ("ARM: EXYNOS: skip wakeup interrupt registration for
exynos5250 if pinctrl is enabled") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/common.c
index 68c0689,cdaa55f..0000000
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@@ -1035,8 -1112,9 +1116,9 @@@ static int __init exynos_init_irq_eint(
  	 * interrupt support code here can be completely removed.
  	 */
  	static const struct of_device_id exynos_pinctrl_ids[] =3D {
 -		{ .compatible =3D "samsung,pinctrl-exynos4210", },
 -		{ .compatible =3D "samsung,pinctrl-exynos4x12", },
 -		{ .compatible =3D "samsung,pinctrl-exynos5250", },
 +		{ .compatible =3D "samsung,exynos4210-pinctrl", },
 +		{ .compatible =3D "samsung,exynos4x12-pinctrl", },
++		{ .compatible =3D "samsung,exynos5250-pinctrl", },
  	};
  	struct device_node *pctrl_np, *wkup_np;
  	const char *wkup_compat =3D "samsung,exynos4210-wakeup-eint";

--Signature=_Thu__31_Jan_2013_01_48_27_+1100_B1vb+z.lc=M0+X/+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCTK7AAoJEECxmPOUX5FEvLwP/0WMwwq/xc1kehjtPwMVyXHd
8bQjaWttxlONTMyQntFoncD+8DRfnRmb8fX4H/47YHEzWHo6QXCWg0X4TgP42yB3
jqT3hyL5ISYt2wzH00oqEZdEjVb28xcgPT/TKMip7IYIxd7cK2Xdgg0ns/SYvF45
P9XnF++BMtK+88G1rJpKHyOrmZxygi0tXZfkP3gj0tT//FYfSAhl1KLcS8NvI8/K
i10O2SJtMRGQwHI8ZipkQMJhUAo2oC7gtFsEvLurnyacQ4PPTbuSISs2UfQ1D/Td
swJmtlOesGJcozQBgxwUD1NRF24Ns1YYezyNfpphLwviXNkKsWj5thVxQvOh5VBm
vhKsWrHjTxefZfHLUYQlVeBkK0NE5F8T+BZ9vGiN5YrftnxCLUyFWkdrovKcRH8J
SbXcdXQDaPb0QFjzVlLV9sWx9U7ogXtuxl1IzC10YPVAtlv0FUbgi+I6hRMELajD
FnRt0TD8Yg7x5AH39qMyCnbIohcmvFQSXc3AAg+t1Zuy1tOMQ1CGGikMYx7zVTU6
H6ZcYMOd3oXLCpk66PlGX2/8yOoUqe/KTaYy4Oki46PtMSoEYrfFpFGASkZy9/J1
507XOyePyo9pAc7aIkpNNxJkKkP0EMT1xPiGj3YQs1KF3pRfGHQSt/3P8ZPuj3Fp
BgSwSYed+Y7pqmsopzLE
=fKM1
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Jan_2013_01_48_27_+1100_B1vb+z.lc=M0+X/+--
