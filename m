Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaBKGsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:48:50 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:41956 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaBKGss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:48:48 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] video: xilinxfb: Move xilinxfb_platform_data directly to the driver
Date: Tue, 11 Feb 2014 07:48:32 +0100
Message-Id: <af8de8bd8803b319c0f6a02ca5109768e5ef8457.1392101292.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3939-1392101312-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3939-1392101312-0001

No reason to have separate file in header in include/linux folder
if this is purely driver specific structure.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

I have this patch in my devel tree for a while and would like
to hear your opinion. I can't see any reason to have
xilinxfb_platform_data in header if this is purely OF driver
used on OF archs.
---
 drivers/video/xilinxfb.c | 15 ++++++++++++++-
 include/linux/xilinxfb.h | 30 ------------------------------
 2 files changed, 14 insertions(+), 31 deletions(-)
 delete mode 100644 include/linux/xilinxfb.h

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 6ff1a91..553cff2 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -33,7 +33,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
 #include <linux/io.h>
-#include <linux/xilinxfb.h>
 #include <linux/slab.h>

 #ifdef CONFIG_PPC_DCR
@@ -84,6 +83,20 @@

 #define PALETTE_ENTRIES_NO	16	/* passed to fb_alloc_cmap() */

+/* ML300/403 reference design framebuffer driver platform data struct */
+struct xilinxfb_platform_data {
+	u32 rotate_screen;      /* Flag to rotate display 180 degrees */
+	u32 screen_height_mm;   /* Physical dimensions of screen in mm */
+	u32 screen_width_mm;
+	u32 xres, yres;         /* resolution of screen in pixels */
+	u32 xvirt, yvirt;       /* resolution of memory buffer */
+
+	/* Physical address of framebuffer memory; If non-zero, driver
+	* will use provided memory address instead of allocating one from
+	* the consistent pool. */
+	u32 fb_phys;
+};
+
 /*
  * Default xilinxfb configuration
  */
diff --git a/include/linux/xilinxfb.h b/include/linux/xilinxfb.h
deleted file mode 100644
index 5a155a9..0000000
--- a/include/linux/xilinxfb.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Platform device data for Xilinx Framebuffer device
- *
- * Copyright 2007 Secret Lab Technologies Ltd.
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2.  This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- */
-
-#ifndef __XILINXFB_H__
-#define __XILINXFB_H__
-
-#include <linux/types.h>
-
-/* ML300/403 reference design framebuffer driver platform data struct */
-struct xilinxfb_platform_data {
-	u32 rotate_screen;	/* Flag to rotate display 180 degrees */
-	u32 screen_height_mm;	/* Physical dimensions of screen in mm */
-	u32 screen_width_mm;
-	u32 xres, yres;		/* resolution of screen in pixels */
-	u32 xvirt, yvirt;	/* resolution of memory buffer */
-
-	/* Physical address of framebuffer memory; If non-zero, driver
-	 * will use provided memory address instead of allocating one from
-	 * the consistent pool. */
-	u32 fb_phys;
-};
-
-#endif  /* __XILINXFB_H__ */
--
1.8.2.3


--=_mimegpg-monstr-desktop-3939-1392101312-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL5x8AACgkQykllyylKDCGWZACghJ/ImTbQeAes03Djj19Zb0Li
aowAnjBUvANjmDKCufQCUPzSejn7aTn3
=O9xJ
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3939-1392101312-0001--
