Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3ARDZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:25:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39058 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3ARDY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:24:59 -0500
Date: Fri, 18 Jan 2013 14:24:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130118142457.796fa6b444cfc0f8c0cdff0a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_Jan_2013_14_24_57_+1100_R=PQbQYtqi7JyE+4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Jan_2013_14_24_57_+1100_R=PQbQYtqi7JyE+4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-exynos/mach-exynos4-dt.c between commit 1d5cc604f42f ("ARM:
remove mach .handle_irq for GIC users") from the arm-soc tree and commit
d99de316e599 ("ARM: EXYNOS: Add support for Exynos secure firmware") from
the samsung tree.

I fixed it up (as supplied - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/mach-exynos4-dt.c
index 112d10e,ab1dacc..0000000
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@@ -106,9 -107,11 +106,10 @@@ DT_MACHINE_START(EXYNOS4210_DT, "Samsun
  	.smp		=3D smp_ops(exynos_smp_ops),
  	.init_irq	=3D exynos4_init_irq,
  	.map_io		=3D exynos4_dt_map_io,
 -	.handle_irq	=3D gic_handle_irq,
+ 	.init_early	=3D exynos_firmware_init,
  	.init_machine	=3D exynos4_dt_machine_init,
  	.init_late	=3D exynos_init_late,
 -	.timer		=3D &exynos4_timer,
 +	.init_time	=3D exynos4_timer_init,
  	.dt_compat	=3D exynos4_dt_compat,
  	.restart        =3D exynos4_restart,
  MACHINE_END

--Signature=_Fri__18_Jan_2013_14_24_57_+1100_R=PQbQYtqi7JyE+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ+MCJAAoJEECxmPOUX5FEdzwP/RBxbyTt8h++KG9JvR0aGoUx
Tu/ucQo4vo+GuB1XEHfznj6Qaa1VioS+9NGrJFaxVAg1mjUnYQdESa7GteVDMGMp
oOTb4QiparOh/3k0SEjqCKRXA9R5Eb/WsQicQmxd7H/DeAxrcI2dx6/r9bDj74Vn
qHRK+1ZoffROJF8GXw+HtrrE2HylV0sZOiFeUHnGysUUasm/HLatj9Qzf7f/Y3w+
X5xdgey/Lk/WZW+SezpqrwFJW3E0JnNfn0aIBqmqkqx/KWvo+EvJk3fCNyKdIUoC
k6BINyJtWqzdiokEO0jxmZU0M0eUO1I75O1h67SxjuEIddmEO8UdG+akwMwvB2U/
7QfnIq2ymsuTBQDrRad4G1/qIgJCv2pCCaykurPfwW2BVUBwvPzm5RsUFV+1xF+O
YeqGiXV5Xmn32oNGfYA1a9a99ieK4xq6A+lweGSj7yeNXMGZsM+IRKfhuY90U21Z
otLzxL8cgSqkEBun6og+RNajSPAlv1cxY8LHuwu/8FwLfq1w7h2XJN8WyPmY3Ju1
RzVbsQekcVBdn9usqkGN0ySoYe8V9lapxXQ2mqxmZy75EflirBkWE6w1MZEHH9wD
XQEw3097/xKwjMU8+wOurCIfuXJdOc9uPNBxSLi/29FxhwXs92Ccdgvgp9E0qVb1
hh3rMI+DUDh8jcYioIGH
=EM1S
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Jan_2013_14_24_57_+1100_R=PQbQYtqi7JyE+4--
