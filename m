Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3ILFyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:54:47 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63119 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3ILFyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:54:39 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 2/3] video: xilinxfb: Use devm_kzalloc instead of kzalloc
Date: Thu, 12 Sep 2013 07:54:33 +0200
Message-Id: <f9868e54718ba467691085ff78061a447eef3635.1378965270.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com>
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com>
In-Reply-To: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com>
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-19577-1378965276-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-19577-1378965276-0001

Simplify driver probe and release function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/video/xilinxfb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 123cd70..fd9c430 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -368,7 +368,6 @@ err_fbmem:
 		devm_iounmap(dev, drvdata->regs);

 err_region:
-	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);

 	return rc;
@@ -403,7 +402,6 @@ static int xilinxfb_release(struct device *dev)
 		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
 #endif

-	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);

 	return 0;
@@ -425,7 +423,7 @@ static int xilinxfb_of_probe(struct platform_device *pdev)
 	pdata = xilinx_fb_default_pdata;

 	/* Allocate the driver data region */
-	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
 		dev_err(&pdev->dev, "Couldn't allocate device private record\n");
 		return -ENOMEM;
@@ -453,7 +451,6 @@ static int xilinxfb_of_probe(struct platform_device *pdev)
 		drvdata->dcr_host = dcr_map(op->dev.of_node, start, drvdata->dcr_len);
 		if (!DCR_MAP_OK(drvdata->dcr_host)) {
 			dev_err(&op->dev, "invalid DCR address\n");
-			kfree(drvdata);
 			return -ENODEV;
 		}
 	}
--
1.8.2.3


--=_mimegpg-monstr-desktop-19577-1378965276-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlIxVxwACgkQykllyylKDCGejwCbBwGimy2fR3lcEH2xClnGr0Km
HIUAn1WnnF2GHy3q/lXLq97ylN6jR8wQ
=DuLt
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-19577-1378965276-0001--
