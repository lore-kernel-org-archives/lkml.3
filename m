Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3EaM4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:56:15 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59070 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3EaMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:55:57 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 2/8] video: xilinxfb: Do not name out_be32 in function name
Date: Fri, 31 May 2013 14:55:32 +0200
Message-Id: <777c3f640bdd77581456ec9f036990479bcfe407.1370004925.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8096-1370004952-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8096-1370004952-0001

out_be32 IO function is not supported by ARM.
It is only available for PPC and Microblaze.
Because this driver can be used on ARM let's
remove out_be32 from function name.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- Remove out_be IO name from function name
- Change patch subject from "Do not use out_be32 IO function"
  to "Do not name out_be32 in function name"

Changes in v2: None

 drivers/video/xilinxfb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index aecd15d..c9b442b 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -57,7 +57,7 @@
  * In case of direct PLB access the second control register will be at
  * an offset of 4 as compared to the DCR access where the offset is 1
  * i.e. REG_CTRL. So this is taken care in the function
- * xilinx_fb_out_be32 where it left shifts the offset 2 times in case of
+ * xilinx_fb_out32 where it left shifts the offset 2 times in case of
  * direct PLB access.
  */
 #define NUM_REGS	2
@@ -150,7 +150,7 @@ struct xilinxfb_drvdata {
  * To perform the read/write on the registers we need to check on
  * which bus its connected and call the appropriate write API.
  */
-static void xilinx_fb_out_be32(struct xilinxfb_drvdata *drvdata, u32 offset,
+static void xilinx_fb_out32(struct xilinxfb_drvdata *drvdata, u32 offset,
 				u32 val)
 {
 	if (drvdata->flags & PLB_ACCESS_FLAG)
@@ -197,7 +197,7 @@ xilinx_fb_blank(int blank_mode, struct fb_info *fbi)
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
 		/* turn on panel */
-		xilinx_fb_out_be32(drvdata, REG_CTRL, drvdata->reg_ctrl_default);
+		xilinx_fb_out32(drvdata, REG_CTRL, drvdata->reg_ctrl_default);
 		break;

 	case FB_BLANK_NORMAL:
@@ -205,7 +205,7 @@ xilinx_fb_blank(int blank_mode, struct fb_info *fbi)
 	case FB_BLANK_HSYNC_SUSPEND:
 	case FB_BLANK_POWERDOWN:
 		/* turn off panel */
-		xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
+		xilinx_fb_out32(drvdata, REG_CTRL, 0);
 	default:
 		break;

@@ -280,13 +280,13 @@ static int xilinxfb_assign(struct device *dev,
 	memset_io((void __iomem *)drvdata->fb_virt, 0, fbsize);

 	/* Tell the hardware where the frame buffer is */
-	xilinx_fb_out_be32(drvdata, REG_FB_ADDR, drvdata->fb_phys);
+	xilinx_fb_out32(drvdata, REG_FB_ADDR, drvdata->fb_phys);

 	/* Turn on the display */
 	drvdata->reg_ctrl_default = REG_CTRL_ENABLE;
 	if (pdata->rotate_screen)
 		drvdata->reg_ctrl_default |= REG_CTRL_ROTATE;
-	xilinx_fb_out_be32(drvdata, REG_CTRL,
+	xilinx_fb_out32(drvdata, REG_CTRL,
 					drvdata->reg_ctrl_default);

 	/* Fill struct fb_info */
@@ -345,7 +345,7 @@ err_cmap:
 		iounmap(drvdata->fb_virt);

 	/* Turn off the display */
-	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
+	xilinx_fb_out32(drvdata, REG_CTRL, 0);

 err_fbmem:
 	if (drvdata->flags & PLB_ACCESS_FLAG)
@@ -381,7 +381,7 @@ static int xilinxfb_release(struct device *dev)
 		iounmap(drvdata->fb_virt);

 	/* Turn off the display */
-	xilinx_fb_out_be32(drvdata, REG_CTRL, 0);
+	xilinx_fb_out32(drvdata, REG_CTRL, 0);

 	/* Release the resources, as allocated based on interface */
 	if (drvdata->flags & PLB_ACCESS_FLAG) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-8096-1370004952-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGondgACgkQykllyylKDCFzKwCfW0tJXsLNybk5cNzqujQTG9vY
L5MAn2XLQxtZaSL2coZJJZjZH3jBGrd7
=k1k6
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8096-1370004952-0001--
