Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3BBLpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 06:45:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40894 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3BBLpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 06:45:34 -0500
Date: Sat, 2 Feb 2013 22:45:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hiroshi Doyu <hdoyu@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the arm-soc tree
Message-Id: <20130202224524.d7c224291a52d6cede31f6b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_22_45_24_+1100_S6jrWk2/5SKh3Atx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_22_45_24_+1100_S6jrWk2/5SKh3Atx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/common.c between commit 0529e315bbda ("ARM: use
common irqchip_init for GIC init") from the arm-soc tree and commits
61fd290d213e ("ARM: tegra: migrate to new clock code") and 5c541b884c09
("ARM: tegra: Add initial support for Tegra114 SoC") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/common.c
index 3599959,2f13513..0000000
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
@@@ -56,10 -58,17 +57,11 @@@ u32 tegra_uart_config[4] =3D=20
  };
 =20
  #ifdef CONFIG_OF
 -static const struct of_device_id tegra_dt_irq_match[] __initconst =3D {
 -	{ .compatible =3D "arm,cortex-a15-gic", .data =3D gic_of_init },
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

--Signature=_Sat__2_Feb_2013_22_45_24_+1100_S6jrWk2/5SKh3Atx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDPxUAAoJEECxmPOUX5FEXGgQAIMuSQnGhI+i7nfX9jo1My8b
3wcQA6xR2g+YQ6ml9ygZAHBPbHc47V60AZXD7ih9WK29x25sadABeuhpjciGM3W7
6IED2nkfEPfj/p303+BsBQro1+MI1CWDbzc24GU2jHi61jmLnx4PP9VFIPAsVHRA
Cdq7LNNfR6B+8hVLYxK2yMYyVNEimUuThrYN44VtJCplPTFjUQ8Zi1LAOc5eGa2O
J2mNzeo3YWlLDJroi8XuhzzGQIWA7ZZdKkMpgTf4D4FvducTVg7XOOTbCBIavSND
9HE+NTnnPSdGphIpAorgQavsWRyFAizfnhYr4pU/DNuirqLrtu0C70jUPc9oSQNC
UROH0mikfsEC2Tjv8vJ2UKmdQmrBs208/68g4kJOGD0yIkyH7Z2HIwJtMgOerj0G
zh3NSkSNJ5KpvqqdK/4WF3x/13tcUd8zLw0n0QE1A8xNr5TTRzyGEz1kJfd9d/wG
Z69ipCxEuebUeH7yE9N0OquyZsdoa+Mfnqon+//WL0jl73OUAIJuVZzk5nabs5OB
X11BKNPkrk9mbXUcVOAOQdDq354U680KuSI9jnpeSogwfIS8JzeQxFAZ8/SPqhz8
yc2aYFRuCyW+TJxE2uZ6VSTEwc1aqCnEZHWqNq7Bm+uOt2ozzGaCgc2cOE6bT8TD
2wsLTkfzZ0ytrj4691bx
=VjXY
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_22_45_24_+1100_S6jrWk2/5SKh3Atx--
