Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbaCFCuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:50:24 -0500
Received: from ozlabs.org ([203.10.76.45]:44656 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbaCFCuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:50:22 -0500
Date: Thu, 6 Mar 2014 13:50:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: linux-next: build warning after merge of the i2c tree
Message-Id: <20140306135016.2f026cd81b41cd2474c99124@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_13_50_16_+1100_sriXNDYgAvaA4Phs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_13_50_16_+1100_sriXNDYgAvaA4Phs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfram,

After merging the i2c tree, today's linux-next build (powerpc
ppc64_defconfig, x86_64 allmodconfig and arm multi_v7_defconfig) produced
this warning:

drivers/video/Kconfig:42:error: recursive dependency detected!
drivers/video/Kconfig:42:	symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_TEG=
RA_FBDEV
drivers/gpu/drm/tegra/Kconfig:18:	symbol DRM_TEGRA_FBDEV depends on DRM_TEG=
RA
drivers/gpu/drm/tegra/Kconfig:1:	symbol DRM_TEGRA depends on RESET_CONTROLL=
ER
drivers/reset/Kconfig:4:	symbol RESET_CONTROLLER is selected by I2C_MV64XXX
drivers/i2c/busses/Kconfig:528:	symbol I2C_MV64XXX depends on I2C
drivers/i2c/Kconfig:5:	symbol I2C is selected by FB_DDC
drivers/video/Kconfig:92:	symbol FB_DDC is selected by FB_CYBER2000_DDC
drivers/video/Kconfig:386:	symbol FB_CYBER2000_DDC depends on FB_CYBER2000
drivers/video/Kconfig:374:	symbol FB_CYBER2000 depends on FB

Introduced by commit 370136bc67c3 ("i2c: mv64xxx: Add reset deassert call").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_13_50_16_+1100_sriXNDYgAvaA4Phs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTF+JtAAoJEMDTa8Ir7ZwV9okP/0U05EldzRcFD8PFX8u0etcb
qrZcYch/A4oFACb1jyY6WOz5/ziXSY1bPe6beO2aQyez5f9uDaZ41TS1wZNxlfiB
pGXxBNGrIDlHb9Mw5636N5f5oua/C7bo7Oge5P8lCJp666rWY2K870fFD701+4cz
Hu7hFWWL5OP1CbaB2Z/RHTDNyr69AbA5x1foT5CZT/hh0QoGZIjlxPXsy/JdUM23
VZef2Bk0923lxVix6qnDw5G/pC2DDooQ3WnXGXRd1XfV3W1SgK/OR1PoHo0AEQod
5eLaYMyqLJHUynql/doGgRZQMGl5kuwyf6MbFprwglIPjQJCujY2BYlKPc42JPSx
J93pC2nx8IBdXYUHR2ah39CipRwSR9h8xCp/SdU8mEV2ZlVYFPVYM3ZF0miuLJqe
XAjMGhSRN17OAr57BJaXY4dRenOfk4BxeNtd14YZm6Ilx1R+226uPjXO7xHWU+eG
zzaKhgJd7PMb2qSTJWJfuTDE5rhwAtG0Xz3ptp6TY165ENV36Dji350vJ8QvIKY+
Y8korylDXlrt+uqeAdrKGNbAv3zIgyy6E7hNVqW2ijir7cccgkkD34M1t9Ijwgro
Xj4oIxgUkeiiCJITSgBjLbfuyvgVhR9UfiUy2ZMR2HmmHmn6/4w7Bfp9Ce94CcCF
f5iFONJXv3u2AMksJ8Gd
=lSAz
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_13_50_16_+1100_sriXNDYgAvaA4Phs--
