Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab3APCXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:23:02 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40530 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab3APCXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:23:00 -0500
Date: Wed, 16 Jan 2013 13:22:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20130116132247.e0a476aa0b5c825931d418e6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Jan_2013_13_22_47_+1100_q62LIGcv=/BfzMYE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jan_2013_13_22_47_+1100_q62LIGcv=/BfzMYE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-spear13xx/spear1340.c between commit f9965aa20706 ("ARM:
SPEAr13xx: Pass DW DMAC platform data from DT") from the slave-dma tree
and commit 0529e315bbda ("ARM: use common irqchip_init for GIC init")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-spear13xx/spear1340.c
index 69c8f72,9a28beb..0000000
--- a/arch/arm/mach-spear13xx/spear1340.c
+++ b/arch/arm/mach-spear13xx/spear1340.c
@@@ -18,9 -18,9 +18,9 @@@
  #include <linux/delay.h>
  #include <linux/dw_dmac.h>
  #include <linux/of_platform.h>
 +#include <linux/pata_arasan_cf_data.h>
- #include <asm/hardware/gic.h>
+ #include <linux/irqchip.h>
  #include <asm/mach/arch.h>
 -#include <mach/dma.h>
  #include <mach/generic.h>
  #include <mach/spear.h>
 =20

--Signature=_Wed__16_Jan_2013_13_22_47_+1100_q62LIGcv=/BfzMYE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9g73AAoJEECxmPOUX5FEICcQAIXcyNgayxTBb1YGh4wJ1npt
k22hcVKCnwF3kcgexzlAyuHAR/dQplvD3SS4jAmSoUj1vAHdd2CymTV5AXYeaXpr
xrrooCYBex9vfcoke4kUiCfZN0PHXiKIN2Qe8RLCVapUDM/ErilRZSkWJN8OWxFD
p1Grs3bBYcYByiERIe8zEthqACeP/0vgZ1iNQeNt+cSMQFjUR9V60jp8lA5P5Hq+
GE5uftzYzLwhl9L4dQQWzuIUER47D0VzD7vAHc1EeFdtAUF2AnfuFkHpdvlAfJxT
tUE54Any4W3qeVvA5vDbLIlvFq+ycrMu5xsWpAPgk8T0nR9jfKVnYZ87exHyUn9b
rjQ+xC9oQqGwbHjQTYRLZYNvDpJlRlO3aNGmHYEL3JNF1nA5hxO1Y8KMAf81XWWo
/z7I1trXyBa+J3sg/BlxslL7mSp36f0hQiWtxE82weinxTZl1qQxaVLHVbo9Hnys
ZhIoB/+3hITyAE7fzjSsxwT4EFpGjNpUvOhmsiKSiIje2V6grw6+qyOiUwcPr7xV
x5dxVhi/IRNcb6nkRrLl9Emol8+aih4brRljZJjHsAghfbwgdcUCoT0ivCzgFDs5
2sb5ommqXDh8U70Ao2hkluL0tJsDcgxGOIM/y1/Q5movlCLmof3gItW/Kq/UnaQ0
NB0FXCf4CEAx8vapyrny
=36Qu
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jan_2013_13_22_47_+1100_q62LIGcv=/BfzMYE--
