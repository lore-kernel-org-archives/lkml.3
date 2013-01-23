Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3AWFak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:30:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45414 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3AWFai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:30:38 -0500
Date: Wed, 23 Jan 2013 16:30:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the tegra tree with the arm-soc tree
Message-Id: <20130123163036.4791935db9e9539c4313c97f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_16_30_36_+1100_+8DozrnPOnmx9EGr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_16_30_36_+1100_+8DozrnPOnmx9EGr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/platsmp.c between commit 520f7bd73354 ("irqchip: Move
ARM gic.h to include/linux/irqchip/arm-gic.h") from the arm-soc tree and
commit 4c6e1ff5b5fe ("ARM: tegra: move tegra_cpu_car.h to
linux/clk/tegra.h") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/platsmp.c
index 18d7290,3ec7fc4..0000000
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

--Signature=_Wed__23_Jan_2013_16_30_36_+1100_+8DozrnPOnmx9EGr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/3V8AAoJEECxmPOUX5FEUM0P/2OollIZsF76Z4N66Ld+v4GK
AGVkeMVh6r5IQDOGSkt+yt8/mcQVYB1uPr2xxPN7oLJcr0jX4ZbjV058R1CZ/Vpw
5O+xWmBeXxKVyT2nHgyBy80n+psAEBrEVsdaWlKwaPlhJj821OAL5o0bRcRyRpaX
zJM6ZzLTXomsdAPnzYr6xWu4k/i5Zke3RJ0O1r7lI9CZSAMtVGU1T0hKkSVFunXI
eYcpIxIK9+BWJ4CuVq1tZustrmLGDNiYd+bnBiYgcObvmhTPoXTLvYS4F3pgqSnS
4lF7uyBOdliGGYIflEoPfDJndpJMcYaQLJYMzwZUZh087JB1zrmR6cfaahOb7GZo
9UDhCaOB4jas633lrzEW2ovRRuDwGlQ5/syejB/tpipdCyfi7xfVyzatG4m/XyeH
+JhP5lDKYYjvZ90+yEfsjsRJd2iLPIGYcYM0vrbLWigoQW58JqSHbB7o+lpuq4r7
T7CSP0odOtvMJkwNDGSIq0d3LHUIw/5/x6fl9hvYFKreLLvRjNsLerCt//X7bvbr
zkCzQR/wcZQQ/MNnQLNtAivR3DsYgpSwaqkfmiCW5JoZ0pA0/rvbWcQD4zKgr6SF
LBynGIcoP8XtQiQYJTJxJldVnpwsXoAKezVCLRr8Pk4Gu9xVMZI7aEgh5azjBqpk
DUgcR/DVtJhG4qXc/LcC
=B4g1
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_16_30_36_+1100_+8DozrnPOnmx9EGr--
