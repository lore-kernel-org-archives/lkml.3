Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3JJGa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:30:56 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:32937 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3JJGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:30:34 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: joe@perches.com, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 2/3] video: xilinxfb: Use devm_kzalloc instead of kzalloc
Date: Thu, 10 Oct 2013 08:30:21 +0200
Message-Id: <eda946e0c15c10902d3e56dadf853d2931ff03a5.1381386616.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381386616.git.michal.simek@xilinx.com>
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381386616.git.michal.simek@xilinx.com>
In-Reply-To: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381386616.git.michal.simek@xilinx.com>
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381386616.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-26979-1381386630-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-26979-1381386630-0001

Simplify driver probe and release function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
---
Changes in v3:
- Remove the unnecessary OOM message

Changes in v2:
- Rebased on git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git for-next

 drivers/video/xilinxfb.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index d12345f..c420328 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -368,8 +368,6 @@ err_fbmem:
 		devm_iounmap(dev, drvdata->regs);

 err_region:
-	kfree(drvdata);
-
 	return rc;
 }

@@ -402,8 +400,6 @@ static int xilinxfb_release(struct device *dev)
 		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
 #endif

-	kfree(drvdata);
-
 	return 0;
 }

@@ -423,11 +419,9 @@ static int xilinxfb_of_probe(struct platform_device *pdev)
 	pdata = xilinx_fb_default_pdata;

 	/* Allocate the driver data region */
-	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata) {
-		dev_err(&pdev->dev, "Couldn't allocate device private record\n");
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
 		return -ENOMEM;
-	}

 	/*
 	 * To check whether the core is connected directly to DCR or BUS
@@ -451,7 +445,6 @@ static int xilinxfb_of_probe(struct platform_device *pdev)
 		drvdata->dcr_host = dcr_map(op->dev.of_node, start, drvdata->dcr_len);
 		if (!DCR_MAP_OK(drvdata->dcr_host)) {
 			dev_err(&op->dev, "invalid DCR address\n");
-			kfree(drvdata);
 			return -ENODEV;
 		}
 	}
--
1.8.2.3


--=_mimegpg-monstr-desktop-26979-1381386630-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJWSYYACgkQykllyylKDCHeuQCglkTaOeAe/f67tkde+dA7vgvL
kZIAoJU/5F+EbOJYI2BFsTetsyP0anqt
=j3df
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-26979-1381386630-0001--
