Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3BKDlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 22:41:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45834 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3BKDlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 22:41:49 -0500
Date: Mon, 11 Feb 2013 14:41:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Padmavathi Venna <padma.v@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Cho KyongHo <pullip.cho@samsung.com>
Subject: linux-next: manual merge of the iommu tree with the sound-asoc tree
Message-Id: <20130211144139.6b685e81bdc1034084fd5cff@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_14_41_39_+1100_HHbQ6ddfjkvpjFmZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_14_41_39_+1100_HHbQ6ddfjkvpjFmZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

Today's linux-next merge of the iommu tree got a conflict in
arch/arm/mach-exynos/mach-exynos5-dt.c between commit 99b97fdccbde ("ARM:
EXYNOS: Enable platform support for I2S controllers") from the sound-asoc
tree and commit 25e9d28d927d ("ARM: EXYNOS: remove system mmu
initialization from exynos tree") from the iommu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/mach-exynos5-dt.c
index ea9e302,2671075..0000000
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@@ -104,12 -104,36 +104,42 @@@ static const struct of_dev_auxdata exyn
  	OF_DEV_AUXDATA("samsung,mfc-v6", 0x11000000, "s5p-mfc-v6", NULL),
  	OF_DEV_AUXDATA("samsung,exynos5250-tmu", 0x10060000,
  				"exynos-tmu", NULL),
 +	OF_DEV_AUXDATA("samsung,i2s-v5", 0x03830000,
 +				"samsung-i2s.0", NULL),
 +	OF_DEV_AUXDATA("samsung,i2s-v5", 0x12D60000,
 +				"samsung-i2s.1", NULL),
 +	OF_DEV_AUXDATA("samsung,i2s-v5", 0x12D70000,
 +				"samsung-i2s.2", NULL),
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11210000,
+ 			"exynos-sysmmu.0", "mfc"), /* MFC_L */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11200000,
+ 			"exynos-sysmmu.1", "mfc"), /* MFC_R */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x14650000,
+ 			"exynos-sysmmu.2", NULL), /* TV */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11F20000,
+ 			"exynos-sysmmu.3", "jpeg"), /* JPEG */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11D40000,
+ 			"exynos-sysmmu.4", NULL), /* ROTATOR */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13E80000,
+ 			"exynos-sysmmu.5", "gscl"), /* GSCL0 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13E90000,
+ 			"exynos-sysmmu.6", "gscl"), /* GSCL1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13EA0000,
+ 			"exynos-sysmmu.7", "gscl"), /* GSCL2 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13EB0000,
+ 			"exynos-sysmmu.8", "gscl"), /* GSCL3 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13260000,
+ 			"exynos-sysmmu.9", NULL), /* FIMC-IS0 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x132C0000,
+ 			"exynos-sysmmu.10", NULL), /* FIMC-IS1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x14640000,
+ 			"exynos-sysmmu.11", NULL), /* FIMD1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13C40000,
+ 			"exynos-sysmmu.12", NULL), /* FIMC-LITE0 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13C50000,
+ 			"exynos-sysmmu.13", NULL), /* FIMC-LITE1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x10A60000,
+ 			"exynos-sysmmu.14", NULL), /* G2D */
  	{},
  };
 =20

--Signature=_Mon__11_Feb_2013_14_41_39_+1100_HHbQ6ddfjkvpjFmZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGGhzAAoJEECxmPOUX5FEEH4QAJC8xqFbJhIsq6r3GsAD/mR0
rWssbzfwaozwJiFdsAUYFNSIngR5nEVZWxjylayJknB+cS5MwCz0mYs7lpQq0uxG
GaJXLEq9NbWFsl3K4dgQ/HoMQKymGTjz6imFgUzVFKkuqqwFB/V9CdMm+T6iUObH
8vKoQtGXJTRS7EB9MLjiXXxPljkLu1GE+8RQjiMUDekKoWtIL38vw00ibBRvbTjo
59FQfqC50gqKWOGzulgupkYmWBQtrLHe2yMLVPynq4rkB2lP4Dl1GspodEQs6kzh
LV17HkWSo5JDZhI0DSqPfSDdTaZEE1Jd1rSeI2XBjdJnrK3toO3GEy3LwAvuZnHN
a7aU+3iicv9gpMaDIyy+eYart7RmJiNvL17g/VR7ohbH31km9R/Ye+svcRneDHhF
TfHs8RC9Bv1FGDv2O2orfCvakd+Q+f7ekIV2lmabQr3kar/Y5ijCraszbU/vk3jr
VPTbcoXnG5lq90+jXJbTfZXR1VUjzv0p7wdi3UTOqIgqaSSiqEauUMrudfZKbQZU
Y269U+kjguEpsPrtyVxWSSgrOcVm5NtmwMAYJTgdVs4WWPr0PItM4D86fTxezbUs
UpHTu6hV5YgbzKcaH04gvXxDBk5KWx5KfxV94y4pgjrKrY2O4zy4jVrWtYlPWuo4
H22DFlRRYHeSBLoeg+R1
=0A7c
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_14_41_39_+1100_HHbQ6ddfjkvpjFmZ--
