Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaKXCWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:22:25 -0500
Received: from ozlabs.org ([103.22.144.67]:53469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaKXCWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:22:23 -0500
Date: Mon, 24 Nov 2014 13:22:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
Message-ID: <20141124132214.2f756b6a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_jI5wNmozWyuNvJNcMUodgz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_jI5wNmozWyuNvJNcMUodgz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/mach-omap2/devices.c between commit e7e42b9d2a7f ("ARM:
OMAP4+: Remove unused omap_l3_noc platform init") from the arm-soc tree
and commit 1b65729a186b ("[media] mach-omap2: remove deprecated
VIDEO_OMAP2 support") from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/devices.c
index 492ef1607115,1b623a06cdcd..000000000000
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@@ -67,28 -67,40 +67,6 @@@ static int __init omap3_l3_init(void
  }
  omap_postcore_initcall(omap3_l3_init);
 =20
- #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
 -static int __init omap4_l3_init(void)
 -{
 -	int i;
 -	struct omap_hwmod *oh[3];
 -	struct platform_device *pdev;
 -	char oh_name[L3_MODULES_MAX_LEN];
--
- static struct resource omap2cam_resources[] =3D {
- 	{
- 		.start		=3D OMAP24XX_CAMERA_BASE,
- 		.end		=3D OMAP24XX_CAMERA_BASE + 0xfff,
- 		.flags		=3D IORESOURCE_MEM,
- 	},
- 	{
- 		.start		=3D 24 + OMAP_INTC_START,
- 		.flags		=3D IORESOURCE_IRQ,
 -	/* If dtb is there, the devices will be created dynamically */
 -	if (of_have_populated_dt())
 -		return -ENODEV;
 -
 -	/*
 -	 * To avoid code running on other OMAPs in
 -	 * multi-omap builds
 -	 */
 -	if (!cpu_is_omap44xx() && !soc_is_omap54xx())
 -		return -ENODEV;
 -
 -	for (i =3D 0; i < L3_MODULES; i++) {
 -		snprintf(oh_name, L3_MODULES_MAX_LEN, "l3_main_%d", i+1);
 -
 -		oh[i] =3D omap_hwmod_lookup(oh_name);
 -		if (!(oh[i]))
 -			pr_err("could not look up %s\n", oh_name);
--	}
- };
--
- static struct platform_device omap2cam_device =3D {
- 	.name		=3D "omap24xxcam",
- 	.id		=3D -1,
- 	.num_resources	=3D ARRAY_SIZE(omap2cam_resources),
- 	.resource	=3D omap2cam_resources,
- };
- #endif
 -	pdev =3D omap_device_build_ss("omap_l3_noc", 0, oh, 3, NULL, 0);
 -
 -	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
 -
 -	return PTR_RET(pdev);
 -}
 -omap_postcore_initcall(omap4_l3_init);
--
  #if defined(CONFIG_IOMMU_API)
 =20
  #include <linux/platform_data/iommu-omap.h>

--Sig_/_jI5wNmozWyuNvJNcMUodgz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcpZcAAoJEMDTa8Ir7ZwVxD4P/ikaYQmAQgsfskd6IZ4Ei1rC
ovYAB90Ayv2s2d4Zmxc7Hr1uZ/y8gt1rQKo6VR+Nia9J/xYzTKG7XgKQJdcvjcRV
9HG+xxCVg4HTnFhh1mO6euXyB5+IBhBBvMN7sGg0APETHYfGIcBH41qjL4lKeZin
5fIybs7M+jRx+jy4WQEMuWo6JVqcNUEK7GlVmIqneOrk5aYn7SUZ93J8i/+sJRI9
XUMPyvqDw+DKdjR3hWogsWmwz13EcQinDXTkVEzHvHpN9ymrRhYNGqa54elA7L4d
TYPDScN0nPl64HaLbfxU50OblfRSxWw/csEszdZmt3nRedyI9ZFL9XvAvE50DdTU
YOCKQsH0Ehuu9E6EWabfQVWVfh6iPkGJn7by2XhOssxbw3GWuKZR3Y5Tko95Pt6g
BML+h6Sz2bMPciMIe7i53VNCBU5iNOb5Rd70stZ6mmM5EN/cHJpXFr60WpFMUbCn
lYnWGpfKNnM91rFTo10uGytCTYU7NIgUPVD9jWfwSE74FSe1ACNqz4TdrIfGr5Cd
4EdfGWZGlGFnrmRov8bYLRWKKSMqZtNi8lNpwlBgtaLEjnNbz8bIXV5wDeNvQPAK
cUohpjffnsoj81K5UwAeF8xJw6oLnyjVIEfdV4Y9IrSTxTQkSk5Uuvdl8zp+rLTL
wnbsQTKFkEIisSPqL3qN
=+429
-----END PGP SIGNATURE-----

--Sig_/_jI5wNmozWyuNvJNcMUodgz--
