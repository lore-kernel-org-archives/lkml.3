Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3BVESB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:18:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53129 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab3BVER5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:17:57 -0500
Date: Fri, 22 Feb 2013 15:17:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Subject: linux-next: build failure after merge of the final tree (drm tree
 related)
Message-Id: <20130222151746.2eff5346595ba60910df867e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Feb_2013_15_17_46_+1100_xaZWhwk14VxJBSwz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2013_15_17_46_+1100_xaZWhwk14VxJBSwz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpu/drm/drm_gem_cma_helper.c: In function 'drm_gem_cma_buf_destroy':
drivers/gpu/drm/drm_gem_cma_helper.c:38:2: error: implicit declaration of f=
unction 'dma_free_writecombine' [-Werror=3Dimplicit-function-declaration]
drivers/gpu/drm/drm_gem_cma_helper.c: In function 'drm_gem_cma_create':
drivers/gpu/drm/drm_gem_cma_helper.c:61:2: error: implicit declaration of f=
unction 'dma_alloc_writecombine' [-Werror=3Dimplicit-function-declaration]

Probably caused by commit 16ea975eac67 ("drm/tilcdc: add TI LCD
Controller DRM driver (v4)") which forced CONFIG_DRM_GEM_CMA_HELPER to
'y'.  dma_alloc/free_writecombine are only defined on ARM.

I added this patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 22 Feb 2013 15:14:50 +1100
Subject: [PATCH] drm/tilcdc: only build on arm

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/tilcdc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/Kconfig b/drivers/gpu/drm/tilcdc/Kconfig
index ae14fd6..d24d040 100644
--- a/drivers/gpu/drm/tilcdc/Kconfig
+++ b/drivers/gpu/drm/tilcdc/Kconfig
@@ -1,6 +1,6 @@
 config DRM_TILCDC
 	tristate "DRM Support for TI LCDC Display Controller"
-	depends on DRM && OF
+	depends on DRM && OF && ARM
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Feb_2013_15_17_46_+1100_xaZWhwk14VxJBSwz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJvFqAAoJEECxmPOUX5FEmXUP/39duPpEP9UsyQkPtqTSIGsB
p+lYtOEs8Ds50G7U3A/0B8fPpwMfISge2tdxL9tn02WTTw04qNTkac4XI1iuEBVj
NwL/9LCXSyOLPwRw7guiDtn9xsnLudaIKNuvk5zyXO16v2Zkcc9lVL4BNypdYvWC
k5qzmPf2CuyWy+HnZFn07vJpjKY9sgc/PYv0Ib6ydP5t9Jk+RO8b1U+KXZ3Nw36n
2AKIgxBdF542hfH7idBwyy2yWspqcDnOf88IYd5Wz2I0J8a5BMXhAcVb6mIcEuAn
K3xmMJEPxO8NtY5p9guFXaxcV9HsEeLajWnXGvTvZNpAWz+VegcTqu8i1KeozAhz
Oit2CjJ/Do3Bp1jKZZswIoEGvpaDr8eCOZDfb2GCbgAzIvjGI7PLthf8aSHp6YXG
rGrhC95X5O3b+I9gB4H2t/1MM/qz/Lnr877h5ze0ZpPM4Icaz7BNvUk3+YdjPpfR
KIKvqa7ItPCNyrvsflLpoBJbWdfB/m2i5G/4CcCq5x5O6kp67SeARCxtFivhGeW0
cKnGe1sk4MHEakyfJVHUOihg5BYYVLDqx78Dq0476w4SHclKuLwm1h/iSB3WCCey
VbQXdvmb/2Qm0PNpEHvcn4SLVn5oPSMEyCyKx7ObncDjJh2MTgsELrsyCjCz4TjA
q/TDuCwaeNqdjGvnR5LC
=YfxS
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2013_15_17_46_+1100_xaZWhwk14VxJBSwz--
