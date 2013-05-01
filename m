Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3EAGom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:44:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37331 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3EAGof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:44:35 -0400
Date: Wed, 1 May 2013 16:44:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hiroshi Doyu <hdoyu@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20130501164423.1233db0b618d0e6b7184c05b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_May_2013_16_44_23_+1000_6cBp1.wTVVK=undr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_May_2013_16_44_23_+1000_6cBp1.wTVVK=undr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-tegra/hotplug.c between commit da2265b130f6 ("ARM: tegra:
remove tegra specific cpu_disable()") from the arm tree and commit
7469688e832e ("ARM: tegra: Unify tegra{20,30,114}_init_early()") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/hotplug.c
index e8323bc,8da9f78..0000000
--- a/arch/arm/mach-tegra/hotplug.c
+++ b/arch/arm/mach-tegra/hotplug.c
@@@ -12,8 -11,10 +11,9 @@@
  #include <linux/smp.h>
  #include <linux/clk/tegra.h>
 =20
 -#include <asm/cacheflush.h>
  #include <asm/smp_plat.h>
 =20
+ #include "fuse.h"
  #include "sleep.h"
 =20
  static void (*tegra_hotplug_shutdown)(void);
@@@ -46,18 -47,22 +46,13 @@@ void __ref tegra_cpu_die(unsigned int c
  	BUG();
  }
 =20
- #ifdef CONFIG_ARCH_TEGRA_2x_SOC
- extern void tegra20_hotplug_shutdown(void);
- void __init tegra20_hotplug_init(void)
 -int tegra_cpu_disable(unsigned int cpu)
 -{
 -	/*
 -	 * we don't allow CPU 0 to be shutdown (it is still too special
 -	 * e.g. clock tick interrupts)
 -	 */
 -	return cpu =3D=3D 0 ? -EPERM : 0;
 -}
 -
+ void __init tegra_hotplug_init(void)
  {
- 	tegra_hotplug_shutdown =3D tegra20_hotplug_shutdown;
- }
- #endif
+ 	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU))
+ 		return;
 =20
- #ifdef CONFIG_ARCH_TEGRA_3x_SOC
- extern void tegra30_hotplug_shutdown(void);
- void __init tegra30_hotplug_init(void)
- {
- 	tegra_hotplug_shutdown =3D tegra30_hotplug_shutdown;
+ 	if (IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC) && tegra_chip_id =3D=3D TEGRA20)
+ 		tegra_hotplug_shutdown =3D tegra20_hotplug_shutdown;
+ 	if (IS_ENABLED(CONFIG_ARCH_TEGRA_3x_SOC) && tegra_chip_id =3D=3D TEGRA30)
+ 		tegra_hotplug_shutdown =3D tegra30_hotplug_shutdown;
  }
- #endif

--Signature=_Wed__1_May_2013_16_44_23_+1000_6cBp1.wTVVK=undr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgLnHAAoJEECxmPOUX5FE0EsP+wZBhYdWkVYf9/bDgFGJMjyw
mcEv+hx5BcTRmfMsQPlFDZIk3uvlejQoOQiEv4ws1Y9jweFMMlh3msVcEzLlZwyu
o80NE43eMHDBjHRWV3r/Hdi+fBjcXg+G/flYhG3H/0KtEb8I5znpJCkm2GHiXk2u
b+s0UPcAwD2OiCF488lncPji7CNt02kX5qaajlLs5pHiSfBBIweoVwCgQPXGEi4K
FVcKHan8dvmZzHabTBrrTd8gT2c3fI2fR6hFEVcZ6xerDasHXtXgXL+lFkJ7Tvko
movs/SYwyX05d3JV5EyiQZnYev/27d47K3ZiWOkUEm+8cNIi9qBZR/zVTTEN5+un
Rnm57mqrqpU7KPJnzyp30xY62v71mzRRutWnTS/NKV1D16ZG/sV/D//KcJohREhY
1RpV5BVbqu+gmPuANskMFaHgQSqVZZWQcdylr29XLip3CFWzW1WXcqavpjcsBDlo
Zdni8z9OBpwoZM2oygBQTxlOXM4Az0wGRCzuCgQysN30IUkNrBvhFOW8cQ2RUNFa
GYaGWsW1Op9d4R+ix68YOHSYvYhm9/9APBoX36zfTVLZcoff/EFBgEBfiAIo29E/
0G4UX67C6Wmt4F7pzK9x0jVhzjTfSt5yChKBFWkNe7JSUyuPYTZnF4rDMgGJN95C
F2Oa4bmeQsRVf2Fy7ZaB
=QSHt
-----END PGP SIGNATURE-----

--Signature=_Wed__1_May_2013_16_44_23_+1000_6cBp1.wTVVK=undr--
