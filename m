Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3AWFZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:25:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42444 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3AWFZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:25:48 -0500
Date: Wed, 23 Jan 2013 16:25:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the arm-soc tree
Message-Id: <20130123162537.b4285c002892dde1405559a6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_16_25_37_+1100_uA3oaJ_o_E/ME6W2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_16_25_37_+1100_uA3oaJ_o_E/ME6W2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/common.c between commit 0529e315bbda ("ARM: use
common irqchip_init for GIC init") from the arm-soc tree and commit
567f70da22d2 ("ARM: tegra: migrate to new clock code") from the tegra
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/common.c
index 3599959,87dd69c..0000000
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@@ -21,9 -21,11 +21,10 @@@
  #include <linux/io.h>
  #include <linux/clk.h>
  #include <linux/delay.h>
 -#include <linux/of_irq.h>
 +#include <linux/irqchip.h>
+ #include <linux/clk/tegra.h>
 =20
  #include <asm/hardware/cache-l2x0.h>
 -#include <asm/hardware/gic.h>
 =20
  #include <mach/powergate.h>
 =20
@@@ -56,10 -58,16 +57,11 @@@ u32 tegra_uart_config[4] =3D=20
  };
 =20
  #ifdef CONFIG_OF
 -static const struct of_device_id tegra_dt_irq_match[] __initconst =3D {
 -	{ .compatible =3D "arm,cortex-a9-gic", .data =3D gic_of_init },
 -	{ }
 -};
 -
  void __init tegra_dt_init_irq(void)
  {
+ 	tegra_clocks_init();
  	tegra_init_irq();
 -	of_irq_init(tegra_dt_irq_match);
 +	irqchip_init();
  }
  #endif
 =20

--Signature=_Wed__23_Jan_2013_16_25_37_+1100_uA3oaJ_o_E/ME6W2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/3RRAAoJEECxmPOUX5FEfS0P/RLcYRrXi+Rju9B/1IVUPSzv
QDv7sh8llkdNFWKJDmE3FwHNOTnhLeaTOIgKaxt3snUFL/TX/sPlLzMhbpUYxW4e
MSKgeRoWQMYRzmDcobJm4fH5olSxVwSFMOrdAi3d5U4p2Bh/Xk7nRrkYBYAmSLlO
yZrQTKx2uctx2tDEA+tL+VRAyVLVMnJDQxvwAdbOyOeYVOHMuIx/PdtHDU67yG/Q
w+5Ge4kg7eeRDDLNfq+q7yxMKHdbU3M0KwxxCD0xZ52RvaK5j0DUuPwFcBt70g66
WvN2EcXFoudlWpXxxPHvyNHfpdeQUP0Oeh+ekUVHyBh8Xhyxu+k81/B9rwnDGfEI
oPvSZYYHSx2gR4Wd1fFLq5qA0f7H/F/xL24c+WzyKdK1e6n/+lGzY8DkHRI4e5vm
Ix1pPNFDcQD1cOdC5hIcqFYN84FMihz39oabkBlyoXXYza5GtT/gDuPPHx22kolJ
tcz8hVWPOITZ6aBfmUraiJSDjPXBadZux6ggy6kwsTdDWKTeuZhT+3tj5gDWO196
ygLU2vpBzbIGMwZQUxe0rY/DHM9lYPNYXyJXthQF1esBPcyyMM1n04rHFmN092OF
7Q4tqr2F9GJkCVfKqjRaXsYmgMeE6p6p0g7y9JhgYZ7sPokipxzxnwhUxmOXHe86
tS5j8jZBNz1RAQbH71jk
=AwBb
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_16_25_37_+1100_uA3oaJ_o_E/ME6W2--
