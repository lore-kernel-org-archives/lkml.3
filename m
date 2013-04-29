Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3D2Hyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:54:37 -0400
Received: from ozlabs.org ([203.10.76.45]:52629 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab3D2Hyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:54:36 -0400
Date: Mon, 29 Apr 2013 17:54:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the xen-arm tree
Message-Id: <20130429175426.9423279609437a2d746cbb7b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_17_54_26_+1000_CH1T9ucmQ6GgzmVh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_17_54_26_+1000_CH1T9ucmQ6GgzmVh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-virt/platsmp.c between commit fe4bff02886b ("arm: introduce
psci_smp_ops") from the xen-arm tree and commit c0114709ed85 ("irqchip:
gic: Perform the gic_secondary_init() call via CPU notifier") from the
arm-soc tree.

The former renamed the file (and contents) so I applied the following
patch and can carry the fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Apr 2013 17:52:27 +1000
Subject: [PATCH] arm: fix for Perform the gic_secondary_init() call via CPU
 notifier

due to code movement.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/kernel/psci_smp.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
index 6ef139d..cd9acc7 100644
--- a/arch/arm/kernel/psci_smp.c
+++ b/arch/arm/kernel/psci_smp.c
@@ -14,7 +14,6 @@
  */
=20
 #include <linux/init.h>
-#include <linux/irqchip/arm-gic.h>
 #include <linux/smp.h>
 #include <linux/of.h>
=20
@@ -55,11 +54,6 @@ static int __cpuinit psci_boot_secondary(unsigned int cp=
u,
 	return -ENODEV;
 }
=20
-static void __cpuinit psci_secondary_init(unsigned int cpu)
-{
-	gic_secondary_init(0);
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 void __ref psci_cpu_die(unsigned int cpu)
 {
@@ -84,7 +78,6 @@ bool __init psci_smp_available(void)
 }
=20
 struct smp_operations __initdata psci_smp_ops =3D {
-	.smp_secondary_init	=3D psci_secondary_init,
 	.smp_boot_secondary	=3D psci_boot_secondary,
 	.cpu_die		=3D psci_cpu_die,
 };
--=20
1.8.1


--=20
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Mon__29_Apr_2013_17_54_26_+1000_CH1T9ucmQ6GgzmVh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRficyAAoJEECxmPOUX5FEfC4P/3BDqp2gyDOZf0IJ8GXgGCnI
oKmL+poxxZuLEgTXeEAqA9/VW466B9O2wPYmroOo9iOCpQfOs7AB1JTbwELqY6Fx
Htjy2x/F/eOuywitjXQujTHf4Yc3AshoroBnO6fsOFVehFQ9VDl+s/U2a013uUwa
U478OEJaj0rP2zTnxaI6MA4/EP9EO/RdQZk+IO4goPVrYSzh2jlhEULCQ0WvVrB0
5JwOQaxbAL/GfZAMDHc0J7AyM4lUP3n9o9sDBRUu3D/zqLXkBT9q+ONfcMXenAdf
JShoooOqVIVoOr5TCmE1vKA/2ysyQO6MxaaCqP9uX8+eV0h9B5m1gowhLX391nRg
57m9ubRDbxvAbWJG6m597w0SAkTO1O2iZ6T7ohPinqqQkotcA0usQQnOUl56N7Fy
ZirVW8e4JQLJoB6khwOwiCsFRD9xggb9zARIRf28pWMKy8lnMmOIqZ56bbSmjsp8
AtqdtKIJyCqNYLu57JwTDwdCp22wHsixXUJKMrN2tWoFBaYnM4cYsMr9MOxaIEd+
aHVJFTOsBHUNc5twT6qgbFo7Lvq3GV5DUxcXb7Xv4id6JabjXCYoSX1zy/XVG9Nz
V1qjgbSle46O8VMiQeEZrKWHvUN8CV2qSmeWg3X+4iMXn3I8FDuL52DmRKJyog4L
UcsotSzlA7TJuvI7oJyC
=w3bO
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_17_54_26_+1000_CH1T9ucmQ6GgzmVh--
