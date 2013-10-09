Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3JIKw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:52:28 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57499 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3JIKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:52:25 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-fbdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 1/3] video: xilinxfb: Use standard variable name convention
Date: Wed,  9 Oct 2013 12:52:12 +0200
Message-Id: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-29027-1381315934-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-29027-1381315934-0001

s/op/pdev/ in xilinxfb_of_probe().
No functional chagnes.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2: None

 drivers/video/xilinxfb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 0e1dd33..d12345f 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -411,7 +411,7 @@ static int xilinxfb_release(struct device *dev)
  * OF bus binding
  */

-static int xilinxfb_of_probe(struct platform_device *op)
+static int xilinxfb_of_probe(struct platform_device *pdev)
 {
 	const u32 *prop;
 	u32 tft_access = 0;
@@ -425,7 +425,7 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	/* Allocate the driver data region */
 	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
-		dev_err(&op->dev, "Couldn't allocate device private record\n");
+		dev_err(&pdev->dev, "Couldn't allocate device private record\n");
 		return -ENOMEM;
 	}

@@ -433,7 +433,7 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	 * To check whether the core is connected directly to DCR or BUS
 	 * interface and initialize the tft_access accordingly.
 	 */
-	of_property_read_u32(op->dev.of_node, "xlnx,dcr-splb-slave-if",
+	of_property_read_u32(pdev->dev.of_node, "xlnx,dcr-splb-slave-if",
 			     &tft_access);

 	/*
@@ -457,29 +457,29 @@ static int xilinxfb_of_probe(struct platform_device *op)
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


--=_mimegpg-monstr-desktop-29027-1381315934-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJVNV8ACgkQykllyylKDCGpkgCfXq7BZU1cyFdruU+cGHtNX20c
LR4AoJuJm6na0VUecoZmiXDkNq0bmMWA
=XJL/
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-29027-1381315934-0001--
