Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbbABWLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:11:11 -0500
Received: from ozlabs.org ([103.22.144.67]:46546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbbABWLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:11:09 -0500
Date: Sat, 3 Jan 2015 09:11:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20150103091101.04b2c11e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qz0qniLi2g=L5vMKfISL0Wt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qz0qniLi2g=L5vMKfISL0Wt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/ethernet/mellanox/mlx4/en_clock.c: In function 'mlx4_en_init_ti=
mestamp':
drivers/net/ethernet/mellanox/mlx4/en_clock.c:249:2: error: implicit declar=
ation of function 'CLOCKSOURCE_MASK' [-Werror=3Dimplicit-function-declarati=
on]
  mdev->cycles.mask =3D CLOCKSOURCE_MASK(48);
  ^
drivers/net/ethernet/mellanox/mlx4/en_clock.c:257:3: error: implicit declar=
ation of function 'clocksource_khz2mult' [-Werror=3Dimplicit-function-decla=
ration]
   clocksource_khz2mult(1000 * dev->caps.hca_core_clock, mdev->cycles.shift=
);
   ^
drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c: In function 'ixgbe_ptp_start_=
cyclecounter':
drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c:796:2: error: implicit declara=
tion of function 'CLOCKSOURCE_MASK' [-Werror=3Dimplicit-function-declaratio=
n]
  adapter->cc.mask =3D CLOCKSOURCE_MASK(64);
  ^

Presumably caused by commit 74d23cc704d1 ("time: move the
timecounter/cyclecounter code into its own file").

I added the following commit for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sat, 3 Jan 2015 09:07:21 +1100
Subject: [PATCH] ixgbe_ptp, mlx4: Include clocksource.h to get CLOCKSOURCE_=
MASK

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  | 1 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/eth=
ernet/intel/ixgbe/ixgbe_ptp.c
index 47c29eaaa140..73548280cbae 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -25,6 +25,7 @@
   Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
=20
 **************************************************************************=
*****/
+#include <linux/clocksource.h>
 #include "ixgbe.h"
 #include <linux/ptp_classify.h>
=20
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/et=
hernet/mellanox/mlx4/en_clock.c
index e9cce4f72b24..7c6ef4b48f8e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -31,6 +31,7 @@
  *
  */
=20
+#include <linux/clocksource.h>
 #include <linux/mlx4/device.h>
=20
 #include "mlx4_en.h"
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/qz0qniLi2g=L5vMKfISL0Wt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCAAGBQJUpxd6AAoJEMDTa8Ir7ZwV3egP+NAncIhaPXOGcN8aZD1DLKFD
skjlYTsmrNO5wo3+qc8DaPsZgZItBQuE1zr5Dh/ozpk+b5NABVnZYX3BOSrbkzYx
j+ZOK8B+zSPMxK0CgW0nzDPF06s4v41GpgnexMOo55g7/h3ieKmNCnJ4gKPSLSF3
By4XmgnZHYGz+PHfZWAALnMYdJL89u/sy2FJQzEg7xMjHYUe6KauMMZnATlephhq
DxoicL6wBT7goXHZm1R3gbOUe4PrcgvnnGHaulreC4bglL5mvV4WxCQL6Fx2fWf3
C4IzFTde4wvFhgVSQ/p1yVuKQo2GG/hORZOS/iE9EiSoQChzbv0WbDGRkcvFs7p3
Meux9rnEbw2z8lX1aNYfxxc6+yQY3bPLKVXzZIPdjsymKzokwqpFWaH12BGggA8v
VMY5Ax5uN4G70OYKUU5RWpSPPDsonLZQwha/yMxOmXuxhneeHGaglbwGvfhSDnQp
Rxw1+po+Rri1/mcDWxw3oruc7vGH0ByXMJlBM0KWWriu3lbiQp7Iv0SydYH5umoO
tQZ04b+kCrtVdm5gxIurVP0gPy1PQuOv/Kyuete97TbiFabyqEzAkmGYoofOQQ4/
tioW0+MmcNyMN4z5u/qh3ZDQjcL93VNbXREOxI0n5AvLQV/MLHw2XOtol1uAqmsr
WQ2rtAy8Mm7atpIbXRA=
=kxyP
-----END PGP SIGNATURE-----

--Sig_/qz0qniLi2g=L5vMKfISL0Wt--
