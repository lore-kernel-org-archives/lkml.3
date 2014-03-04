Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaCDFN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:13:28 -0500
Received: from ozlabs.org ([203.10.76.45]:33085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaCDFN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:13:27 -0500
Date: Tue, 4 Mar 2014 16:13:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with the omap_dss2 tree
Message-Id: <20140304161320.2d76810bf6bd8c6eb554b564@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Mar_2014_16_13_20_+1100_w_qVt/M9Fb0zhOfK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Mar_2014_16_13_20_+1100_w_qVt/M9Fb0zhOfK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in
drivers/video/Kconfig, drivers/video/Makefile and drivers/video/sgivwfb.c
between commit 08667731d1d4 ("video: move fbdev to drivers/video/fbdev")
from the omap_dss2 tree and commit c5f9ee3d665a ("x86, platforms: Remove
SGI Visual Workstation") from the tip tree.

I removed drivers/video/fbdev/sgivwfb.c and added the following merge
fix patch and can carry the fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Mar 2014 16:11:12 +1100
Subject: [PATCH] video: fbdev: fix up fro removal of SGI Visual Workstation

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/fbdev/Kconfig  | 11 +----------
 drivers/video/fbdev/Makefile |  1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 31c3f3ddfd38..6b1984c7f4e7 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -765,18 +765,9 @@ config FB_HGA
 	  As this card technology is at least 25 years old,
 	  most people will answer N here.
=20
-config FB_SGIVW
-	tristate "SGI Visual Workstation framebuffer support"
-	depends on FB && X86_VISWS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  SGI Visual Workstation support for framebuffer graphics.
-
 config FB_GBE
 	bool "SGI Graphics Backend frame buffer support"
-	depends on (FB =3D y) && (SGI_IP32 || X86_VISWS)
+	depends on (FB =3D y) && SGI_IP32
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
index 6ef2c66110e3..0284f2a12538 100644
--- a/drivers/video/fbdev/Makefile
+++ b/drivers/video/fbdev/Makefile
@@ -55,7 +55,6 @@ obj-$(CONFIG_FB_CG14)             +=3D cg14.o sbuslib.o
 obj-$(CONFIG_FB_P9100)            +=3D p9100.o sbuslib.o
 obj-$(CONFIG_FB_TCX)              +=3D tcx.o sbuslib.o
 obj-$(CONFIG_FB_LEO)              +=3D leo.o sbuslib.o
-obj-$(CONFIG_FB_SGIVW)            +=3D sgivwfb.o
 obj-$(CONFIG_FB_ACORN)            +=3D acornfb.o
 obj-$(CONFIG_FB_ATARI)            +=3D atafb.o c2p_iplan2.o atafb_mfb.o \
                                      atafb_iplan2p2.o atafb_iplan2p4.o ata=
fb_iplan2p8.o
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Mar_2014_16_13_20_+1100_w_qVt/M9Fb0zhOfK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFWD0AAoJEMDTa8Ir7ZwVXogP+gPG2iMEf2DFtFNpR/yd2w7j
Nyd3pMojKPRNY9iq5fhK9iWZrKf8y6fROBJs9T10NOFMkDHxNEP5zV+vkzcJsRuy
+bw9zd7wCT7DZwMew6DdxhxcNhPUIg/mcn9jQHZhU/S/NrPpgtZ4EUwcnF8M1Chf
LZ5Uw+M4mfXR+MlVGDxWOSmdCjpe8cTsaqMzsB8CbUuWETKDhKp53iu+HfQlJxRG
4LYTpv9YD2p7EGPF6ABA3xkKdo8uyqPVYiz6lcGfuNhQSvci2uFXxXHmGxzGsuOb
BEj3dC0Uk80lSO6z80vCtn6BdjshpJr62PC/9/vXQsRcQHphi6Mp3f7Cijjyvox1
jiLhnS8b80gyjF8ISFmuIakxHHZBJPCctI9veAi7KjmW+WKzMMfnyIb6DpDOvIlz
j2VAFpJVsZXcnWf3J7T9wuNRYdlHKgQ2GKLxOJt5YRayth/wlxFJGVjtLR8YjvHm
MAWQ8aexakKaWkIyey7f9+nbBOcvfS5gcfpY6OIyKEPiSkU+G9ceF96sJf6gHJ03
RSyscZkoHIH1XAus/bEewW1NhdWWPGOcfEIZndk8Ian9vddiVdGdvdjJCHShXiU5
Jq3w9J4mCjjrmDKvpYRW3xWr6rkrVq4dg6dXqR6Aa7xta56cqBy329+wt1Pp9IxG
WB/7U58UpXcTIz+XiVcE
=89ST
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Mar_2014_16_13_20_+1100_w_qVt/M9Fb0zhOfK--
