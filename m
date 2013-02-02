Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3BBLwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 06:52:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46235 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3BBLwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 06:52:35 -0500
Date: Sat, 2 Feb 2013 22:52:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the arm-soc tree
Message-Id: <20130202225233.ee33af6d25a42239ae542ebd@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_22_52_33_+1100_R3=5qBbsJyQ6NTty"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_22_52_33_+1100_R3=5qBbsJyQ6NTty
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/platsmp.c between commits b1cffebf1029 ("ARM: GIC:
remove direct use of gic_raise_softirq") and 520f7bd73354 ("irqchip: Move
ARM gic.h to include/linux/irqchip/arm-gic.h") from the arm-soc tree and
commits 89572c77cdff ("ARM: tegra: move tegra_cpu_car.h to
linux/clk/tegra.h") and a8a6930157e0 ("ARM: tegra: Use DT /cpu node to
detect number of CPU core") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/platsmp.c
index 18d7290,2ff68a4..0000000
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@@ -18,11 -18,13 +18,13 @@@
  #include <linux/jiffies.h>
  #include <linux/smp.h>
  #include <linux/io.h>
 +#include <linux/irqchip/arm-gic.h>
+ #include <linux/clk/tegra.h>
 =20
  #include <asm/cacheflush.h>
 -#include <asm/hardware/gic.h>
  #include <asm/mach-types.h>
  #include <asm/smp_scu.h>
+ #include <asm/smp_plat.h>
 =20
  #include <mach/powergate.h>
 =20
@@@ -143,22 -176,9 +176,8 @@@ done
  	return status;
  }
 =20
- /*
-  * Initialise the CPU possible map early - this describes the CPUs
-  * which may be present or become present in the system.
-  */
  static void __init tegra_smp_init_cpus(void)
  {
- 	unsigned int i, ncores =3D scu_get_core_count(scu_base);
-=20
- 	if (ncores > nr_cpu_ids) {
- 		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
- 			ncores, nr_cpu_ids);
- 		ncores =3D nr_cpu_ids;
- 	}
-=20
- 	for (i =3D 0; i < ncores; i++)
- 		set_cpu_possible(i, true);
 -	set_smp_cross_call(gic_raise_softirq);
  }
 =20
  static void __init tegra_smp_prepare_cpus(unsigned int max_cpus)

--Signature=_Sat__2_Feb_2013_22_52_33_+1100_R3=5qBbsJyQ6NTty
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDP4BAAoJEECxmPOUX5FEANwQAIDqL31FIUSkOVfJ5DgiykNw
FotspmVV1RnadYIYv5a6MxdCdfbfYoXWnfBG7ICtD3lGPDCkIr3usivfi/PcbPLv
j7m7BaxQUSMzdt+ZX6v1V8on4C/X4MTNpY+xiZn9kHWNDu1E5KokjVseAWnWsaOk
Q/hgJlIlnieMZcPB6szlYMeh4K2cVxCquotjQw4P5elTzeLkRIl9Lzv9JZLtAnec
8gv7Aglf1a0ZGIdfdct+j0anou5PM0osMfUPWRTC29unnzTfE4wjsInMvrSJASzI
jF6lKS2Yxi854VWA3JsJ1ezFqSswG4dTm7EuwK3U8g3rv7IJ6XA2gonK7MeuFzRd
mtPluA4xTIdkMI1kmCk6AZer8ei7RB4kcpUCmWwbWyj5WzxrGQWg4hnzP8UVh4aL
L9nQnlYU3oP/b6VfH2+36tXPWi8iVk88WIQ7SMd0Ucqx+gZ10Bh9L8v5A6HH/pbW
rHwW16k3ZmT7k8PblQe3zPLjyAw1ROTHuPUaywpLGfyEBT8zbM2U3its9Zu7CCC5
GyAzVd+KwnesgKABnTYFcpziwFFUKfkFX4qXYskAChfmxlLGjqvBQ7foRtkvxO8D
WiULih0WLAHYKxSjztDFVx/2n/ejxMThqVtaq47Ve1MFPcgUS8JGhGBqvLBqIY5c
lGiZaIWk0yHucjtQsi3+
=dSVc
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_22_52_33_+1100_R3=5qBbsJyQ6NTty--
