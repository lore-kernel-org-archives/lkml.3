Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3BGEsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:48:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51880 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3BGEsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:48:30 -0500
Date: Thu, 7 Feb 2013 15:48:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hideki EIRAKU <hdk@igel.co.jp>, Joerg Roedel <joro@8bytes.org>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: linux-next: manual merge of the arm-soc tree with the iommu tree
Message-Id: <20130207154828.57604e8aaeee23878c15c177@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Feb_2013_15_48_28_+1100_R6qzNPXir2zD8T2h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Feb_2013_15_48_28_+1100_R6qzNPXir2zD8T2h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/setup-sh73a0.c between commit 9a27dee73f55 ("ARM:
mach-shmobile: sh73a0: Add IPMMU device") from the iommu tree and commit
486095331af0 ("ARM: mach-shmobile: sh73a0: Minimal setup using DT") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-sh73a0.c
index 36c2b2e,2ecd668..0000000
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@@ -755,36 -780,7 +781,36 @@@ static struct platform_device pmu_devic
  	.resource	=3D pmu_resources,
  };
 =20
 +/* an IPMMU module for ICB */
 +static struct resource ipmmu_resources[] =3D {
 +	[0] =3D {
 +		.name	=3D "IPMMU",
 +		.start	=3D 0xfe951000,
 +		.end	=3D 0xfe9510ff,
 +		.flags	=3D IORESOURCE_MEM,
 +	},
 +};
 +
 +static const char * const ipmmu_dev_names[] =3D {
 +	"sh_mobile_lcdc_fb.0",
 +};
 +
 +static struct shmobile_ipmmu_platform_data ipmmu_platform_data =3D {
 +	.dev_names =3D ipmmu_dev_names,
 +	.num_dev_names =3D ARRAY_SIZE(ipmmu_dev_names),
 +};
 +
 +static struct platform_device ipmmu_device =3D {
 +	.name           =3D "ipmmu",
 +	.id             =3D -1,
 +	.dev =3D {
 +		.platform_data =3D &ipmmu_platform_data,
 +	},
 +	.resource       =3D ipmmu_resources,
 +	.num_resources  =3D ARRAY_SIZE(ipmmu_resources),
 +};
 +
- static struct platform_device *sh73a0_early_devices[] __initdata =3D {
+ static struct platform_device *sh73a0_early_devices_dt[] __initdata =3D {
  	&scif0_device,
  	&scif1_device,
  	&scif2_device,
@@@ -795,9 -791,11 +821,12 @@@
  	&scif7_device,
  	&scif8_device,
  	&cmt10_device,
+ };
+=20
+ static struct platform_device *sh73a0_early_devices[] __initdata =3D {
  	&tmu00_device,
  	&tmu01_device,
 +	&ipmmu_device,
  };
 =20
  static struct platform_device *sh73a0_late_devices[] __initdata =3D {

--Signature=_Thu__7_Feb_2013_15_48_28_+1100_R6qzNPXir2zD8T2h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREzIcAAoJEECxmPOUX5FEUTwP/ikbBUw0REpt1pZufKOn4lcP
Mrss2yZ5dowMInBQIiT9tPdYHhx2D8Xi/XUKG6uwN9jSK9EpXzoRrdYUhTgA0xaE
rN2AfaebAtYDwblUcbw0TxEKdutcr6RIia6vjTrhVvw1MhlPJGI4SUmDzowablog
CViiVPsLMH0mwuotPW782++XFJhxUX/hVJDiHthlPqdOGKuwgoTnU4JJi65kd9QJ
tbkRm7ysk/6tkPIJ0g1XWyON+DmBdj5jc/U8+oILMdNBU4qvBg/WlGIaRazNPUDR
X17kfL2B0YNKsrI35nOBp2NXLKgL7MXWno4KJIwfUw2xaUQ80shoHP6a60QjCF7j
5E1yqRuTrcC+ZPk6au/8BdvjFjxgH8QJsqrKOeAzWWnBNUkZYJ7PQstiYeP7wM6M
1WN81rMDT0e5yeMcQUV87mmcRkfHYZF3S8QAZfgViTfZ2zhJsIBvnl48jv2b6fSB
MJQ+rtu/YmRBaKSXfNY7EDTz+/aIMDu8yDrrdVNZ/gPNx8rY3VvVv/GfCe2sxR3Y
lRafpph1jhmkJryCTiEGo1BalRHmy2khyslTAf6/PkJQyvNAWk60YJ0rGvotmmFh
sLKtZPYD2wRf32OA3zZWoavsPlkVM2a6xGE7jICzVs9reRAZpLQkHNpkwYssnmM/
stkP3wY7i2vWktWUHKXo
=H0UB
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Feb_2013_15_48_28_+1100_R6qzNPXir2zD8T2h--
