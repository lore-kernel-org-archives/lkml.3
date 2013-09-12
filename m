Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3ILFyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:54:40 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55618 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3ILFyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:54:37 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-fbdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 1/3] video: xilinxfb: Use standard variable name convention
Date: Thu, 12 Sep 2013 07:54:32 +0200
Message-Id: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-19560-1378965274-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-19560-1378965274-0001

s/op/pdev/ in xilinxfb_of_probe().
No functional chagnes.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/video/xilinxfb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 84c664e..123cd70 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -413,7 +413,7 @@ static int xilinxfb_release(struct device *dev)
  * OF bus binding
  */

-static int xilinxfb_of_probe(struct platform_device *op)
+static int xilinxfb_of_probe(struct platform_device *pdev)
 {
 	const u32 *prop;
 	u32 tft_access = 0;
@@ -427,7 +427,7 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	/* Allocate the driver data region */
 	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
-		dev_err(&op->dev, "Couldn't allocate device private record\n");
+		dev_err(&pdev->dev, "Couldn't allocate device private record\n");
 		return -ENOMEM;
 	}

@@ -435,7 +435,7 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	 * To check whether the core is connected directly to DCR or BUS
 	 * interface and initialize the tft_access accordingly.
 	 */
-	of_property_read_u32(op->dev.of_node, "xlnx,dcr-splb-slave-if",
+	of_property_read_u32(pdev->dev.of_node, "xlnx,dcr-splb-slave-if",
 			     &tft_access);

 	/*
@@ -459,29 +459,29 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	}
 #endif

-	prop = of_get_property(op->dev.of_node, "phys-size", &size);
+	prop = of_get_property(pdev->dev.of_node, "phys-size", &size);
 	if ((prop) && (size >= sizeof(u32)*2)) {
 		pdata.screen_width_mm = prop[0];
 		pdata.screen_height_mm = prop[1];
 	}

-	prop = of_get_property(op->dev.of_node, "resolution", &size);
+	prop = of_get_property(pdev->dev.of_node, "resolution", &size);
 	if ((prop) && (size >= sizeof(u32)*2)) {
 		pdata.xres = prop[0];
 		pdata.yres = prop[1];
 	}

-	prop = of_get_property(op->dev.of_node, "virtual-resolution", &size);
+	prop = of_get_property(pdev->dev.of_node, "virtual-resolution", &size);
 	if ((prop) && (size >= sizeof(u32)*2)) {
 		pdata.xvirt = prop[0];
 		pdata.yvirt = prop[1];
 	}

-	if (of_find_property(op->dev.of_node, "rotate-display", NULL))
+	if (of_find_property(pdev->dev.of_node, "rotate-display", NULL))
 		pdata.rotate_screen = 1;

-	dev_set_drvdata(&op->dev, drvdata);
-	return xilinxfb_assign(op, drvdata, &pdata);
+	dev_set_drvdata(&pdev->dev, drvdata);
+	return xilinxfb_assign(pdev, drvdata, &pdata);
 }

 static int xilinxfb_of_remove(struct platform_device *op)
--
1.8.2.3


--=_mimegpg-monstr-desktop-19560-1378965274-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlIxVxoACgkQykllyylKDCGdzwCfdxp9/Zoup/55nFaGT6bhYXNe
adMAmwYy++wCUNYil+qCiFUgufrRocHN
=I9A8
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-19560-1378965274-0001--
