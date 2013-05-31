Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3EaM4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:56:22 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63678 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3EaM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:56:00 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 3/8] video: xilinxfb: Rename PLB_ACCESS_FLAG to BUS_ACCESS_FLAG
Date: Fri, 31 May 2013 14:55:33 +0200
Message-Id: <d160ae90d823d93efddc10b11406e7427a542175.1370004925.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8112-1370004955-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8112-1370004955-0001

Using only PLB name is wrong for a long time because
the same access functions are also used for AXI.
s/PLB/BUS/g

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- New patch in this patchset based on discussions

Changes in v2: None

 drivers/video/xilinxfb.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index c9b442b..d94c992 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -44,7 +44,7 @@


 /*
- * Xilinx calls it "PLB TFT LCD Controller" though it can also be used for
+ * Xilinx calls it "TFT LCD Controller" though it can also be used for
  * the VGA port on the Xilinx ML40x board. This is a hardware display
  * controller for a 640x480 resolution TFT or VGA screen.
  *
@@ -54,11 +54,11 @@
  * don't start thinking about scrolling).  The second allows the LCD to
  * be turned on or off as well as rotated 180 degrees.
  *
- * In case of direct PLB access the second control register will be at
+ * In case of direct BUS access the second control register will be at
  * an offset of 4 as compared to the DCR access where the offset is 1
  * i.e. REG_CTRL. So this is taken care in the function
  * xilinx_fb_out32 where it left shifts the offset 2 times in case of
- * direct PLB access.
+ * direct BUS access.
  */
 #define NUM_REGS	2
 #define REG_FB_ADDR	0
@@ -116,7 +116,7 @@ static struct fb_var_screeninfo xilinx_fb_var = {
 };


-#define PLB_ACCESS_FLAG	0x1		/* 1 = PLB, 0 = DCR */
+#define BUS_ACCESS_FLAG		0x1 /* 1 = BUS, 0 = DCR */

 struct xilinxfb_drvdata {

@@ -146,14 +146,14 @@ struct xilinxfb_drvdata {
 	container_of(_info, struct xilinxfb_drvdata, info)

 /*
- * The XPS TFT Controller can be accessed through PLB or DCR interface.
+ * The XPS TFT Controller can be accessed through BUS or DCR interface.
  * To perform the read/write on the registers we need to check on
  * which bus its connected and call the appropriate write API.
  */
 static void xilinx_fb_out32(struct xilinxfb_drvdata *drvdata, u32 offset,
 				u32 val)
 {
-	if (drvdata->flags & PLB_ACCESS_FLAG)
+	if (drvdata->flags & BUS_ACCESS_FLAG)
 		out_be32(drvdata->regs + (offset << 2), val);
 #ifdef CONFIG_PPC_DCR
 	else
@@ -235,10 +235,10 @@ static int xilinxfb_assign(struct device *dev,
 	int rc;
 	int fbsize = pdata->xvirt * pdata->yvirt * BYTES_PER_PIXEL;

-	if (drvdata->flags & PLB_ACCESS_FLAG) {
+	if (drvdata->flags & BUS_ACCESS_FLAG) {
 		/*
 		 * Map the control registers in if the controller
-		 * is on direct PLB interface.
+		 * is on direct BUS interface.
 		 */
 		if (!request_mem_region(physaddr, 8, DRIVER_NAME)) {
 			dev_err(dev, "Couldn't lock memory region at 0x%08lX\n",
@@ -270,7 +270,7 @@ static int xilinxfb_assign(struct device *dev,
 	if (!drvdata->fb_virt) {
 		dev_err(dev, "Could not allocate frame buffer memory\n");
 		rc = -ENOMEM;
-		if (drvdata->flags & PLB_ACCESS_FLAG)
+		if (drvdata->flags & BUS_ACCESS_FLAG)
 			goto err_fbmem;
 		else
 			goto err_region;
@@ -323,7 +323,7 @@ static int xilinxfb_assign(struct device *dev,
 		goto err_regfb;
 	}

-	if (drvdata->flags & PLB_ACCESS_FLAG) {
+	if (drvdata->flags & BUS_ACCESS_FLAG) {
 		/* Put a banner in the log (for DEBUG) */
 		dev_dbg(dev, "regs: phys=%lx, virt=%p\n", physaddr,
 					drvdata->regs);
@@ -348,11 +348,11 @@ err_cmap:
 	xilinx_fb_out32(drvdata, REG_CTRL, 0);

 err_fbmem:
-	if (drvdata->flags & PLB_ACCESS_FLAG)
+	if (drvdata->flags & BUS_ACCESS_FLAG)
 		iounmap(drvdata->regs);

 err_map:
-	if (drvdata->flags & PLB_ACCESS_FLAG)
+	if (drvdata->flags & BUS_ACCESS_FLAG)
 		release_mem_region(physaddr, 8);

 err_region:
@@ -384,7 +384,7 @@ static int xilinxfb_release(struct device *dev)
 	xilinx_fb_out32(drvdata, REG_CTRL, 0);

 	/* Release the resources, as allocated based on interface */
-	if (drvdata->flags & PLB_ACCESS_FLAG) {
+	if (drvdata->flags & BUS_ACCESS_FLAG) {
 		iounmap(drvdata->regs);
 		release_mem_region(drvdata->regs_phys, 8);
 	}
@@ -423,18 +423,18 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	}

 	/*
-	 * To check whether the core is connected directly to DCR or PLB
+	 * To check whether the core is connected directly to DCR or BUS
 	 * interface and initialize the tft_access accordingly.
 	 */
 	of_property_read_u32(op->dev.of_node, "xlnx,dcr-splb-slave-if",
 			     &tft_access);

 	/*
-	 * Fill the resource structure if its direct PLB interface
+	 * Fill the resource structure if its direct BUS interface
 	 * otherwise fill the dcr_host structure.
 	 */
 	if (tft_access) {
-		drvdata->flags |= PLB_ACCESS_FLAG;
+		drvdata->flags |= BUS_ACCESS_FLAG;
 		rc = of_address_to_resource(op->dev.of_node, 0, &res);
 		if (rc) {
 			dev_err(&op->dev, "invalid address\n");
--
1.8.2.3


--=_mimegpg-monstr-desktop-8112-1370004955-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGondsACgkQykllyylKDCGAWgCeIJNaBmzCIG90xxYLx7+RwnrG
uucAnRdXzpOhUqZl0WGHsTGAfkGIp8u2
=x/4p
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8112-1370004955-0001--
