Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab3APC0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:26:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42624 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3APC0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:26:54 -0500
Date: Wed, 16 Jan 2013 13:26:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20130116132652.d740bb94b9aaf2a4b41aef6b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Jan_2013_13_26_52_+1100_pfzSthogS2Zr+T7U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jan_2013_13_26_52_+1100_pfzSthogS2Zr+T7U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/mach-spear3xx/spear3xx.c and arch/arm/mach-spear6xx/spear6xx.c
between commit 3a95b9fbba89 ("pl080.h: moved from
arm/include/asm/hardware to include/linux/amba/") from the slave-dma tree
and commit e9c515589df7 ("ARM: spear: use common irqchip_init function")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-spear3xx/spear3xx.c
index 3d9b1b5,b2ba516..0000000
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@@ -15,10 -15,8 +15,7 @@@
 =20
  #include <linux/amba/pl022.h>
  #include <linux/amba/pl08x.h>
- #include <linux/irqchip/spear-shirq.h>
- #include <linux/of_irq.h>
  #include <linux/io.h>
- #include <asm/hardware/vic.h>
 -#include <asm/hardware/pl080.h>
  #include <plat/pl080.h>
  #include <mach/generic.h>
  #include <mach/spear.h>
diff --cc arch/arm/mach-spear6xx/spear6xx.c
index 8ce65a2,b8bd33c..0000000
--- a/arch/arm/mach-spear6xx/spear6xx.c
+++ b/arch/arm/mach-spear6xx/spear6xx.c
@@@ -16,12 -16,11 +16,11 @@@
  #include <linux/amba/pl08x.h>
  #include <linux/clk.h>
  #include <linux/err.h>
+ #include <linux/irqchip.h>
  #include <linux/of.h>
  #include <linux/of_address.h>
- #include <linux/of_irq.h>
  #include <linux/of_platform.h>
 -#include <asm/hardware/pl080.h>
 +#include <linux/amba/pl080.h>
- #include <asm/hardware/vic.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/time.h>
  #include <asm/mach/map.h>

--Signature=_Wed__16_Jan_2013_13_26_52_+1100_pfzSthogS2Zr+T7U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJQ9g/sAAoJEECxmPOUX5FE+nMP+LyHt0nxpPuPb2lRkvYCMyKV
QM74zT15rR4plfCUsrnTjI3NWaesBuHvKUTGyhbEyWBRiEh4CFWMIPuXteHXQ+8r
Lm+JMNO7McGKU1CkTvUdD2vaE9hcmxN4A0ZQb4WLpRxLVy/Xrvyr6+qZYMLD+iLn
08hoQmU6UC+MiKM2/bJj2xnxWfYY1wopkVylWOGQjoFsSpr3I6OFS7Qe1tqBmq+g
wer4WDoSP+syoCLp5rm1VLGYm3IS8uGUn7MArYRmob2jUBLGjgFIdlGsTjpzwrJk
xlbAFS7LZKpIAJv4xyTdTFX5Hhd+2dtpgESp9iVm2jaQQUBbFYwS4MOxxnFyxPET
2R7/mXt3PlJA5gBnYB9XvDtxH+aLQGcs95TRqPJ5CMB0FprlVPhEgwfjzTHjFY76
WHSR7vL0wa9M0MnoDrXo7AdGanmrGT0Jtp5+ARR2wth3SxOedr1Y+58hRcYFbBEW
Q1qlStlpxVZkzJe7u9ja0AWdx3mzqxPRQPbi7m83iCEe5Wte7OsSZf0a6zaL5qzO
XyDTfLpxGc369GtuZEioEiuRuADWt2/8MwatAC4eZCqdkIn13t/cm+E8XgoJ7Lng
jfhd+j8pPYy/YFwo3omFry5Z8VHW2ziZ4q58ibejeo+ymGdfWmaMdC8xwuG5L2zh
/ti1CYLFMzTPDwAcsUY=
=kzja
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jan_2013_13_26_52_+1100_pfzSthogS2Zr+T7U--
